# Tableau CRM Query Helper

This helper class enables you to quickly and easily query Tableau CRM datasets directly from a native Lightning Web Component.

## How to design queries in JavaScript

The main function of this component is to extend the ability to query Tableau CRM datasets from an LWC's javascript. This can be done by
designing a simple JSON file in the LWC and passing it to the `TableauCRMQueryHelper.TableauCRMQueryBuilder` Apex class as a parameter.

### Configuration Reference
|Key                            |Value                                                      |Type                               |Required                           |
|-------------------------------|-----------------------------------------------------------|-----------------------------------|-----------------------------------|
|datasetName                    |The API name of the Tableau CRM dataset to be queried      |String                             |*Yes*                              |
|fields                         |An array of objects which can contain the [following values](#field-parameter-reference) to define the fields to query      |Array(Object)       |*Yes*        |
|filter          |Defines a filter for the query, ex: `'FieldName' == "foo"`. Noties the single quotes around *FieldName* and the double quotes around *foo*? Those are required for the query filter to function properyly     |String                               |*No*                           |
|groupBy                 |Defines a group by statement for the query. You may group by one or many fields defined in the query, or you may also define the group by statement as `["all"]` to group by all.                   |Array(String)                               |*No*                           |
|queryLimit           |Defines a limit value for the query. (Max limit: 10,000)                      |Integer                               |*No*                           |
|stream                            |Defines a custom value for the stream variable, ex. `q = load "xyz"`, `x = load "xyz"`, `y = load "xyz"`, etc. If not defined, the default value is `q`.                     |String (Probably should be a single char)                               |No                           |

### Field Parameter Reference
|Key                            |Value                                                      |Type                               |Required                           |
|-------------------------------|-----------------------------------------------------------|-----------------------------------|-----------------------------------|
|apiName                    |The API name of the Dataset Field      |String                             |*Yes*                              |
|alias                         |An alias to rename the apiName field      |String       |*No*        |
|aggregate                         |If defined, an aggregate value will be used on the field. Possible values include `min`, `max`, `count`, `avg`, `unique`, and `sum`  |String       |*No*        |

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
