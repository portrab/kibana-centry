# kibana-centry

Observabilidade e rastreabilidade das integrações do **Centry** (sistema legado de integração com marketplaces) — captura de requests/responses de Rails e Sidekiq, centralizada fora do monólito para consulta via Kibana ou ferramenta equivalente.

Este repositório ainda está na fase de discovery. Nenhum código de implementação foi gerado até o momento — apenas a estrutura organizacional do projeto e os documentos de contexto que orientarão as próximas fases (specs por módulo, arquitetura detalhada e implementação).

## Estrutura

```
docs/context/       Documentos de discovery (objetivo, arquitetura, stack, escopo, restrições, glossário, gestão)
architecture/diagrams/c4/   Diagramas C4 (C1 Contexto, C2 Containers, C3 Componentes) — ainda não gerados
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

## Próximos passos

Com a estrutura de discovery organizada, o próximo passo é gerar as specs (PRD e tech spec) de cada módulo listado no Escopo Macro em [scope_features_context.md](docs/context/scope_features_context.md).
