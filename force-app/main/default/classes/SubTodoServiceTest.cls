@IsTest
public with sharing class SubTodoServiceTest {
    @TestSetup
    public static void init() {
        TodoTriggerHandler.enableTrigger = false;
        Id testRecordTypeId = Schema.SObjectType.Todo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
        Todo__c todo = TestDataFactory.TODO.createTodo('Test todo', testRecordTypeId, 'In progress');
        insert todo;
        todo.ToDo_External_Id__c = todo.Id;
        update todo;
        SubTodoTriggerHandler.enableTrigger = false;
        SubTodo__c subTodo = new SubTodo__c(Master__c = todo.Id);
        insert subTodo;
    }

    @IsTest
    public static void createSubTodoTest() {
        List<SubTodo__c> subTodosToSend = [
                SELECT SubTodo_External_Id__c, Name, Done__c, Master__r.ToDo_External_Id__c
                FROM SubTodo__c
        ];
        for (SubTodo__c subTodoToSend : subTodosToSend) {
            subTodoToSend.Id = null;
            subTodoToSend.Master__r.ToDo_External_Id__c = subTodoToSend.Master__r.Id;
        }
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(JSON.serialize(subTodosToSend));
        RestContext.request = request;
        Test.startTest();
        String subTodoResult = SubTodoService.createSubTodo();
        Test.stopTest();
        List<SubTodo__c> subTodoFromResult = (List<SubTodo__c>) JSON.deserialize(subTodoResult, List<SubTodo__c>.class);
        System.assertEquals(false, subTodoFromResult.isEmpty(), 'Result list is empty after createSubTodo');
    }

    @IsTest
    public static void updateTodoTest() {
        List<SubTodo__c> subTodosToSend = [
                SELECT SubTodo_External_Id__c, Name, Done__c, Master__r.ToDo_External_Id__c
                FROM SubTodo__c
        ];
        for (SubTodo__c subTodoToSend : subTodosToSend) {
            subTodoToSend.SubTodo_External_Id__c = subTodoToSend.Id;
        }
        SubTodoTriggerHandler.enableTrigger = false;
        update subTodosToSend;
        RestRequest request = new RestRequest();
        request.httpMethod = 'PATCH';
        request.requestBody = Blob.valueOf(JSON.serialize(subTodosToSend));
        RestContext.request = request;
        Test.startTest();
        String subTodoResult = SubTodoService.updateSubTodo();
        Test.stopTest();
        List<SubTodo__c> subTodoFromResult = (List<SubTodo__c>) JSON.deserialize(subTodoResult, List<SubTodo__c>.class);
        System.assertEquals(false, subTodoFromResult.isEmpty(), 'Result list is empty after updateSubTodo');
    }

    @IsTest
    public static void deleteSubTodoTest() {
        Map<Id, SubTodo__c> subTodosByIdsMap = new Map<Id, SubTodo__c>([
                SELECT SubTodo_External_Id__c, Name, Done__c, Master__r.ToDo_External_Id__c
                FROM SubTodo__c
        ]);
        for (SubTodo__c subTodoToSend : subTodosByIdsMap.values()) {
            subTodoToSend.SubTodo_External_Id__c = subTodoToSend.Id;
        }
        SubTodoTriggerHandler.enableTrigger = false;
        update subTodosByIdsMap.values();
        RestRequest request = new RestRequest();
        request.httpMethod = 'DELETE';
        request.requestBody = Blob.valueOf(JSON.serialize(subTodosByIdsMap.keySet()));
        RestContext.request = request;
        Test.startTest();
        String subTodoResult = SubTodoService.deleteSubTodo();
        Test.stopTest();
        List<SubTodo__c> subTodoFromResult = (List<SubTodo__c>) JSON.deserialize(subTodoResult, List<SubTodo__c>.class);
        System.assertEquals(false, subTodoFromResult.isEmpty(), 'Result list is empty after deleteSubTodo');
    }

    @IsTest
    public static void undeleteTodoTest() {
        Map<Id, SubTodo__c> subTodosByIdsMap = new Map<Id, SubTodo__c>([
                SELECT SubTodo_External_Id__c, Name, Done__c, Master__r.ToDo_External_Id__c
                FROM SubTodo__c
        ]);
        for (SubTodo__c subTodoToSend : subTodosByIdsMap.values()) {
            subTodoToSend.SubTodo_External_Id__c = subTodoToSend.Id;
        }
        SubTodoTriggerHandler.enableTrigger = false;
        update subTodosByIdsMap.values();
        delete subTodosByIdsMap.values();
        RestRequest request = new RestRequest();
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(JSON.serialize(subTodosByIdsMap.keySet()));
        RestContext.request = request;
        Test.startTest();
        String subTodoResult = SubTodoService.undeleteTodo();
        Test.stopTest();
        List<SubTodo__c> subTodoFromResult = (List<SubTodo__c>) JSON.deserialize(subTodoResult, List<SubTodo__c>.class);
        System.assertEquals(false, subTodoFromResult.isEmpty(), 'Result list is empty after undeleteSubTodo');
    }
}