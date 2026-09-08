# Guia de Integração — centry_observability

Como conectar a gem `centry_observability` (código Ruby neste repositório) à aplicação Centry (`belanit-inventario`) e à infraestrutura de observabilidade (ELK).

## 1. Adicionar a gem ao Centry

No `Gemfile` do Centry:

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

## 3. Instrumentar chamadas HTTP a marketplaces

Em cada client de integração (ex.: `FalabellaClient`, `RipleyClient`):

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

Em `config/initializers/sidekiq.rb`:

```ruby
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add CentryObservability::SidekiqServerMiddleware
  end
end
```

## 5. Subir a plataforma de observabilidade (Elasticsearch + Kibana)

```bash
cd infra
docker compose up -d

curl -X PUT "localhost:9200/_index_template/centry-integrations" \
  -H "Content-Type: application/json" \
  -d @elasticsearch/templates/centry-integrations-template.json
```

## 6. Instalar o Filebeat no host do Centry

O Centry não roda em containers, então o Filebeat deve ser instalado diretamente na VM (Oracle Cloud), apontando `infra/filebeat/filebeat.yml` para o caminho real de `log/integrations.log` e para o host do Elasticsearch (via `ELASTICSEARCH_HOST`).

## Decisões de arquitetura já refletidas no código

| Decisão | Onde está implementada |
|---|---|
| Não bloquear a aplicação em caso de falha de gravação | `LogWriter` grava em thread separada e engole exceções |
| Envio não-direto (arquivo/fila intermediária) | `LogWriter` escreve em arquivo local; Filebeat faz o envio ao Elasticsearch |
| Mascaramento de tokens/api_keys | `Sanitizer`, aplicado antes de qualquer persistência |
| Compressão de payloads/responses grandes | `PayloadCompressor` (gzip + base64) acima de `max_payload_size` |
| Captura em Rails e em Sidekiq | `RequestLogger` (chamadas HTTP) e `SidekiqServerMiddleware` (workers) |

## Próximos passos

- Cobrir os campos mínimos definidos em `scope_features_context.md` nos dashboards do Kibana (volume por marketplace, erros por endpoint, workers com mais falhas).
- Definir os filtros obrigatórios de busca (cliente, marketplace, endpoint, HTTP status, método HTTP, produto) como saved searches no Kibana.
- Avaliar critérios de alerta (workers mortos, alto volume de falhas) via Watcher/ElastAlert ou equivalente compatível com a stack.
