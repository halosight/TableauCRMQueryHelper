public with sharing class TableauCRMQueryHelper {
    @AuraEnabled
    public static TableauCRMQueryResults TableauCRMQueryBuilder(String jsonData){
        if(String.isBlank(jsonData)) {
            throw new AuraHandledException('JSON Data (jsonData) passed to query builder was empty. Make sure to pass a stringified JSON to build the query.');
        }
        System.debug(jsonData);
        QueryConfig config = (QueryConfig)JSON.deserialize(jsonData, QueryConfig.class);
        System.debug(config);
        TableauCRMQueryResults queryResult = new TableauCRMQueryResults();
        //Build SAQL query from QueryField input sent from JS
        // System.debug(config);
        List<Wave.ProjectionNode> queryFields = new List<Wave.ProjectionNode>();
        for(QueryField field: config.fields){
            if(String.isBlank(field.alias)){
                field.alias = field.apiName;
            }
            Wave.ProjectionNode node = Wave.QueryBuilder.get(WrapQuotes(field.apiName));
            //Add aggregate to node if present
            if(String.isNotBlank(field.aggregate)){
                switch on field.aggregate.toLowerCase() {
                    when 'min' {	
                        node = node.min();
                    }	
                    when 'max' {	
                        node = node.max();
                    }
                    when 'count' {	
                        node = node.count();
                    }
                    when 'avg' {	
                        node = node.avg();
                    }
                    when 'unique' {	
                        node = node.unique();
                    }
                    when 'sum' {	
                        node = node.sum();
                    }
                    when else {
                        throw new AuraHandledException('Invalid aggregate specified. Must be min, max, count, avg, unique, or sum.');
                    }
                }
            }
            node = node.alias(WrapQuotes(field.alias));
            queryFields.add(node);
        }

        Wave.QueryNode result = Wave.QueryBuilder.loadByDeveloperName(config.datasetName);
        //Add filter if present
        if(String.isNotBlank(config.filter)){
            result = result.filter(config.filter);
        }

        //Add group by if present
        if(config.groupBy != null) {
            if(config.groupBy.size() == 1 && config.groupBy[0].toLowerCase() == 'all') {
                result = result.group();
            } else {
                result = result.group(config.groupBy);
            }
        }

        //Check if fields are present
        if(config.fields == null) {
            throw new AuraHandledException('Query without fields is invalid.');
        }

        //Add query fields
        result = result.foreach(queryFields);
        
        //Add query limit if present
        if(config.queryLimit != null){
            result = result.cap(config.queryLimit);
        }

        //Update stream var if present
        if(String.isBlank(config.stream)){
            config.stream = 'q';
        }
        
        if(Test.isRunningTest()){
            queryResult.result = 'testResult';
        } else {
            String query = result.build(config.stream);
            System.debug(query);
            ConnectApi.LiteralJson analyticsQueryResult = result.execute(config.stream);

            queryResult.result = analyticsQueryResult.json;
        }

        return queryResult;
    }

    private static String WrapQuotes(String value){
        value = '\'' + value + '\'';
        return value;
    }

    public class TableauCRMQueryResults {
        @AuraEnabled public String result {get; set;}
    }

    public class QueryConfig {
        @AuraEnabled public String datasetName {get; set;}
        @AuraEnabled public String filter {get; set;}
        @AuraEnabled public List<QueryField> fields {get; set;}
        @AuraEnabled public List<String> groupBy {get; set;}
        @AuraEnabled public Integer queryLimit {get; set;}
        @AuraEnabled public String stream {get; set;}
    }

    public class QueryField {
        @AuraEnabled public String apiName {get; set;}
        @AuraEnabled public String alias {get; set; }
        @AuraEnabled public String aggregate {get; set; } // min, max, count, avg, unique, as, sum
    }
}
