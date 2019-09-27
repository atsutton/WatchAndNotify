public with sharing class NoticeRuleGetter {  

    public List<Notice_Rule__c> getRules(Schema.SObjectType recType) {
        String recTypeStr = recType.getDescribe().getName();
        List<Notice_Rule__c> rules = [
                SELECT Id,
                    Target_Change__c,
                    Target_Field__c,
                    Target_Record_Type__c,
                    Target_Value__c
                FROM
                    Notice_Rule__c
                WHERE
                    Target_Record_Type__c = :recTypeStr AND
                    Active__c = true
        ];
        return rules;
    }

}