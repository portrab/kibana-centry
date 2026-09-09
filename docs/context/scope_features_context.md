# Detalle del Alcance Macro del Proyecto

## Visión General del Producto

Centry es un sistema legado de integración con marketplaces que aún necesita operar con soporte efectivo mientras ocurre la migración de clientes hacia Anymarket. Este proyecto agrega una capa de observabilidad enfocada en requests y responses de las integraciones, para reducir la dependencia del acceso técnico a producción y mejorar la capacidad de investigación operativa. Al concluir, el equipo tendrá una visión centralizada de los logs de las integraciones, trazabilidad por producto y sincronización, mecanismos de búsqueda para soporte, alertas sobre fallas relevantes y dashboards con métricas operativas esenciales.

---

## Roadmap

| Orden | Módulo | Qué entrega al negocio |
|---|---|---|
| 1 | Centralización de logs de integraciones | Da visibilidad centralizada de las llamadas realizadas a marketplaces sin depender de la consola de producción. |
| 2 | Trazabilidad de requests/responses por producto | Permite entender el estado y el historial detallado de las sincronizaciones por producto. |
| 3 | Alertas y monitoreo operativo | Ayuda a detectar fallas críticas con mayor rapidez y reducir el tiempo de reacción. |
| 4 | Dashboards y métricas operativas | Ofrece una visión analítica sobre el volumen de llamadas, fallas y comportamiento de los workers. |

---

## Módulos y Features

---

### Módulo: Centralización de logs de integraciones

Este módulo resuelve la falta de visibilidad centralizada sobre las llamadas realizadas por Centry a los marketplaces y otras integraciones externas. Será usado principalmente por desarrollo y soporte para consultar evidencias operativas sin acceder a la consola de producción. El valor entregado es reducir la investigación manual y crear una base única de consulta sobre el comportamiento de las integraciones.

#### Feature: Recolección de logs de requests en Rails y Sidekiq

La feature debe registrar los requests realizados a marketplaces desde la aplicación Rails y también desde los workers ejecutados en Sidekiq, cubriendo todas las integraciones relevantes. El foco inicial no es capturar logs genéricos de errores internos de Rails, sino los eventos directamente ligados a las llamadas externas realizadas por el sistema. Esto diferencia la solución de una implementación genérica de logging, porque el alcance inicial está claramente restringido a la observabilidad de las integraciones con marketplaces.

#### Feature: Visualización centralizada de logs operativos

La feature debe permitir que los usuarios consulten en un único lugar los logs de las integraciones ya capturados. El uso esperado es solo de lectura: soporte y desarrollo podrán ver los registros y utilizarlos para análisis y reporte de incidentes, sin ninguna acción de corrección o reprocesamiento desde esa interfaz. El objetivo es sustituir la dependencia de la consola de producción por una visión operativa accesible y consistente.

#### Feature: Registro estructurado de datos mínimos por log

Cada log necesita almacenar un conjunto mínimo de información para que el análisis sea realmente útil en el contexto del producto: fecha, marketplace, endpoint, payload, respuesta recibida, HTTP status, worker relacionado, company_id, integration_config_id y product_id. Además, como el proyecto trata con integraciones reales, campos sensibles como tokens y api_keys no deben persistirse en texto plano. Cuando los payloads o responses sean muy grandes, el comportamiento esperado es almacenarlos de forma comprimida para equilibrar la utilidad analítica con las restricciones de performance y volumen.

---

### Módulo: Trazabilidad de requests/responses por producto

Este módulo resuelve la dificultad de entender, con detalle, qué ocurrió en la sincronización de un producto específico. Es útil para investigar incidentes operativos y esclarecer el estado de las integraciones por ítem, especialmente cuando el historial actual es insuficiente. El valor entregado es permitir una lectura contextualizada de requests y responses con vínculo a la sincronización real del producto.

#### Feature: Historial detallado de sincronización por producto

La feature debe presentar la traza de las interacciones de integración relacionadas con un producto específico, permitiendo entender en qué estado se encuentra la sincronización y qué ocurrió a lo largo del flujo. El foco no es solo la solicitud aislada, sino la lectura operativa por producto, que es la forma más útil para el contexto actual de Centry. Esto amplía el historial existente, hoy parcial, hacia una visión más confiable y accionable.

#### Feature: Relación entre request y sincronización concreta

Cada request registrado debe poder asociarse a una sincronización específica, para que la investigación no quede desconectada del proceso real del negocio. Esta asociación es importante porque el problema actual no es solo ver una llamada HTTP, sino comprender a qué sincronización afectó y en qué contexto ocurrió. Siempre que sea aplicable, la información también debe indicar el worker relacionado con el procesamiento.

#### Feature: Exhibición de detalles técnicos relevantes de la llamada

