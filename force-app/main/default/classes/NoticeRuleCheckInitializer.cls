public with sharing class NoticeRuleCheckInitializer {
    @TestVisible NoticeRuleGetter ruleGetter;
    @TestVisible NoticeRuleChecker ruleChecker;
    @TestVisible List<Notice_Rule__c> rules;
    @TestVisible Schema.SObjectType recType;
    @TestVisible Set<ID> targetRecordIDs;

    public NoticeRuleCheckInitializer(Map<Id,SObject> newRecords, Map<Id,Sobject> oldRecords) {
        ruleGetter = new NoticeRuleGetter();
        ruleChecker = new NoticeRuleChecker();
        rules = new List<Notice_Rule__c>();
        recType = oldRecords.getSObjectType();
        runGetter();
        ruleChecker.checkRules(newRecords, oldRecords, rules);
    }

    private void runGetter() {
        List<Notice_Rule__c> rulesTargetByType = ruleGetter.getRules(recType);
        rules.addAll(rulesTargetByType);
    }

}