## Potential Model Folder structure
Below outlines a useful project structure that mimics the setup of a traditional software app with internal APIs 
You will find some comments at the top of the example files in this repo
```
models/
    intermediate/
        origin/
            salesforce/
                account.sql
                opportunity.sql
            app_prod/
            hubspot/
            google_analytics/
            ...etc
        transformed/
            salesforce/
                account_xf.sql
                opportunity_xf.sql
                ...etc
            app_prod/
            hubspot/
            google_analytics/
            ...etc

    marts/
        common/
            dim_date.sql
            dim_numbers.sql
            ...etc
        marketing/
        revenue/
        customers/
        ...etc
    
    sources/
        salesforce/
            account_src.sql
            opportunity_src.sql
        app_prod/
        hubspot/
        google_analytics/
        ...etc
```
This is a hierarchical structure that presents data sources, modified/ transformed and "business-ready" data in separate places. 

`sources` - A single folder per data originator. Salesforce, Hubspot, Production App, etc. Rename and cast types here. 

`intermediate/origin/` - The lowest level of models that anyone interacting with the warehouse should ever use. Going a level lower will take to you to the raw, source tables. Origin models should reflect the system they're coming from while also being usable. Including simple logical fields for convenience makes sense here - ie. `is_customer`, `is_complete`, etc

`intermediate/transformed/` - These are highly processed tables that have foreign keys out to the relevant Origin models. These usually are categorical by source

`marts` - The highest level tables that are exposed to end users via BI tool or direct querying by analysts, etc. These are broken out by category to make it easier to understand what business unit/ function they relate to, as well as to identify groups of tables that are useful together. 