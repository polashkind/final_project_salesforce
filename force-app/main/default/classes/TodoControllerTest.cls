@isTest
private class TodoControllerTest {

    @isTest
    static void getMapTest() {
        TodoTriggerHandler.enableTrigger = false;
        SubTodoTriggerHandler.enableTrigger = false;

        Todo__c testTodo = new Todo__c(Name = 'test todo', Status__c = 'In progress');
        insert new List<Todo__c> { testTodo, new Todo__c(Name = 'alt test todo', Status__c = 'Done') };
        insert new List<SubTodo__c> {
            new SubTodo__c(Name = 'test sub one', Master__c = testTodo.Id),
            new SubTodo__c(Name = 'test sub two', Master__c = testTodo.Id)
        };

        Map<String, List<SubTodo__c>> todoMap = TodoController.getTodoMap();
        
        System.assertEquals(todoMap.keySet().size(), 2);

        String todoString;
        for (String setElement : todoMap.keySet()) {
            todoString = setElement;
            break;
        }
        Todo__c todo = (Todo__c) JSON.deserialize(todoString, Type.forName('Todo__c'));
        System.assertEquals('test todo', todo.Name);
        SubTodo__c sub = todoMap.values().get(0).get(1);
        System.assertEquals(todo.Id, sub.Master__c);
        System.assertEquals('test sub two', sub.Name);
    }

    @isTest
    static void getRecordTypesTest() {
        Map<String, String> typesMap = TodoController.getRecordTypes();
        System.assertNotEquals(null, typesMap);
        System.assertEquals(3, typesMap.size());
    }

/*     @isTest
    static void getSearchedMapTest() {
        Map<String, List<SubTodo__c>> todoMap = TodoController.getSearchedMap('alt');
        
        System.assertEquals(todoMap.keySet().size(), 1);

        String todoString;
        for (String setElement : todoMap.keySet()) {
            todoString = setElement;
            break;
        }
        Todo__c todo = (Todo__c) JSON.deserialize(todoString, Type.forName('Todo__c'));
        System.assertEquals('alt test todo', todo.Name);
    }

    @isTest
    static void getFullSearchedMapTest() {
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = [SELECT Master__c FROM SubTodo__c WHERE Name LIKE '%two%' LIMIT 1].Master__c;

        Test.startTest();
        Test.setFixedSearchResults(fixedSearchResults);
        Map<String, List<SubTodo__c>> todoMap = TodoController.getFullSearchedMap('two');
        Test.stopTest();
        
        System.assertEquals(1, todoMap.keySet().size());

        String todoString;
        for (String setElement : todoMap.keySet()) {
            todoString = setElement;
            break;
        }
        
        Todo__c todo = (Todo__c) JSON.deserialize(todoString, Type.forName('Todo__c'));
        System.assertEquals('test todo', todo.Name);
        SubTodo__c sub = todoMap.values().get(0).get(0);
        System.assertEquals(todo.Id, sub.Master__c);
        System.assertEquals('test sub one', sub.Name);
    } */
}
