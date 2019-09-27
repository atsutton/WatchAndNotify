public with sharing class AccountTriggerHandler {
    @testVisible private Boolean isExecuting = false;
    @testVisible private Integer batchSize = 0;
    
    public AccountTriggerHandler(Boolean isExecuting, Integer batchSize) {
        this.isExecuting = isExecuting;
        this.batchSize = batchSize;
    }

    public void onAfterUpdate(Map<Id,Account> updatedAccounts, Map<Id,Account> oldAccounts) {
        NoticeRuleCheckInitializer checker = new NoticeRuleCheckInitializer(updatedAccounts, oldAccounts);
    }
}