public with sharing class TodoTriggerHandler {
    public static void handleBeforeInsert(List<Todo__c> todoList) {
        TodoHelper.assignTodoToQ(todoList);
    }
}
