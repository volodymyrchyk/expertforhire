public class VehicleTriggerHandler {

    public void afterInsert(List<Vehicle__c> records) {
        List<Vehicle__c> geolocToInsert = new List<Vehicle__c>();
        Map<Id, Vehicle__c> mapJuncToInsert = new Map<Id, Vehicle__c>();
        
        for (Vehicle__c rec : records) {
            if (rec.Geolocation__Latitude__s == null || rec.Geolocation__Longitude__s == null) {
                geolocToInsert.add(rec);
            } else {
                mapJuncToInsert.put(rec.Id, rec);
            }        
        }

        if (geolocToInsert.size() > 0) {
            system.debug('vehicle geo insert launched');
            VehicleUpdateGeo asyncJob = new VehicleUpdateGeo(geolocToInsert);
            System.enqueueJob(asyncJob);
        }

        if (mapJuncToInsert.size() > 0) {
            system.debug('junction on vehicle create');
            ExpertToVehicleHandler handler = new ExpertToVehicleHandler();
            handler.afterVehicleInsert(mapJuncToInsert);
        }
    }

    public void afterUpdate(List<Vehicle__c> newRecs, List<Vehicle__c> oldRecs) {
        List<Vehicle__c> geolocToUpdate = new List<Vehicle__c>();
        Map<Id, Vehicle__c> mapJuncToUpdate = new Map<Id, Vehicle__c>();

        for (Integer i = 0; i < newRecs.size(); i++) {
            if (newRecs[i].Full_Address__c != oldRecs[i].Full_Address__c) {
                geolocToUpdate.add(newRecs[i]);
            } else if (newRecs[i].Geolocation__Latitude__s != oldRecs[i].Geolocation__Latitude__s || 
                        newRecs[i].Geolocation__Longitude__s != oldRecs[i].Geolocation__Longitude__s) {
                            mapJuncToUpdate.put(newRecs[i].Id, newRecs[i]);
            }
        }

        if (geolocToUpdate.size() > 0) {
            system.debug('vehicle geo update launched');
            VehicleUpdateGeo asyncJob = new VehicleUpdateGeo(geolocToUpdate);
            system.enqueueJob(asyncJob);
        } 
        if (mapJuncToUpdate.size() > 0) {
            system.debug('junction on vehicle update');
            ExpertToVehicleHandler handler = new ExpertToVehicleHandler();
            handler.afterVehicleUpdate(mapJuncToUpdate);
        }
    }
}
