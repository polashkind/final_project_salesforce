public with sharing class SubTodoTriggerHandler {
    public static Boolean enableTrigger = true;
    
    @Future(Callout=true)
    public static void sendAfterInsert(Set<Id> todosIdSet) {
        List<SubTodo__c> subTodosToSend = [
                SELECT SubTodo_External_Id__c, Name, Done__c, Master__r.ToDo_External_Id__c
                FROM SubTodo__c
                WHERE Id IN :todosIdSet
        ];
        for (SubTodo__c todo : subTodosToSend) {
            todo.Id = null;
        }
        TodoCallout.insertSubTodos(subTodosToSend);
    }

    public static void afterInsert(Map<Id,SubTodo__c> subTodoMap) {
        List<SubTodo__c> subTodosList = [
                SELECT Id, SubTodo_External_Id__c
                FROM SubTodo__c
                WHERE Id IN :subTodoMap.keySet()
        ];
        List<SubTodo__c> subTodoToUpdate = new List<SubTodo__c>();
        for (SubTodo__c subTodo : subTodosList) {
            if (String.isEmpty(subTodo.SubTodo_External_Id__c)) {
                subTodo.SubTodo_External_Id__c = subTodo.Id;
                subTodoToUpdate.add(subTodo);
            }
        }
        if (!subTodoToUpdate.isEmpty()){
            SubTodoTriggerHandler.enableTrigger = false;
            update subTodoToUpdate;
        }
        sendAfterInsert(subTodoMap.keySet());
    }

    @Future(Callout=true)
    public static void afterUpdate(Set<Id> subTodosIdSet) {
        List<SubTodo__c> subTodosToSend = [
                SELECT SubTodo_External_Id__c, Name, Done__c, Master__r.ToDo_External_Id__c
                FROM SubTodo__c
                WHERE Id IN :subTodosIdSet
        ];
        TodoCallout.updateSubTodos(subTodosToSend);
    }

    public static void afterDelete(Map<Id,SubTodo__c> subTodosMap) {
        Set<Id> externalIdSet = new Set<Id>();
        for (SubTodo__c subTodo : subTodosMap.values()) {
            externalIdSet.add(subTodo.SubTodo_External_Id__c);
        }
        sendAfterDelete(externalIdSet);
    }

    @Future(Callout=true)
    public static void sendAfterDelete(Set<Id> externalIdSet) {
        TodoCallout.deleteSubTodos(externalIdSet);
    }

    public static void afterUndelete(Map<Id,SubTodo__c> subTodosMap) {
        Set<Id> externalIdSet = new Set<Id>();
        for (SubTodo__c subTodo : subTodosMap.values()) {
            externalIdSet.add(subTodo.SubTodo_External_Id__c);
        }
        sendAfterUndelete(externalIdSet);
    }

    @Future(Callout=true)
    public static void sendAfterUndelete(Set<Id> externalIdSet) {
        TodoCallout.undeleteSubTodos(externalIdSet);
    }
}