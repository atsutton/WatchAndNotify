public with sharing class NoticeRuleCheckInitializer {
    @TestVisible NoticeRuleGetter ruleGetter;
    @TestVisible NoticeRuleChecker ruleChecker;
    @TestVisible Map<Id,SObject> newRecords;
    @TestVisible Map<Id,SObject> oldRecords;
    @TestVisible List<Notice_Rule__c> rules;

    public NoticeRuleCheckInitializer(Map<Id,SObject> newRecordsTrig, Map<Id,Sobject> oldRecordsTrig) {
        this.ruleGetter = new NoticeRuleGetter();
        this.ruleChecker = new NoticeRuleChecker();
        this.newRecords = newRecordsTrig.clone();
        this.oldRecords = oldRecordsTrig.clone();
        Schema.SObjectType recType = oldRecords.getSObjectType();
        this.rules = ruleGetter.getRules(recType);

        removeNewInserts();
        if(newRecords.size() != 0 && oldRecords.size() != 0) {
            ruleChecker.checkRules(newRecords, oldRecords, rules);
        }    
    }

    // Exclude records created less than 2 seconds ago
    private void removeNewInserts() {
        for(String key : oldRecords.keySet()) {
            SObject record = oldRecords.get(key);
            Datetime testDT = Datetime.valueOf(record.get('createddate')).addSeconds(2);
            if (testDT > Datetime.now()) {
                newRecords.remove(key);
                oldRecords.remove(key);
            } 
        }
    }
}