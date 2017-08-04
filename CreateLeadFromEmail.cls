global class CreateLeadFromEmail implements Messaging.InboundEmailHandler {
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        String subToCompare = 'Create Lead';

        if(email.subject.equalsIgnoreCase(subToCompare))
        {
            String fullName = email.fromName;
            String body = email.plainTextBody;
            
            Lead l = new Lead();
            String[] nameArr = fullName.split(' ');
            if(nameArr.size() > 0){
            	l.FirstName = nameArr[0];
            }
            if(nameArr.size() > 1){
                l.LastName = nameArr[nameArr.size()-1];
            }
            l.Description = body;
            l.Company = 'Revature';
            l.Status = 'Open - Not Contacted';



            try{
            	insert l;

                // add body as an attachment
                Attachment bodyAttachment = new Attachment();
                bodyAttachment.Body = Blob.valueOf(email.plainTextBody);
                bodyAttachment.ParentId = l.Id;
                bodyAttachment.Name = 'emailBody.txt';
                insert bodyAttachment;
                // add attachment
                if(email.textAttachments != null && email.textAttachments.size() > 0){
                    List<Attachment> attachments = new List<Attachment>();
                    for(integer i = 0; i < email.textAttachments.size(); i++){
                        Attachment attachment = new Attachment();
                        attachment.ParentId = l.Id;
                        attachment.Name = email.textAttachments[i].filename;
                        attachment.Body = Blob.valueOf(email.textAttachments[i].body);

                        attachments.add(attachment);
                    }
                    insert attachments;
                }


            }catch(DMLException e){
                result.success = false;
                return result;
            }

        }else if(email.subject.containsIgnoreCase('Lead Details')){
            String fullBody = email.plainTextBody;
            List<String> lines = fullBody.split('\\n');

			String firstName, lastName;
            String street, city, state, zip, emailString, phoneString;
            String other = '';

            String[] lineSplit;
            String valueString;
            for(String line : lines){
                if(line.contains(':')){
                    lineSplit = line.split(':');
                    valueString = lineSplit[lineSplit.size()-1].trim();
                }
                if(line.containsIgnoreCase('First Name:')){
                	firstName = valueString;  
                }else if(line.containsIgnoreCase('Last Name:')){
                	lastName = valueString;
                }else if(line.containsIgnoreCase('Home:')){
                    phoneString = valueString;
                }else if(line.containsIgnoreCase('Address:')){
                    street = valueString;
                }else if(line.containsIgnoreCase('City:')){
                    city = valueString;
                }else if(line.containsIgnoreCase('St:') || line.containsIgnoreCase('State:')){
                    state = valueString;
                }else if(line.containsIgnoreCase('Zip:')){
                    zip = valueString;
                }else if(line.containsIgnoreCase('Email:')){
                    emailString = valueString;
                }else{
                    other += line + ' ';
                }
            }

            Lead l = new Lead();
            l.FirstName = firstName;
            l.LastName = lastName;
            l.Phone = phoneString;
            l.Street = street;
            l.City = city;
            l.State = state;
            l.PostalCode = zip;
            l.Email = emailString;
            l.Description = other;
            
            l.Company = 'Revature';
            l.Status = 'Open - Not Contacted';
            try{
            	insert l;
            }catch(DMLException e){
                result.success = false;
                return result;
            }
        }

    	result.success = true;
        return result;
    }
}