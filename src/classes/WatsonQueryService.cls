public with sharing class WatsonQueryService {
    @InvocableMethod(label='Execute Watson query' description='Return list of passage text')
    public static List<List<Watson_Query_Response__c>> executeQuery2(List<String> query) {
        if(query == null || query.size() == 0){
            return null;
        }
        
        System.debug('*** Request ***');
        System.debug('query=' + JSON.serialize(query[0]));
        
        // //////////////////////////////////////////////////////
        // these should be moved out to config setting or such //
        // //////////////////////////////////////////////////////
        String username = '55c72e1d-15cc-498a-9584-57bc7c9c80bd';
        String password = 'EPVMtzmXrzhA';
        
        // create the query string
        String queryStr = 'https://gateway.watsonplatform.net/discovery/api/v1/environments/bc9957f2-6e5f-449d-994f-597339a50630/collections/1ac71c6d-24c4-41de-8698-fab88680a754/query?version=2017-11-07&count=10&deduplicate=false&highlight=true&return=extracted_metadata.filename&passages=true&passages.count=3&natural_language_query=' + EncodingUtil.urlEncode(query[0], 'UTF-8');
        System.debug('REST API query=' + queryStr);
        
        // setup the REST API call
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(queryStr);
        request.setMethod('GET');
        
        request.setTimeout(120000);   // 2 minute (maximum that can be set)
        
        // set the BASIC authentication header
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        
        // query the IBM Watson service
        HttpResponse response = http.send(request);
        
        List<List<Watson_Query_Response__c>> resultsWrapper = new List<List<Watson_Query_Response__c>>();
        List<Watson_Query_Response__c> results = new List<Watson_Query_Response__c>();
        
        // If the request is successful, process the response
        if (response.getStatusCode() == 200) {
            
            // Deserialize the JSON string into collections of primitive data types.
            System.debug(response.getBody());
            Map<String, Object> respDetails = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> passages = (List<Object>)respDetails.get('passages');
            
            for (Object passage: passages) {
                Map<String, Object> details = (Map<String, Object>) passage;
                System.debug('text=' + details.get('passage_text'));
                Watson_Query_Response__c wqr = new Watson_Query_Response__c();
                wqr.passage_text__c = (String)details.get('passage_text');
                results.add(wqr);
            }
        }
        // return a generic error message if the API call failed
        else
        {
            //results.add('ERROR Invoking Watson Service > ' + response.getStatusCode() + ':' + response.getStatus());
            return null;
        }
        
        resultsWrapper.add(results);        
        return resultsWrapper;
    }
    
    public static WatsonDiscoveryResults executeDiscoveryQuery(String query) {
        if(query == null){
            return null;
        }
        
        System.debug('*** Request ***');
        System.debug('query=' + query);
        
        try
        {
            // //////////////////////////////////////////////////////
            // these should be moved out to config setting or such //
            // //////////////////////////////////////////////////////
            String username = '55c72e1d-15cc-498a-9584-57bc7c9c80bd';
            String password = 'EPVMtzmXrzhA';
            
            // create the query string
            String queryStr = 'https://gateway.watsonplatform.net/discovery/api/v1/environments/bc9957f2-6e5f-449d-994f-597339a50630/collections/1ac71c6d-24c4-41de-8698-fab88680a754/query?version=2017-11-07&count=10&deduplicate=false&highlight=true&return=extracted_metadata.filename&passages=true&passages.count=3&natural_language_query=' + EncodingUtil.urlEncode(query, 'UTF-8');
            System.debug('REST API query=' + queryStr);
            
            // setup the REST API call
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(queryStr);
            request.setMethod('GET');
            
            request.setTimeout(120000);   // 2 minute (maximum that can be set)
            
            // set the BASIC authentication header
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            
            // query the IBM Watson service
            HttpResponse response = http.send(request);
            
            // If the request is successful, process the response
            if (response.getStatusCode() == 200) {
                
                // Deserialize the JSON string into collections of primitive data types.
                System.debug(response.getBody());
                WatsonDiscoveryResults res = (WatsonDiscoveryResults)JSON.deserialize(response.getBody(), WatsonDiscoveryResults.class);
                return res;
            }
            // return a generic error message if the API call failed
            else
            {
                return null;
            }
        }
        catch (Exception e)
        {
            return null;
        }
        
        
    }
    
    /*
public static List<List<String>> executeQuery(List<String> query) {
if(query == null || query.size() == 0){
return null;
}

System.debug('*** Request ***');
System.debug('query=' + JSON.serialize(query[0]));

// //////////////////////////////////////////////////////
// these should be moved out to config setting or such //
// //////////////////////////////////////////////////////
String username = '55c72e1d-15cc-498a-9584-57bc7c9c80bd';
String password = 'EPVMtzmXrzhA';

// create the query string
String queryStr = 'https://gateway.watsonplatform.net/discovery/api/v1/environments/bc9957f2-6e5f-449d-994f-597339a50630/collections/1ac71c6d-24c4-41de-8698-fab88680a754/query?version=2017-11-07&count=10&deduplicate=false&highlight=true&return=extracted_metadata.filename&passages=true&passages.count=3&natural_language_query=' + EncodingUtil.urlEncode(query[0], 'UTF-8');
System.debug('REST API query=' + queryStr);

// setup the REST API call
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint(queryStr);
request.setMethod('GET');

request.setTimeout(120000);   // 2 minute (maximum that can be set)

// set the BASIC authentication header
Blob headerValue = Blob.valueOf(username + ':' + password);
String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
request.setHeader('Authorization', authorizationHeader);

// query the IBM Watson service
HttpResponse response = http.send(request);

List<List<String>> resultsWrapper = new List<List<String>>();
List<String> results = new List<String>();

// If the request is successful, process the response
if (response.getStatusCode() == 200) {

// Deserialize the JSON string into collections of primitive data types.
Map<String, Object> respDetails = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
List<Object> passages = (List<Object>)respDetails.get('passages');

for (Object passage: passages) {
Map<String, Object> details = (Map<String, Object>) passage;
System.debug('text=' + details.get('passage_text'));
results.add((String)details.get('passage_text'));
}
}
// return a generic error message if the API call failed
else
{
results.add('ERROR Invoking Watson Service > ' + response.getStatusCode() + ':' + response.getStatus());
}

resultsWrapper.add(results);        
return resultsWrapper;
}
*/
    
    public static void testService()
    {
        
       
        List<String> query = new List<String>();
        query.add('can I charge a fee for a missed appointment');
        
        String queryStr = 'can I charge a fee for a missed appointment';
        WatsonDiscoveryResults res = executeDiscoveryQuery(queryStr);
        System.debug('RESPONSE');
        System.debug(JSON.serializePretty(res));
        
        for (WatsonDiscoveryResults.Passage p : res.passages)
        {
            System.debug('File [' + p.document_id + '] = ' + res.getFileName(p.document_id));
        }
        
        /*
        List<List<Watson_Query_Response__c>> resultsWrapper = executeQuery2(query);
        List<Watson_Query_Response__c> results = resultsWrapper.get(0);
        for (Watson_Query_Response__c passage : results)
        {
            System.debug('passage=' + passage.passage_text__c);
        }
        */
        
        /*
List<List<String>> resultsWrapper = executeQuery(query);
List<String> results = resultsWrapper.get(0);
for (String passage : results)
{
System.debug('passage=' + passage);
}
*/
    }
    
    public class PassageDetails
    {
        @InvocableVariable
        public String passage_text;
    }
}