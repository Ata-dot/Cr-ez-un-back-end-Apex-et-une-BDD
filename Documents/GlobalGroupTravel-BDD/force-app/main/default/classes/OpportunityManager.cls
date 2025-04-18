/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-06-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OpportunityManager {

    // Créer une opp
    @AuraEnabled
    public static Opportunity createOpportunity(Id accounId, String opportunityName, String stageName, String closeDate) {
        System.debug('OpportunityManager.createOpportunity');

        // Verifier AccountId n'est pas null
        if (accounId == null) {
            throw new AuraHandledException('Account ID is required');
        }

        // Verifier que le nom de l'opportunité n'est pas null
        if (String.isBlank(opportunityName)) {
            throw new AuraHandledException('Opportunity Name is required');
        }

        // Verifier que le nom de la vente n'est pas null
        if (String.isBlank(stageName)) {
            throw new AuraHandledException('Stage Name is required');
        }

        // Verifier que la date de fin n'est pas null
        if (String.isBlank(closeDate)) {
            throw new AuraHandledException('Close Date is required');
        }
            
        // convertir le string closeDate en Date
        Date closeDateParsed = Date.valueOf(closeDate);

        // Créer l'opp'
        System.debug('AccountId = ' + accounId);
        System.debug('Opportunity Name = ' + opportunityName);
        Opportunity opp = new Opportunity();
        opp.Name = opportunityName;
        opp.StageName = stageName;
        opp.CloseDate = closeDateParsed;
        opp.AccountId = accounId;
        
        insert opp;
        return opp;
    }
    
    // Mettre à jour une opp
    @AuraEnabled
    public static Opportunity updateOpportunity(Id opportunityId, String opportunityName, String stageName, String closeDate) {
        System.debug('OpportunityManager.updateOpportunity');

        // Verifier que l'ID de l'opportunité n'est pas null
        if (opportunityId == null) {
            throw new AuraHandledException('Opportunity ID is required');
        }

        // Verifier que le nom de l'opportunité n'est pas null
        if (String.isBlank(opportunityName)) {
            throw new AuraHandledException('Opportunity Name is required');
        }

        // Verifier que le nom de la vente n'est pas null   
        if (String.isBlank(stageName)) {
            throw new AuraHandledException('Stage Name is required');
        }

        // Verifier que la date de fin n'est pas null
        if (String.isBlank(closeDate)) {
            throw new AuraHandledException('Close Date is required');
        }

        // Mettre à jour la vente
        Opportunity opp = getOpportunityById(opportunityId);
        opp.Name = opportunityName;
        opp.StageName = stageName;
        opp.CloseDate = Date.valueOf(closeDate);
        update opp;
        return opp;
    }

    // Supprimer une opp
    @AuraEnabled
    public static void deleteOpportunity(Id opportunityId) {
        System.debug('OpportunityManager.deleteOpportunity');

        // Supprimer la vente
        Opportunity opp = getOpportunityById(opportunityId);
        delete opp;
    }

    // Récupérer une opp par son ID
    @AuraEnabled
    public static Opportunity getOpportunityById(Id opportunityId) {
        System.debug('OpportunityManager.getOpportunityById');

        // Verifier que l'ID de l'opportunité n'est pas null
        if (opportunityId == null) {
            throw new AuraHandledException('Opportunity ID is required');
        }

        // Récupérer la vente via SOQL
        Opportunity opp =  [SELECT Id, Name, StageName, CloseDate, Pricebook2Id FROM Opportunity WHERE Id = :opportunityId];

        // Verifier que le nom de l'opp' n'est pas null
        if (opp.Name == null) {
            throw new AuraHandledException('Opportunity Name is required');
        }
        System.debug('OpportunityManager.getOpportunityById');
        return opp;
        
    }
     // Récupérer plusieurs opportunités par leurs ID
    @AuraEnabled
    public static List<Opportunity> getOpportunitiesById(List<Id> opportunityIds) {
        System.debug('OpportunityManager.getOpportunitiesById');

        // Verifier que la liste des ID n'est pas null
        if (opportunityIds == null) {
            throw new AuraHandledException('Opportunity IDs are required');
        }

        // Récupérer les opportunités via SOQL
        return [SELECT Id, Name, StageName, CloseDate FROM Opportunity WHERE Id IN :opportunityIds];
    }
        
}