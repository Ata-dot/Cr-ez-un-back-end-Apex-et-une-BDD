/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class TripManager {
 // Créer un voyage
 public static void CreateTrip(String OpportunityId, String name, String status, Date startDate, Date endDate, String NumberOfParticipants, Id accountId) {
    System.debug('TripManager.CreateTrip');

    // Vérifier que OpportunityId n'est pas null    
    if (OpportunityId == null) {
        System.debug('OpportunityId is null');
        throw new AuraHandledException('Opportunity ID is required');
    }

    // Vérifier que le nom du voyage n'est pas null
    if (String.isBlank(name)) {
        System.debug('Name is null');
        throw new AuraHandledException('Trip Name is required');
    }

    // Vérifier que le statut du voyage n'est pas null
    if (String.isBlank(status)) {
        System.debug('Status is null');
        throw new AuraHandledException('Status is required');
    }

    // Vérifier que la date de fin n'est pas null
    if (endDate == null) {
        System.debug('EndDate is null');
        throw new AuraHandledException('End Date is required');
    }

    // Vérifier que accountId n'est pas null
    if (accountId == null) {
        System.debug('AccountId is null');
        throw new AuraHandledException('Account ID is required');
    }

    // Vérifier que le nombre de participants n'est pas null
    if (String.isBlank(NumberOfParticipants)) {
        System.debug('NumberOfParticipants is null');
        throw new AuraHandledException('Number of Participants is required');
    }
    
    // Créer le voyage
    Trip__c trip = new Trip__c();
    trip.Opportunity__c = OpportunityId; // Utilisation de l'ID de l'opportunité pour lier le voyage
    trip.Name = name;
    trip.Status__c = status; // Utilisation de la variable 'status' pour le champ 'Status'
    trip.StartDate__c = startDate; // Utilisation de la variable 'startDate' pour la date de début
    trip.EndDate__c = endDate; // Utilisation de la variable 'endDate' pour la date de fin
    trip.Account__c = accountId; // Lier le voyage à un compte via l'ID
    trip.NumberOfParticipants__c = Decimal.valueOf(NumberOfParticipants); // Utilisation de la variable 'NumberOfParticipants' pour le champ 'NumberOfParticipants

    // Insérer le voyage
    insert trip;
    System.debug('TripManager.createTrip : ' + trip);
}
    

    // Mettre à jour un voyage
    public static void UpdateTrip(Id tripId, String name, String status, Date endDate, String description, Id accountId) {
        System.debug('TripManager.UpdateTrip');

        // Vérifier que l'ID du voyage n'est pas null
        if (tripId == null) {
            System.debug('TripId is null');
            throw new AuraHandledException('Trip ID is required');
        }

        // Vérifier que le nom du voyage n'est pas null
        if (String.isBlank(name)) {
            System.debug('Name is null');
            throw new AuraHandledException('Trip Name is required');
        }

        // Vérifier que le statut du voyage n'est pas null
        if (String.isBlank(status)) {
            System.debug('Status is null');
            throw new AuraHandledException('Status is required');
        }

        // Vérifier que la date de fin n'est pas null   
        if (endDate == null) {
            System.debug('EndDate is null');
            throw new AuraHandledException('End Date is required');
        }

        // Vérifier que accountId n'est pas null
        if (accountId == null) {
            System.debug('AccountId is null');
            throw new AuraHandledException('Account ID is required');
        }

        // Mettre à jour le voyage
        Trip__c trip = getTripById(tripId);
        trip.Name = name;
        trip.Status__c = status; // Mise à jour du statut
        trip.EndDate__c = endDate; // Mise à jour de la date de fin
        trip.Account__c = accountId; // Mise à jour du compte associé

        // Mettre à jour le voyage
        update trip;
        System.debug('TripManager.UpdateTrip : ' + trip);
    }

    // Supprimer un voyage
    public static void DeleteTrip(Id tripId) {
        System.debug('TripManager.DeleteTrip');

        // Vérifier que l'ID du voyage n'est pas null
        if (tripId == null) {
            System.debug('TripId is null');
            throw new AuraHandledException('Trip ID is required');
        }

        // Récupérer le voyage par son ID
        Trip__c trip = [SELECT Id FROM Trip__c WHERE Id = :tripId LIMIT 1];

        // Supprimer le voyage
        delete trip;
        System.debug('TripManager.DeleteTrip: Trip deleted with ID: ' + tripId);
    }

    // Récupérer un voyage par son ID
    public static Trip__c getTripById(Id tripId) {
        System.debug('TripManager.getTripById');

        // Vérifier que l'ID du voyage n'est pas null
        if (tripId == null) {
            System.debug('TripId is null');
            throw new AuraHandledException('Trip ID is required');
        }

        // Récupérer le voyage via SOQL
        Trip__c trip = [SELECT Id, Name, EndDate__c, Status__c, Account__c FROM Trip__c WHERE Id = :tripId LIMIT 1];

        // Vérifier si le voyage existe 
        if (trip == null) {
            System.debug('Trip not found');
            throw new AuraHandledException('Trip not found');
        }

        System.debug('TripManager.getTripById');
        return trip;
    }

    // Récupérer les voyages par leurs ID   
    public static List<Trip__c> getTripsById(List<Id> tripIds) {
        System.debug('TripManager.getTripsById');

        // Vérifier que la liste des ID n'est pas null
        if (tripIds == null) {
            System.debug('TripIds is null');
            throw new AuraHandledException('Trip IDs are required');
        }

        // Récupérer les voyages via SOQL
        List<Trip__c> trips = [SELECT Id, Name, EndDate__c, Status__c, Account__c FROM Trip__c WHERE Id IN :tripIds];
        return trips;
    }
}
