@isTest
public class TestDataFactory {
    
    public static List<Account> makeInsertAccounts(Integer accCount) {
        List<Account> accounts = new List<Account>();
        if (accCount >= 1) {
            for(Integer i = 0; i < accCount; i++) {
                String newName = 'TestAccount' + i;
                Account newRec = new Account ( Name = newName);
                accounts.add(newRec);
            }
            insert accounts;
        }
        return accounts;
    }

    public static List<Notice_Rule__c> makeInsertNoticeRules(Integer ruleCount, Notice_Rule__c ruleProps) {
        List <Notice_Rule__c> rules = new List<Notice_Rule__c>();
            for(Integer i = 0; i < ruleCount; i++) {
                Notice_Rule__c rule = new Notice_Rule__c(
                    Name = ruleProps.Name + i,
                    Target_Change__c = ruleProps.Target_Change__c,
                    Target_Field__c = ruleProps.Target_Field__c,
                    Target_Record_Type__c = ruleProps.Target_Record_Type__c,
                    Target_Value__c = ruleProps.Target_Value__c,
                    Active__c = ruleProps.Active__c
                );
                rules.add(rule);
            }
        insert rules;
        return rules;
    }
}