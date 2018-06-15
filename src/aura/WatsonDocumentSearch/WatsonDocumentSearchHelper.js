({
    loadRecord : function(component) {
        var self = this;
        var recid = component.get("v.recordId");
        console.log("loadRecord id: " + recid);
        
        component.set('v.searchResults', null);
        
        var action = component.get("c.queryRecord");
        
        var paramMap = {};
        paramMap['recId'] = recid;
        
        action.setParams({
            "params": JSON.stringify(paramMap)
        });
        
        
        action.setCallback(component, function(response) {
            var resp = JSON.parse(response.getReturnValue());
            
            if (resp.status === 'ERROR') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": resp.msg,
                    "mode": "sticky",
                    "type": "error"
                });
                toastEvent.fire();
            } 
            else 
            {
                if (resp.data != null && resp.data['query'] != '')
                {
                    component.set('v.objectName', resp.data['objectName']);
                    component.set('v.queryStr', resp.data['query']);
                    self.executeQuery(component);
                }
            }
        });
        $A.enqueueAction(action);
    },
    executeQuery : function(component) {
        var self = this;
        
        self.showSpinner(component);
        
        component.set('v.searchResults', null);
        
        var queryStr = component.get("v.queryStr");
        
        var action = component.get("c.queryData");
        
        var paramMap = {};
        paramMap['query'] = queryStr;
        
        action.setParams({
            "params": JSON.stringify(paramMap)
        });
        
        
        action.setCallback(component, function(response) {
            var resp = JSON.parse(response.getReturnValue());
            
            if (resp.status === 'ERROR') {
                self.hideSpinner(component);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": resp.msg,
                    "mode": "sticky",
                    "type": "error"
                });
                toastEvent.fire();
            } 
            else 
            {
                self.hideSpinner(component);
               console.log('resp=' + JSON.stringify(resp.data));
                component.set('v.searchResults', resp.data);
            }
        });
        $A.enqueueAction(action);
    },
    attachDocument : function(component, docId) {
        var self = this;
        
        var action = component.get("c.attachDocToRecord");
        
        var paramMap = {};
        paramMap['recId'] = component.get("v.recordId");
        paramMap['docId'] = docId;
        
        action.setParams({
            "params": JSON.stringify(paramMap)
        });
        
        
        action.setCallback(component, function(response) {
            var resp = JSON.parse(response.getReturnValue());
            
            if (resp.status === 'ERROR') {
                self.hideSpinner(component);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": resp.msg,
                    "mode": "sticky",
                    "type": "error"
                });
                toastEvent.fire();
            } 
            else 
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Document Attached!",
                    "message": "Document has been attached to " + component.get("v.objectName"),
                    "mode": "dismissible",
                    "duration" : 1000,
                    "type": "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner:function(component){
        component.set("v.IsSpinner",true);
    },
    hideSpinner:function(component){
        component.set("v.IsSpinner",false);
    }
})