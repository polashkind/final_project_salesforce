trigger TodoTrigger on Todo__c (before insert,after insert, after update, after delete, after undelete) {
    if (TodoTriggerHandler.enableTrigger) {
        switch on Trigger.operationType {
            when AFTER_INSERT {
                TodoTriggerHandler.afterInsert(Trigger.newMap);
            }
            when AFTER_UPDATE {
                TodoTriggerHandler.afterUpdate(Trigger.newMap.keySet());
            }
            when AFTER_DELETE {
                TodoTriggerHandler.afterDelete(Trigger.oldMap);
            }
            when AFTER_UNDELETE {
                TodoTriggerHandler.afterUndelete(Trigger.newMap);
            }
            when BEFORE_INSERT {
                TodoTriggerHandler.handleBeforeInsert(Trigger.new);
            }
        }
    }
}