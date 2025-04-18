/**
 * @description       : Planifie et execute le batch CancelTripsBatch automatiquement
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class CancelTripsScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        System.debug('Début de lancement du batch de annulation des voyages (CancelTripsBatch)');

        //Création de l'instance du batch
        CancelTripsBatch batchCancelTrips = new CancelTripsBatch();

        //Execution du batch
        Database.executeBatch(batchCancelTrips, 200);

    }
}