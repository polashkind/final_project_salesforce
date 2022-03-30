@RestResource(UrlMapping='/TodoIntegration/*')
global class TodoService {

    @HttpPost
    global static String createTodo() {
        List<Todo__c> todos = prepareTodosForDML();
        if (!todos.isEmpty()) {
            TodoTriggerHandler.enableTrigger = false;
            insert todos;
        }
        return JSON.serialize(todos);
    }

    @HttpPatch
    global static String updateTodo() {
        List<Todo__c> todos = prepareTodosForDML();
        if (!todos.isEmpty()) {
            TodoTriggerHandler.enableTrigger = false;
            upsert todos ToDo_External_Id__c;
        }
        return JSON.serialize(todos);
    }

    @HttpDelete
    global static String deleteTodo() {
        RestRequest request = RestContext.request;
        Set<Id> todosExternalIdSet = (Set<Id>) JSON.deserialize(request.requestBody.toString(), Set<Id>.class);
        List<Todo__c> todos = [
                SELECT Id, ToDo_External_Id__c
                FROM Todo__c
                WHERE ToDo_External_Id__c IN :todosExternalIdSet
        ];
        if (!todos.isEmpty()) {
            TodoTriggerHandler.enableTrigger = false;
            delete todos;
        }
        return JSON.serialize(todos);
    }

    @HttpPut
    global static String undeleteTodo() {
        RestRequest request = RestContext.request;
        Set<Id> todosExternalIdSet = (Set<Id>) JSON.deserialize(request.requestBody.toString(), Set<Id>.class);
        List<Todo__c> todos = [
                SELECT Id, ToDo_External_Id__c
                FROM Todo__c
                WHERE ToDo_External_Id__c IN :todosExternalIdSet AND IsDeleted = TRUE
                ALL ROWS
        ];
        if (!todos.isEmpty()) {
            TodoTriggerHandler.enableTrigger = false;
            undelete todos;
        }
        return JSON.serialize(todos);
    }

    private static List<Todo__c> prepareTodosForDML() {
        List<RecordType> recordTypes = [
                SELECT Id, DeveloperName, SobjectType
                FROM RecordType
                WHERE SobjectType = 'Todo__c'
        ];
        Map<String, Id> recordTypeToIdMap = new Map<String, Id>();
        for (RecordType recordType : recordTypes) {
            recordTypeToIdMap.put(recordType.DeveloperName, recordType.Id);
        }

        RestRequest request = RestContext.request;
        List<Todo__c> todos = (List<Todo__c>) JSON.deserialize(request.requestBody.toString(), List<Todo__c>.class);
        for (Todo__c todo : todos) {
            String recordTypeId = recordTypeToIdMap.get(todo.RecordType.DeveloperName);
            todo.RecordType = null;
            todo.RecordTypeId = recordTypeId;
        }
        return todos;
    }
}