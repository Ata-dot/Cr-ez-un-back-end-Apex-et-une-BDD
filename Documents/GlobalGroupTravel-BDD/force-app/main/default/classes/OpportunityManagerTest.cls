/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-06-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : Classe de test pour les opérations de gestion des opportunités dans OpportunityManager
 * 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-06-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : Test class for OpportunityManager operations
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-06-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/


    /** Test de la création d'une opportunité.
     * Ce test vérifie si la méthode 'createOpportunity' crée bien une opportunité avec les valeurs attendues.
     * - Un compte est créé et lié à l'opportunité.
     * - Une opporunité est ensuite créée avec des valeurs spécifiques.
     * - Les valeurs de l'opportunité sont vérifiées pour s'assurer qu'elles correspondent aux valeurs insérées.
     */

    @IsTest
    public with sharing class OpportunityManagerTest {
    static void TestCreateOpportunity() {

        // Création d'un Account pour lier l'Opportunity
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Définition d'une date valide pour la fermeture de l'opportunité
        Date closeDate = Date.today().addDays(30);

        Test.startTest();  
        // Création de l'opportunité via le manager
        Opportunity opp = OpportunityManager.createOpportunity(acc.Id, 'Test Opportunity', 'Prospecting', String.valueOf(closeDate));
        
        Test.stopTest();

        // Récupération de l'opportunité pour valider les valeurs insérées
        Opportunity insertedOpp = [SELECT Id, AccountId, Name, StageName, CloseDate 
                           FROM Opportunity WHERE Id =: opp.Id];

     System.assertNotEquals(null, insertedOpp, 'L\'opportunité doit exister.');
     System.assertNotEquals(null, insertedOpp.Id, 'L\'opportunité doit avoir un ID.');
     System.assertEquals(acc.Id, insertedOpp.AccountId, 'L\'opportunité doit être associée au bon compte.');
     System.assertEquals('Test Opportunity', insertedOpp.Name, 'Le nom de l\'opportunité doit être correct.');
     System.assertEquals('Prospecting', insertedOpp.StageName, 'Le stage de l\'opportunité doit être correct.');
     System.assertEquals(closeDate, insertedOpp.CloseDate, 'La date de fermeture doit être correcte.');

    }

    /** Test de la récupération d'une opportunité par ID.
     * Ce test vérifie si la méthode 'getOpportunityById' récupère bien une opportunité par son ID.
     * - Un compte est créé et lié à l'opportunité.
     * - Une opportunité est créée avec des valeurs spécifiques.
     * - L'opportunité est récupérée par son ID.
     * - Les valeurs de l'opportunité récupérée sont vérifiées pour s'assurer qu'elles correspondent aux valeurs insérées.
     */

    @IsTest
    static void TestgetOpportunityById() {

        // Création d'un Account et d'une Opportunity
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Date closeDate = Date.today().addDays(30);

        Test.startTest();
        Opportunity opp = OpportunityManager.createOpportunity(acc.Id, 'Test Opportunity', 'Prospecting', String.valueOf(closeDate));
        Test.stopTest();

        // Récupération de l'opportunité par ID
        Opportunity fetchedOpp = OpportunityManager.getOpportunityById(opp.Id);
        
        // Assertions pour vérifier que l'opportunité récupérée correspond aux attentes
        System.assertNotEquals(null, fetchedOpp, 'L\'opportunité doit être récupérée.');
        System.assertEquals(opp.Id, fetchedOpp.Id, 'L\'ID de l\'opportunité doit correspondre.');
        System.assertEquals('Test Opportunity', fetchedOpp.Name, 'Le nom de l\'opportunité doit être correct.');
        System.assertEquals('Prospecting', fetchedOpp.StageName, 'Le stage de l\'opportunité doit être correct.');
        System.assertEquals(closeDate, fetchedOpp.CloseDate, 'La date de fermeture doit être correcte.');
    }




    /** Test de la suppression d'une opportunité.
     * Ce test vérifie si la méthode 'deleteOpportunity' supprime correctement une opportunité. 
     * - Un compte est créé et lié à l'opportunité.
     * - La méthode 'createOpportunity' est utilisée pour créer une opportunité.
     * - La méthode 'deleteOpportunity' est utilisée pour supprimer l'opportunité.      
     * - Un compte est créé et lié à l'opportunité. 
     * - Le test vérifie que l'opportunité a bien été supprimée.
     */

    @IsTest
    static void TestdeleteOpportunity() {
        
        // Création d'un Account et d'une Opportunity
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Date closeDate = Date.today().addDays(30);

        Test.startTest();
        Opportunity opp = OpportunityManager.createOpportunity(acc.Id, 'Test Opportunity', 'Prospecting', String.valueOf(closeDate));
       
        // Suppression de l'opportunité
        OpportunityManager.deleteOpportunity(opp.Id);
        Test.stopTest();
        
        // Vérification que l'opportunité a bien été supprimée
        try {
            Opportunity deleteOpp = [SELECT Id FROM Opportunity WHERE Id = :opp.Id];
            System.Assert(false, 'The opportunity should have been deleted');
        } catch (QueryException e) {
            System.Assert(true, 'The opportunity has been deleted');
        }
    }
        
        @IsTest
        static void TestUpdateOpportunity() {
            // Création d'un Account et d'une Opportunity
            Account acc = new Account(Name = 'Test Account');
            insert acc;

            Date closeDate = Date.today().addDays(30);

            Test.startTest();
            Opportunity opp = OpportunityManager.createOpportunity(acc.Id, 'Test Opportunity', 'Prospecting', String.valueOf(closeDate));
            
            // Mise à jour de l'opportunité
            String newName = 'Updated Opportunity';
            String newStage = 'Closed Won';
            String newCloseDate = String.valueOf(Date.today().addDays(60));
            
            Opportunity updatedOpp = OpportunityManager.updateOpportunity(opp.Id, newName, newStage, newCloseDate);
            Test.stopTest();

            // Vérification que l'opportunité a bien été mise à jour
            System.assertEquals(newName, updatedOpp.Name, 'Le nom de l\'opportunité doit être mis à jour.');
            System.assertEquals(newStage, updatedOpp.StageName, 'Le stage de l\'opportunité doit être mis à jour.');
            System.assertEquals(Date.valueOf(newCloseDate), updatedOpp.CloseDate, 'La date de fermeture doit être mise à jour.');
        }





}

