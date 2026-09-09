# kibana-centry

Observabilidad y trazabilidad de las integraciones de **Centry** (sistema legado de integración con marketplaces) — captura de requests/responses de Rails y Sidekiq, centralizada fuera del monolito para consulta vía Kibana o herramienta equivalente.

Este repositorio contiene la gem `centry_observability` — el código que se agregará al monolito Centry (`belanit-inventario`) para capturar y sanitizar esos eventos — y la infraestructura (Elasticsearch + Kibana + Filebeat) que los recibe.

## Estructura

```
docs/context/               Documentos de discovery (objetivo, arquitectura, stack, alcance, restricciones, glosario, gestión)
docs/integration-guide.md   Cómo conectar la gem a Centry y levantar la stack de observabilidad
architecture/diagrams/c4/   Diagramas C4 (C1 Contexto, C2 Contenedores, C3 Componentes) — aún no generados
lib/centry_observability/   Gem Ruby: saneamiento, compresión, escritura asíncrona, instrumentación Rails/Sidekiq
spec/                        Pruebas RSpec de la gem
infra/                       docker-compose (Elasticsearch + Kibana), config de Filebeat y template de índice
```

## Documentos de contexto

| Documento | Contenido |
|---|---|
| [project_goal_context.md](docs/context/project_goal_context.md) | Problema, objetivo, público objetivo, alcance macro y negativo |
| [architecture_definition_context.md](docs/context/architecture_definition_context.md) | Patrón arquitectónico, organización del sistema, decisiones, diagramas C4 |
| [tech_stack_context.md](docs/context/tech_stack_context.md) | Lenguajes, frameworks, bases de datos, infraestructura y sistemas externos |
| [scope_features_context.md](docs/context/scope_features_context.md) | Roadmap, módulos y features detalladas, fuera de alcance |
| [tech_restrictions_context.md](docs/context/tech_restrictions_context.md) | Tecnologías prohibidas, restricciones de ambiente/seguridad, decisiones irreversibles |
| [glossary_context.md](docs/context/glossary_context.md) | Términos de dominio, ciclos de vida, relaciones entre entidades |
| [project_management_context.md](docs/context/project_management_context.md) | Plataforma de gestión, modelo de trabajo, ceremonias, flujo de estados |

## Sistema de referencia

**Centry** es un monolito Rails (4.2.1 / Ruby 2.3.8) con frontend Vue 2, workers en Sidekiq, PostgreSQL y MongoDB, alojado en Oracle Cloud. Continúa en operación mientras ocurre la migración de clientes hacia Anymarket. Ver [project_goal_context.md](docs/context/project_goal_context.md) para el detalle completo.

## Ejecutando las pruebas de la gem

```bash
bundle install
bundle exec rspec
```

## Levantando la stack de observabilidad

Ver [docs/integration-guide.md](docs/integration-guide.md) para el paso a paso completo (levantar Elasticsearch/Kibana, cargar el template de índice, instalar Filebeat en el host de Centry e instrumentar los clients de integración y los workers Sidekiq).

## Próximos pasos

- Generar las specs (PRD y tech spec) de cada módulo listado en el Alcance Macro en [scope_features_context.md](docs/context/scope_features_context.md).
- Construir los dashboards de Kibana (volumen por marketplace, errores por endpoint, workers con más fallas).
- Definir los criterios de alerta (workers muertos, alto volumen de fallas).
