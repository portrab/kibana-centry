# Definición de Arquitectura

## Patrón Arquitectónico Adoptado

**Patrón:** Plugins / extensiones sobre monolito Rails

**Justificación:** Centry es hoy un monolito Rails en producción, con acoplamiento operativo a las integraciones, workers y persistencias ya existentes. Como la necesidad de este proyecto es agregar observabilidad sin reestructurar el legado ni alterar la lógica de negocio de las sincronizaciones, el enfoque dominante es extender el monolito con mecanismos de captura de logs y trazabilidad, integrando esos eventos a una plataforma externa de observabilidad. Este patrón reduce el riesgo de entrega, exige menos cambios estructurales en el sistema legado y permite una evolución incremental por puntos de extensión, preservando el ritmo viable para un sistema que ya está en sustentación y migración gradual de clientes.

---

## Cómo está Organizado el Sistema

Centry está organizado como un monolito Rails que concentra la lógica principal de la aplicación y se integra con un frontend en Vue 2, con los workers asíncronos ejecutados vía Sidekiq y con las bases PostgreSQL y MongoDB. La aplicación Rails actúa como núcleo del sistema, accediendo a una u otra base de datos según la necesidad funcional. El procesamiento asíncrono es encolado por la aplicación y consumido por instancias de Sidekiq, que ejecutan los workers relacionados con las sincronizaciones e integraciones. La solución de observabilidad se acoplará a ese flujo como una extensión del monolito, capturando eventos de Rails y Sidekiq y enviándolos, mediante archivo o cola intermedia, a una herramienta externa de consulta como Kibana o equivalente.

---

## Decisiones Arquitectónicas Importantes

| Decisión | Qué se decidió | Justificación |
|---|---|---|
| Punto de captura de eventos | Los logs de observabilidad se capturarán tanto en la aplicación Rails como en los workers ejecutados por Sidekiq. | Esto permite cubrir tanto llamadas síncronas como procesamiento asíncrono ligado a las integraciones, que son partes centrales del problema operativo actual. |
| Plataforma de observabilidad | Los logs y eventos se centralizarán fuera del monolito, en una herramienta externa de observabilidad. | La centralización externa evita depender de la consola de producción para el análisis y separa la capa de consulta operativa de la ejecución del sistema legado. |
| Interfaz de consulta | Kibana es la opción inicial de visualización y consulta, pero herramientas similares siguen permitidas si resultan más adecuadas al contexto. | El objetivo del proyecto es la capacidad de observación, no la obligatoriedad de una marca específica, manteniendo flexibilidad de implementación sin perder el rumbo de la solución. |
| Preservación de la lógica de negocio | La iniciativa no debe alterar la lógica de negocio de las sincronizaciones existentes. | El alcance del proyecto es mejorar la observabilidad y la trazabilidad, reduciendo el riesgo en un sistema legado que aún debe operar mientras ocurre la migración de clientes. |
| Tratamiento de payloads y responses grandes | Los payloads y responses muy grandes deben almacenarse de forma comprimida. | Esto ayuda a equilibrar la utilidad analítica con las restricciones de performance, volumen y retención de logs en el ambiente productivo. |
| Protección de datos sensibles | Los tokens y api_keys deben ocultarse o enmascararse antes de la persistencia de los logs. | La observabilidad no puede exponer credenciales sensibles, especialmente en una solución que amplía el acceso de consulta más allá de quienes hoy usan la consola de producción. |
| Ruta de envío hacia la plataforma externa | El envío de los logs no será directo desde la aplicación hacia la herramienta final; habrá un archivo o cola intermedia antes de la ingesta. | Esta decisión reduce el acoplamiento con la herramienta de destino y ayuda a controlar el impacto de performance en el sistema productivo. |

---

## Diagramas

**C1 — Contexto:** _Aún no existe. Debe generarse en `architecture/diagrams/c4/c1-context.png` para representar a Centry, los usuarios internos y los sistemas externos integrados._  
**C2 — Contenedores:** _Aún no existe. Debe generarse en `architecture/diagrams/c4/c2-containers.png` para representar el monolito Rails, el frontend Vue 2, Sidekiq, Redis, PostgreSQL, MongoDB y la plataforma externa de observabilidad._  
**C3 — Componentes:** _Aún no existe. Debe generarse en `architecture/diagrams/c4/c3-components.png` para mostrar los puntos de captura de logs, el flujo de encolado/archivo intermedio y la relación con las sincronizaciones e integraciones._

---

> **Recordatorio:** este documento describe la intención arquitectónica. Cuando exista divergencia entre lo que está aquí y lo que está en el código, el código debe corregirse — o este documento debe actualizarse con un ADR que justifique el cambio.
