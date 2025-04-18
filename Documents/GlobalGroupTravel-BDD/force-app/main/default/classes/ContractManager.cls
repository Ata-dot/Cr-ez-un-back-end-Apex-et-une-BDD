/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-04-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ContractManager {

    // Créer un contrat
    @AuraEnabled
    public static Contract createContract(Id accountId, String contractName, Date startDate, Date endDate) {
        System.debug('ContractManager.createContract');

        // Vérifier que l'account n'est pas null
        if (accountId == null) {
            throw new AuraHandledException('Account ID is required');
        }

        // Vérifier que le nom du contrat n'est pas null
        if (String.isBlank(contractName)) {
            throw new AuraHandledException('Contract Name is required');
        }

        // Vérifier que la date de début n'est pas null
        if (startDate == null) {
            throw new AuraHandledException('Start Date is required');
        }

        // Vérifier que la date de fin n'est pas null
        if (endDate == null) {
            throw new AuraHandledException('End Date is required');
        }

        // Vérification que la date de début est antérieure à la date de fin
        if (Date.valueOf(startDate) >= Date.valueOf(endDate)) {
            throw new AuraHandledException('Start Date must be before End Date');
        }

        // Créer le contrat
        Contract contract = new Contract();
        contract.AccountId = accountId;
        contract.Name = contractName;
        contract.StartDate = Date.valueOf(startDate);
        
        // Calcul de la date de fin (en fonction du terme du contrat)
        Integer contractTermMonths = 12; 
        contract.ContractTerm = contractTermMonths;

        insert contract;
        return contract;
    }

    // Mettre à jour un contrat
    @AuraEnabled
    public static Contract updateContract(Id contractId, String contractName, String startDate, String endDate) {
        System.debug('ContractManager.updateContract');

        // Vérifier que l'ID du contrat n'est pas null
        if (contractId == null) {
            throw new AuraHandledException('Contract ID is required');
        }

        // Vérifier que le nom du contrat n'est pas null
        if (String.isBlank(contractName)) {
            throw new AuraHandledException('Contract Name is required');
        }

        // Vérifier que la date de début n'est pas null 
        if (String.isBlank(startDate)) {
            throw new AuraHandledException('Start Date is required');
        }

        // Vérifier que la date de fin n'est pas null
        if (String.isBlank(endDate)) {
            throw new AuraHandledException('End Date is required');
        }

        // Vérification que la date de début est antérieure à la date de fin
        if (Date.valueOf(startDate) >= Date.valueOf(endDate)) {
            throw new AuraHandledException('Start Date must be before End Date');
        }

        // Mettre à jour le contrat
        Contract contract = getContractById(contractId);
        contract.Name = contractName;
        contract.StartDate = Date.valueOf(startDate);
        
        update contract;
        System.debug('ContractManager.updateContract');
        return contract;
    }

    // Supprimer un contrat
    @AuraEnabled
    public static void deleteContract(Id contractId) {
        System.debug('ContractManager.deleteContract');

        // Vérifier que l'ID du contrat n'est pas null
        if (contractId == null) {
            throw new AuraHandledException('Contract ID is required');
        }

        // Supprimer le contrat
        Contract contract = getContractById(contractId);
        delete contract;
        System.debug('ContractManager.deleteContract');
    }

    // Récupérer un contrat par son ID
    @AuraEnabled
    public static Contract getContractById(Id contractId) {
        System.debug('ContractManager.getContractById');

        // Vérifier que l'ID du contrat n'est pas null
        if (contractId == null) {
            throw new AuraHandledException('Contract ID is required');
        }
        // Récupérer le contrat via SOQL
        return [SELECT Id, Name, StartDate, EndDate FROM Contract WHERE Id = :contractId];
    }

    // Récupérer plusieurs contrats par leurs ID
    @AuraEnabled
    public static List<Contract> getContractsById(List<Id> contractIds) {
        System.debug('ContractManager.getContractsById');

        // Vérifier que la liste des ID n'est pas null
        if (contractIds == null) {
            throw new AuraHandledException('Contract IDs are required');
        }

        // Récupérer les contrats via SOQL
        return [SELECT Id, Name, StartDate, EndDate FROM Contract WHERE Id IN :contractIds];
    }
}
