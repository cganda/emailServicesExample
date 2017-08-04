global class CreateContactEmailService implements Messaging.InboundEmailHandler{
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        if(email.subject.equalsIgnoreCase('Create Contact'))
        {
            Contact c = new Contact();
            String fullBody = email.plainTextBody;
            List<String> lines = fullBody.split('\\n');
                        
            try{
                c.LastName = lines.get(0);
            	insert c;
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[]{email.fromAddress});
                mail.setSubject('Created Contact');
                mail.setPlainTextBody('Created Contact ' + c.Id);
                Messaging.sendEmail(new Messaging.Email[] { mail });

                result.success = true;
                                
            }catch(Exception e){
                result.success = false;
            }
        }
        
        return result;
      }
}