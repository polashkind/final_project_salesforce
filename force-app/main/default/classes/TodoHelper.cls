public with sharing class TodoHelper {
    public static void assignTodoToQ(List<Todo__c> todoList) {
        for (Todo__c todo : todoList) {
            // get RecordType by RecordTypeId
            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE Id = :todo.recordTypeId LIMIT 1];
            // get queue by recordTypeName
            Group queue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :recordType.Name LIMIT 1];
            // assign queue id to todo ownerId 
            todo.OwnerId = queue.Id;
        }
    }
}
