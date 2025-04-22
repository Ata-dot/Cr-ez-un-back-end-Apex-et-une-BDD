/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-22-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : Classe de test pour le trigger CreateTripOnOpportunityWin
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 04-22-2025
**/
@isTest
public class CreateTripOnOpportunityWinTest {
    
    // Méthode utilitaire pour créer une opportunité de test avec tous les champs requis
    static Opportunity createTestOpportunity() {
        // Créer un compte de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Créer une opportunité associée à ce compte
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(30),
            AccountId = testAccount.Id,
            NumberOfParticipants__c = 10,
            EndDate__c = Date.today().addDays(7)
        );
        insert testOpp;

        return testOpp;
    }

    @isTest
    static void testCreateTripOnOpportunityWin() {
        // Créer une opportunité de test
        Opportunity testOpp = createTestOpportunity();

        // Mettre à jour l’opportunité avec StageName = Closed Won
        testOpp.StageName = 'Closed Won';
        update testOpp;

        // Vérifier qu’un Trip__c a été créé
        List<Trip__c> createdTrips = [
            SELECT Id, Opportunity__c, Name, Status__c, NumberOfParticipants__c, StartDate__c, EndDate__c
            FROM Trip__c
            WHERE Opportunity__c = :testOpp.Id
        ];

        // Assertions sur le trip
        System.assertEquals(1, createdTrips.size(), 'Un trip devrait être créé');
        Trip__c trip = createdTrips[0];
        System.assertEquals(testOpp.Id, trip.Opportunity__c, 'Le trip doit être lié à la bonne opportunité');
        System.assertEquals('Test Opportunity Trip', trip.Name, 'Le nom du trip doit être correct');
        System.assertEquals('To come', trip.Status__c, 'Le statut du trip doit être "To come"');
        System.assertEquals(10, trip.NumberOfParticipants__c, 'Le nombre de participants doit correspondre');
        System.assertEquals(Date.today().addDays(1), trip.StartDate__c, 'La date de début doit être demain');
        System.assertEquals(Date.today().addDays(7), trip.EndDate__c, 'La date de fin doit être dans 7 jours');
    }
}
