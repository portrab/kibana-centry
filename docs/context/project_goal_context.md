# Objetivo del Proyecto

## Identificación del Sistema

**Nombre del sistema:** Centry

**Estado:** Producción

**Repositorio de código:** Repositorio privado `belanit-inventario`

**Última actualización:** 2026-09-07 — Pablo Guzman, Desarrollador

### Ambientes

| Ambiente | URL |
|---|---|
| Desarrollo | No informado |
| Homologación | No existe / no informado |
| Producción | No informado |

---

## Problema a Resolver

**Situación actual:** Hoy, la investigación de errores y comportamientos en Centry depende fuertemente del acceso manual a la consola de producción. Para analizar fallas de la aplicación, es necesario ejecutar funciones directamente en la consola Rails en producción. Para errores en procesos asíncronos, se utiliza la morgue de Sidekiq. También existe un historial de sincronizaciones por producto, pero muestra solo parte de las respuestas de las APIs y no ofrece detalles suficientes sobre qué se envió, cuál fue la respuesta completa recibida y cómo se comportó el proceso de punta a punta.

**Causa raíz:** El sistema no posee observabilidad centralizada ni trazas de trazabilidad suficientes para los procesos internos, workers y llamadas a APIs externas. La información relevante está dispersa entre la consola Rails, el ambiente de producción, la morgue de Sidekiq y los historiales parciales de sincronización.

**Impacto:** El principal impacto recae sobre el equipo técnico responsable de dar soporte al legado, especialmente Pablo Guzman, quien necesita responder dudas sobre comportamientos, integraciones y ejecución de workers sin contar con una herramienta centralizada de análisis. Esto reduce la autonomía del equipo de soporte, que hoy no puede investigar incidentes o flujos operativos sin depender de alguien con acceso técnico a producción. Como consecuencia, el análisis de problemas es más lento, más manual y más riesgoso, además de generar un cuello de botella en la atención y en la investigación de integraciones con marketplaces.

---

## Objetivo del Proyecto

**A dónde debemos llegar con el proyecto entregado:**

- Permitir que el equipo de soporte investigue comportamientos e incidentes sin necesidad de acceso a la consola de producción.
- Visualizar requests y responses de las integraciones con marketplaces y otras plataformas en un único lugar, con contexto suficiente para el análisis operativo.
- Detectar fallas de workers e integraciones en menos tiempo, con mayor trazabilidad de lo que ocurre en cada proceso.
- Disponer de métricas operativas sobre el volumen y el momento de las solicitudes realizadas hacia los distintos marketplaces integrados.

---

## Visión General del Sistema

### Propósito

Centry es un sistema legado de integración con marketplaces y plataformas de e-commerce. Su rol es intermediar sincronizaciones, intercambios de datos y ejecución de procesos entre clientes y canales externos, como marketplaces, tiendas y plataformas comerciales. Aun existiendo un movimiento de migración de clientes hacia Anymarket, Centry continúa en operación y necesita una sustentación adecuada. Este proyecto existe para mejorar la capacidad de observación y soporte sobre ese sistema mientras siga activo.

### Público Objetivo y Usuarios

**Perfil 1 — Desarrollador responsable del legado**  
_Descripción: profesional técnico responsable de investigar fallas, entender el comportamiento de la aplicación y mantener el funcionamiento del sistema legado._  
_Qué hace y cuándo lo hace: analiza incidentes, hace seguimiento de integraciones, valida la ejecución de workers e investiga comportamientos reportados por otras áreas, principalmente cuando hay fallas o dudas operativas._

**Perfil 2 — Equipo de Soporte**  
_Descripción: equipo operativo que atiende dudas, investiga comportamientos y hace seguimiento de problemas reportados en el uso del sistema y de las integraciones._  
_Qué hace y cuándo lo hace: consulta información sobre los procesos de la aplicación, busca evidencias sobre fallas en sincronizaciones y necesita entender qué ocurrió en las integraciones sin depender por completo del acceso técnico a producción._

**Perfil 3 — Product Owner**  
_Descripción: responsable de priorizar y decidir, junto al equipo técnico, qué entra o no en el proyecto de evolución de Centry._  
_Qué hace y cuándo lo hace: define prioridades, aprueba el alcance y hace seguimiento de las decisiones sobre inversiones en el sistema legado mientras este continúa activo._

### Contexto de Mercado y Posicionamiento

**Contexto de mercado:** El sistema opera en el contexto de integración de operaciones de e-commerce y marketplaces, conectando clientes con canales como marketplaces chilenos y plataformas de tienda virtual. Este mercado exige confiabilidad en las sincronizaciones, capacidad de respuesta rápida ante fallas y buena visibilidad operativa sobre las integraciones externas.

