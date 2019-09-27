@isTest
public with sharing class LeadTriggerHandlerTest {
    @isTest
    static void testConstructor() {
        Boolean isExecuting = true;
        Integer batchSize = 25;
        LeadTriggerHandler handler = new LeadTriggerHandler(isExecuting, batchSize);

        System.assertEquals(isExecuting, handler.isExecuting, 'handler.isExecuting should equal ' + isExecuting);
        System.assertEquals(batchSize, handler.batchSize, 'handler.isExecuting should equal ' + batchSize);
    }

    @isTest
    static void testOnAfterUpdate() {
        Boolean isExecuting = true;
        Integer batchSize = 25;
        Integer leadCount = 5;
        
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0; i < leadCount; i++) {
            String s = 'TestLead' + i;
            Lead l = new Lead(
                Lastname = s,
                Company = s,
                Status = 'Open'
            );
            leads.add(l);
        }
        insert leads;
        Map<Id,Lead> oldLeadMap = new Map<Id,Lead>([SELECT Id, CreatedDate FROM Lead]);
        Map<Id,Lead> newLeadMap = oldLeadMap.clone();

        LeadTriggerHandler handler = new LeadTriggerHandler(isExecuting, batchSize);
        handler.onAfterUpdate(newLeadMap, oldLeadMap);

    }
}
