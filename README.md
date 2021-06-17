# Deterministics builds with Poetry and Docker Development


### Poetry - Python packaging and dependency management

https://python-poetry.org/

**PEP 517/518**: Traz especificações sobre como um pacotes python devem especificar e buildar suas dependências. 

Arquivo único para gerenciamento de pacotes e dependência (**TOML**)
Utiliza um arquivo no formato toml que pode ser utilizado por outros gerenciadores.

**Autoatualização:**
Poetry permite sua auto atualização/gerenciamento de versões
#
##### DEPENDENCY RESOLVER
Poetry comes with an exhaustive dependency resolver, which will always find a solution if it exists.
#
##### ISOLATION
Poetry either uses your configured virtualenvs or creates its own to always be isolated from your system.
#
##### INTUITIVE CLI
Poetry's commands are intuitive and easy to use, with sensible defaults while still being configurable.
#
##### Libraries:
Very powerful for build and publishing (public and private repository). Read the docs.
#
##### Security 
Use package hash
example:
```
13ce7b0871122719fd1199a7293ebd4753689142382480697e9e0c4ff45a8a6a  requests-2.25.0.tar.gz
```
#
##### VERSION CONSTRAINTS  
#
##### Caret requirements
#
| Requirements   |      Versions Allowed      |
|----------|:-------------:|
|^1.2.3|>=1.2.3 <2.0.0|
|^1.2|>=1.2.0 <2.0.0|
|^1|>=1.0.0 <2.0.0|
|^0.2.3|>=0.2.3 <0.3.0|
|^0.0.3|>=0.0.3 <0.0.4|
|^0.0|	>=0.0.0 <0.1.0|
|^0|	>=0.0.0 <1.0.0|
#
##### Tilde requirements
#
| Requirements   |      Versions Allowed      |
|----------|:-------------:|
|~1.2.3|	>=1.2.3 <1.3.0|
|~1.2|	>=1.2.0 <1.3.0|
|~1|	>=1.0.0 <2.0.0|
#
##### Wildcard requirements
#
| Requirements   |      Versions Allowed      |
|----------|:-------------:|
|*|>=0.0.0|
|1.*|>=1.0.0 <2.0.0|
|1.2.*|>=1.2.0 <1.3.0|
##### Inequality requirements
#
```
>= 1.2.0
> 1
< 2
!= 1.2.3
```

## Comandos úteis:

#### Iniciar projeto
#
```
poetry new nome_projeto
```
ou para inicializar gerenciamento com poetry em projetos já existentes
```
poetry init
```

#### Instalar dependências de um projeto já inicializado com poetry
#
```
poetry install
```
ou sem as dependências de desenvolvimento
```
poetry install --no-dev
```
ou para remover dependências que não estão presentes no .lock
```
poetry install --remove-untracked
```

#### Adicionar Pacotes
```
poetry add requests
poetry add pendulum@^2.0.5
poetry add "pendulum>=2.0.5"
poetry add pendulum@latest
poetry add git+https://github.com/sdispater/pendulum.git
poetry add git+ssh://git@github.com/sdispater/pendulum.git
poetry add git+https://github.com/sdispater/pendulum.git#develop
poetry add git+https://github.com/sdispater/pendulum.git#2.0.5
poetry add ./my-package/
poetry add ../my-package/dist/my-package-0.1.0.tar.gz
poetry add ../my-package/dist/my_package-0.1.0.whl
poetry add requests[security,socks]
poetry add "requests[security,socks]~=2.22.0"
poetry add "git+https://github.com/pallets/flask.git@1.1.1[dotenv,dev]"
```
#
#### Atualizando dependências (toml and .lock)
#
```
poetry update
poetry update requests rows
```
#
#### Rastreamento de dependências
#
```bash
poetry show --tree

beautifulsoup4 4.9.3 Screen-scraping library
└── soupsieve >1.2
eventlet 0.30.2 Highly concurrent networking library
├── dnspython >=1.15.0,<2.0.0
├── greenlet >=0.3
└── six >=1.10.0
```
```
poetry show --no-dev
ou
poetry show --latest
```

#### Configurações
```bash
poetry config --list
cache-dir = "/home/abairo/.cache/pypoetry"
experimental.new-installer = true
installer.parallel = true
virtualenvs.create = true
virtualenvs.in-project = null
virtualenvs.path = "{cache-dir}/virtualenvs"  # /home/abairo/.cache/pypoetry/virtualenvs
```
#
#### Rodar scripts com poetry
#
```
poetry run python -V
```

#### Travar dependências sem instalar
#
```
poetry lock
```
### Exportar para outros formatos
```
poetry export -f requirements.txt --output requirements.txt
```
### Produção
```
pip install --require-hashes -r requirements.txt
```
#
# Development with Docker S2
#
#### Twelve-Factor App
#
#### #1 Base de Código
Uma base de código com rastreamento utilizando controle de revisão, muitos deploys
# #2 Dependências
Declare e isole as dependências. Pip, Poetry... Pipenv (evite esse)
# #3 Configurações
Armazene as configurações no ambiente (env vars)
#### #4 Serviços de Apoio
Trate os serviços de apoio, como recursos ligados. (bds, proxys, ...)
#### #5 Construa, lance, execute
Separe estritamente os builds e execute em estágios
#### #6 Processos
Execute a aplicação como um ou mais processos que não armazenam estado
#### #7 Vínculo de porta
Exporte serviços por ligação de porta
#### #8 Concorrência
Dimensione por um modelo de processo
#### #9 Descartabilidade
Maximizar a robustez com inicialização e desligamento rápido
# #10 Dev/prod semelhantes
Mantenha o desenvolvimento, teste, produção o mais semelhante possível
#### #11 Logs
Trate logs como fluxo de eventos
#### #12 Processos de Admin
Executar tarefas de administração/gerenciamento como processos pontuais
#
#### Makefile
#
Boas práticas: Ao escrever um Makefile respeite ao máximo as "apis/interfaces" externas como docker (build, run, prune, ...), poetry (update, add, ...) e etc...
ex.:
 ```bash
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
 ```
 