@isTest
public with sharing class CreateTodoFromEmailTest {
    
    @isTest
    static void handleInboundEmailTest() {
        
        TodoTriggerHandler.enableTrigger = false;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.subject = 'Test';
        email.fromname = 'Test Test';
        env.fromAddress = 'Test@email.com';
        email.plainTextBody = 'Test';
        
		// emailProcess.handleInboundEmail(email, env);
        
        Test.startTest();
        CreateTodoFromEmail emailProcess = new CreateTodoFromEmail();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email, env);
        System.assertEquals(result.success, true);
        Test.stopTest();

    }
}
