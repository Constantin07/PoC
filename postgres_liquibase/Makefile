
POSTGRES_USER ?= migration
POSTGRES_PASSWORD ?= migration
POSTGRES_HOST ?= localhost
POSTGRES_DB ?= test

IMAGE = liquibase/liquibase:4.5.0
OPTIONS = --rm --network=host -v `pwd`/changelog:/liquibase/changelog:rw -e JAVA_OPTS="-DLiquibaseHubMode=off"

# Common config
CONFIG = \
--driver=org.postgresql.Driver \
--url="jdbc:postgresql://${POSTGRES_HOST}:5432/${POSTGRES_DB}" \
--username=${POSTGRES_USER} \
--password=${POSTGRES_PASSWORD}

.PHONY: update gen-changelog snapshot history validate

update:
	@docker run ${OPTIONS} ${IMAGE} ${CONFIG} \
	--changeLogFile=changelog.xml update

gen-changelog:
	@docker run ${OPTIONS} ${IMAGE} ${CONFIG} \
	--changeLogFile=/liquibase/changelog/dbchangelog.xml generateChangeLog

snapshot:
	@docker run ${OPTIONS} ${IMAGE} ${CONFIG} snapshot

history:
	@docker run ${OPTIONS} ${IMAGE} ${CONFIG} history

validate:
	@docker run ${OPTIONS} ${IMAGE} ${CONFIG} \
	--changeLogFile=changelog.xml --logLevel=info validate

status:
	@docker run ${OPTIONS} ${IMAGE} ${CONFIG} \
	--changeLogFile=changelog.xml status

sync:
	@docker run ${OPTIONS} ${IMAGE} ${CONFIG} \
	--changeLogFile=changelog.xml changelogSync

clear:
	@docker run ${OPTIONS} ${IMAGE} ${CONFIG} \
	--changeLogFile=changelog.xml clearCheckSums
