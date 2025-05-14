# Globals
.PHONY: help up down
.DEFAULT: help
.ONESHELL:
.SILENT:
SHELL=/bin/bash
.SHELLFLAGS = -ceo pipefail

# Colours for Help Message and INFO formatting
YELLOW := "\e[1;33m"
NC := "\e[0m"
INFO := @bash -c 'printf $(YELLOW); echo "=> $$0"; printf $(NC)'

# Targets
UP = Docker Compose UP - Detached Mode
DOWN = Docker Compose DOWN - Volumes Removed
DB_DVDRENTAL = Setup DB dvdrental from .tar
DB_EXERCISES = Setup DB exercises from .tar

export 

help:
	$(INFO) "Run: make <TARGET>"
	$(INFO) "List of Supported Targets:"
	@echo
	@echo -e "\tup:           $$UP"
	@echo -e "\tdown:         $$DOWN"
	@echo -e "\tdb/dvdrental: $$DB_DVDRENTAL"
	@echo -e "\tdb/exercises: $$DB_EXERCISES"	
	@echo

up:
	$(INFO) "$$UP"
	docker-compose up -d

down:
	$(INFO) "$$DOWN"
	docker-compose down -v

db/dvdrental:
	$(INFO) "$$DB_DVDRENTAL"
	docker cp data/dvdrental.tar local_pgdb:/
	docker exec local_pgdb /bin/bash -c "psql -U postgres -c 'CREATE DATABASE dvdrental;'"
	docker exec local_pgdb /bin/bash -c "pg_restore --clean --verbose -U postgres -d dvdrental ./dvdrental.tar 2>>/dev/null; echo dvdrental restored"

db/exercises:
	$(INFO) "$$DB_DVDRENTAL"
	docker cp data/exercises.tar local_pgdb:/
	docker exec local_pgdb /bin/bash -c "psql -U postgres -c 'CREATE DATABASE exercises;'"
	docker exec local_pgdb /bin/bash -c "pg_restore --clean --verbose -U postgres -d exercises ./exercises.tar 2>>/dev/null; echo exercises restored"
