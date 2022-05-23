import { LightningElement } from 'lwc';
export default class Greeting extends LightningElement {
    greeting = 'Trailblazer';
    poop = 'Default';

    handleGreetingChange(event) {
        this.greeting = event.target.value;
    }
}