public with sharing class ExpertTriggerHandler {
    
    public void afterInsert(List<Expert__c> records) {
        List<Expert__c> geolocToInsert = new List<Expert__c>();
        Map<Id, Expert__c> mapJuncToInsert = new Map<Id, Expert__c>(); 

        for (Expert__c rec : records) {
            if (rec.Geolocation__Latitude__s == null || rec.Geolocation__Longitude__s == null) {
                geolocToInsert.add(rec);
            } else {
                mapJuncToInsert.put(rec.Id, rec);
            }
        }

        if (geolocToInsert.size() > 0) {
            system.debug('expert geo insert launched');
            ExpertUpdateGeo asyncJob = new ExpertUpdateGeo(geolocToInsert);
            system.enqueueJob(asyncJob);
        }

        if (mapJuncToInsert.size() > 0) {
            system.debug('junction on expert create');
            ExpertToVehicleHandler handler = new ExpertToVehicleHandler();
            handler.afterExpertInsert(mapJuncToInsert);
        }
    }

    public void afterUpdate(List<Expert__c> newRecs, List<Expert__c> oldRecs) {
        List<Expert__c> geolocToUpdate = new List<Expert__c>();
        Map<Id, Expert__c> mapJuncToUpdate = new Map<Id, Expert__c>();

        for (Integer i = 0; i < newRecs.size(); i++) {
            if (newRecs[i].Full_Address__c != oldRecs[i].Full_Address__c) {
                geolocToUpdate.add(newRecs[i]);
            } else if (newRecs[i].Geolocation__Latitude__s != oldRecs[i].Geolocation__Latitude__s || 
                        newRecs[i].Geolocation__Longitude__s != oldRecs[i].Geolocation__Longitude__s ||
                        newRecs[i].Radius_km__c != oldRecs[i].Radius_km__c) {
                mapJuncToUpdate.put(newRecs[i].Id, newRecs[i]);
            }
        }

        if (geolocToUpdate.size() > 0) {
            system.debug('update handler launched');
            ExpertUpdateGeo asyncJob = new ExpertUpdateGeo(geolocToUpdate);
            system.enqueueJob(asyncJob);
        }

        if (mapJuncToUpdate.size() > 0) {
            system.debug('junction on expert update');
            ExpertToVehicleHandler handler = new ExpertToVehicleHandler();
            handler.afterExpertUpdate(mapJuncToUpdate);
        }
    }
}
