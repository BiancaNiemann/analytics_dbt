
#### Tables
- Built as tables in the database
- Data is stored on disk
- Slower to build
- Faster to query
- Configure in dbt_project.yml or with the following config block
{{ config(
    materialized='table'
)}}

#### Views
- Built as views in the database
- Query is stored on disk
- Faster to build
- Slower to query
- Configure in dbt_project.yml or with the following config block
{{ config(
    materialized='view'
)}}

#### Ephemeral Models
- Does not exist in the database
- Imported as CTE into downstream models
- Increases build time of downstream models
- Cannot query directly
- Ephemeral Documentation
-Configure in dbt_project.yml or with the following config block
{{ config(
    materialized='ephemeral'
)}}

#### Where to configure
- In the project file

name: my_project
version: 1.0.0
config-version: 2

models:
  my_project:
    events:
      # materialize all models in models/events as tables
      +materialized: table
    csvs:
      # this is redundant, and does not need to be set
      +materialized: view

- in the model file
{{ config(materialized='table', sort='timestamp', dist='user_id') }}

select *
from ...

- In the property file
version: 2

models:
  - name: events
    config:
      materialized: table