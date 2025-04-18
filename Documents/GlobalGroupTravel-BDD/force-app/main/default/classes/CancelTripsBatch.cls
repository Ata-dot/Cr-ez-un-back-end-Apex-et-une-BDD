/**
 * @description       : Annule les voyages dont la date de début est dans 7 jours et qui ont moins de 10 participants.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-17-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class CancelTripsBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date targetDate = Date.today().addDays(7);
        System.debug('[START] Date cible pour annuler les voyages : ' + targetDate);

        String query = 'SELECT Id, StartDate__c, NumberOfParticipants__c, Status__c ' +
                       'FROM Trip__c ' +
                       'WHERE StartDate__c = :targetDate ' +
                       'AND NumberOfParticipants__c < 10 ' +
                       'AND Status__c != \'Cancelled\'';

        System.debug('[START] Requête SOQL utilisée : ' + query);
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Trip__c> scope) {
        System.debug('[EXECUTE] Début du traitement - Nombre de voyages récupérés : ' + scope.size());

        if (scope.isEmpty()) {
            System.debug('[EXECUTE] Aucun voyage à traiter. Fin du batch pour ce scope.');
            return;
        }

        for (Trip__c trip : scope) {
            System.debug('[EXECUTE] Voyage à annuler - ID : ' + trip.Id + 
                         ', StartDate : ' + trip.StartDate__c + 
                         ', Participants : ' + trip.NumberOfParticipants__c + 
                         ', Statut actuel : ' + trip.Status__c);
            trip.Status__c = 'Cancelled';
        }

        try {
            update scope;
            System.debug('[EXECUTE] Voyages mis à jour avec succès : ' + scope);
        } catch (DmlException e) {
            System.debug('[ERROR] Erreur lors de la mise à jour des voyages : ' + e.getMessage());
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('[FINISH] Batch CancelTripsBatch terminé avec succès.');

        Datetime dt = Datetime.now().addMinutes(5);
        String schTm = dt.format('s m H d M \'?\' yyyy');
        System.debug('[FINISH] Planification de CancelTripsScheduler à : ' + schTm);

        String jobId = System.schedule('Test Cancel Trip ' + schTm, schTm, new CancelTripsScheduler());
        System.debug('[FINISH] Job CancelTripsScheduler planifié avec l\'ID : ' + jobId);
    }
}
