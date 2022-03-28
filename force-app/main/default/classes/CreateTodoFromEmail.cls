global class CreateTodoFromEmail implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail( Messaging.InboundEmail email, Messaging.InboundEnvelope env ) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();         
        String myPlainText= '';               
        myPlainText = email.plainTextBody;
           
        try {
            Todo__c todo = new Todo__c( Description__c = myPlainText, Name = email.Subject, Status__c = 'In progress' );      
            System.debug( 'New todo: ' + todo );     
            insert todo;
        }
           
        catch ( Exception e) {
            System.debug( 'Error is: ' + e.getMessage() );
        }  
         
        result.success = true;        
        return result;
    }
}