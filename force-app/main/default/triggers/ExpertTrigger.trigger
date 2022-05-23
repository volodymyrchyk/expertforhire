trigger ExpertTrigger on Expert__c (after insert, after update) {

    ExpertTriggerHandler expHandler = new ExpertTriggerHandler();

    if (Trigger.isAfter && Trigger.isInsert) {
        expHandler.afterInsert(Trigger.New);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        expHandler.afterUpdate(Trigger.New, Trigger.Old);
    }
}