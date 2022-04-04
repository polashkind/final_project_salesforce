@isTest
public with sharing class TodoHelperTest {
    
    @isTest
    static void assignTodoToQTest() {
        
        //RecordType recordType = TestDataFactory.RECORDTYPE.createRecordType('Test', 'Todo__c');
        //system.debug('recordType' + recordType);
        TodoTriggerHandler.enableTrigger = false;
        Id testRecordTypeId = Schema.SObjectType.Todo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
        List<Todo__c> todos = TestDataFactory.TODO.createTodoList(5, 'Test todo', testRecordTypeId, 'In progress');
        Group queue = TestDataFactory.QUEUE.createQueue('Later Group', 'Queue');
        
        Test.startTest();
        
        TodoHelper.assignTodoToQ(todos);
        
        Test.stopTest();

        System.assertNotEquals(null, todos);
        System.assertEquals(queue.Id, todos[0].OwnerId);
    }
}
