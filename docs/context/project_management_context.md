# Gestión del Proyecto y Ciclo de Desarrollo

## Plataforma de Gestión

**Plataforma:** Azure DevOps  
**URL / Acceso:** Pendiente de confirmación con el administrador de la plataforma (ver [Información Pendiente de Confirmación](#información-pendiente-de-confirmación))  
**Cómo solicitar acceso:** A través del administrador de la plataforma

---

## Modelo de Organización del Trabajo

| Nivel | Nombre utilizado | Qué representa | Ejemplo |
|---|---|---|---|
| 1 — más alto | Épica | Agrupa un objetivo mayor de negocio y organiza un conjunto de features relacionadas | Observabilidad y centralización de logs de Centry |
| 2 | Feature | Agrupa entregas relacionadas dentro de una épica hasta llegar al nivel implementable | Captura de logs de Rails y Sidekiq |
| 3 | PBI | Unidad principal revisada y desarrollada por el equipo de desarrollo | Implementar enmascaramiento de tokens en los logs |
| 4 — más bajo | No formalizado | No se informó un nivel por debajo de PBI usado formalmente en el proceso | No aplica |

---

## Tamaño y Criterios de un PBI

**Tamaño máximo:** Un PBI debe completarse en máximo 1 semana

**Un buen PBI debe:**
- Tener un alcance claro para desarrollo dentro de un sprint
- Ser lo suficientemente pequeño para entregarse en hasta 1 semana
- Ser revisable por el equipo de desarrollo
- Representar una entrega objetiva dentro de la feature

**Un PBI debe dividirse cuando:**
- Tenga 13 o más Story Points
- Exceda la capacidad de entrega dentro de una semana
- Sea demasiado grande para una revisión y validación adecuadas

---

## Modelo de Desarrollo

**Metodología:** Scrum

**Duración del ciclo:** Sprints (la duración en semanas y la fecha de inicio del ciclo actual aún no fueron confirmadas con el equipo — ver [Información Pendiente de Confirmación](#información-pendiente-de-confirmación))

---

## Ceremonias y Rituales

| Ceremonia | Frecuencia | Duración | Objetivo |
|---|---|---|---|
| Daily | Diaria | A confirmar* | Indicar en qué está trabajando cada persona y alinear el avance del equipo |
| Planning | Cada sprint | A confirmar* | Planificar el trabajo del ciclo |
| Refinamiento | Recurrente en el ciclo | A confirmar* | Detallar y preparar ítems futuros |
| Review | Cada sprint | A confirmar* | Revisar lo que fue entregado |
| Retrospectiva | Cada sprint | A confirmar* | Identificar mejoras en el proceso |

_\* Duraciones aún no confirmadas con el equipo — ver [Información Pendiente de Confirmación](#información-pendiente-de-confirmación)._

---

## Flujo de Estados

> **Nota sobre los nombres:** los estados de abajo se reproducen tal como están configurados en el board de Azure DevOps. No traducir estos valores en specs, código o queries — deben usarse exactamente como aparecen en la herramienta.

| Estado (nombre en ADO) | Descripción | Quién lo mueve hasta aquí |
|---|---|---|
| Nuevo | Ítem recién creado | A confirmar* |
| Para planeamiento | Esperando entrada en planificación | A confirmar* |
| En Planeamiento | En planificación | A confirmar* |
| Para desarrollo | Listo para desarrollo | A confirmar* |
| En desarrollo | En desarrollo | Desarrollador |
| Para Code Review | Desarrollo concluido, esperando revisión | Desarrollador |
| En Code Review | En revisión de código | A confirmar* |
| Para Homologación | Esperando validación en homologación | A confirmar* |
| En Homologación | En homologación | A confirmar* |
| Retirar WIP | Ítem pausado o retirado del trabajo en curso | A confirmar* |
| Para Merge Request | Esperando merge request | A confirmar* |
| En Merge Request | En merge request | A confirmar* |
| Monitoreo en Producción | Ítem en observación tras la publicación | A confirmar* |
| En Producción | Entrega ya publicada en producción | A confirmar* |

_\* Responsable de la transición aún no confirmado con el equipo, excepto los dos estados ya validados (Desarrollador) — ver [Información Pendiente de Confirmación](#información-pendiente-de-confirmación)._

---

## Definición de Terminado (Definition of Done)

- El ítem debe estar publicado en producción
- Las tareas hijas relacionadas deben estar cerradas
- No deben existir bugs internos abiertos asociados a la misma tarea

---

## Seguimiento y Monitoreo

**Responsable del seguimiento:** Product Owner

**Métricas monitoreadas:**

| Métrica | Qué mide | Dónde se monitorea | Frecuencia |
|---|---|---|---|
| Cantidad de PBIs entregados | Volumen de entregas realizadas por el equipo | Azure DevOps | Por sprint |
| Cantidad de bugs creados | Incidencia de problemas identificados | Azure DevOps | Por sprint |

**Reporte a stakeholders:** El avance se reporta en las dailies, indicando en qué está trabajando el equipo y el estado actual de las actividades

---

## Información Pendiente de Confirmación

Las brechas a continuación se listan en un solo lugar para dejar explícito qué ya se conoce frente a lo que aún depende de validación con el equipo o con el administrador de la plataforma. Ningún dato fue inferido o presumido — hasta que se confirmen, no deben usarse como referencia en decisiones de proceso.

| Ítem | Dónde aparece en el documento | Confirmar con |
|---|---|---|
| URL / forma de acceso a Azure DevOps | Plataforma de Gestión | Administrador de la plataforma |
| Fecha de inicio del sprint actual | Modelo de Desarrollo | Product Owner / Scrum Master |
| Duración de cada ceremonia (Daily, Planning, Refinamiento, Review, Retrospectiva) | Ceremonias y Rituales | Scrum Master / equipo |
| Responsable de la transición de los estados no asignados a "Desarrollador" (11 de los 13 estados del flujo) | Flujo de Estados | Equipo / Product Owner |
