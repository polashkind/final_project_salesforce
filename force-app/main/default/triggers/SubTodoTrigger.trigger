trigger SubTodoTrigger on SubTodo__c (after insert, after update, after delete, after undelete) {
    if (SubTodoTriggerHandler.enableTrigger) {
        switch on Trigger.operationType {
            when AFTER_INSERT {
                SubTodoTriggerHandler.afterInsert(Trigger.newMap);
            }
            when AFTER_UPDATE {
                SubTodoTriggerHandler.afterUpdate(Trigger.newMap.keySet());
            }
            when AFTER_DELETE {
                SubTodoTriggerHandler.afterDelete(Trigger.oldMap);
            }
            when AFTER_UNDELETE {
                SubTodoTriggerHandler.afterUndelete(Trigger.newMap);
            }
        }
    }
}