**Posicionamiento:** Centry no se está tratando como una nueva plataforma estratégica de crecimiento, sino como un sistema legado crítico que aún necesita operar con soporte adecuado mientras los clientes son migrados. El valor de este proyecto está en dar visibilidad operativa y trazabilidad a una aplicación que aún sostiene integraciones importantes, reduciendo la dependencia del análisis manual y del acceso privilegiado a producción.

**Público objetivo de mercado:** El sistema atiende operaciones de clientes que venden en marketplaces y plataformas de e-commerce y dependen de integraciones con canales como Falabella, Ripley, Mercado Libre, Shopify, Bsale, WooCommerce y Prestashop.

### Contexto de Uso por el Cliente

Dentro de la operación, Centry funciona como una capa integradora entre clientes y múltiples canales externos, dando soporte a sincronizaciones e intercambios de información vía APIs. Se relaciona con marketplaces chilenos, como Falabella, Ripley y Mercado Libre, además de plataformas como Shopify, Bsale, WooCommerce y Prestashop, entre otras. En el día a día, la sustentación del sistema depende de entender qué se procesó, qué se envió a las APIs, qué respuestas se recibieron y cómo ejecutaron los workers cada etapa. Hoy ese análisis es difícil y fragmentado, lo que justifica la necesidad de una solución de observabilidad más adecuada.

---

## Contexto de Negocio

**Sobre el negocio:** El proyecto se inserta en un escenario de sustentación de sistema legado. Aunque existe un movimiento de migración de los clientes de Centry hacia Anymarket, el sistema sigue siendo relevante mientras permanezca en operación. Por lo tanto, el objetivo de negocio no es expandir el producto, sino reducir el costo operativo y aumentar la capacidad de soporte, investigación y entendimiento de lo que ocurre en las integraciones aún activas.

**Dominio y segmento:** El sistema se inserta en el dominio de integraciones para e-commerce y marketplaces, con foco en la sincronización de datos y la ejecución de procesos entre clientes y plataformas externas.

**Proceso actual (cómo lo hacen hoy):** Cuando ocurre un error, una duda operativa o la necesidad de entender el comportamiento de una integración, la investigación se realiza manualmente por alguien con conocimiento técnico y acceso a producción. Esa persona consulta la consola Rails, ejecuta funciones, revisa la morgue de Sidekiq en busca de workers con falla y analiza los historiales parciales de sincronización por producto. El flujo es lento, fragmentado y poco accesible para el equipo de soporte.

**Restricciones y reglas de negocio relevantes:** Existe preocupación por el impacto en el rendimiento y por la política de retención de logs. El proyecto también debe respetar el carácter transitorio del sistema en el contexto de la migración hacia Anymarket, evitando inversiones que impliquen una reestructuración amplia del producto o cambios en las reglas de negocio de las sincronizaciones.

---

## Alcance Macro del Proyecto

| # | Módulo / Épica | Prioridad |
|---|---|---|
| 1 | Centralización de logs de la aplicación | Alta |
| 2 | Trazabilidad de requests y responses hacia marketplaces | Alta |
| 3 | Dashboards y métricas operativas | Media |
| 4 | Búsqueda y filtros para soporte | Alta |
| 5 | Alertas y monitoreo proactivo | Media |

---

## Alcance Negativo del Proyecto

| Qué no se hará | Motivo |
|---|---|
| Corregir todos los bugs existentes de la aplicación | El objetivo del proyecto es mejorar la observabilidad y la trazabilidad, no actuar como una iniciativa amplia de corrección del legado. |
| Reemplazar Centry | El proyecto busca dar mejor soporte al sistema actual mientras este continúe en operación. |
| Modificar reglas de negocio de las sincronizaciones | La iniciativa está enfocada en la visibilidad operativa, no en alterar el comportamiento funcional de las integraciones. |
| Llevar adelante la migración de clientes hacia Anymarket como parte de esta entrega | La migración es un movimiento paralelo y no forma parte del alcance de esta iniciativa de observabilidad. |

---

## Personas e Intereses (Stakeholders)

| Nombre | Empresa / Área | Rol en el Proyecto |
|---|---|---|
| Pablo Guzman | Desarrollo | Desarrollador responsable del legado y usuario principal de la solución |
| Product Owner | Producto | Decisor y priorizador del proyecto |
| Equipo de Soporte | Soporte | Área usuaria de la herramienta y principal beneficiaria de la autonomía operativa |

---

> **Próximo paso:** con este documento completado y revisado, invoca `makuco-specify` referenciando este archivo para generar las specs de cada módulo listado en el Alcance Macro.
