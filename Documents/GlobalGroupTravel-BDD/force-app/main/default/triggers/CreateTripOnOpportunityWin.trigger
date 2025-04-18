/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger CreateTripOnOpportunityWin on Opportunity (after update, after insert) {

    if (Trigger.isAfter && Trigger.isInsert) {
        for (Opportunity opp : Trigger.new) {
            ContractManager.createContract(
                opp.AccountId,
                opp.Name,
                Date.Today(),
                Date.Today().addMonths(12)
            );
        }
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        Set<Id> wonOppIds = new Set<Id>();

        for (Opportunity opp : Trigger.new) {
            Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
            if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                wonOppIds.add(opp.Id);
            }
        }

        if (!wonOppIds.isEmpty()) {
            Map<Id, Trip__c> existingTrips = new Map<Id, Trip__c>();
            for (Trip__c trip : [
                SELECT Id, Opportunity__c FROM Trip__c WHERE Opportunity__c IN :wonOppIds
            ]) {
                existingTrips.put(trip.Opportunity__c, trip);
            }

            for (Opportunity opp : Trigger.new) {
                if (
                    wonOppIds.contains(opp.Id) &&
                    !existingTrips.containsKey(opp.Id) &&
                    opp.NumberofParticipants__c != null
                ) {
                    Date tripStart = opp.StartDate__c != null ? opp.StartDate__c : Date.today();
                    Date tripEnd = opp.EndDate__c != null ? opp.EndDate__c : tripStart.addDays(7);

                    TripManager.CreateTrip(
                        opp.Id,
                        opp.Name + ' Trip',
                        'To come',
                        tripStart,
                        tripEnd,
                        String.valueOf(opp.NumberofParticipants__c),
                        opp.AccountId
                    );
                }
            }
        }
    }
}

