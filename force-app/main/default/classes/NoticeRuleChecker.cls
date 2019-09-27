public with sharing class NoticeRuleChecker {
    private List<Notice_Rule_Event__c> events;

    public NoticeRuleChecker() {
        this.events = new List<Notice_Rule_Event__c>();
    }

    public void checkRules(Map<Id,SObject> newRecords, Map<Id,Sobject> oldRecords, List<Notice_Rule__c> rules) {
        for (Notice_Rule__c rule : rules) {
            String recType = rule.Target_Record_Type__c;
            String field = rule.Target_Field__c;
            String change = rule.Target_Change__c;
            String value = rule.Target_Value__c;

            // Check if field is valid for given record type
            if (!isValid(recType, field)) {
                String template = 'ERROR: field "{0}" is invalid for record type "{1}" on notice rule "{2}"';
                List<String> params = new List<String>{field, recType, rule.Id};
                String errorMSG = String.format(template, params);
                System.debug(errorMSG); 
                continue; 
            }

            // Loop records sent by trigger
            for(Id recID : oldRecords.keySet()) {
                SObject newRecord = newRecords.get(recID);
                SObject oldRecord = oldRecords.get(recID);
                
                // If field is not set on either record, continue loop
                List<SObject> recordList = new List<SObject>{newRecord, oldRecord};
                if(!isSetOnOne(recordList, field)) {
                    String template = 'ERROR: field "{0}" is not set on "{1}" record "{2}" sent by trigger';
                    List<String> params = new List<String>{field, recType, oldRecord.Id};
                    String errorMSG = String.format(template, params);
                    System.debug(errorMSG);
                    continue;
                } 

                // Get field values and compare
                String newVal = getValueOrBlank(newRecord, field);
                String oldVal = getValueOrBlank(oldRecord, field);
                switch on change {
                    when 'Any change' {
                        if (newVal != oldVal) {
                            makeRuleEvent(rule.Id);
                        }   
                    }
                    when 'Equals' {
                        if (newVal == value) {
                            makeRuleEvent(rule.Id);
                        }
                    }
                    when 'Not equal to' {
                        if (newVal != value) {
                            makeRuleEvent(rule.Id);
                        }
                    }
                    when 'Contains' {
                        if (newVal.contains(value)) {
                            makeRuleEvent(rule.Id);
                        }
                    }
                    when 'Does not contain' {
                        if (!newVal.contains(value)) {
                            makeRuleEvent(rule.Id);
                        }
                    }
                    when 'Starts with' {
                        if (newVal.startsWith(value)) {
                            makeRuleEvent(rule.Id);
                        }
                    }
                }
            }
        }
        insert events;
    }

    private Boolean isValid(String recType, String field) {
        // Get field map for object type
        List<String> types = new List<String>{recType};
        List<Schema.DescribeSObjectResult> dsorList = Schema.describeSObjects(types);            
        Map<String,Schema.SObjectField> fieldMap = dsorList[0].fields.getMap();
        Boolean result = fieldMap.containsKey(field);
        // If field is invalid for object type
        if (!result) {
            // Log error
            String template = 'ERROR: field "{0}" is invalid for record type "{1}"';
            List<String> params = new List<String>{field, recType};
            String errorMSG = String.format(template, params);
            System.debug(errorMSG);
        }
        return result;
    }

    private Boolean isSetOnOne(List<SObject> records, String field) {
        Boolean result = false;
        for(SObject rec : records) {
            if(rec.isSet(field)) {
                result = true;
                break;
            }
        }
        return result;
    }

    private String getValueOrBlank(SObject record, String field) {
        String result = '';
        if (record.isSet(field)) {
            result = record.get(field).toString();
        }
        return result;
    }

    private void makeRuleEvent(Id ruleId) {
        Notice_Rule_Event__c newEvent = new Notice_Rule_Event__c(Notice_Rule__c = ruleId);
        events.add(newEvent);
    }
    
}