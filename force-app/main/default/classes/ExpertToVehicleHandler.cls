public class ExpertToVehicleHandler {

    public void afterVehicleInsert(Map<Id, Vehicle__c> mapVehicles) {
        List<ExpertToVehicle__c> insertJunctions = new List<ExpertToVehicle__c>();
        Map<Id, Expert__c> mapExperts = new Map<Id, Expert__c>([SELECT Radius_km__c, Geolocation__Latitude__s, 
                                                                Geolocation__Longitude__s, 
                                                                Countries_of_operation__c FROM Expert__c]);
        for (Expert__c expert : mapExperts.values()) {
            for (Vehicle__c vehicle : mapVehicles.values()) {
                Location vehicLoc = location.newInstance(vehicle.Geolocation__Latitude__s, vehicle.Geolocation__Longitude__s);
                Location expertLoc = location.newInstance(expert.Geolocation__Latitude__s, expert.Geolocation__Longitude__s);
                if (Location.getDistance(vehicLoc, expertLoc, 'km') <= expert.Radius_km__c) {
                    ExpertToVehicle__c junction = new ExpertToVehicle__c(Vehicle__c = vehicle.Id, Expert__c = expert.Id);
                    insertJunctions.add(junction);
                }
            }
        }
        insert insertJunctions;
    }
    
    public void afterVehicleUpdate(Map<Id, Vehicle__c> mapVehicles) {
        List<ExpertToVehicle__c> oldJunctions = [SELECT Vehicle__c, Expert__c 
                                                FROM ExpertToVehicle__c
                                                WHERE Vehicle__c IN :mapVehicles.keySet()];
        List<ExpertToVehicle__c> keepJunctions = new List<ExpertToVehicle__c>();
        List<ExpertToVehicle__c> insertJunctions = new List<ExpertToVehicle__c>();
        List<ExpertToVehicle__c> deleteJunctions = new List<ExpertToVehicle__c>();
        Map<Id, Expert__c> mapExperts = new Map<Id, Expert__c>([SELECT Radius_km__c, Geolocation__Latitude__s, 
                                                                Geolocation__Longitude__s, 
                                                                Countries_of_operation__c 
                                                                FROM Expert__c]);
        Boolean isPresent;

        for (ExpertToVehicle__c presJunc : oldJunctions) {
            Location vehiLoc = location.newInstance(mapVehicles.get(presJunc.Vehicle__c).Geolocation__Latitude__s,
                                                    mapVehicles.get(presJunc.Vehicle__c).Geolocation__Longitude__s);
            Location expertLoc = location.newInstance(mapExperts.get(presJunc.Expert__c).Geolocation__Latitude__s,
                                                        mapExperts.get(presJunc.Expert__c).Geolocation__Longitude__s);
            if (Location.getDistance(vehiLoc, expertLoc, 'km') > mapExperts.get(presJunc.Expert__c).Radius_km__c) {
                deleteJunctions.add(presJunc);
            } else {
                keepJunctions.add(presJunc);
            }
        }
        delete deleteJunctions;

        for (Expert__c expert : mapExperts.values()) {
            for (Vehicle__c vehicle : mapVehicles.values()) {
                Location vehicLoc = location.newInstance(vehicle.Geolocation__Latitude__s, vehicle.Geolocation__Longitude__s);
                Location expertLoc = location.newInstance(expert.Geolocation__Latitude__s, expert.Geolocation__Longitude__s);
                if (Location.getDistance(vehicLoc, expertLoc, 'km') <= expert.Radius_km__c) {
                    isPresent = false;
                    for (ExpertToVehicle__c keepJunction : keepJunctions) {
                        if (keepJunction.Vehicle__c == vehicle.Id && keepJunction.Expert__c == expert.Id) {
                            isPresent = true;
                            break;
                        }
                    }

                    if (!isPresent) {
                        ExpertToVehicle__c junction = new ExpertToVehicle__c(Vehicle__c = vehicle.Id, Expert__c = expert.Id);
                        insertJunctions.add(junction);
                    }
                } 
            }
        }
        insert insertJunctions;
    }

    public void afterExpertInsert(Map<Id, Expert__c> mapExperts) {
        List<ExpertToVehicle__c> insertJunctions = new List<ExpertToVehicle__c>();
        Map<Id, Vehicle__c> mapVehicles = new Map<Id, Vehicle__c>([SELECT Geolocation__Latitude__s,
                                                                    Geolocation__Longitude__s,
                                                                    Country_of_location__c
                                                                    FROM Vehicle__c]);
        for (Vehicle__c vehicle : mapVehicles.values()) {
            for (Expert__c expert : mapExperts.values()) {
                Location vehiLoc = location.newInstance(vehicle.Geolocation__Latitude__s,
                                                        vehicle.Geolocation__Longitude__s);
                Location expertLoc = location.newInstance(expert.Geolocation__Latitude__s,
                                                        expert.Geolocation__Longitude__s);
                if (Location.getDistance(vehiLoc, expertLoc, 'km') <= expert.Radius_km__c) {
                    ExpertToVehicle__c junction = new ExpertToVehicle__c(Vehicle__c = vehicle.Id, Expert__c = expert.Id);
                    insertJunctions.add(junction);
                }
            }
        }
        insert insertJunctions;
    }

    public void afterExpertUpdate(Map<Id, Expert__c> mapExperts) {
        List<ExpertToVehicle__c> oldJunctions = [SELECT Vehicle__c, Expert__c 
                                                FROM ExpertToVehicle__c
                                                WHERE Expert__c IN :mapExperts.keySet()];
        List<ExpertToVehicle__c> keepJunctions = new List<ExpertToVehicle__c>();
        List<ExpertToVehicle__c> insertJunctions = new List<ExpertToVehicle__c>();
        List<ExpertToVehicle__c> deleteJunctions = new List<ExpertToVehicle__c>();                                       
        Map<Id, Vehicle__c> mapVehicles = new Map<Id, Vehicle__c>([SELECT Geolocation__Latitude__s,
                                                                    Geolocation__Longitude__s,
                                                                    Country_of_location__c
                                                                    FROM Vehicle__c]);
        Boolean isPresent;

        for (ExpertToVehicle__c presJunc : oldJunctions) {
            Location vehiLoc = location.newInstance(mapVehicles.get(presJunc.Vehicle__c).Geolocation__Latitude__s,
                                                    mapVehicles.get(presJunc.Vehicle__c).Geolocation__Longitude__s);
            Location expertLoc = location.newInstance(mapExperts.get(presJunc.Expert__c).Geolocation__Latitude__s,
                                                        mapExperts.get(presJunc.Expert__c).Geolocation__Longitude__s);
            if (Location.getDistance(vehiLoc, expertLoc, 'km') > mapExperts.get(presJunc.Expert__c).Radius_km__c) {
                deleteJunctions.add(presJunc);
            } else {
                keepJunctions.add(presJunc);
            }
        }
        delete deleteJunctions;

        for (Vehicle__c vehicle : mapVehicles.values()) {
            for (Expert__c expert : mapExperts.values()) {
                Location vehiLoc = location.newInstance(vehicle.Geolocation__Latitude__s, vehicle.Geolocation__Longitude__s);
                Location expertLoc = location.newInstance(expert.Geolocation__Latitude__s, expert.Geolocation__Longitude__s);
                if (Location.getDistance(vehiLoc, expertLoc, 'km') <= expert.Radius_km__c) {
                    isPresent = false;
                    for (ExpertToVehicle__c keepJunction : keepJunctions) {
                        if (keepJunction.Vehicle__c == vehicle.Id && keepJunction.Expert__c == expert.Id) {
                            isPresent = true;
                            break;
                        }
                    }

                    if (!isPresent) {
                        ExpertToVehicle__c junction = new ExpertToVehicle__c(Vehicle__c = vehicle.Id, Expert__c = expert.Id);
                        insertJunctions.add(junction);
                    }
                }
            }
        }
        insert insertJunctions;
    }
}
