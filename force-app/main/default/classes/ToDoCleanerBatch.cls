public with sharing class ToDoCleanerBatch implements Database.Batchable<SObject>, Schedulable {

    public Iterable<SObject> start(Database.BatchableContext BC) {
        List<ToDo_Batch_Setting__mdt> toDoBatchSettings = [
                SELECT Id, DeveloperName, Number_of_Days_to_Delete__c
                FROM ToDo_Batch_Setting__mdt
                WHERE DeveloperName = 'Todo_Batch'
                LIMIT 1
        ];
        Date dateToClean = Date.today().addDays(-Integer.valueOf(toDoBatchSettings.get(0).Number_of_Days_to_Delete__c));
        return Database.getQueryLocator([
                SELECT Id, CreatedDate
                FROM Todo__c
                WHERE CreatedDate < :dateToClean
        ]);
    }

    public void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(this);
    }

    public void execute(Database.BatchableContext BC, List<SObject> todosList) {
        List<Todo__c> todos = todosList;
        if (!todos.isEmpty()) {
            System.debug('Number of Todo__c records to delete: ' + todos.size());
            delete todos;
        }
    }

    public void finish(Database.BatchableContext param1) {
    }

}
