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
- can see all above change on the left under version control - commit and sync

Modularity
We could build each of our final models in a single model as we did with dim_customers, however with dbt we can create our final data products using modularity.
Modularity is the degree to which a system's components may be separated and recombined, often with the benefit of flexibility and variety in use.
This allows us to build data artifacts in logical steps.
For example, we can stage the raw customers and orders data to shape it into what we want it to look like. Then we can build a model that references both of these to build the final dim_customers model.
Thinking modularly is how software engineers build applications. Models can be leveraged to apply this modular thinking to analytics engineering.
ref Macro
Models can be written to reference the underlying tables and views that were building the data warehouse (e.g. analytics.dbt_jsmith.stg_jaffle_shop_customers). This hard codes the table names and makes it difficult to share code between developers.
The ref function allows us to build dependencies between models in a flexible way that can be shared in a common code base. The ref function compiles to the name of the database object as it has been created on the most recent execution of dbt run in the particular development environment. This is determined by the environment configuration that was set up when the project was created.
Example: {{ ref('stg_jaffle_shop_customers') }} compiles to analytics.dbt_jsmith.stg_jaffle_shop_customers.
The ref function also builds a lineage graph like the one shown below. dbt is able to determine dependencies between models and takes those into account to build models in the correct order.

Naming Conventions 
In working on this project, we established some conventions for naming our models.

Sources (src) refer to the raw table data that have been built in the warehouse through a loading process. (We will cover configuring Sources in the Sources module)
Staging (stg) refers to models that are built directly on top of sources. These have a one-to-one relationship with sources tables. These are used for very light transformations that shape the data into what you want it to be. These models are used to clean and standardize the data before transforming data downstream. Note: These are typically materialized as views.
Intermediate (int) refers to any models that exist between final fact and dimension tables. These should be built on staging models rather than directly on sources to leverage the data cleaning that was done in staging.
Fact (fct) refers to any data that represents something that occurred or is occurring. Examples include sessions, transactions, orders, stories, votes. These are typically skinny, long tables.
Dimension (dim) refers to data that represents a person, place or thing. Examples include customers, products, candidates, buildings, employees.
Note: The Fact and Dimension convention is based on previous normalized modeling techniques.
Reorganize Project
When dbt run is executed, dbt will automatically run every model in the models directory.
The subfolder structure within the models directory can be leveraged for organizing the project as the data team sees fit.
This can then be leveraged to select certain folders with dbt run and the model selector.
Example: If dbt run -s staging will run all models that exist in models/staging. (Note: This can also be applied for dbt test as well which will be covered later.)
The following framework can be a starting part for designing your own model organization:
Marts folder: All intermediate, fact, and dimension models can be stored here. Further subfolders can be used to separate data by business function (e.g. marketing, finance)
Staging folder: All staging models and source configurations can be stored here. Further subfolders can be used to separate data by data source (e.g. Stripe, Segment, Salesforce). (We will cover configuring Sources in the Sources module)