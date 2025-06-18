# analytics_dbt

### Learning dbt
* ETL or ELT
* Models
* Tests
* Macros
* YAML, jinja
* DAG

### Shortcuts
* __ will show list of all keyboard shortcuts (double underscore)

### Commands
* dbt build
* dbt run (will update and load to snowflake - or datawarehouse being used)
* dbt test

### Notes
* each model will map to either a table or view inside of datawarehouse - one to one
* files go in the models folder
* if somethimg is read only check the branch, if new one create a branch to work in for Github
* dbt run --select dim_customers will only run that one command
* modular thinking approach - use stage tables that are reusable - eg stg_customers or stg_orders (also in the models folder as sql files)
* in table refering to the stage tables use ref (select * from {{ ref('stg_customers') }}) - using jinja
* create sources with YAML to use in stage tables to refer to original tables in datawarehouse from ({{ source('jaffle_shop', 'customers') }}) - using jinja
* compile button will show the code with out the jinja code, will replace with the actual sql code

### naming conventions
- sources (are not models) are way of referencing the raw tables that exist inside of data warehouse
- staging models - built one to one with underliying source data (renaming columns, checking data quality and fixing)
- intermediate models - between staging and the rest of our final tables (might want to hide from final users, just show to the team) and should ref stage models and not source tables
- fact models - skinny long tables, represnt things that occuring or occured (orders, events, clicks)
- dimension models - things that exist like people (things that are) (customers, user)
- query with a BI tool

### reorganise your project
- remove example directories
- add some sub folders in the models folder (eg marts (can also have a folder in marts called marketing) or staging folders)
- can drag and drop the original modes into the new folders created above
- inside - dbt_project.yml file can rename the project, and at bottom can change materialised to Table instead of view within the new project name and which folder
    models:
  jaffle_shop:
    marts:
      materialized: table
    staging:
      materialized: view
