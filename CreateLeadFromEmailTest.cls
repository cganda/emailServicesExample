@isTest
public class CreateLeadFromEmailTest {
    
    @isTest static void testCreateLead(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.subject = 'Create Lead';
        email.fromAddress = 'test@test.com';
        email.fromName = 'Tester One';
        email.plainTextBody = 'Hello, World\nAnother Line?';
        
        CreateLeadFromEmail handler = new CreateLeadFromEmail();
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, env);
       	
        system.assert(result.success);
        Lead l = [SELECT Id, FirstName, LastName, Description FROM Lead WHERE FirstName = 'Tester' LIMIT 1];
        system.assertEquals('One', l.LastName);
        system.assertEquals('Hello, World\nAnother Line?', l.Description);
    }
    
    @isTest static void testDetailedLead(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.subject = 'Lead Details';
        email.fromAddress = 'test@test.com';
        email.plainTextBody =  'Health & Life Lead: Harold Lahmon' +
                'Home:7405071242\n' +
                'Work:\n' +
                'Ext\n' +
                'Address:8750 columbus Rd Lot 37b\n' +
                'City: Mount Vernon\n' +
                'St:OH\n' +
                'Zip:43050\n' +
                'Email:kennyhl35@aol.com\n' +
                'Email:kennyhl35@aol.com\n' +
                'Comments:\n' +
                'Applicant First Name:karold\n'+
                'Applicant Last Name:lahmon\n' +
                'Applicant Middle Name:k\n'+
                'Applicant Age: 49\n' +
                'Applicant Gender: male\n' +
                'Applicant Height: 6\n';
        
        CreateLeadFromEmail handler = new CreateLeadFromEmail();
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, env);
       	
        system.assert(result.success);
        Lead l = [SELECT Id, FirstName, LastName, Email, Street, City, State, PostalCode, Phone, Description FROM Lead WHERE FirstName = 'karold' LIMIT 1];
        system.assertEquals('karold', l.FirstName);
        system.assertEquals('lahmon', l.LastName);
        system.assertEquals('kennyhl35@aol.com', l.Email);
        system.assertEquals('8750 columbus Rd Lot 37b', l.Street);
        system.assertEquals('Mount Vernon', l.City);
        system.assertEquals('OH', l.State);
        system.assertEquals('43050', l.PostalCode);
        system.assertEquals('7405071242', l.Phone);
        // not used: Health & life lead:Harold Lahmon, Work:, Ext, Comments:, Applicant Middle Name:k, Applicant Age:49, Applicant Gender: male, Applicant Height: 6
    }
}