/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class CancelTripsSchedulerTest {

    @isTest
    static void testSchedulerExecution() {
        // Créer un voyage avec moins de 10 participants et les dates correctement définies
        Trip__c trip = new Trip__c(
            StartDate__c = Date.today().addDays(7),  // Date de début dans 7 jours
            EndDate__c = Date.today().addDays(14),   // Date de fin dans 14 jours
            NumberOfParticipants__c = 9,  // Moins de 10 participants
            Status__c = 'To come'  // Statut initial "À venir"
        );
        
        insert trip;

        // Commencer le test
        Test.startTest();

        // Appel direct à la méthode execute du scheduler
        CancelTripsScheduler scheduler = new CancelTripsScheduler();
        scheduler.execute(null); // Exécuter le batch via le scheduler
        
        // Attendre la fin de l'exécution pour effectuer les assertions
        Test.stopTest();

        // Vérifier que le statut du voyage a bien été changé en "Cancelled"
        Trip__c result = [SELECT Status__c FROM Trip__c WHERE Id = :trip.Id];
        System.debug('Statut du voyage après le batch : ' + result.Status__c);

        // Vérifier que le statut du voyage a bien été mis à jour
        System.assertEquals('Cancelled', result.Status__c, 'Le statut du voyage doit être "Cancelled"');
    }
}
