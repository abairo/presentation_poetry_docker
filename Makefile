build:
	docker-compose -f docker-compose.local.yaml build

up:
	docker-compose -f docker-compose.local.yaml up --force-recreate

down:
	docker-compose -f docker-compose.local.yaml down 

volumes-prune:
	docker volume prune -f

migrate:
	docker-compose -f docker-compose.local.yaml run --rm --entrypoint="" web python src/manage.py migrate

makemigrations:
	docker-compose -f docker-compose.local.yaml run --rm --entrypoint="" web python src/manage.py makemigrations

run:
	docker-compose -f docker-compose.local.yaml run --rm --entrypoint="" --service-ports web python src/manage.py $(cmd) 

migrations:
	docker-compose -f docker-compose.local.yaml run --rm --entrypoint="" web python src/manage.py makemigrations

migrate:
	docker-compose -f docker-compose.local.yaml run --rm --entrypoint="" web python src/manage.py migrate

loaddata:
	docker-compose -f docker-compose.local.yaml run --rm --entrypoint="" web python src/manage.py loaddata fixtures/dev/*.json

dumpdata:
	docker-compose -f docker-compose.local.yaml run --entrypoint="" --rm web python src/manage.py dumpdata --indent 4 $(cmd)

shell:
	docker-compose -f docker-compose.local.yaml run --rm --entrypoint="" web python src/manage.py shell

pytest:
	docker-compose -f docker-compose.local.yaml run --rm --entrypoint="" web poetry run pytest src/app_messages/tests.py --cov-report=html

bash:
	docker-compose -f docker-compose.local.yaml run --rm --entrypoint="" web bash