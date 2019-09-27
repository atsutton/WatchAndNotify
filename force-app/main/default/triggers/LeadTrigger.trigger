//Structure via http://amitsalesforce.blogspot.com/2015/06/trigger-best-practices-sample-trigger.html
trigger LeadTrigger on Lead ( before insert, before update, before delete, 
                                                    after insert, after update, after delete,
                                                    after undelete) {

    LeadTriggerHandler handler = new LeadTriggerHandler(Trigger.isExecuting, Trigger.size);

    if (Trigger.isUpdate) {
        if(Trigger.isAfter) {
           handler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
    
}