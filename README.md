# Watch and Notify
<p align="center"><img src="https://github.com/atsutton/WatchAndNotify/blob/master/watchandnotify-249x187.jpg" alt="Watch and Notify Salesforce Application"></p>
                                                                                                          
A Salesforce application that lets you watch for record changes and send email alerts when changes occur. 

## Setup

```````````````````````````````````
git clone https://github.com/atsutton/WatchAndNotify

cd WatchAndNotify

sfdx force:org:create -a Scratch1 -s -f config/project-scratch-def.json

sfdx force:source:push

sfdx force:user:permset:assign -n WatchAndNotify

sfdx force:org:open

```````````````````````````````````

Then navigate to App Launcher > Watch And Notify. 

Apps are included for both Lightning Experience and Salesforce Classic app launchers. 


## Overview

WatchAndNotify allows you to create 'Notice Rules' that watch for changes to specified SObject types and fields. You can even specify the type of change to watch for and a target value. 

For example, you can set a Notice Rule to watch for changes to the Name field of Account records. You can also watch for more specific changes, such as when the name field does not equal 'Acme Company' or when it contains the string 'LLC'.

Alerts are sent via email. You can specify the recipient email address on each Notice Rule.

Rules can be created to watch Account and Lead records. The fields that can be watched include any that are updateable by the current user. Rules can also be activated or deactivated via checkbox. 

## Details

Notice Rules are created via a custom Visualforce page. When a rule is triggered, an associated Notice Rule Event (Notice_Rule_Event__c) record is created.

A process (i.e. in Process Builder) executes when each Notice Rule Event created. The process checks the associated rule for an email address. If found, the event record is passed to a Flow, which gathers more data and sends the alert email. 

### Visualforce Page

The page (NoticeRule.page) is assigned to the 'New' and 'Edit' actions for Notice Rules. It uses a custom controller extension (NoticeRuleNewExtension.cls)

Several of the form fields update dynamically: 

- Changes to the 'Target Record Type' will auto-update the list of options under 'Target Field'. 

- Setting the 'Target Change' field to 'Any change' will auto-hide the 'Target Value' field.

### Apex Classes

Trigger and trigger handler classes catpure the new and old versions of updated records. The handlers instantiate NoticeRuleCheckInitializer with the old and new records. 

NoticeRuleCheckInitializer uses NoticeRuleGetter to fetch all active rules targeting the correct SObject type. A check is performed to remove any records created less than two seconds prior. This is to ensure records updated by 'after insert' triggers and similar processes are not included. 

The old records, new records, and rules are then passed to NoticeRuleChecker, which performs the check of records vs. rules and creates any necessary Notice Rule Events. 

### Apex Test Classes

Each Apex class has a corresponding test class, following the naming convention 'MyClassNameTest'. 

### Permission Set

The included permission set grants all permissions needed to create and edit rules. Permissions are provided to access the apps in both Lightning Experience and Salesforce Classic. 
