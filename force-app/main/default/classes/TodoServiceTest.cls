@IsTest
public with sharing class TodoServiceTest {
    @TestSetup
    public static void init() {
        Id testRecordTypeId = Schema.SObjectType.Todo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
        TodoTriggerHandler.enableTrigger = false;
        TestDataFactory.TODO.createTodoList(5, 'Test todo', testRecordTypeId, 'In progress');
    }

    @IsTest
    public static void createTodoTest() {
        List<Todo__c> todosToSend = [
                SELECT ToDo_External_Id__c, Name, Status__c, RecordType.DeveloperName, Description__c
                FROM Todo__c
        ];
        for (Todo__c todo : todosToSend) {
            todo.Id = null;
        }
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(JSON.serialize(todosToSend));
        RestContext.request = request;
        Test.startTest();
        String todoResult = TodoService.createTodo();
        Test.stopTest();
        List<Todo__c> todoFromResult = (List<Todo__c>) JSON.deserialize(todoResult, List<Todo__c>.class);
        System.assertEquals(false, todoFromResult.isEmpty(), 'Result list is empty after createTodo');
    }

    @IsTest
    public static void updateTodoTest() {
        List<Todo__c> todosToSend = [
                SELECT Id, ToDo_External_Id__c, Name, Status__c, RecordType.DeveloperName, Description__c
                FROM Todo__c
        ];
        for (Todo__c todo : todosToSend) {
            todo.ToDo_External_Id__c = todo.Id;
        }
        TodoTriggerHandler.enableTrigger = false;
        update todosToSend;
        RestRequest request = new RestRequest();
        request.httpMethod = 'PATCH';
        request.requestBody = Blob.valueOf(JSON.serialize(todosToSend));
        RestContext.request = request;
        Test.startTest();
        String todoResult = TodoService.updateTodo();
        Test.stopTest();
        List<Todo__c> todoFromResult = (List<Todo__c>) JSON.deserialize(todoResult, List<Todo__c>.class);
        System.assertEquals(false, todoFromResult.isEmpty(), 'Result list is empty after updateTodo');
    }

    @IsTest
    public static void deleteTodoTest() {
        Map<Id, Todo__c> todosByIdsMap = new Map<Id, Todo__c>([
                SELECT Id, ToDo_External_Id__c, Name, Status__c, RecordType.DeveloperName, Description__c
                FROM Todo__c
        ]);
        for (Todo__c todo : todosByIdsMap.values()) {
            todo.ToDo_External_Id__c = todo.Id;
        }
        TodoTriggerHandler.enableTrigger = false;
        update todosByIdsMap.values();
        RestRequest request = new RestRequest();
        request.httpMethod = 'DELETE';
        request.requestBody = Blob.valueOf(JSON.serialize(todosByIdsMap.keySet()));
        RestContext.request = request;
        Test.startTest();
        String todoResult = TodoService.deleteTodo();
        Test.stopTest();
        List<Todo__c> todoFromResult = (List<Todo__c>) JSON.deserialize(todoResult, List<Todo__c>.class);
        System.assertEquals(false, todoFromResult.isEmpty(), 'Result list is empty after deleteTodo');
    }

    @IsTest
    public static void undeleteTodoTest() {
        Map<Id, Todo__c> todosByIdsMap = new Map<Id, Todo__c>([
                SELECT Id, ToDo_External_Id__c, Name, Status__c, RecordType.DeveloperName, Description__c
                FROM Todo__c
        ]);
        for (Todo__c todo : todosByIdsMap.values()) {
            todo.ToDo_External_Id__c = todo.Id;
        }
        TodoTriggerHandler.enableTrigger = false;
        update todosByIdsMap.values();
        delete todosByIdsMap.values();
        RestRequest request = new RestRequest();
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(JSON.serialize(todosByIdsMap.keySet()));
        RestContext.request = request;
        Test.startTest();
        String todoResult = TodoService.undeleteTodo();
        Test.stopTest();
        List<Todo__c> todoFromResult = (List<Todo__c>) JSON.deserialize(todoResult, List<Todo__c>.class);
        System.assertEquals(false, todoFromResult.isEmpty(), 'Result list is empty after undeleteTodo');
    }
}