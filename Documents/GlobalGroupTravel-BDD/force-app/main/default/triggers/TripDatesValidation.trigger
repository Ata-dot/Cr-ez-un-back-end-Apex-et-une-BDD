/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-17-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger TripDatesValidation on Trip__c (before insert, before update) {
    // Parcourir chaque Trip à insérer ou mettre à jour
    for(Trip__c trip : Trigger.new){

        // Vérifier que les dates de début et de fin ne sont pas nulles
        if(trip.StartDate__c == null || trip.EndDate__c == null){
            trip.addError('Les dates de début et de fin sont obligatoires');
        }
        
        // Vérifier que la date de fin est supérieure à la date de début
        if(trip.EndDate__c < trip.StartDate__c){
            trip.addError('La date de fin doit être supérieure à la date de début');
        }
    }

    }

