/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class CancelTripsBatchTest {

    @isTest
    static void testCancelTripsBatch() {
        
        // Créer un voyage avec moins de 10 participants
        List<Trip__c> trips = new List<Trip__c>();
        
        // Créer un voyage dont la date de début est dans 7 jours
        Trip__c trip = new Trip__c();
        trip.StartDate__c = Date.today().addDays(7); 
        trip.EndDate__c = Date.today().addDays(14);
        trip.NumberOfParticipants__c = 9;  // Moins de 10 participants
        trip.Status__c = 'To come';  // Statut "À venir"
        
        trips.add(trip);
        
        // Créer un autre voyage, mais avec plus de 10 participants
        Trip__c trip2 = new Trip__c();
        trip2.StartDate__c = Date.today().addDays(7); 
        trip2.EndDate__c = Date.today().addDays(14);
        trip2.NumberOfParticipants__c = 15;  // Plus de 10 participants
        trip2.Status__c = 'To come';  // Statut "À venir"
        
        trips.add(trip2);
        
        // Insérer les voyages dans la base de données
        insert trips;
        
        // Commencer le test
        Test.startTest();

        // Exécution du batch
        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch, 200);  // Taille du lot (batch size)

        // Arrêter le test
        Test.stopTest();  // S'assurer que l'exécution du batch est terminée avant d'effectuer les assertions
        
        // Récupérer les voyages après l'exécution du batch
        List<Trip__c> result = [SELECT Id, Status__c FROM Trip__c WHERE Id IN :trips];
        
        // Vérifier que le premier voyage a été annulé
        System.debug('Statut du voyage après le batch (voyage 1) : ' + result[0].Status__c);
        System.assertEquals('Cancelled', result[0].Status__c, 'Le statut du voyage devrait être "Cancelled"');
        
        // Vérifier que le second voyage n’a pas été annulé
        System.debug('Statut du voyage après le batch (voyage 2) : ' + result[1].Status__c);
        System.assertEquals('To come', result[1].Status__c, 'Le statut du second voyage ne devrait pas être changé');
    }
}
