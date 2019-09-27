@isTest
private class NoticeRuleGetterTest {
    @isTest
    static void testConstructor() {
        NoticeRuleGetter getter = new NoticeRuleGetter();
        System.assertNotEquals(null, getter, 'Rule getter should not be null.');
    }

    @isTest
    static void testGetRuleByType() {
        Notice_Rule__c ruleProps = new Notice_Rule__c(
            Name = 'TestName',
            Target_Change__c = 'Any change',
            Target_Field__c = 'Name',
            Target_Record_Type__c = 'Account',
            Target_Value__c = '',
            Active__c = true
        );
        
        Integer ruleCount = 5;
        TestDataFactory.makeInsertNoticeRules(ruleCount, ruleProps);
        Schema.SObjectType recType = Account.SObjectType;
        NoticeRuleGetter getter = new NoticeRuleGetter();
        List<Notice_Rule__c> rules = getter.getRules(recType);

        System.assertEquals(ruleCount, rules.size(), 'Number of rules retrieved should equal ' + ruleCount);
    }
}