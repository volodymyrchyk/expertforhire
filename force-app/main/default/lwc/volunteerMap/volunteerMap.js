import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
const VOLUNTEER_NAME_FIELD = 'Volunteer__c.Name';
const LOCATION_LATITUDE_FIELD = 'Volunteer__c.Geolocation__Latitude__s';
const LOCATION_LONGITUDE_FIELD = 'Volunteer__c.Geolocation__Longitude__s';
const VOLUNT_FIELDS = [VOLUNTEER_NAME_FIELD, LOCATION_LATITUDE_FIELD, LOCATION_LONGITUDE_FIELD];

export default class VolunteerMap extends LightningElement {
    @api recordId;
    data;
    error;
    mapMarkers = [];
    @wire(getRecord, { recordId: '$recordId', fields: VOLUNT_FIELDS })
    wiredAccount({data, error}) {
        if (data) {
            this.data = data;
            this.error = undefined;
            this.name =  getFieldValue(data, VOLUNTEER_NAME_FIELD);
            // const Latitude = getFieldValue(data, LOCATION_LATITUDE_FIELD);
            const Latitude1 = '51.757966';
            const Longitude1 = '17';
            const Latitude2 = '52';
            const Longitude2 = '17';
            console.log('latitude ', typeof(Latitude));
            // this.mapMarkers = [{
            //                     location: { Latitude, Longitude},
            //                     title: this.name,
            //                     description: `Coords: ${Latitude}, ${Longitude}`
            // }];
            this.mapMarkers = [{location:{Longitude:Longitude1, Latitude:Latitude1}}];
            // this.mapMarkers = [{location: {City: 'Warsaw', Country: 'Poland', Street: 'Koszykowa'}, title: 'Bob', type: 'Circle', radius: 1000}];
            // this.mapMarkers = [{location: {City: 'Warsaw', Country: 'Poland', Street: '15 Koszykowa'}, type: 'Circle', radius: 150000, strokeColor: '#0000FF',
            // strokeOpacity: 0.8,
            // strokeWeight: 1,
            // fillColor: '#0000FF',
            // fillOpacity: 0.15,}];
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }
}