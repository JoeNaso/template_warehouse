help: ## Show this
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

profile: ## Copy the profiles.yml template ot the place that DBT expects it to be
	mkdir -p ~/.dbt
	cp data_warehouse/profiles.yml ~/.dbt/
