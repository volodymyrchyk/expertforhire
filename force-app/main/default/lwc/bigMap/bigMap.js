import { LightningElement, api, wire } from 'lwc';
import getRecords from '@salesforce/apex/BigMapSelector.getRecords';
import getLocations from '@salesforce/apex/BigMapSelector.getLocations';

export default class BigMap extends LightningElement {
    data;
    error;
    dupa = false;
    mapMarkers = [];

    // @wire(getRecords)
    // Locs({data, error}) {
    //     if (data) {
    //         for (let item of data) {
    //             if (item.Description__c) {
    //                 let row = {location:{Longitude:item.Geolocation__Longitude__s, 
    //                             Latitude:item.Geolocation__Latitude__s},
    //                             title: item.Description__c};
    //                 this.mapMarkers.push(row);
    //             } else {
    //                 let row = {location:{Longitude:item.Geolocation__Longitude__s, 
    //                     Latitude:item.Geolocation__Latitude__s},
    //                     title: item.Name, 
    //                     type:'Circle', 
    //                     radius: item.Radius_for_search__c*1000,
    //                     strokeColor: '#0000FF',
    //                     strokeOpacity: 0.8,
    //                     strokeWeight: 1,
    //                     fillColor: '#0000FF',
    //                     fillOpacity: 0.15,};
    //                 this.mapMarkers.push(row);          
    //             }
    //         }
    //         this.dupa = true;
    //     } else {
    //         this.error = error;
    //         this.data = undefined;
    //     }
    // }

    @wire(getLocations)
    getLocas({data, error}) {
        if (data) {
            this.mapMarkers = data;
            this.dupa = true;
        } else {
            this.error = error;
            this.data = undefined;
        }
    }

}