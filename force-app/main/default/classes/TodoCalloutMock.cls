@IsTest
public with sharing class TodoCalloutMock implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatus('OK');
        response.setStatusCode(200);
        return response;
    }
}