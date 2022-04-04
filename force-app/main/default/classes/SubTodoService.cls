@RestResource(UrlMapping='/SubTodoIntegration/*')
global class SubTodoService {

    @HttpPost
    global static String createSubTodo() {
        List<SubTodo__c> subTodos = prepareSubTodosForDML();
        if (!subTodos.isEmpty()) {
            SubTodoTriggerHandler.enableTrigger = false;
            insert subTodos;
        }
        return JSON.serialize(subTodos);
    }

    @HttpDelete
    global static String deleteSubTodo() {
        RestRequest request = RestContext.request;
        Set<Id> subTodosExternalIdSet = (Set<Id>) JSON.deserialize(request.requestBody.toString(), Set<Id>.class);
        List<SubTodo__c> subTodos = [
                SELECT Id, SubTodo_External_Id__c
                FROM SubTodo__c
                WHERE SubTodo_External_Id__c IN :subTodosExternalIdSet
        ];
        if (!subTodos.isEmpty()) {
            SubTodoTriggerHandler.enableTrigger = false;
            delete subTodos;
        }
        return JSON.serialize(subTodos);
    }

    @HttpPut
    global static String undeleteTodo() {
        RestRequest request = RestContext.request;
        Set<Id> subTodosExternalIdSet = (Set<Id>) JSON.deserialize(request.requestBody.toString(), Set<Id>.class);
        List<SubTodo__c> subTodos = [
                SELECT Id, SubTodo_External_Id__c
                FROM SubTodo__c
                WHERE SubTodo_External_Id__c IN :subTodosExternalIdSet AND IsDeleted = TRUE
                ALL ROWS
        ];
        if (!subTodos.isEmpty()) {
            SubTodoTriggerHandler.enableTrigger = false;
            undelete subTodos;
        }
        return JSON.serialize(subTodos);
    }


    @HttpPatch
    global static String updateSubTodo() {
        List<SubTodo__c> subTodos = prepareSubTodosForDML();
        if (!subTodos.isEmpty()) {
            SubTodoTriggerHandler.enableTrigger = false;
            upsert subTodos SubTodo_External_Id__c;
        }
        return JSON.serialize(subTodos);
    }

    private static List<SubTodo__c> prepareSubTodosForDML() {
        RestRequest request = RestContext.request;
        List<SubTodo__c> subTodos = (List<SubTodo__c>) JSON.deserialize(request.requestBody.toString(), List<SubTodo__c>.class);
        List<SubTodo__c> subTodosToInsert = new List<SubTodo__c>();
        for (SubTodo__c subTodo : subTodos) {
            Todo__c masterTodo = new Todo__c(ToDo_External_Id__c = subTodo.Master__r.ToDo_External_Id__c);
            SubTodo__c subTodoToInsert = new SubTodo__c(
                    Name = subTodo.Name,
                    Done__c = subTodo.Done__c,
                    SubTodo_External_Id__c = subTodo.SubTodo_External_Id__c,
                    Master__r = masterTodo
            );
            subTodosToInsert.add(subTodoToInsert);
        }
        return subTodosToInsert;
    }
}