trigger VehicleTrigger on Vehicle__c (after insert, after update) {
    
    VehicleTriggerHandler vehicHandler = new VehicleTriggerHandler();

    if (Trigger.isAfter && Trigger.isInsert) {
        vehicHandler.afterInsert(Trigger.New);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        vehicHandler.afterUpdate(Trigger.New, Trigger.Old);
    }
}