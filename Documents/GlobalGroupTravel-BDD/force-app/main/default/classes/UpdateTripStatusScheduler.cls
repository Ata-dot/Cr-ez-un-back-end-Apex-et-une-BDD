/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-10-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class UpdateTripStatusScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        System.debug('Début de lancement du batch de mise à jour des statuts des voyages (UpdateTripStatusBatch)');

        //Création de l'instance du batch
        UpdateTripStatusBatch batchUpdateTripStatus = new UpdateTripStatusBatch();

        //Execution du batch
        Database.executeBatch(batchUpdateTripStatus, 200);
    }
}