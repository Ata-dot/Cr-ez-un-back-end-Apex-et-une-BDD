/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-07-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : Tests pour la gestion des voyages (création, mise à jour, suppression).
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 04-07-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public with sharing class TripManagerTest {
    
    // Test de la création d'un voyage
    @IsTest
    static void testCreateTrip() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            CloseDate = Date.today().addMonths(1),
            StageName = 'Prospecting',
            AccountId = testAccount.Id
        );
        insert testOpp;

        Test.startTest();
        TripManager.CreateTrip(
            testOpp.Id,
            'Test Trip',
            'In progress',
            Date.today(),
            Date.today().addDays(5),
            '20',
            testAccount.Id
        );
        Test.stopTest();

        List<Trip__c> trips = [SELECT Id, Name, EndDate__c, Account__c, Status__c, Opportunity__c 
                               FROM Trip__c 
                               WHERE Name = 'Test Trip'];
        System.assertEquals(1, trips.size(), 'Un voyage devrait être créé');
        System.assertEquals('In progress', trips[0].Status__c);
        System.assertEquals(testOpp.Id, trips[0].Opportunity__c);
        System.assertEquals(testAccount.Id, trips[0].Account__c);
        System.assertEquals(Date.today().addDays(5), trips[0].EndDate__c);
    }

    // Test de la mise à jour d'un voyage
    @IsTest
    static void testUpdateTrip() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            CloseDate = Date.today().addMonths(1),
            StageName = 'Prospecting',
            AccountId = testAccount.Id
        );
        insert testOpp;

        Trip__c newTrip = new Trip__c(
            Name = 'Initial Trip',
            StartDate__c = Date.today(),
            EndDate__c = Date.today().addDays(5),
            Account__c = testAccount.Id,
            Status__c = 'To come',
            Destination__c = 'Londres',
            NumberofParticipants__c = 8,
            TotalCost__c = 4000,
            Opportunity__c = testOpp.Id
        );
        insert newTrip;

        newTrip.Name = 'Updated Trip';
        newTrip.EndDate__c = Date.today().addDays(10);
        newTrip.Status__c = 'In progress';
        newTrip.Destination__c = 'Rome';
        newTrip.NumberofParticipants__c = 15;
        newTrip.TotalCost__c = 6000;
        update newTrip;

        Trip__c updatedTrip = [SELECT Name, EndDate__c, Status__c, Destination__c, 
                                      NumberofParticipants__c, TotalCost__c 
                               FROM Trip__c 
                               WHERE Id = :newTrip.Id];
        System.assertEquals('Updated Trip', updatedTrip.Name);
        System.assertEquals(Date.today().addDays(10), updatedTrip.EndDate__c);
        System.assertEquals('In progress', updatedTrip.Status__c);
        System.assertEquals('Rome', updatedTrip.Destination__c);
        System.assertEquals(15, updatedTrip.NumberofParticipants__c);
        System.assertEquals(6000, updatedTrip.TotalCost__c);
    }

    // Test de la suppression d'un voyage
    @IsTest
    static void testDeleteTrip() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            CloseDate = Date.today().addMonths(1),
            StageName = 'Prospecting',
            AccountId = testAccount.Id
        );
        insert testOpp;

        Trip__c newTrip = new Trip__c(
            Name = 'Trip to delete',
            StartDate__c = Date.today(),
            EndDate__c = Date.today().addDays(5),
            Account__c = testAccount.Id,
            Status__c = 'Cancelled',
            Destination__c = 'Berlin',
            NumberofParticipants__c = 12,
            TotalCost__c = 3000,
            Opportunity__c = testOpp.Id
        );
        insert newTrip;

        delete newTrip;

        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Id = :newTrip.Id];
        System.assertEquals(0, trips.size(), 'Le voyage devrait avoir été supprimé.');
    }
}
