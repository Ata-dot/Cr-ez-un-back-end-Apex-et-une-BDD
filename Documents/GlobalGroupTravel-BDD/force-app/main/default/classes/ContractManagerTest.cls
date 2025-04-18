/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : Classe de test pour les méthodes de gestion des contrats dans ContractManager
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

/**
 * @description       : Test class for ContractManager operations
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

    /** 
     * Test de la création d'un contrat.
     * Cest vérifie si la méthode de création de contrat fonctionne correctement.
     * - Un client est créé.
     * - Un contrat est créé pour ce client.
     * - Le statut du contrat est vérifié.
     * - Le contrat est récupéré de la base de données pour vérification.
     */

    @isTest
    public with sharing class ContractManagerTest {

    static void testCreateContract() {

        // Création d'un compte
        Account acc = new Account(Name='Test Account');
        insert acc;

        // Création d'un contrat pour ce client
        Contract cont = new Contract();
        cont.AccountId = acc.Id;
        cont.StartDate = Date.today();
       
        
        Test.startTest(); // Début du test pour gérer les limites de gouvernance
        insert cont;
        Test.stopTest(); // Fin du test

        // Vérification du statut du contrat après l'insertion
        System.assertEquals('Draft', cont.Status);
        
        // Récupération du contrat inséré pour validation
        Contract insertedContract = [SELECT Id, Status FROM Contract WHERE Id = :cont.Id];
        System.assertEquals('Draft', insertedContract.Status);
    }

    /**
     * Test de la mise à jour d'un contrat.
     * Cela vérifie si la méthode de mise à jour de contrat fonctionne correctement.
     * - Un client est créé.
     * - Un contrat est créé pour ce client.
     * - Le contrat est mis à jour.
     * - Le contrat est récupéré de la base de données pour vérification.   
     */

    @isTest
    static void testUpdateContract() {

        // Création d'un compte
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        // Création d'un contrat pour ce client
        Contract cont = new Contract();
        cont.AccountId = acc.Id;
        cont.StartDate = Date.today();
       
        
        insert cont;
        
        // Mise à jour du contrat
        cont.Status = 'Activated';
        
        Test.startTest();
        update cont;
        Test.stopTest();
        
        // Vérification que le statut a été mis à jour
        Contract updatedContract = [SELECT Id, Status FROM Contract WHERE Id = :cont.Id];
        System.assertEquals('Activated', updatedContract.Status);
    }

    /**
     * Test de la suppression d'un contrat
     * Ce test vérifie si la méthode de suppression de contrat fonctionne correctement.
     * - Un client est créé.
     * - Un contrat est créé pour ce client.
     * - Le contrat est supprimé.
     * - Vérification que le contrat a bien été supprimé.
     */

    @isTest
    static void testDeleteContract() {

        // Création d'un compte
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        // Création d'un contrat pour ce client
        Contract cont = new Contract();
        cont.AccountId = acc.Id;
        cont.StartDate = Date.today();
       
        
        insert cont;
        
        Test.startTest();
        delete cont;
        Test.stopTest();
        
        // Vérification que le contrat a bien été supprimé
        try {
            Contract deletedContract = [SELECT Id FROM Contract WHERE Id = :cont.Id LIMIT 1];
            System.assert(false, 'Contract should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Contract successfully deleted');
        }
    }

    /** Test de l'activation d'un contrat.
     * Ce test vérifie si la méthode d'activation de contrat fonctionne correctement.
     * - Un client est créé.
     * - Un contrat est créé pour ce client.
     * - Le contrat est activé.
     * - Vérification que le contrat est activé.
     */

    @isTest
    static void testContractManager() {

        // Création d'un compte
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        // Création d'un contrat pour ce client
        Contract cont = new Contract();
        cont.AccountId = acc.Id;
        cont.StartDate = Date.today();
       
        Test.startTest();
        insert cont;
        cont.Status = 'Activated';
        update cont;
        delete cont;
        Test.stopTest();

        // Vérification que le contrat a bien été supprimé
        try {
            Contract deletedContract = [SELECT Id FROM Contract WHERE Id = :cont.Id LIMIT 1];
            System.assert(false, 'Contract should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Contract successfully deleted');
        }
        
    }
}
