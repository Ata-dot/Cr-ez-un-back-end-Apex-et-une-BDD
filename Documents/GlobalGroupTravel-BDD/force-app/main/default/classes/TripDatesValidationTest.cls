/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TripDatesValidationTest {
 
    // Test pour vérifier que les dates de début et de fin sont obligatoires
    @isTest
    static void testStartDateAndEndDateRequired() {
        // Création d'un trip avec des dates de début et de fin nulles
        Trip__c trip = new Trip__c();
        trip.Name = 'Trip 1';
        trip.StartDate__c = null;
        trip.EndDate__c = null;

        Test.startTest();
        try {
            insert trip;
            // Vérification que l'exception a bien été levée lors de l'insertion
            System.assert(false, 'DML operation should have thrown an exception');
        } catch (DmlException e) {
            // Vérification du message d'erreur spécifique
            System.assert(e.getMessage().contains('Les dates de début et de fin sont obligatoires'));
        }
        Test.stopTest();

        // Vérification que le voyage n'a pas été inséré
        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Name = 'Trip 1'];
        System.Assert.areEqual(0, trips.size(), 'Trip should not have been inserted');
    }
  
    // Test pour vérifier que la date de fin est supérieure à la date de début
    @isTest
    static void testEndDateAfterStartDate() {
        // Création d'un trip avec une date de fin avant la date de début
        Trip__c trip = new Trip__c();
        trip.Name = 'Trip 2';
        trip.StartDate__c = Date.today().addDays(5);
        trip.EndDate__c = Date.today().addDays(3); // La date de fin est avant la date de début

        Test.startTest();
        try {
            insert trip;
            // Vérification que l'exception est levée
            System.assert(false, 'DML operation should have thrown an exception');
        } catch (DmlException e) {
            // Vérification du message d'erreur spécifique
            System.assert(e.getMessage().contains('La date de fin doit être supérieure à la date de début'));
        }
        Test.stopTest();

        // Vérification que le voyage n'a pas été inséré
        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Name = 'Trip 2'];
        System.Assert.areEqual(0, trips.size(), 'Trip should not have been inserted');
    }

    // Test pour vérifier que le statut est mis à jour correctement
    @isTest
    static void testTripStatusUpdate() {
        // Cas 1 : Voyage avec date de début dans le futur (statut 'To come')
        Trip__c tripToCome = new Trip__c();
        tripToCome.Name = 'Trip 3';
        tripToCome.StartDate__c = Date.today().addDays(7);  // 7 jours à partir d'aujourd'hui
        tripToCome.EndDate__c = Date.today().addDays(10);
        tripToCome.NumberOfParticipants__c = 11;  
        insert tripToCome;

        // Vérification que le statut du voyage est 'To come'
        Trip__c tripFetched = [SELECT Id, Status__c FROM Trip__c WHERE Id = :tripToCome.Id];
        System.assertEquals('To come', tripFetched.Status__c, 'Statut should be "To come"');

        // Cas 2 : Voyage en cours (date de début passée, date de fin dans le futur)
        Trip__c tripInProgress = new Trip__c();
        tripInProgress.Name = 'Trip 4';
        tripInProgress.StartDate__c = Date.today().addDays(-5);  // 5 jours avant aujourd'hui
        tripInProgress.EndDate__c = Date.today().addDays(5);  // 5 jours après aujourd'hui
        tripInProgress.NumberOfParticipants__c = 15;  // Plus de 10 participants
        insert tripInProgress;

        // Vérifier que le statut du voyage est 'In progress'
        tripFetched = [SELECT Id, Status__c FROM Trip__c WHERE Id = :tripInProgress.Id];
        System.assertEquals('In progress', tripFetched.Status__c, 'Statut should be "In progress"');

        // Cas 3 : Voyage terminé (date de fin passée)
        Trip__c tripCompleted = new Trip__c();
        tripCompleted.Name = 'Trip 5';
        tripCompleted.StartDate__c = Date.today().addDays(-15);  // 15 jours avant aujourd'hui
        tripCompleted.EndDate__c = Date.today().addDays(-10);  // 10 jours avant aujourd'hui
        tripCompleted.NumberOfParticipants__c = 20;  // Plus de 10 participants
        insert tripCompleted;

        // Vérifier que le statut du voyage est 'Completed'
        tripFetched = [SELECT Id, Status__c FROM Trip__c WHERE Id = :tripCompleted.Id];
        System.assertEquals('Completed', tripFetched.Status__c, 'Statut should be "Completed"');
    }
}
