public class WatsonDiscoveryResults {
  public Integer matching_results;
  public String session_token;
  public List<Passage> passages;
  public List<Result> results;
  
  private Map<String, String> fileIdMap = null;
    
  public String getFileName(String id)
  {
    if (fileIdMap == null)
    {
       fileIdMap = new Map<String, String>();
       
       for (Result r : results)
       {
           if (r.extracted_metadata.filename != null)
           {
              fileIdMap.put(r.id, r.extracted_metadata.filename);
           }
       }
    }
      
    if (fileIdMap.containsKey(id))
    {
        return fileIdMap.get(id);
    }
    return null;
  }
    
  public class Passage
  {
      public String document_id;
      public Decimal passage_score;
      public String passage_text;
      public Integer start_offset;
      public Integer end_offset;
      public String field;
  }  
    
  public class Result
  {
      public String id;
      public ResultMetadata result_metadata;
      public ExtractedMetadata extracted_metadata;
      public Highlight highlight;
  }
    
  public class ResultMetadata
  {
      public Decimal score;
  }
    
  public class ExtractedMetadata
  {
      public String filename;
  }
    
  public class Highlight
  {
      List<String> html;
      List<String> text;
  }
}