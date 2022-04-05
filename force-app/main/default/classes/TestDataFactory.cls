public with sharing class TestDataFactory {
    
    //public static TestRecordTypeFactory RECORDTYPE = new TestRecordTypeFactory();
    public static TestTodoFactory TODO = new TestTodoFactory();
    public static TestQueueFactory QUEUE = new TestQueueFactory();
	
    public class TestTodoFactory{
        public Todo__c createTodo(String name, Id recordTypeId, String status) {
            return new Todo__c(Name = name, RecordTypeId = recordTypeId, Status__c = status);
        }

        public List<Todo__c> createTodoList(Integer count, String Name, Id recordTypeId, String status) {
            List<Todo__c> todos = new List<Todo__c>();
            for(Integer i = 0; i < count; i++) {
                todos.add(createTodo(name, recordTypeId, status));
            }
            insert todos;
            return todos;
        }
    }

    public class TestQueueFactory{
        public Group createQueue(String name, String type) {
            Group queue = new Group(Name = name, Type = type);
            insert queue;
            return queue;
        }
    }
}
