@IsTest
public with sharing class ToDoCleanerBatchTest {

    @IsTest
    static void testBatchSchedule() {
        Test.startTest();
        ToDoCleanerBatch todoCleanerBatch = new ToDoCleanerBatch();
        String cron = '0 0 * * * ?';
        String jobId = System.schedule('ToDo__c cleaner job every hour', cron, todoCleanerBatch);
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered FROM CronTrigger WHERE Id = :jobId];
        Test.stopTest();
        System.assertEquals(0, cronTrigger.TimesTriggered);
        System.assertEquals(cron, cronTrigger.CronExpression);
    }

    @IsTest
    static void testBatchIterable() {
        Todo__c todo = new Todo__c(
                Name = 'Test todo',
                Status__c = 'In progress'
        );
        TodoTriggerHandler.enableTrigger = false;
        insert todo;
        List<ToDo_Batch_Setting__mdt> toDoBatchSettings = [
                SELECT Id, DeveloperName, Number_of_Days_to_Delete__c
                FROM ToDo_Batch_Setting__mdt
                WHERE DeveloperName = 'Todo_Batch'
                LIMIT 1
        ];
        Date dateToClean = Date.today().addDays(-Integer.valueOf(toDoBatchSettings.get(0).Number_of_Days_to_Delete__c + 1));
        Test.setCreatedDate(todo.Id, dateToClean);
        Test.startTest();
        Database.executeBatch(new ToDoCleanerBatch());
        Test.stopTest();
        List<Todo__c> todos = [SELECT Id FROM Todo__c WHERE Id = :todo.Id];
        System.assertEquals(true, todos.isEmpty());
    }

}