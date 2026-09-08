# kibana-centry

Observabilidade e rastreabilidade das integrações do **Centry** (sistema legado de integração com marketplaces) — captura de requests/responses de Rails e Sidekiq, centralizada fora do monólito para consulta via Kibana ou ferramenta equivalente.

Este repositório contém a gem `centry_observability` — o código que será adicionado ao monólito Centry (`belanit-inventario`) para capturar e sanitizar esses eventos — e a infraestrutura (Elasticsearch + Kibana + Filebeat) que os recebe.

## Estrutura

```
docs/context/               Documentos de discovery (objetivo, arquitetura, stack, escopo, restrições, glossário, gestão)
docs/integration-guide.md   Como plugar a gem no Centry e subir a stack de observabilidade
architecture/diagrams/c4/   Diagramas C4 (C1 Contexto, C2 Containers, C3 Componentes) — ainda não gerados
lib/centry_observability/   Gem Ruby: sanitização, compressão, escrita assíncrona, instrumentação Rails/Sidekiq
spec/                        Testes RSpec da gem
infra/                       docker-compose (Elasticsearch + Kibana), config do Filebeat e template de índice
```

## Documentos de contexto

| Documento | Conteúdo |
|---|---|
| [project_goal_context.md](docs/context/project_goal_context.md) | Problema, objetivo, público-alvo, escopo macro e negativo |
| [architecture_definition_context.md](docs/context/architecture_definition_context.md) | Padrão arquitetural, organização do sistema, decisões, diagramas C4 |
| [tech_stack_context.md](docs/context/tech_stack_context.md) | Linguagens, frameworks, bancos de dados, infraestrutura e sistemas externos |
| [scope_features_context.md](docs/context/scope_features_context.md) | Roadmap, módulos e features detalhadas, fora do escopo |
| [tech_restrictions_context.md](docs/context/tech_restrictions_context.md) | Tecnologias proibidas, restrições de ambiente/segurança, decisões irreversíveis |
| [glossary_context.md](docs/context/glossary_context.md) | Termos de domínio, ciclos de vida, relações entre entidades |
| [project_management_context.md](docs/context/project_management_context.md) | Plataforma de gestão, modelo de trabalho, cerimônias, fluxo de status |

## Sistema de referência

**Centry** é um monólito Rails (4.2.1 / Ruby 2.3.8) com frontend Vue 2, workers em Sidekiq, PostgreSQL e MongoDB, hospedado em Oracle Cloud. Continua em operação enquanto ocorre a migração de clientes para Anymarket. Ver [project_goal_context.md](docs/context/project_goal_context.md) para o detalhamento completo.

## Rodando os testes da gem

```bash
bundle install
bundle exec rspec
```

## Subindo a stack de observabilidade

Ver [docs/integration-guide.md](docs/integration-guide.md) para o passo a passo completo (subir Elasticsearch/Kibana, carregar o template de índice, instalar o Filebeat no host do Centry e instrumentar os clients de integração e os workers Sidekiq).

## Próximos passos

- Gerar as specs (PRD e tech spec) de cada módulo listado no Escopo Macro em [scope_features_context.md](docs/context/scope_features_context.md).
- Construir os dashboards do Kibana (volume por marketplace, erros por endpoint, workers com mais falhas).
- Definir os critérios de alerta (workers mortos, alto volume de falhas).
