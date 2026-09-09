# Guía de Integración — centry_observability

Cómo conectar la gem `centry_observability` (código Ruby en este repositorio) a la aplicación Centry (`belanit-inventario`) y a la infraestructura de observabilidad (ELK).

## 1. Agregar la gem a Centry

En el `Gemfile` de Centry:

```ruby
gem "centry_observability", git: "git@github.com:portrab/kibana-centry.git"
```

## 2. Configurar

`config/initializers/centry_observability.rb`:

```ruby
CentryObservability.configure do |config|
  config.log_path = Rails.root.join("log", "integrations.log").to_s
  config.enabled = !Rails.env.test?
end
```

## 3. Instrumentar llamadas HTTP a marketplaces

En cada client de integración (ej.: `FalabellaClient`, `RipleyClient`):

```ruby
context = {
  marketplace: "falabella",
  endpoint: url,
  http_method: "POST",
  company_id: company.id,
  integration_config_id: integration_config.id,
  product_id: product.id,
  payload: request_body
}

response = CentryObservability.request_logger.track(context) do
  resp = HTTPClient.post(url, request_body, headers)
  context[:http_status] = resp.status
  context[:response_body] = resp.body
  resp
end
```

## 4. Instrumentar workers Sidekiq

En `config/initializers/sidekiq.rb`:

```ruby
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add CentryObservability::SidekiqServerMiddleware
  end
end
```

## 5. Levantar la plataforma de observabilidad (Elasticsearch + Kibana)

```bash
cd infra
docker compose up -d

curl -X PUT "localhost:9200/_index_template/centry-integrations" \
  -H "Content-Type: application/json" \
  -d @elasticsearch/templates/centry-integrations-template.json
```

## 6. Instalar Filebeat en el host de Centry

Centry no corre en contenedores, por lo que Filebeat debe instalarse directamente en la VM (Oracle Cloud), apuntando `infra/filebeat/filebeat.yml` a la ruta real de `log/integrations.log` y al host de Elasticsearch (vía `ELASTICSEARCH_HOST`).

## Decisiones de arquitectura ya reflejadas en el código

| Decisión | Dónde está implementada |
|---|---|
| No bloquear la aplicación en caso de falla de escritura | `LogWriter` escribe en un thread separado y captura las excepciones |
| Envío no directo (archivo/cola intermedia) | `LogWriter` escribe en un archivo local; Filebeat hace el envío a Elasticsearch |
| Enmascaramiento de tokens/api_keys | `Sanitizer`, aplicado antes de cualquier persistencia |
| Compresión de payloads/responses grandes | `PayloadCompressor` (gzip + base64) por encima de `max_payload_size` |
| Captura en Rails y en Sidekiq | `RequestLogger` (llamadas HTTP) y `SidekiqServerMiddleware` (workers) |

## Próximos pasos

- Cubrir los campos mínimos definidos en `scope_features_context.md` en los dashboards de Kibana (volumen por marketplace, errores por endpoint, workers con más fallas).
- Definir los filtros obligatorios de búsqueda (cliente, marketplace, endpoint, HTTP status, método HTTP, producto) como saved searches en Kibana.
- Evaluar criterios de alerta (workers muertos, alto volumen de fallas) vía Watcher/ElastAlert o equivalente compatible con la stack.