La feature debe mostrar, además de los campos mínimos ya definidos, el método HTTP y la duración de la llamada, ya que esta información ayuda a diferenciar fallas de negocio, fallas de integración y degradación de performance. El objetivo no es convertir la solución en una herramienta técnica genérica de APM, sino ofrecer datos suficientes para que soporte y desarrollo comprendan el comportamiento de las integraciones en el nivel necesario para el producto.

#### Feature: Búsqueda con filtros obligatorios para investigación

La consulta de requests y responses debe contar con filtros obligatorios para evitar búsquedas demasiado amplias y ayudar al rendimiento de la solución. Los filtros obligatorios definidos hasta ahora son: cliente, marketplace, endpoint, HTTP status, método HTTP y producto. Esta regla de uso diferencia la búsqueda de una búsqueda libre genérica, ya que refleja la necesidad operativa de encontrar rápidamente el recorte correcto sin sobrecargar el sistema.

---

### Módulo: Alertas y monitoreo operativo

Este módulo resuelve la detección tardía de fallas críticas en el comportamiento del sistema, especialmente en workers y en escenarios de alto volumen de errores. Será usado inicialmente por desarrollo y por el liderazgo funcional del proyecto para hacer seguimiento de condiciones anormales sin depender solo del análisis reactivo. El valor entregado es reducir el tiempo para percibir incidentes importantes y reaccionar con mayor rapidez.

#### Feature: Generación de alertas para workers muertos

La feature debe identificar situaciones en las que existan workers muertos y transformar ese evento en una alerta visible. Como hoy la verificación depende de una consulta manual, este recurso anticipa la percepción de problemas críticos en procesos asíncronos. El alcance de la feature es señalar el incidente, no corregirlo automáticamente.

#### Feature: Generación de alertas para alto volumen de fallas

La feature debe alertar cuando haya un volumen anormalmente alto de fallas en las integraciones monitoreadas. El objetivo es permitir que el equipo perciba degradaciones operativas de forma más rápida, especialmente en integraciones con marketplaces. Los criterios exactos de umbral aún podrán refinarse más adelante, pero el tipo de evento ya está definido como requisito de alcance.

#### Feature: Distribución de alertas en dashboard y por correo electrónico

Las alertas deben ser visibles en dashboard y, idealmente, también enviarse por correo electrónico. Los destinatarios iniciales son Pablo Guzman y el Product Owner, ya que ambos participan en las decisiones y en la respuesta operativa al sistema legado. Esto garantiza que la solución no sea solo pasiva, evitando que alguien tenga que abrir la herramienta para descubrir un problema ya en curso.

---

### Módulo: Dashboards y métricas operativas

Este módulo resuelve la falta de visión agregada sobre el comportamiento de las integraciones y de los workers de Centry. Su principal usuario es el equipo de desarrollo, que necesita ver patrones, volúmenes y fallas con menos esfuerzo analítico manual. El valor entregado es apoyar el seguimiento operativo y la priorización técnica con base en datos consolidados.

#### Feature: Dashboard de volumen de requests por marketplace

La feature debe presentar la cantidad de requests realizados por marketplace, permitiendo identificar la concentración de tráfico, picos de uso y distribución operativa entre integraciones. Esta visualización ayuda a contextualizar la carga del sistema y a interpretar mejor otras fallas observadas. El valor para el negocio está en entender la operación real del legado aún activo.

#### Feature: Dashboard de errores por endpoint

La feature debe consolidar los errores por endpoint para destacar qué integraciones o puntos específicos de la comunicación externa presentan más fallas. Esto facilita la priorización de la investigación y la identificación de comportamientos problemáticos recurrentes. En lugar de depender de una lectura caso a caso, el equipo podrá observar tendencias agregadas.

#### Feature: Dashboard de workers con más fallas

La feature debe mostrar qué workers concentran mayor número de fallas, ayudando al equipo de desarrollo a localizar las áreas más inestables de la operación asíncrona. Como los workers tienen un rol importante en la ejecución de las sincronizaciones, esta métrica conecta directamente la observabilidad técnica con la sustentación del proceso de integración. El uso es analítico y de priorización, no de gestión automática de los workers.

---

## Fuera de Alcance

> Lista lo que fue explícitamente excluido. Registrar lo que no se hará evita discusiones recurrentes y alineaciones tardías.

| Ítem excluido | Motivo |
|---|---|
| Corrección amplia de bugs de Centry | El proyecto está enfocado en observabilidad y trazabilidad, no en el saneamiento general del legado. |
| Sustitución de Centry por otra plataforma | La iniciativa existe para apoyar la sustentación del sistema actual mientras este continúe activo. |
| Migración de clientes hacia Anymarket | La migración es un movimiento paralelo y no forma parte de esta entrega. |
| Alteración de las reglas de negocio de sincronización | El objetivo es observar mejor el comportamiento actual, sin cambiar la lógica funcional de las integraciones. |
| Inclusión inmediata de logs genéricos de errores internos de Rails | En el alcance inicial, la observabilidad está limitada a los requests de las integraciones con marketplaces. |
