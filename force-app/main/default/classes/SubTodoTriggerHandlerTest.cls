@IsTest
public with sharing class SubTodoTriggerHandlerTest {
    @IsTest
    public static void afterInsertTest() {
        Test.setMock(HttpCalloutMock.class, new TodoCalloutMock());
        Group queue = new Group(Name = 'Later', Type = 'Queue');
        insert queue;
        Id testRecordTypeId = Schema.SObjectType.Todo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
        Todo__c todo = TestDataFactory.TODO.createTodo('Test todo', testRecordTypeId, 'In progress');
        Boolean noError = true;
        TodoTriggerHandler.enableTrigger = false;
        insert todo;
        Test.startTest();
        try {
            SubTodo__c subTodo = new SubTodo__c(Master__c = todo.Id);
            insert subTodo;
        } catch (StatusCodeException e) {
            System.debug(e);
            noError = false;
        }
        Test.stopTest();
        System.assertEquals(true, noError, 'Error during SubTodo__c afterInsert process');
    }

    @IsTest
    public static void afterUpdateTest() {
        Test.setMock(HttpCalloutMock.class, new TodoCalloutMock());
        Group queue = new Group(Name = 'Later', Type = 'Queue');
        insert queue;
        Id testRecordTypeId = Schema.SObjectType.Todo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
        Todo__c todo = TestDataFactory.TODO.createTodo('Test todo', testRecordTypeId, 'In progress');
        Boolean noError = true;
        TodoTriggerHandler.enableTrigger = false;
        insert todo;
        SubTodoTriggerHandler.enableTrigger = false;
        SubTodo__c subTodo = new SubTodo__c(Master__c = todo.Id);
        insert subTodo;
        SubTodoTriggerHandler.enableTrigger = true;
        Test.startTest();
        try {
            subTodo.Done__c = true;
            update subTodo;
        } catch (StatusCodeException e) {
            System.debug(e);
            noError = false;
        }
        Test.stopTest();
        System.assertEquals(true, noError, 'Error during SubTodo__c afterUpdate process');
    }

    @IsTest
    public static void afterDeleteTest() {
        Test.setMock(HttpCalloutMock.class, new TodoCalloutMock());
        Group queue = new Group(Name = 'Later', Type = 'Queue');
        insert queue;
        Id testRecordTypeId = Schema.SObjectType.Todo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
        Todo__c todo = TestDataFactory.TODO.createTodo('Test todo', testRecordTypeId, 'In progress');
        Boolean noError = true;
        TodoTriggerHandler.enableTrigger = false;
        insert todo;
        SubTodoTriggerHandler.enableTrigger = false;
        SubTodo__c subTodo = new SubTodo__c(Master__c = todo.Id);
        insert subTodo;
        SubTodoTriggerHandler.enableTrigger = true;
        Test.startTest();
        try {
            delete subTodo;
        } catch (StatusCodeException e) {
            System.debug(e);
            noError = false;
        }
        Test.stopTest();
        System.assertEquals(true, noError, 'Error during SubTodo__c afterDelete process');
    }

    @IsTest
    public static void afterUndeleteTest() {
        Test.setMock(HttpCalloutMock.class, new TodoCalloutMock());
        Group queue = new Group(Name = 'Later', Type = 'Queue');
        insert queue;
        Id testRecordTypeId = Schema.SObjectType.Todo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
        Todo__c todo = TestDataFactory.TODO.createTodo('Test todo', testRecordTypeId, 'In progress');
        Boolean noError = true;
        TodoTriggerHandler.enableTrigger = false;
        insert todo;
        SubTodoTriggerHandler.enableTrigger = false;
        SubTodo__c subTodo = new SubTodo__c(Master__c = todo.Id);
        insert subTodo;
        delete subTodo;
        SubTodoTriggerHandler.enableTrigger = true;
        Test.startTest();
        try {
            undelete subTodo;
        } catch (StatusCodeException e) {
            System.debug(e);
            noError = false;
        }
        Test.stopTest();
        System.assertEquals(true, noError, 'Error during SubTodo__c afterDelete process');
    }
}