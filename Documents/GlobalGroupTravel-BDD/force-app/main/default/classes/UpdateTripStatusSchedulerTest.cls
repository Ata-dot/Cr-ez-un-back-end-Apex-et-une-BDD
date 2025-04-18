/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class UpdateTripStatusSchedulerTest {

    @isTest
    static void testScheduler() {
        // Créer des voyages avec des dates qui déclencheront la mise à jour du statut
        List<Trip__c> trips = new List<Trip__c>();

        // Créer un voyage qui commence dans le futur
        Trip__c trip1 = new Trip__c();
        trip1.StartDate__c = System.today().addDays(5);  // Début dans 5 jours
        trip1.EndDate__c = System.today().addDays(10);  // Fin dans 10 jours
        trip1.NumberOfParticipants__c = 11;
        trip1.Status__c = 'To come';  // Statut initial
        trips.add(trip1);
        
        // Créer un voyage qui est en cours
        Trip__c trip2 = new Trip__c();
        trip2.StartDate__c = System.today().addDays(-5);  // Début il y a 5 jours
        trip2.EndDate__c = System.today().addDays(5);  // Fin dans 5 jours
        trip2.NumberOfParticipants__c = 20;
        trip2.Status__c = 'In progress';  // Statut initial
        trips.add(trip2);
        
        // Créer un voyage qui est déjà terminé
        Trip__c trip3 = new Trip__c();
        trip3.StartDate__c = System.today().addDays(-10);  // Début il y a 10 jours
        trip3.EndDate__c = System.today().addDays(-5);  // Fin il y a 5 jours
        trip3.NumberOfParticipants__c = 10;
        trip3.Status__c = 'Completed';  // Statut initial
        trips.add(trip3);

        insert trips;  // Insérer les voyages dans la base de données

        // Commencer le test
        Test.startTest();

        // Appel de l'exécution du Scheduler en simulant un job planifié
        UpdateTripStatusScheduler scheduler = new UpdateTripStatusScheduler();
        
        // Appeler directement la méthode execute() du Scheduler 
        scheduler.execute(null); 

        // Arrêter le test pour exécuter le job
        Test.stopTest();

        // Vérifier que les statuts ont été correctement mis à jour
        List<Trip__c> result = [SELECT Id, Status__c FROM Trip__c WHERE Id IN :trips];

        // Vérifier que le statut du voyage 1 est maintenant 'To come'
        System.assertEquals('To come', result[0].Status__c, 'Le statut du voyage 1 doit être "To come"');
        
        // Vérifier que le statut du voyage 2 est maintenant 'In progress'
        System.assertEquals('In progress', result[1].Status__c, 'Le statut du voyage 2 doit être "In progress"');
        
        // Vérifier que le statut du voyage 3 est maintenant 'Completed'
        System.assertEquals('Completed', result[2].Status__c, 'Le statut du voyage 3 doit être "Completed"');
    }
}
