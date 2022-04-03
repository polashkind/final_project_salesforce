@IsTest
public with sharing class TodoTriggerHandlerTest {

    public static Todo__c prepareToDo(){
        Test.setMock(HttpCalloutMock.class, new TodoCalloutMock());
        Group queue = new Group(Name = 'Later', Type = 'Queue');
        insert queue;
        Id testRecordTypeId = Schema.SObjectType.Todo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
        return TestDataFactory.TODO.createTodo('Test todo', testRecordTypeId, 'In progress');
    }

    @IsTest
    public static void afterInsertTest() {
        Todo__c todo = prepareToDo();
        Boolean noError = true;
        Test.startTest();
        try {
            insert todo;
        } catch (StatusCodeException e) {
            System.debug(e);
            noError = false;
        }
        Test.stopTest();
        System.assertEquals(true, noError, 'Error during Todo__c afterInsert process');
    }

    @IsTest
    public static void afterUpdateTest() {
        Todo__c todo = prepareToDo();
        Boolean noError = true;
        TodoTriggerHandler.enableTrigger = false;
        insert todo;
        TodoTriggerHandler.enableTrigger = true;
        Test.startTest();
        try {
            todo.Name = 'New name';
            update todo;
        } catch (StatusCodeException e) {
            System.debug(e);
            noError = false;
        }
        Test.stopTest();
        System.assertEquals(true, noError, 'Error during Todo__c afterUpdate process');
    }

    @IsTest
    public static void afterDeleteTest() {
        Todo__c todo = prepareToDo();
        Boolean noError = true;
        TodoTriggerHandler.enableTrigger = false;
        insert todo;
        TodoTriggerHandler.enableTrigger = true;
        Test.startTest();
        try {
            delete todo;
        } catch (StatusCodeException e) {
            System.debug(e);
            noError = false;
        }
        Test.stopTest();
        System.assertEquals(true, noError, 'Error during Todo__c afterDelete process');
    }

    @IsTest
    public static void afterUndeleteTest() {
        Todo__c todo = prepareToDo();
        Boolean noError = true;
        TodoTriggerHandler.enableTrigger = false;
        insert todo;
        delete todo;
        TodoTriggerHandler.enableTrigger = true;
        Test.startTest();
        try {
            undelete todo;
        } catch (StatusCodeException e) {
            System.debug(e);
            noError = false;
        }
        Test.stopTest();
        System.assertEquals(true, noError, 'Error during Todo__c afterUndelete process');
    }
}