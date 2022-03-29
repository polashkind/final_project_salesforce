public with sharing class TodoHelper {
    public static void assignTodoToQ(List<Todo__c> todoList) {
        for (Todo__c todo : todoList) {
            // get RecordType by RecordTypeId
            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE Id = :todo.recordTypeId LIMIT 1];
            // get queue by recordTypeName
            String qName = recordType.Name;
            system.debug('qName' + qName);
            String assignQ = '%' + qName + '%';
            system.debug('assignQ' + assignQ);
            Group queue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name LIKE :assignQ LIMIT 1];
            // assign queue id to todo ownerId 
            todo.OwnerId = queue.Id;
        }
    }
}
