@isTest
public with sharing class NoticeRuleExtensionTest {

    @isTest
    static void testContructor() {
        NoticeRuleExtension ext = getController();
        Notice_Rule__c rule = getRule();
        System.assertEquals(rule.Id, ext.rule.Id, 'rule.Id property should equal ' + rule.Id);
        System.assertNotEquals(null, ext.listTargetFieldOptions, 'fieldOptions property should not be null');
        System.assertEquals(null, ext.selectedTargetField, 'selectedTargetField property should equal null');
        System.assertEquals('Any change', ext.selectedTargetChange, 'selectedTargetChange property should equal \'Any change\'');
    }

    @isTest
    static void testSelectOptionsFieldsUpdateable() {
        NoticeRuleExtension ext = getController();       
        List<Schema.DescribeSObjectResult> dsorList = getTargetRecordTypeDSORList();
        // Loop the describe result of each available record type
        for(Schema.DescribeSObjectResult dsor : dsorList){
            // Set target record type and generate field options
            ext.rule.Target_Record_Type__c = dsor.getName();
            ext.updateTargetFieldOptions();
            // Confirm the value of each select option is a valid, updateable field
            List<SelectOption> selectOptions = ext.listTargetFieldOptions;
            Map<String, Schema.SObjectField> fieldMap = dsor.fields.getMap();
            for (SelectOption opt : selectOptions) {
                String fieldName = opt.getValue();
                if (fieldName == '') { continue; }
                Schema.DescribeFieldResult field = fieldMap.get(fieldName).getDescribe();
                System.assert(field.isUpdateable(), 'Field "'+ field.getName() + ' is not updateable');
            }
        }
    }

    @isTest
    static void testSelectOptionsCount() {
        NoticeRuleExtension ext = getController();     
        List<Schema.DescribeSObjectResult> dsorList = getTargetRecordTypeDSORList();
        // Loop the describe result of each available record type
        for(Schema.DescribeSObjectResult dsor : dsorList) {
            String objectName = dsor.getName();
            Integer validFieldCount = 0;
            Map<String, SObjectField> fieldMap = dsor.fields.getMap();
            // Count the number of updateable fields
            for(String fieldName : fieldMap.keySet()) {
                if (fieldMap.get(fieldName).getDescribe().isUpdateable()) {
                    validFieldCount++; 
                }
            }
            // Get count of select options
            ext.rule.Target_Record_Type__c = objectName;
            ext.updateTargetFieldOptions();
            Integer optionCount = ext.listTargetFieldOptions.size();
            // Check count vs count of object's updateable fields
            System.assertEquals(validFieldCount, optionCount, 'Number of select options does not equal number of updateable ' + objectName + ' fields');
        }
    }

    @isTest
    static void testUpdateTargetFieldOptionsBlankSelected() {
        NoticeRuleExtension ext = getController();
        List<Schema.DescribeSObjectResult> dsorList = getTargetRecordTypeDSORList();
        for(Schema.DescribeSObjectResult dsor : dsorList) {
            String objectName = dsor.getName();
            
            ext.rule.Target_Record_Type__c = objectName;
            ext.updateTargetFieldOptions();
            System.assert(ext.listTargetFieldOptions.size() > 1, 'More than one select options should exist when ' + objectName + 'is selected');

            ext.rule.Target_Record_Type__c = '';
            ext.updateTargetFieldOptions();
            System.assert(ext.listTargetFieldOptions.size() == 1, 'Only one select options should exist when ' + objectName + 'is selected');
        }
    }

    @isTest
    static void testUpdateShowTargetValue() {
        NoticeRuleExtension ext = getController();     
        // Get values of Target_Change__c picklist  
        Schema.DescribeFieldResult dfr = Schema.SObjectType.Notice_Rule__c.fields.Target_Change__c;
        List<Schema.PicklistEntry> pickListEntries = dfr.getPicklistValues();
        // Loop picklist vlaues
        for (Schema.PicklistEntry p : pickListEntries) {
            String val = p.getValue();
            ext.rule.Target_Change__c = val;
            ext.updateShowTargetValue();
            // Confirm showTargetValues is true for all picklist values except 'Any change'
            if (val == 'Any change') {
                System.assertEquals('', ext.rule.Target_Value__c, 'Rule\'s target value property should be \'\'');
                System.assertEquals(false, ext.showTargetValueField, 'Rule\'s target value property should be false');
            } else {
                System.assertEquals(true, ext.showTargetValueField, 'showTargetValueField should be true when target change equals ' + val);
            }
        }
    }


    @isTest
    static void testSave() {
        NoticeRuleExtension ext = getController();
        System.assertEquals(null, ext.selectedTargetField, 'Extension.selectedTargetField should be null');
        String fieldName = 'billingcity';
        ext.selectedTargetField = fieldName;
        PageReference p = ext.save();
        System.assertEquals(fieldName, ext.rule.Target_Field__c, 'rule.Target_Field__c should equal ' + fieldName);
    }   


    // UTILITY METHODS
    
    @TestSetup
    static void basicSetup(){
        Notice_Rule__c rule = new Notice_Rule__c(
            Name = 'TestName',
            Target_Change__c = 'Any change',
            Target_Field__c = 'Name',
            Target_Record_Type__c = 'Account',
            Target_Value__c = '',
            Active__c = true
        );
        insert rule;    
    }

    static Notice_Rule__c getRule() {
        Notice_Rule__c rule = [
            SELECT 
                Id, Name, Target_Change__c, Target_Field__c, Target_Record_Type__c, Target_Value__c, Active__c
            FROM 
                Notice_Rule__c
        ];
        return rule;
    }

    // Instantiate and return page controller
    static NoticeRuleExtension getController() {
        Notice_Rule__c rule = getRule();
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(rule);
        NoticeRuleExtension ext = new NoticeRuleExtension(stdCtrl);
        return ext;
    }

    // Return the describe result of each object listed in Target_Record_Type__c picklist
    static List<Schema.DescribeSObjectResult> getTargetRecordTypeDSORList() {
        Schema.DescribeFieldResult dfr = Schema.SObjectType.Notice_Rule__c.fields.Target_Record_Type__c;
        List<Schema.PicklistEntry> pickValues = dfr.getPicklistValues();
        List<String> types = new List<String>();
        for(Schema.PicklistEntry entry : pickValues) {
            types.add(entry.getValue());
        }
        List<Schema.DescribeSObjectResult> dsorList = Schema.describeSObjects(types);
        return dsorList;
    }
    
}