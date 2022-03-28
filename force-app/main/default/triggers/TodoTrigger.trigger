trigger TodoTrigger on Todo__c (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        TodoTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}