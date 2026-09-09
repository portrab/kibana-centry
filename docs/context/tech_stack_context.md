# Stack de Tecnología

## Lenguaje y Runtime

| Ítem | Tecnología | Versión | Observación |
|---|---|---|---|
| Lenguaje principal | Ruby | 2.3.8 | Lenguaje principal del monolito Centry |
| Runtime / Plataforma | Node.js | 14.21.3 | Usado en el proyecto frontend en Vue 2 |
| Gestor de paquetes | Bundler | 1.17.3 | Gestor principal del backend Rails |

---

## Frameworks y Bibliotecas Principales

| Capa | Framework / Biblioteca | Versión | Finalidad |
|---|---|---|---|
| Backend | Rails | 4.2.1 | Monolito principal de la aplicación |
| Backend | GraphQL, graphql-batch, graphql-client | ~> 1.10 | Exposición y consumo de la API GraphQL en `/graphql` |
| Backend | Devise | No informado | Autenticación |
| Backend | Pundit | No informado | Autorización |
| Backend | Draper | No informado | Decoradores |
| Backend | RABL | No informado | Construcción de vistas JSON |
| Backend | Paperclip + S3 | No informado | Gestión de adjuntos y almacenamiento |
| Frontend | Vue | ^2.6.11 | Interfaz web principal |
| Frontend | Vue CLI / @vue/cli-service | ^4.1.1 | Build y ejecución del frontend |
| Frontend | Vuex, vue-router | ^3.1.3 / ^3.1.6 | Gestión de estado y enrutamiento |
| Frontend | vue-apollo, @apollo/client | No informado | Consumo de la API GraphQL de Rails |
| Frontend | apollo3-cache-persist, apollo-link-timeout | No informado | Persistencia de caché y control de timeout en el cliente GraphQL |
| Frontend | bootstrap-vue, Bootstrap 4 | No informado | Componentes y estilo de interfaz |
| Frontend | vue-select, vue-multiselect-listbox | No informado | Componentes de selección |
| Frontend | vue-sweetalert2, vue-tour, portal-vue, pretty-checkbox-vue | No informado | Componentes auxiliares de UX/UI |
| Frontend | jexcel, xlsx, vue-xlsx, jszip, vue-html2pdf | No informado | Exportación de planillas, archivos y PDFs |
| Frontend | chart.js, vue-chartjs, Cube.js | No informado | Dashboards, gráficos y BI |
| Frontend | jquery, moment, moment-timezone, vue-recaptcha, vue-gtag, vue-tinymce-editor, vuedraggable | No informado | Dependencias legadas y funcionalidades auxiliares |
| ORM / Acceso a datos | ActiveRecord + pg | ~> 0.21 | Acceso a PostgreSQL |
| ORM / Acceso a datos | Mongoid | 5.0 | ODM principal para acceso a MongoDB |
| Pruebas | RSpec, mongoid-rspec, FactoryBot, WebMock | No informado | Pruebas de backend y apoyo al aislamiento de dependencias |
| Pruebas | Jest | No informado | Pruebas del frontend |

---

## Base de Datos

| Tipo | Tecnología | Versión | Uso en el sistema |
|---|---|---|---|
| Relacional | PostgreSQL | No informado | Datos de OAuth/Doorkeeper y tablas de soporte; base secundaria |
| Relacional/Documento principal | MongoDB | No informado | Base principal con productos, variantes, compañías, usuarios, órdenes, configuraciones de integración e historial de sincronización |
| Caché | Redis | No informado | Colas de Sidekiq, locking distribuido con redis-semaphore / SafeRedisSemaphore, redis-objects y cachés puntuales por variable de ambiente |
| Caché | Memcached | No informado | Caché general de Rails en producción (`mem_cache_store`) |
| Búsqueda | mongoid_search | No informado | Búsqueda full-text dentro de MongoDB; no hay Elasticsearch ni OpenSearch en uso hoy |

---

## Infraestructura y Cloud

| Ítem | Tecnología | Observación |
|---|---|---|
| Proveedor de cloud | Oracle Cloud | Ambiente alojado en Oracle Cloud |
| Contenedores | No utiliza | No hay uso de Docker en el proyecto actual |
| Orquestación | No utiliza | No hay Kubernetes ni otro orquestador |
| CI/CD | Script + cron en producción | Las instancias de producción leen cambios de la rama `master` vía cron |
| Monitoreo | Scripts operativos + Sidekiq | Scripts en producción para revisar datos de la base y escalar instancias de Sidekiq cuando sea necesario |

---

## Sistemas y Componentes Externos

| Sistema / Componente | Tipo | Finalidad | Cómo integra |
|---|---|---|---|
| Falabella | API / integración de marketplace | Sincronización operativa con marketplace | Integración vía APIs de Centry |
| Ripley | API / integración de marketplace | Sincronización operativa con marketplace | Integración vía APIs de Centry |
| Mercado Libre | API / integración de marketplace | Sincronización operativa con marketplace | Integración vía APIs de Centry |
| Paris | API / integración de marketplace | Sincronización operativa con marketplace | Integración vía APIs de Centry |
| Dafiti | API / integración de marketplace | Sincronización operativa con marketplace | Integración vía APIs de Centry |
| Shopify | API / plataforma externa | Integración con e-commerce | Integración vía APIs de Centry |
| Bsale | API / sistema externo | Integración comercial/operativa | Integración vía APIs de Centry |
| WooCommerce | API / plataforma externa | Integración con e-commerce | Integración vía APIs de Centry |
| Prestashop | API / plataforma externa | Integración con e-commerce | Integración vía APIs de Centry |

---

## Herramientas de Desarrollo

| Herramienta | Finalidad |
|---|---|
| RubyMine | IDE principal |
| Postman | Pruebas y exploración de APIs |
