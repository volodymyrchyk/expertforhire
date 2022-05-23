public class ExpertUpdateGeo implements Queueable, Database.AllowsCallouts {
    List<Expert__c> experts;
    
    public ExpertUpdateGeo(List<Expert__c> exps) {
        this.experts = exps;
    }

    public void execute(QueueableContext context) {
        Map<Id, Expert__c> mapRecords = new Map<Id, Expert__c>([SELECT Id, 
                                                                Geolocation__Latitude__s, 
                                                                Geolocation__Longitude__s, 
                                                                Building__c,
                                                                Street__c,
                                                                City__c,
                                                                Country_of_location__c
                                                                FROM Expert__c
                                                                WHERE Id in :experts]);
    
    for (Id recId : mapRecords.keySet()) {
        Http htp = new Http();
        HttpRequest request = new HttpRequest();
        String fullAddress = mapRecords.get(recId).Building__c 
                                    + '+' + mapRecords.get(recId).Street__c
                                    + '+' + mapRecords.get(recId).City__c 
                                    + '+' + mapRecords.get(recId).Country_of_location__c;
        String endpoint = 'https://api.opencagedata.com/geocode/v1/json?key=ae5ba6db64b34616923068e753748c74&q='
                            + fullAddress;
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = htp.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> rezu = (List<Object>) result.get('results');
            Map<String, Object> rez = (Map<String, Object>) rezu[0];
            Map<String, Object> geom = (Map<String, Object>) rez.get('geometry');
            Decimal lat = (Decimal) geom.get('lat');
            Decimal lng = (Decimal) geom.get('lng');
            system.debug('lat => ' + lat + ' || lng => ' + lng);
            mapRecords.get(recId).Geolocation__Latitude__s = lat;
            mapRecords.get(recId).Geolocation__Longitude__s = lng;
        }
        update mapRecords.values();
    }
    
                                                            }
}
