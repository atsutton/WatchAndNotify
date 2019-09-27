@isTest
private class NoticeRuleCheckerTest {

    @isTest
    static void testConstructor() {
        NoticeRuleChecker checker = new NoticeRuleChecker();
        System.assertNotEquals(null, checker, 'Notice rule checker should not be null');
    }

    @isTest
    static void testFailAnyChange() {
        Integer eventTotal = 25;
        List<Notice_Rule__c> rules = getRules();
        Map<Id,Account> oldRecords = getAccounts();
        Map<Id,Account> newRecords = oldRecords.deepClone();
        for (String k : newRecords.keySet()) {
            Account a = newRecords.get(k);
            a.Name = a.Name + 'x';
        }
        runRuleChecker(newRecords, oldRecords, rules, eventTotal);
    }

    @isTest
    static void testFailEquals() {
        Integer eventTotal = 25;
        List<Notice_Rule__c> rules = getRules();
        for(Notice_Rule__c rule : rules) {
            rule.Target_Change__c = 'Equals';
            rule.Target_Value__c = 'x';
        }

        Map<Id,Account> oldRecords = getAccounts();
        Map<Id,Account> newRecords = oldRecords.deepClone();
        for (String k : newRecords.keySet()) {
            Account a = newRecords.get(k);
            a.Name = 'x';
        }

        runRuleChecker(newRecords, oldRecords, rules, eventTotal);
    }

    @isTest
    static void testFailNotEqualTo() {
        Integer eventTotal = 25;
        List<Notice_Rule__c> rules = getRules();
        for(Notice_Rule__c rule : rules) {
            rule.Target_Change__c = 'Not equal to';
            rule.Target_Value__c = 'x';
        }

        Map<Id,Account> oldRecords = getAccounts();
        Map<Id,Account> newRecords = oldRecords.deepClone();

        runRuleChecker(newRecords, oldRecords, rules, eventTotal);
    }

    @isTest
    static void testFailContains() {
        Integer eventTotal = 25;
        List<Notice_Rule__c> rules = getRules();
        for(Notice_Rule__c rule : rules) {
            rule.Target_Change__c = 'Contains';
            rule.Target_Value__c = 'x';
        }

        Map<Id,Account> oldRecords = getAccounts();
        Map<Id,Account> newRecords = oldRecords.deepClone();
        for (String k : newRecords.keySet()) {
            Account a = newRecords.get(k);
            a.Name = a.Name + 'x';
        }
        runRuleChecker(newRecords, oldRecords, rules, eventTotal);
    }

    @isTest
    static void testFailDoesNotContain() {
        Integer eventTotal = 25;
        List<Notice_Rule__c> rules = getRules();
        for(Notice_Rule__c rule : rules) {
            rule.Target_Change__c = 'Does not contain';
            rule.Target_Value__c = 'x';
        }

        Map<Id,Account> oldRecords = getAccounts();
        Map<Id,Account> newRecords = oldRecords.deepClone();

       runRuleChecker(newRecords, oldRecords, rules, eventTotal);
    }

    @isTest
    static void testFailStartsWith() {
        Integer eventTotal = 25;
        List<Notice_Rule__c> rules = getRules();
        for(Notice_Rule__c rule : rules) {
            rule.Target_Change__c = 'Starts with';
            rule.Target_Value__c = 'x';
        }

        Map<Id,Account> oldRecords = getAccounts();
        Map<Id,Account> newRecords = oldRecords.deepClone();
        for (String k : newRecords.keySet()) {
            Account a = newRecords.get(k);
            a.Name = 'x' + a.name;
        }
        
        runRuleChecker(newRecords, oldRecords, rules, eventTotal);
    }

    @isTest
    static void testFieldNameBad() {
        Integer eventTotal = 0;
        List<Notice_Rule__c> rules = getRules();
        for(Notice_Rule__c rule : rules) {
            rule.Target_Field__c = 'Bad Field Name';
        }
        Map<Id,Account> oldRecords = getAccounts();
        Map<Id,Account> newRecords = oldRecords.deepClone();
        for (String k : newRecords.keySet()) {
            Account a = newRecords.get(k);
            a.Name = a.Name + 'x';
        }
        runRuleChecker(newRecords, oldRecords, rules, eventTotal);
    }

    @isTest
    static void testFieldNameNotSetOnRecords() {
        Integer eventTotal = 0;
        List<Notice_Rule__c> rules = getRules();
        for(Notice_Rule__c rule : rules) {
            rule.Target_Field__c = 'TickerSymbol';
        }
        Map<Id,Account> oldRecords = getAccounts();
        Map<Id,Account> newRecords = oldRecords.deepClone();
        for (String k : newRecords.keySet()) {
            Account a = newRecords.get(k);
            a.Name = a.Name + 'x';
        }
        runRuleChecker(newRecords, oldRecords, rules, eventTotal);
    }


    // Utility Methods

    @TestSetup
    static void basicSetup(){
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
        List<Account> accounts = TestDataFactory.makeInsertAccounts(accCount);
        List<Notice_Rule__c> rules = TestDataFactory.makeInsertNoticeRules(ruleCount, ruleProps);
    }
    
    static Map<Id,Account> getAccounts() {
        Map<Id,Account> acctMap = new Map<Id,Account>([SELECT Id, Name FROM Account]);
        return acctMap;
    }

    static List<Notice_Rule__c> getRules() {
        return [SELECT Id, Target_Record_Type__c, Target_Field__c, Target_Change__c, Target_Value__c FROM Notice_Rule__c];
    }

    static List<Notice_Rule_Event__c> getEvents() {
        return [SELECT Id FROM Notice_Rule_Event__c];
    }

    static void runRuleChecker(Map<Id,Account> newRecords, Map<Id,Account> oldRecords, List<Notice_Rule__c> rules, Integer eventTotal) {
        NoticeRuleChecker checker = new NoticeRuleChecker();
        checker.checkRules(newRecords, oldRecords, rules);
        List<Notice_Rule_Event__c> events = getEvents();
        System.assertEquals(eventTotal, events.size(), 'Number of notice rule events should be ' + eventTotal);
    }

}
