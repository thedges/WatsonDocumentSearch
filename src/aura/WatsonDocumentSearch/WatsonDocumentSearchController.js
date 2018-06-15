({
    doInit : function(component, event, helper) {
        helper.loadRecord(component);
    },
    handleSearch : function(component, event, helper) {
        helper.executeQuery(component);
    },
    searchEvent : function(component, event, helper) {
        console.log(event.getParams().keyCode);
        if(event.getParams().keyCode == 13){
            helper.executeQuery(component);
        }
    },
    popDoc : function(component, event, helper) {
        var idx = event.target.id;
        console.log("idx=" + idx);
        
        $A.get('e.lightning:openFiles').fire({
            recordIds: [idx]
        });
    },
    attachDoc : function(component, event, helper) {
        var idx = event.target.id;
        console.log("idx=" + idx);
        
        helper.attachDocument(component, idx);
    },
    onRecordIdChange : function(component, event, helper) {
        var newRecordId = component.get("v.recordId");
        console.log('newRecordId=' + newRecordId);
        helper.loadRecord(component);
    }    
})