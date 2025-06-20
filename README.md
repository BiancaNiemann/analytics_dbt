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

### Understanding sources
* docs.getdbt.com/docs/build/sources

##### Sources
Sources represent the raw data that is loaded into the data warehouse.
We can reference tables in our models with an explicit table name (raw.jaffle_shop.customers).
However, setting up Sources in dbt and referring to them with the sourcefunction enables a few important tools.
Multiple tables from a single source can be configured in one place.
Sources are easily identified as green nodes in the Lineage Graph.
You can use dbt source freshness to check the freshness of raw tables.
Configuring sources
Sources are configured in YML files in the models directory.
The following code block configures the table raw.jaffle_shop.customers and raw.jaffle_shop.orders:

- Example

version: 2

sources:
  - name: jaffle_shop (name of folder inside database below)
    database: raw (where found in database)
    schema: jaffle_shop
    tables:
      - name: customers (names of tables inside folder and database above)
      - name: orders

* How to call the data using source
select 
    id as customer_id,
    first_name,
    last_name
from {{ source('jaffle_shop', 'customers') }}

Source function
The ref function is used to build dependencies between models.
Similarly, the source function is used to build the dependency of one model to a source.
Given the source configuration above, the snippet {{ source('jaffle_shop','customers') }} in a model file will compile to raw.jaffle_shop.customers.
The Lineage Graph will represent the sources in green.

### Freshness

Freshness thresholds can be set in the YML file where sources are configured. For each table, the keys loaded_at_field and freshness must be configured.

Load freshness block and loaded_at_field to the source in yml file above
can apply at schema level

freshness:
    warn_after: {count: 6, period: hour} - can also be minutes or days
    error_after: {count: 12, period: hour}
loaded_at_field: _etl_loaded_at

dbt source freshness

A threshold can be configured for giving a warning and an error with the keys warn_after and error_after.
The freshness of sources can then be determined with the command dbt source freshness.

### building tests
##### generic test
- unique
- accepted_values
- not_null
- relationships

##### singular data test

Testing
Testing is used in software engineering to make sure that the code does what we expect it to.
In Analytics Engineering, testing allows us to make sure that the SQL transformations we write produce a model that meets our assertions.
In dbt, tests are written as select statements. These select statements are run against your materialized models to ensure they meet your assertions.
Tests in dbt
In dbt, there are two types of tests - generic tests and singular tests:
Generic tests are a way to validate your data models and ensure data quality. These tests are predefined and can be applied to any column of your data models to check for common data issues. They are written in YAML files.
Singular tests are data tests defined by writing specific SQL queries that return records which fail the test conditions. These tests are referred to as "singular" because they are one-off assertions that are uniquely designed for a single purpose or specific scenario within the data models.
dbt ships with four built in tests: unique, not null, accepted values, relationships.
Unique tests to see if every value in a column is unique
Not_null tests to see if every value in a column is not null
Accepted_values tests to make sure every value in a column is equal to a value in a provided list
Relationships tests to ensure that every value in a column exists in a column in another model (see: referential integrity)
Tests can be run against your current project using a range of commands:
dbt test runs all tests in the dbt project
dbt test --select test_type:generic
dbt test --select test_type:singular
dbt test --select one_specific_model

In development, dbt Cloud will provide a visual for your test results. Each test produces a log that you can view to investigate the test results further.
In production, dbt Cloud can be scheduled to run dbt test. The ‘Run History’ tab provides a similar interface for viewing the test results.

### Documentation basics

- very important part of analytics
- often seperate to the actual code
- in same interfce in dbt in yaml files, so no seperate relationship
- documention helps level up workflow
- Answer questions on modelling or sources or other aspects of project
- Can pass on to stakeholders to help them answer questions like, where is data coming from, how is it being calculated
- can do in dbt DAG, see from ource all the way through (uses ref and source models)
- or model/source level (see grain of table)
- or document at column level (eg what does order status mean)
- add in the scema.yml file as description under model name (think about targeting audience and how the desc will help them)
- when a lot of data for description can use a doc block {%docs order_status %} and {% enddocs %} and it will link to the markdown file for the info and link with description: "{{doc('order_status')}}"
- can have multi doc blocks, just refer to correct name when connecting it to the schema

