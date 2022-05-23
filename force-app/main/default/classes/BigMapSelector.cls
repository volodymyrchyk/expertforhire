global class BigMapSelector {
    @AuraEnabled(cacheable=true)
    public static List<Expert__c> getExperts(){
        return [SELECT First_Name__c, Last_Name__c, Geolocation__Longitude__s, Geolocation__Latitude__s, 
                Country_of_location__c,
                 City__c, Street__c, Building__c,
                Radius_km__c FROM Expert__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Vehicle__c> getVehicles() {
        return [SELECT Description__c, Geolocation__Longitude__s, Geolocation__Latitude__s FROM Vehicle__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> getRecords() {
        List<sObject> rezus = new List<sObject>();  
        rezus.addall(getExperts());
        rezus.addall(getVehicles());
        return rezus;
    }

    @AuraEnabled(cacheable=true)
    public static List<MapMarker> getLocations() {
        List<MapMarker> locations = new List<MapMarker>();
        List<Vehicle__c> vehicles = getVehicles();
        List<Expert__c> experts = getExperts();
        for (Vehicle__c vehicle : vehicles) {
            MapMarker oneLocation = new MapMarker();
            oneLocation.location = new Loca();
            oneLocation.location.Longitude = vehicle.Geolocation__Longitude__s;
            oneLocation.location.Latitude = vehicle.Geolocation__Latitude__s;
            oneLocation.title = vehicle.Description__c;
            locations.add(oneLocation);
        }
        for (Expert__c expert : experts) {
            MapMarker oneLocation = new MapMarker();
            oneLocation.location = new Loca();
            oneLocation.location.Longitude = expert.Geolocation__Longitude__s;
            oneLocation.location.Latitude = expert.Geolocation__Latitude__s;
            oneLocation.location.Country = expert.Country_of_location__c;
            oneLocation.location.City = expert.City__c;
            oneLocation.location.Street = expert.Street__c + ' ' + expert.Building__c;
            system.debug(oneLocation);
            oneLocation.type ='Circle'; 
            oneLocation.radius = expert.Radius_km__c*1000;
            oneLocation.strokeColor = '#0000FF';
            oneLocation.strokeOpacity = 0.8;
            oneLocation.strokeWeight = 1;
            oneLocation.fillColor = '#0000FF';
            oneLocation.fillOpacity = 0.15;
            locations.add(oneLocation);
        }
        return locations;
    }

    private class MapMarker {
        @AuraEnabled public Loca location;
        @AuraEnabled public String title;
        @AuraEnabled public String type;
        @AuraEnabled public Decimal radius;
        @AuraEnabled public String strokeColor;
        @AuraEnabled public Decimal strokeOpacity;
        @AuraEnabled public Integer strokeWeight;
        @AuraEnabled public String fillColor;
        @AuraEnabled public Decimal fillOpacity;
    }

}
