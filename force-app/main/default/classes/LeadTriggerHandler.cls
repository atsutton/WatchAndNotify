public with sharing class LeadTriggerHandler {
    @testVisible private Boolean isExecuting = false;
    @testVisible private Integer batchSize = 0;
    
    public LeadTriggerHandler(Boolean isExecuting, Integer batchSize) {
        this.isExecuting = isExecuting;
        this.batchSize = batchSize;
    }

    public void onAfterUpdate(Map<Id,Lead> updatedLeads, Map<Id,Lead> oldLeads) {
        NoticeRuleCheckInitializer checker = new NoticeRuleCheckInitializer(updatedLeads, oldLeads);
    }
}