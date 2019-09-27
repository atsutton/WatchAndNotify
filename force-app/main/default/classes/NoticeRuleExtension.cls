public with sharing class NoticeRuleExtension {
    @testVisible ApexPages.StandardController controller; 
    @testVisible private final Notice_Rule__c rule;
    @testVisible private Map<String, List<SelectOption>> mapTargetFieldOptions;
    @testVisible public List<SelectOption> listTargetFieldOptions {get; set;}
    @testVisible public String selectedTargetField {get; set;}
    @testVisible public String selectedTargetChange {get; set;}
    @testVisible public Boolean showTargetValueField {get; set;}
    @testVisible public String titleSectionMain {get; set;}
    
    public NoticeRuleExtension(ApexPages.StandardController stdController) {
        this.controller = stdController;
        this.rule = (Notice_rule__c)controller.getRecord();
        this.mapTargetFieldOptions = new Map<String, List<SelectOption>>();
        this.listTargetFieldOptions = new List<SelectOption>();
        buildPage();
    }

    private void buildPage() {
        buildMapTargetFieldOptions();
        updateTargetFieldOptions();
        updateShowTargetValue();
        updateTitleSectionMain();
    }

    public void buildMapTargetFieldOptions() {
        // Get describe info for target sobject types
        List<Schema.DescribeSObjectResult> dsorList = describeTargetRecordTypes();
        for(Schema.DescribeSObjectResult dsor : dsorList) {
            // Get list of field names for the sobject type
            Map<String, Schema.SObjectField> fieldMap = dsor.fields.getMap();
            List<String> fieldNames = new List<String>(fieldMap.keySet());
            // Build a list of select options using the field names
            List<SelectOption> options = new List<SelectOption>();
            for(String key : fieldNames) {
                // Skip fields that cannot be updated
                if(!fieldMap.get(key).getDescribe().isUpdateable()) { continue; }
                SelectOption o = new SelectOption(key, fieldMap.get(key).getDescribe().getLabel());
                options.add(o);
            }
            options.sort();
            String sObjectName = dsor.getName();
            // Add select options list to map
            mapTargetFieldOptions.put(sObjectName, options);
        }
        // Add blank list of select options to map
        List<SelectOption> blankList = new List<SelectOption>();
        SelectOption blankOption = new SelectOption('', '--None--');
        blankList.add(blankOption);
        mapTargetFieldOptions.put('blank', blankList);
    }

    
    private List<Schema.DescribeSObjectResult> describeTargetRecordTypes() {
        // List picklist values of Target_Record_Type__c
        List<String> objectTypes = new List<String>();
        Schema.DescribeFieldResult descFieldResult = Schema.SObjectType.Notice_Rule__c.fields.Target_Record_Type__c;
        List<Schema.PicklistEntry> pListEntries = descFieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : pListEntries) {
            objectTypes.add(entry.getValue());
        }
        // Get describe info for all listed sobjecttypes
        List<Schema.DescribeSObjectResult> dsorList = Schema.describeSObjects(objectTypes);
        return dsorList;
    }

    public void updateTargetFieldOptions() {
        String typeSelected = rule.Target_Record_Type__c;
        if (typeSelected == null || typeSelected == '') {
            listTargetFieldOptions = mapTargetFieldOptions.get('blank');
        } else {
            listTargetFieldOptions = mapTargetFieldOptions.get(typeSelected);
        }
    }

    public void updateShowTargetValue() {
        selectedTargetChange = rule.Target_Change__c;
        if (selectedTargetChange == 'Any change') {
            rule.Target_Value__c = '';
            showTargetValueField = false;
        } else {
            showTargetValueField = true;
        }
    }

    public void updateTitleSectionMain() {
        if (rule.Id == null) {
            this.titleSectionMain = 'New';
        } else { 
            this.titleSectionMain = 'Edit'; 
        }
    }

    public PageReference save() {
        rule.Target_Field__c = selectedTargetField;
        return controller.save();
    }

}