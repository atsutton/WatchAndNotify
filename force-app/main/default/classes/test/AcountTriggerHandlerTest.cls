@isTest
public with sharing class AcountTriggerHandlerTest {
    @isTest
    static void testConstructor() {
        Boolean isExecuting = true;
        Integer batchSize = 25;

        AccountTriggerHandler handler = new AccountTriggerHandler(isExecuting, batchSize);

        System.assertEquals(isExecuting, handler.isExecuting, 'handler.isExecuting should equal ' + isExecuting);
        System.assertEquals(batchSize, handler.batchSize, 'handler.isExecuting should equal ' + batchSize);
    }

    
    @isTest
    static void testOnAfterUpdate() {
        Boolean isExecuting = true;
        Integer batchSize = 25;
        Integer acctCount = 5;
        
        List<Account> accts = new List<Account>();
        for(Integer i = 0; i < acctCount; i++) {
            Account a = new Account(
                Name = 'TestAccount' + i
            );
            accts.add(a);
        }
        insert accts;
        Map<Id,Account> oldAccountMap = new Map<Id,Account>([SELECT Id, CreatedDate FROM Account]);
        Map<Id,Account> newAccountMap = oldAccountMap.clone();

        AccountTriggerHandler handler = new AccountTriggerHandler(isExecuting, batchSize);
        handler.onAfterUpdate(newAccountMap, oldAccountMap);

    }
}
