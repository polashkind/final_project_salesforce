public with sharing class TodoTriggerHandler {
    public static Boolean enableTrigger = true;

    public static void handleBeforeInsert(List<Todo__c> todoList) {
        TodoHelper.assignTodoToQ(todoList);
    }

    @Future(Callout=true)
    public static void sendAfterInsert(Set<Id> todosIdSet) {
        List<Todo__c> todosToSend = [
                SELECT ToDo_External_Id__c, Name, Status__c, RecordType.DeveloperName, Description__c
                FROM Todo__c
                WHERE Id IN :todosIdSet
        ];
        for (Todo__c todo : todosToSend) {
            todo.Id = null;
        }
        TodoCallout.insertTodos(todosToSend);
    }

    public static void afterInsert(Map<Id, Todo__c> todosMap) {
        List<Todo__c> todosList = [
                SELECT Id, ToDo_External_Id__c
                FROM Todo__c
                WHERE Id IN :todosMap.keySet()
        ];
        List<Todo__c> todoToUpdate = new List<Todo__c>();
        for (Todo__c todo : todosList) {
            if (String.isEmpty(todo.ToDo_External_Id__c)) {
                todo.ToDo_External_Id__c = todo.Id;
                todoToUpdate.add(todo);
            }
        }
        if (!todosList.isEmpty()) {
            TodoTriggerHandler.enableTrigger = false;
            update todoToUpdate;
        }
        sendAfterInsert(todosMap.keySet());
    }

    @Future(Callout=true)
    public static void afterUpdate(Set<Id> todosIdSet) {
        List<Todo__c> todosToSend = [
                SELECT ToDo_External_Id__c, Name, Status__c, RecordType.DeveloperName, Description__c
                FROM Todo__c
                WHERE Id IN :todosIdSet
        ];
        TodoCallout.updateTodos(todosToSend);
    }

    public static void afterDelete(Map<Id, Todo__c> todosMap) {
        Set<Id> externalIdSet = new Set<Id>();
        for (Todo__c todo : todosMap.values()) {
            externalIdSet.add(todo.ToDo_External_Id__c);
        }
        sendAfterDelete(externalIdSet);
    }

    @Future(Callout=true)
    public static void sendAfterDelete(Set<Id> externalIdSet) {
        TodoCallout.deleteTodos(externalIdSet);
    }

    public static void afterUndelete(Map<Id, Todo__c> todosMap) {
        Set<Id> externalIdSet = new Set<Id>();
        for (Todo__c todo : todosMap.values()) {
            externalIdSet.add(todo.ToDo_External_Id__c);
        }
        TodoTriggerHandler.sendAfterUndelete(externalIdSet);
    }

    @Future(Callout=true)
    public static void sendAfterUndelete(Set<Id> externalIdSet) {
        TodoCallout.undeleteTodos(externalIdSet);
    }
}