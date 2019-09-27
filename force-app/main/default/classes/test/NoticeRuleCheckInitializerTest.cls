@isTest
private class NoticeRuleCheckInitializerTest {
    @isTest
    static void testConstructor() {
        Notice_Rule__c ruleProps = new Notice_Rule__c(
            Name = 'TestName',
            Target_Change__c = 'Any change',
            Target_Field__c = 'Name',
            Target_Record_Type__c = 'Account',
            Target_Value__c = '',
            Active__c = true
        );
        
        Integer accCount = 5;
        Integer ruleCount = 5;
        SObjectType recTypeObj = Account.sObjectType;

        List<Account> accounts = TestDataFactory.makeInsertAccounts(accCount);
        TestDataFactory.makeInsertNoticeRules(ruleCount, ruleProps);
        Map<Id,Account> oldAccounts = new Map<Id,Account>([SELECT Id, Name FROM Account]);
        Map<Id,Account> newAccounts = oldAccounts.deepClone();
        NoticeRuleCheckInitializer init = new NoticeRuleCheckInitializer(oldAccounts, newAccounts);

        System.assertNotEquals(null, init, 'Initializer should not be null.');
        System.assertNotEquals(null, init.ruleGetter, 'Rule getter should not be null.');
        System.assertNotEquals(null, init.ruleChecker, 'Rule checker should not be null.');
        System.assertEquals(recTypeObj, init.recType, 'recType should be' + recTypeObj);
        System.assertEquals(ruleCount, init.rules.size(), 'Number of rules should be ' + ruleCount);

    }
}