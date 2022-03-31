public with sharing class TodoHelper {
    public static void assignTodoToQ(List<Todo__c> todoList) {
        
        List<Id> recordTypeIds = new List<Id>();
        for (Todo__c todo : todoList) {
            recordTypeIds.add(todo.RecordTypeId);
        }
        
        List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE Id IN :recordTypeIds];
        List<Group> queues = [SELECT Id, Name FROM Group WHERE Type = 'Queue'];
        
        Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>(recordTypes);
        
        // get RecordType by RecordTypeId
        Map<String, String> queueNameByRecordTypeName = new Map<String, String>();
        for(Todo__c todo : todoList) {
            RecordType recordType = recordTypeMap.get(todo.RecordTypeId);
            queueNameByRecordTypeName.put(recordType.Name, recordType.Name + ' Group');
        }
        
        Map<String, Group> queueByQueueName = new Map<String, Group>();
        for(Group queue : queues) {
            queueByQueueName.put(queue.Name, queue);
        }

        // Map queue ID by record type ID
        Map<Id, Id> queueIdByRecordTypeId = new Map<Id, Id>();
        for(RecordType recordType : recordTypes) {
            Group queue = queueByQueueName.get(queueNameByRecordTypeName.get(recordType.Name));
            queueIdByRecordTypeId.put(recordType.Id, queue.Id);
        }
        for (Todo__c todo : todoList) {
            todo.OwnerId = queueIdByRecordTypeId.get(todo.RecordTypeId);
        }
    }
}
