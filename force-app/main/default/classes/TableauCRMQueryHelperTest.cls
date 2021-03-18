@isTest
public class TableauCRMQueryHelperTest {
    @isTest
    private static void testTableauCRMQueryBuilder(){
        TableauCRMQueryHelper.QueryConfig config = new TableauCRMQueryHelper.QueryConfig();
        config.queryLimit = 100;
        config.datasetName = 'testDataset';
        config.filter = '\'TestField\' == "12345"';
        config.groupBy = new String[]{'State', 'City'};
        
        List<TableauCRMQueryHelper.QueryField> queryFields = new List<TableauCRMQueryHelper.QueryField>();
        List<String> aggregates = new String[]{'min', 'max', 'count', 'avg', 'unique', 'sum'};
        
        //Create a field for each aggragate measure
        for(String agg : aggregates) {
            TableauCRMQueryHelper.QueryField field = new TableauCRMQueryHelper.QueryField();
            field.apiName = 'testApiName-' + agg;
            field.alias = 'testAlias-' + agg;
            field.aggregate = agg;
            queryFields.add(field);
        }
        
        config.fields = queryFields;

        String jsonConfig = JSON.serialize(config);
        
        Test.startTest();
        TableauCRMQueryHelper.TableauCRMQueryResults results = TableauCRMQueryHelper.TableauCRMQueryBuilder(jsonConfig);
        Test.stopTest();
        
        System.assertEquals('testResult', results.result);
    }
}
