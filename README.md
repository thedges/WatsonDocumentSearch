# WatsonDocumentSearch

This package contains a Lightning Component that performs searches on [IBM Discovery Service](https://www.ibm.com/watson/services/discovery/). The use case is an agency can upload policy documents to IBM's discovery service and have it 'index' those documents. Then a call center or case worker can query those documents with this component to get snippets of those policy documents that hopefully answer a question or provide further context on the query. 

Current capabilities of component are:
* <b>Case Auto Search</b> - if component is added to Case page, it will perform auto-search base on Case subject
* <b>Dynamic Search</b> - component has text box to perform dynamic searches
* <b>File Attachment</b> - files can be attached (i.e. linked) to Case records
* <b>Console Utility App</b> - the component can be used as a Console utility app if desired

Before is video showing the component in action. The video shows the above functionality in that order.

![alt text](https://github.com/thedges/WatsonDocumentSearch/blob/master/WatsonDocumentSearch.gif "Sample Image")

SETUP: The documents were uploaded to IBM Discovery Service but also a local copy was stored in Salesforce in a Chatter Files library called 'Policy Documents'. The Lightning Component matches the file name returned by IBM and links to actual document stored in Chatter Files.

NOTE: This is a custom component with no configuration options and was built for specific demo. Contact me if you are interested in using and we can tweak to your demo needs.

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
