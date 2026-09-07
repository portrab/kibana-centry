# Stack de Tecnologia

## Linguagem e Runtime

| Item | Tecnologia | Versão | Observação |
|---|---|---|---|
| Linguagem principal | Ruby | 2.3.8 | Linguagem principal do monólito Centry |
| Runtime / Plataforma | Node.js | 14.21.3 | Usado no projeto frontend em Vue 2 |
| Gerenciador de pacotes | Bundler | 1.17.3 | Gerenciador principal do backend Rails |

---

## Frameworks e Bibliotecas Principais

| Camada | Framework / Biblioteca | Versão | Finalidade |
|---|---|---|---|
| Backend | Rails | 4.2.1 | Monólito principal da aplicação |
| Backend | GraphQL, graphql-batch, graphql-client | ~> 1.10 | Exposição e consumo da API GraphQL em `/graphql` |
| Backend | Devise | Não informado | Autenticação |
| Backend | Pundit | Não informado | Autorização |
| Backend | Draper | Não informado | Decoradores |
| Backend | RABL | Não informado | Construção de views JSON |
| Backend | Paperclip + S3 | Não informado | Gestão de anexos e armazenamento |
| Frontend | Vue | ^2.6.11 | Interface web principal |
| Frontend | Vue CLI / @vue/cli-service | ^4.1.1 | Build e execução do frontend |
| Frontend | Vuex, vue-router | ^3.1.3 / ^3.1.6 | Gerenciamento de estado e roteamento |
| Frontend | vue-apollo, @apollo/client | Não informado | Consumo da API GraphQL do Rails |
| Frontend | apollo3-cache-persist, apollo-link-timeout | Não informado | Persistência de cache e controle de timeout no cliente GraphQL |
| Frontend | bootstrap-vue, Bootstrap 4 | Não informado | Componentes e estilo de interface |
| Frontend | vue-select, vue-multiselect-listbox | Não informado | Componentes de seleção |
| Frontend | vue-sweetalert2, vue-tour, portal-vue, pretty-checkbox-vue | Não informado | Componentes auxiliares de UX/UI |
| Frontend | jexcel, xlsx, vue-xlsx, jszip, vue-html2pdf | Não informado | Exportação de planilhas, arquivos e PDFs |
| Frontend | chart.js, vue-chartjs, Cube.js | Não informado | Dashboards, gráficos e BI |
| Frontend | jquery, moment, moment-timezone, vue-recaptcha, vue-gtag, vue-tinymce-editor, vuedraggable | Não informado | Dependências legadas e funcionalidades auxiliares |
| ORM / Acesso a dados | ActiveRecord + pg | ~> 0.21 | Acesso ao PostgreSQL |
| ORM / Acesso a dados | Mongoid | 5.0 | ODM principal para acesso ao MongoDB |
| Testes | RSpec, mongoid-rspec, FactoryBot, WebMock | Não informado | Testes de backend e apoio a isolamento de dependências |
| Testes | Jest | Não informado | Testes do frontend |

---

## Banco de Dados

| Tipo | Tecnologia | Versão | Uso no sistema |
|---|---|---|---|
| Relacional | PostgreSQL | Não informado | Dados de OAuth/Doorkeeper e tabelas de suporte; base secundária |
| Relacional/Documento principal | MongoDB | Não informado | Base principal com produtos, variantes, companhias, usuários, ordens, configurações de integração e histórico de sincronização |
| Cache | Redis | Não informado | Filas do Sidekiq, locking distribuído com redis-semaphore / SafeRedisSemaphore, redis-objects e caches pontuais por variável de ambiente |
| Cache | Memcached | Não informado | Cache geral do Rails em produção (`mem_cache_store`) |
| Busca | mongoid_search | Não informado | Busca full-text dentro do MongoDB; não há Elasticsearch nem OpenSearch em uso hoje |

---

## Infraestrutura e Cloud

| Item | Tecnologia | Observação |
|---|---|---|
| Cloud provider | Oracle Cloud | Ambiente hospedado em Oracle Cloud |
| Containers | Não utiliza | Não há uso de Docker no projeto atual |
| Orquestração | Não utiliza | Não há Kubernetes nem outro orquestrador |
| CI/CD | Script + cron em produção | Instâncias de produção leem mudanças da branch `master` via cron |
| Monitoramento | Scripts operacionais + Sidekiq | Scripts em produção para revisar dados da base e escalar instâncias de Sidekiq quando necessário |

---

## Sistemas e Componentes Externos

| Sistema / Componente | Tipo | Finalidade | Como integra |
|---|---|---|---|
| Falabella | API / integração de marketplace | Sincronização operacional com marketplace | Integração via APIs do Centry |
| Ripley | API / integração de marketplace | Sincronização operacional com marketplace | Integração via APIs do Centry |
| Mercado Livre | API / integração de marketplace | Sincronização operacional com marketplace | Integração via APIs do Centry |
| Paris | API / integração de marketplace | Sincronização operacional com marketplace | Integração via APIs do Centry |
| Dafiti | API / integração de marketplace | Sincronização operacional com marketplace | Integração via APIs do Centry |
| Shopify | API / plataforma externa | Integração com e-commerce | Integração via APIs do Centry |
| Bsale | API / sistema externo | Integração comercial/operacional | Integração via APIs do Centry |
| WooCommerce | API / plataforma externa | Integração com e-commerce | Integração via APIs do Centry |
| Prestashop | API / plataforma externa | Integração com e-commerce | Integração via APIs do Centry |

---

## Ferramentas de Desenvolvimento

| Ferramenta | Finalidade |
|---|---|
| RubyMine | IDE principal |
| Postman | Testes e exploração de APIs |
