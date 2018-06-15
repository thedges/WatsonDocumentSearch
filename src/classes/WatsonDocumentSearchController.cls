public class WatsonDocumentSearchController {
    @AuraEnabled
    public static String queryRecord(String params)
    {
        System.debug('queryRecord invoked...');
        Map<String, String> paramMap = (Map<String, String>)JSON.deserialize(params,   Map<String, String>.class);
        System.debug(JSON.serializePretty(paramMap));
        PSResponse resp = new PSResponse();
        
        try
        {
            Map<String, String> dataResp = new Map<String, String>();
            dataResp.put('query', '');
            
            String recordId;
            
            if (paramMap.containsKey('recId')) recordId = paramMap.get('recId');
            
            if (recordId != null)
            {
                String objectName = ID.valueOf(recordId).getSObjectType().getDescribe().getName();
                dataResp.put('objectName', objectName);
                
                if (objectName == 'Case')
                {
                    Case c = [SELECT Id, Subject FROM Case Where Id = :recordId LIMIT 1];
                    dataResp.put('query', c.Subject);
                }
            }
            
            resp.data = dataResp;
        }
        catch (exception e)
        {
            resp.status = PSResponse.ERROR;
            resp.msg = e.getMessage();
        }
        
        return  JSON.serialize(resp);
    }
    
    @AuraEnabled
    public static String queryData(String params)
    {
        System.debug('queryData invoked...');
        Map<String, String> paramMap = (Map<String, String>)JSON.deserialize(params,   Map<String, String>.class);
        System.debug(JSON.serializePretty(paramMap));
        PSResponse resp = new PSResponse();
        Map<String, String> fileIdMap = new Map<String, String>();
        
        try
        {
            if (paramMap.containsKey('query'))
            {
                // build lookup of all policy docs in library 'Policy Docs'
                ID workspaceId = [SELECT Id FROM ContentWorkspace WHERE Name = 'Policy Docs'][0].Id;
                List <ContentVersion> allDocuments = [SELECT Id, Title, ContentDocumentId, PathOnClient FROM ContentVersion WHERE ContentDocument.ParentId = :workspaceId];
                for (ContentVersion v : allDocuments)
                {
                    fileIdMap.put(v.PathOnClient, v.ContentDocumentId);
                }
                System.debug(JSON.serializePretty(fileIdMap));
                
                WatsonDiscoveryResults res = WatsonQueryService.executeDiscoveryQuery(paramMap.get('query'));
                
                List<Map<String, String>> dataResp = new List<Map<String, String>>();
                for (WatsonDiscoveryResults.Passage p : res.passages)
                {
                    String fileName = res.getFileName(p.document_id);
                    
                    Map<String, String> rec = new Map<String, String>();
                    rec.put('docId', p.document_id);
                    rec.put('text', p.passage_text.replaceAll('<p>','').replaceAll('</p>','').replaceAll('<h3>','').replaceAll('</h3>','').replaceAll('<b>','').replaceAll('</b>',''));
                    rec.put('score', String.valueOf(p.passage_score.setScale(2)));
                    rec.put('docName', fileName);
                    rec.put('docURL', '');
                    rec.put('docId', fileIdMap.get(fileName));
                    dataResp.add(rec);
                }
                
                System.debug(JSON.serializePretty(dataResp));
                resp.data = dataResp;
            }
        }
        catch (exception e)
        {
            resp.status = PSResponse.ERROR;
            resp.msg = e.getMessage();
        }
        
        return  JSON.serialize(resp);
    }
    
    @AuraEnabled
    public static String attachDocToRecord(String params)
    {
        System.debug('attachDocToRecord invoked...');
        Map<String, String> paramMap = (Map<String, String>)JSON.deserialize(params,   Map<String, String>.class);
        System.debug(JSON.serializePretty(paramMap));
        PSResponse resp = new PSResponse();
        
        try
        {
            Map<String, String> dataResp = new Map<String, String>();
            
            String recordId = null;
            String docId = null;
            if (paramMap.containsKey('recId')) recordId = paramMap.get('recId');
            if (paramMap.containsKey('docId')) docId = paramMap.get('docId');
            
            
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = docId;
            cdl.LinkedEntityId = recordId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'InternalUsers';
            insert cdl;
            
            
        }
        catch (exception e)
        {
            resp.status = PSResponse.ERROR;
            resp.msg = e.getMessage();
        }
        
        return  JSON.serialize(resp);
    }
}