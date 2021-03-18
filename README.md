# Tableau CRM Query Helper

This helper class enables you to quickly and easily query Tableau CRM datasets directly from a native Lightning Web Component.

## How to design queries in JavaScript

The main function of this component is to extend the ability to query Tableau CRM datasets from an LWC's javascript. This can be done by
designing a simple JSON file in the LWC and passing it to the `TableauCRMQueryHelper.TableauCRMQueryBuilder` Apex class as a parameter.

### Tutorial

1. Import the TableauCRMQueryHelper class reference into your project:
```
import { LightningElement } from 'lwc';
import buildTableauCRMQuery from '@salesforce/apex/TableauCRMQueryHelper.TableauCRMQueryBuilder';

export default class QueryHelperDemo extends LightningElement {
    ...
```

2. Next, create a method that can configure your query and convert it to stringified JSON when called:
```
    uniqueFieldQueryFunc() {
        let query = {
            datasetName: 'DemoDataset',
            filter: '\'Id\' == "Foo"',
            fields: [
                {
                    apiName: "Color",
                    alias: "unique_Colors",
                    aggregate: 'unique'
                }
            ],
            groupBy: ['all'],
            limit: 1
        }
        return JSON.stringify(query);
    }
```

3. Finally, call buildTableauCRMQuery through an event handler or through the @wire annotation (you may need to add (cacheable=true) to the Apex function in order to use the @wire method), and pass the return value of the function you made above as a parameter:
```
    onClick() {
        let queryConfiguration = this.uniqueFieldQueryFunc();
        buildTableauCRMQuery({jsonData: queryConfiguration}).then(result => {
            const resultJson = JSON.parse(result.result);
            console.log(resultJson.results.records);
        })
    }
```
Here we would expect an array of SAQL results to be displayed to the console. In this case, the array would only contain one index, which would be a unique count of "Color" fields in the dataset that have Id "Foo". Of course, in the real world we would want the query to be a little more dynamic, and it can be! By simply passing a few parameters into the `uniqueFieldQueryFunc()` funciton above, we can dynamically pass in a dataset name, fields names, or really anything and a SAQL query will be built out of it. Using the example above, the exact SAQL query that will be generated will look like this:
```
q = load "datasetId/datasetVersionId";
q = filter q by 'DemoDataset' == "Foo";
q = group q by all;
q = foreach q generate unique('Color') as 'unique_Colors';
q = limit q 1;
```

### Query Response
The response variable used above: `const resultJson = JSON.parse(result.result);`, contains loads of useful information while using and debugging this helper. Primarily, the generated query is accessible by using the `query` key. For example, `console.log(resultJson.query);` would log the generated SAQL query to the console. Additonally, the `responseTime` key is useful to analyzing how effecient your query is running.

### Configuration Reference
|Key                            |Value                                                      |Type                               |Required                           |
|-------------------------------|-----------------------------------------------------------|-----------------------------------|-----------------------------------|
|datasetName                    |The API name of the Tableau CRM dataset to be queried      |String                             |*Yes*                              |
|fields                         |An array of objects which can contain the [following values](#field-parameter-reference) to define the fields to query      |Array(Object)       |*Yes*        |
|filter          |Defines a filter for the query, ex: `'FieldName' == "foo"`. Notice the single quotes around *FieldName* and the double quotes around *foo*? Those are required for the query filter to function properly     |String                               |*No*                           |
|groupBy                 |Defines a group by statement for the query. You may group by one or many fields defined in the query, or you may also define the group by statement as `["all"]` to group by all.                   |Array(String)                               |*No*                           |
|queryLimit           |Defines a limit value for the query. (Max limit: 10,000)                      |Integer                               |*No*                           |
|stream                            |Defines a custom value for the stream variable, ex. `q = load "xyz"`, `x = load "xyz"`, `y = load "xyz"`, etc. If not defined, the default value is `q`.                     |String (Probably should be a single char)                               |No                           |

### Field Parameter Reference
|Key                            |Value                                                      |Type                               |Required                           |
|-------------------------------|-----------------------------------------------------------|-----------------------------------|-----------------------------------|
|apiName                    |The API name of the Dataset Field      |String                             |*Yes*                              |
|alias                         |An alias to rename the apiName field      |String       |*No*        |
|aggregate                         |If defined, an aggregate value will be used on the field. Possible values include `min`, `max`, `count`, `avg`, `unique`, and `sum`  |String       |*No*        |


## References

- [Tableau CRM Apex SDK](https://developer.salesforce.com/docs/atlas.en-us.bi_dev_guide_sdk.meta/bi_dev_guide_sdk/bi_sdk_apex.htm)
- [Tableau CRM Apex SDK QueryBuilder Examples](https://developer.salesforce.com/docs/atlas.en-us.bi_dev_guide_sdk.meta/bi_dev_guide_sdk/bi_sdk_apex_examples.htm)
