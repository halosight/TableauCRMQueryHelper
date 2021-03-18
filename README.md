# Tableau CRM Query Helper

This helper class enables you to quickly and easily query Tableau CRM datasets directly from a native Lightning Web Component.

## How to design queries in JavaScript

The main function of this component is to extend the ability to query Tableau CRM datasets from an LWC's javascript. This can be done by
designing a simple JSON file in the LWC and passing it to the `TableauCRMQueryHelper.TableauCRMQueryBuilder` Apex class as a parameter.

### Configuration Reference
|Key                            |Value                                                      |Type                               |Required                           |
|-------------------------------|-----------------------------------------------------------|-----------------------------------|-----------------------------------|
|datasetName                    |The API name of the Tableau CRM dataset to be queried      |String                             |*Yes*                              |
|fields                         |An array of object which can contain the [following values](###field-parameter-reference) to define the fields to query      |Array       |*Yes*        |

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
