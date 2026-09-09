# Glosario del Proyecto

## Términos del Dominio

| Término | Traducción EN | Definición | Evitar (sinónimos incorrectos) |
|---|---|---|---|
| Centry | Centry | Sistema legado de integración con marketplaces y plataformas de e-commerce utilizado para sincronizar datos entre clientes y canales externos. En el contexto de este proyecto, es la aplicación que continuará operando mientras ocurre la migración de clientes hacia Anymarket y que necesita mejor observabilidad para soporte e investigación operativa. | Tratarlo como si ya fuera Anymarket o como si fuera solo un panel administrativo. |
| Marketplace | Marketplace | Canal externo de venta u operación comercial con el que Centry se integra para enviar y recibir información. En el contexto actual, incluye principalmente marketplaces chilenos, como Falabella, Ripley y Mercado Libre, además de otras plataformas conectadas al sistema. | Usarlo como sinónimo de cualquier sistema externo sin diferenciar canal comercial de otras integraciones. |
| Integración | Integration | Conexión funcional entre Centry y un sistema externo, normalmente un marketplace o plataforma de e-commerce, mediante la cual se sincronizan datos. Una integración depende de una configuración propia por cliente y es el contexto donde se analizan requests, responses y errores operativos. | Confundir con sincronización individual o con un único request aislado. |
| Sincronización | Synchronization | Proceso mediante el cual Centry intenta enviar o actualizar información de un producto en un marketplace o canal externo. En el proyecto, la sincronización es la unidad operativa que necesita trazabilidad para entender qué se ejecutó, con qué resultado y qué requests formaron parte del proceso. | Llamar "error de sincronización" a cualquier error del producto sin vínculo con un intento real de integración. |
| Worker | Worker | Proceso asíncrono responsable de ejecutar tareas en segundo plano dentro de Centry, como etapas de integración y sincronización. En el contexto de la observabilidad, el worker es relevante porque puede estar asociado a requests específicos y también porque las fallas en workers deben monitorearse. | Tratarlo como usuario, servicio externo o sinónimo de cola. |
| Sidekiq | Sidekiq | Herramienta usada por Centry para la ejecución y gestión de workers asíncronos. Hoy ya forma parte de la operación de análisis de fallas mediante la morgue de jobs, y seguirá siendo una referencia operativa para investigar errores relacionados con el procesamiento asíncrono. | Usarlo como sinónimo de worker o como si fuera el propio proceso de negocio. |
| Request | Request | Llamada enviada por Centry hacia un marketplace o plataforma externa durante una integración o sincronización. En el alcance del proyecto, cada request debe registrarse con contexto suficiente para su análisis, incluyendo endpoint, payload, método HTTP, status de la respuesta, duración y vínculos operativos. | Llamar "log" a cualquier request sin distinguir la llamada realizada del registro que la describe. |
| Response | Response | Respuesta devuelta por un sistema externo tras un request realizado por Centry. La response es esencial para el análisis operativo porque ayuda a entender si la integración fue aceptada, rechazada o falló técnicamente, y debe almacenarse con cuidado cuando el volumen sea muy grande. | Resumir toda response solo como error sin preservar el retorno relevante del canal externo. |
| Producto | Product | Ítem perteneciente a una empresa cliente y que es sincronizado por Centry con marketplaces o plataformas externas. En el contexto de este proyecto, el producto es una de las principales claves de trazabilidad, porque el análisis deseado necesita mostrar el historial de sincronización de cada ítem con mayor detalle. | Confundir con sincronización, catálogo completo o empresa cliente. |
| company_id | company_id | Identificador interno de la empresa o cliente dentro de Centry. Es uno de los campos mínimos para la búsqueda y trazabilidad de los logs, ya que permite filtrar y analizar eventos de integración en el contexto correcto de cada cliente atendido por el sistema. | Usarlo como si identificara integración, producto o marketplace. |
| integration_config_id | integration_config_id | Identificador de la configuración de integración de una empresa con un marketplace o canal externo. Una misma empresa puede tener más de un integration_config_id, y este campo es fundamental para saber con qué conexión específica está relacionado un request o sincronización. | Confundir con company_id o tratarlo como identificador universal del cliente. |

---

## Estados y Ciclos de Vida

### Sincronización de Producto

La sincronización de producto en Centry se representa hoy mediante un estado simple que refleja el resultado del intento de sincronización. Aunque no existe un flujo rico con múltiples estados formales, hay un comportamiento operativo importante: el valor puede empezar vacío en sincronizaciones asíncronas y solo después concluirse como éxito o error.

| Estado | Descripción | Transiciones permitidas |
|---|---|---|
| Vacío / Nulo | Estado temporal de una sincronización asíncrona aún en curso o en espera de finalización del ciclo. Indica que el procesamiento se inició, pero el resultado final aún no se ha consolidado. | Puede evolucionar a True o False. |
| True | Indica que el producto se sincronizó correctamente con el canal externo, sin error en el resultado final de la operación. | Estado final; un nuevo intento futuro inicia un nuevo ciclo operativo. |
| False | Indica que hubo un intento de sincronización del producto, pero el proceso terminó con error. El problema puede estar relacionado con la integración, el payload, la respuesta del canal o el procesamiento involucrado. | Estado final; un nuevo intento futuro inicia un nuevo ciclo operativo. |

### Worker

Los workers tienen importancia operativa en el sistema, pero no se informó un ciclo de vida formal de negocio para ellos en el contexto actual. Lo que importa para este proyecto es su asociación con requests y la capacidad de identificar fallas relevantes, como workers muertos.

| Estado | Descripción | Transiciones permitidas |
|---|---|---|
| Sin ciclo formal documentado | No existe, hasta el momento, un conjunto formal de estados de negocio documentado para workers dentro del proyecto. Se tratan principalmente como elementos operativos de ejecución asíncrona. | No aplica en el contexto actual. |

---

## Relaciones Entre Términos

- Un producto puede tener muchas sincronizaciones a lo largo del tiempo.
- Una sincronización genera uno o más requests hacia marketplaces o plataformas externas.
- Un request puede ejecutarse en el contexto de un worker asíncrono.
- Un worker puede procesar sincronizaciones relacionadas con productos.
- Un company_id identifica a la empresa cliente dueña de los productos e integraciones observadas.
- Un integration_config_id identifica la configuración específica que conecta a una empresa con un marketplace.
- Una empresa puede tener más de un integration_config_id, dependiendo de la cantidad de integraciones configuradas.
- Cada response está asociada al request que originó la llamada al sistema externo.

---

## Siglas y Abreviaturas

No usamos siglas de negocio específicas en este proyecto hasta el momento.

| Sigla | Significado | Contexto de uso |
|---|---|---|
| N/A | No aplica | No hay siglas de negocio formalmente adoptadas por el equipo en este contexto. |

---

## Historial de Cambios

| Fecha | Término | Cambio | Motivo |
|---|---|---|---|
| 2026-09-07 | Sincronización | Agregado | Registrar el concepto central de trazabilidad del proyecto. |
| 2026-09-07 | integration_config_id | Agregado | Documentar el identificador necesario para el análisis de las integraciones por configuración específica. |
| 2026-09-07 | company_id | Agregado | Documentar la principal referencia de cliente usada en las búsquedas y filtros operativos. |
| 2026-09-07 | Worker | Agregado | Registrar el rol operativo de los procesos asíncronos en el contexto de la observabilidad. |
| 2026-09-07 | Request / Response | Agregado | Hacer explícitos los objetos centrales de la iniciativa de logs y trazabilidad. |
