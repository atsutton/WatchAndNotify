@isTest
public class TestDatafactoryTest {

    @isTest
    static void testMakeInsertAccounts() {
        Integer accCount = 5;
        TestDataFactory.makeInsertAccounts(accCount);
        List<Account> allAccounts = [SELECT Id FROM Account];
        System.assertEquals(accCount, allAccounts.size(), 'Number of accounts should equal ' + accCount);
    }

    @isTest
    static void testMakeInsertNoticeRules() {
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
        List<Notice_Rule__c> allRules = [SELECT Id, Target_Record_Type__c, Target_Field__c, Active__c FROM Notice_Rule__c];
        
        System.assertEquals(ruleCount, allRules.size(), 'Number of Notice Rule records should equal ' + ruleCount);
        for(Notice_Rule__c rule : allRules) {
            System.assertEquals(ruleProps.Target_Field__c, rule.Target_Field__c, 'Target_Field__c should equal ' + ruleProps.Target_Field__c);
            System.assertEquals(ruleProps.Target_Record_Type__c, rule.Target_Record_Type__c, 'Target_Record_Type__c should equal ' + ruleProps.Target_Record_Type__c);
            System.assertEquals(ruleProps.Active__c, rule.Active__c, 'Active__c should equal ' + ruleProps.Active__c);
        }
    }
}