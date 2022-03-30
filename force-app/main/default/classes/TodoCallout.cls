public with sharing class TodoCallout {
    private final static String calloutTodo = 'callout:Epam316/services/apexrest/TodoIntegration/';
    private final static String calloutSubTodo = 'callout:Epam316/services/apexrest/SubTodoIntegration/';
    private final static String header = 'Content-Type';
    private final static String headerType = 'application/json;charset=UTF-8';

    public static HttpResponse insertTodos(List<Todo__c> todos) {
        return sendRequest('POST', calloutTodo, JSON.serialize(todos));
    }

    public static HttpResponse updateTodos(List<Todo__c> todos) {
        return sendRequest('PATCH', calloutTodo, JSON.serialize(todos));
    }

    public static HttpResponse deleteTodos(Set<Id> externalIdSet) {
        return sendRequest('DELETE', calloutTodo, JSON.serialize(externalIdSet));
    }

    public static HttpResponse undeleteTodos(Set<Id> externalIdSet) {
        return sendRequest('PUT', calloutTodo, JSON.serialize(externalIdSet));
    }

    public static HttpResponse insertSubTodos(List<SubTodo__c> subTodos) {
        return sendRequest('POST', calloutSubTodo, JSON.serialize(subTodos));
    }

    public static HttpResponse updateSubTodos(List<SubTodo__c> subTodos) {
        return sendRequest('PATCH', calloutSubTodo, JSON.serialize(subTodos));
    }

    public static HttpResponse deleteSubTodos(Set<Id> externalIdSet) {
        return sendRequest('DELETE', calloutSubTodo, JSON.serialize(externalIdSet));
    }

    public static HttpResponse undeleteSubTodos(Set<Id> externalIdSet) {
        return sendRequest('PUT', calloutSubTodo, JSON.serialize(externalIdSet));
    }

    private static HttpResponse sendRequest(String method, String endPoint, String body) {
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(endPoint);
        request.setHeader(header, headerType);

        if (String.isNotBlank(body)) {
            request.setBody(body);
        }

        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() != 200) {
            System.debug('ERROR Send Request - Status Code: ' + response.getStatusCode());
        }
        return response;
    }
}