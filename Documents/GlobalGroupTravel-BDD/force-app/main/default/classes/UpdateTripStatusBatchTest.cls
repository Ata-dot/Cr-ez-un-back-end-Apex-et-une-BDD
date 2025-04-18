/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 *
 */
@isTest
private class UpdateTripStatusBatchTest {

    @isTest
    static void TestBatchUpdateTripStatus () {

        // Créer des voyages de test
        List<Trip__c> trips = new List<Trip__c>();

        // Voyage 1 : A venir (date de début dans le futur)
        Trip__c trip1 = new Trip__c();
        trip1.StartDate__c = System.today().addDays(7);
        trip1.NumberOfParticipants__c = 11;
        trip1.Status__c = 'To come';
        trip1.EndDate__c = System.today().addDays(14);
        trips.add(trip1); 

        // Voyage 2 : En cours (date de début aujourd'hui)
        Trip__c trip2 = new Trip__c();
        trip2.StartDate__c = System.today();
        trip2.NumberOfParticipants__c = 9;
        trip2.Status__c = 'In progress';
        trip2.EndDate__c = System.today().addDays(14);
        trips.add(trip2);

        // Voyage 3 : Terminé (date de fin passée)
        Trip__c trip3 = new Trip__c();
        trip3.StartDate__c = System.today().addDays(-7);
        trip3.EndDate__c = System.today().addDays(-1);
        trip3.NumberOfParticipants__c = 9;
        trip3.Status__c = 'Completed';
        trips.add(trip3);

        // Insertion des voyages
        insert trips;

        // Lancer le test
        Test.startTest();

        // Execution du batch
        System.debug ('Execution du batch UpdateTripStatusBatch...');
        Database.executeBatch(new UpdateTripStatusBatch());
        
        // Stop the test
        Test.stopTest();

        // Recupérer les voyages apres le batch
        List<Trip__c> result = [SELECT Id, Status__c FROM Trip__c];

        // Afficher les voyages
        System.debug('Liste des voyages: ' + result);

        // Voyage 1 devrait être 'To come' (StartDate > aujourd'hui)
        System.assertEquals('To come', result[0].Status__c);

        // Voyage 2 devrait être 'In progress' (StartDate <= aujourd'hui et EndDate > aujourd'hui)
        System.assertEquals('In progress', result[1].Status__c);

        // Voyage 3 devrait être 'Completed' (EndDate <= aujourd'hui)
        System.assertEquals('Completed', result[2].Status__c);


    }
    
}