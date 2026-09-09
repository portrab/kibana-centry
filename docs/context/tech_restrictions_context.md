# Restricciones y Decisiones Técnicas

## Tecnologías Prohibidas

| Qué no usar | Motivo | Alternativa recomendada |
|---|---|---|
| Envío síncrono de logs desde el request principal | Puede aumentar la latencia de la aplicación web e impactar directamente en la experiencia y la estabilidad del sistema productivo | Captura local con escritura asíncrona en archivo o intermediario desacoplado antes del envío a la plataforma externa |
| Persistencia de tokens o api_keys en texto plano en los logs | Expone credenciales sensibles en una traza operativa que tiende a tener un acceso más amplio | Enmascaramiento o saneamiento de los campos sensibles antes de la persistencia |
| Cualquier mecanismo de logging que bloquee la aplicación cuando falle la escritura | La observabilidad no puede interrumpir el flujo operativo del monolito ni el procesamiento de los workers | Logging tolerante a fallas, con descarte controlado, buffer o fallback asíncrono |

---

## Restricciones de Ambiente

| Restricción | Descripción | Impacto en el proyecto |
|---|---|---|
| Stack legado en Ruby/Rails antiguos | Centry opera sobre Ruby 2.3.8 y Rails 4.2.1, lo que limita bibliotecas, versiones y enfoques modernos de observabilidad | La solución debe priorizar la compatibilidad con el legado y evitar dependencias que exijan actualizar el runtime o cambios estructurales amplios |

---

## Restricciones de Seguridad y Compliance

| Requisito | Descripción | Cómo se cumple |
|---|---|---|
| Protección de credenciales sensibles | Los tokens y api_keys no pueden persistirse en texto plano en los logs | Los datos sensibles deben enmascararse o eliminarse antes de la escritura y del envío al sistema externo de observabilidad |

---

## Decisiones Tomadas y No Revertir

| Decisión | Contexto | Por qué no revertir |
|---|---|---|
| No alterar la lógica de negocio de las sincronizaciones | El objetivo del proyecto es agregar observabilidad a Centry sin interferir en el comportamiento funcional de las integraciones existentes | Revertir esta decisión ampliaría el alcance, el riesgo operativo y la probabilidad de introducir regresiones en un sistema legado aún crítico |
| Capturar logs tanto de la aplicación Rails como de Sidekiq | El problema de trazabilidad involucra flujos síncronos y asíncronos del sistema | Revertir reduciría la cobertura operativa y mantendría puntos ciegos justamente en las rutinas de integración y procesamiento en segundo plano |
| Centralizar los logs fuera del monolito | El análisis operativo no debe depender únicamente del ambiente local de la aplicación ni de la lectura manual en producción | Revertir mantendría la dificultad actual de consulta, correlación e investigación de los eventos del sistema |
| Usar archivo o cola intermedia antes de la herramienta final | Se decidió evitar el envío directo desde el monolito hacia la plataforma de observabilidad | Revertir aumentaría el acoplamiento con la herramienta final y elevaría el riesgo de impacto en performance o indisponibilidad por falla en el destino |
| Priorizar el impacto mínimo en performance | El sistema está en producción y continúa soportando operación real mientras se implementa la solución | Revertir esta prioridad pondría en riesgo la estabilidad, la latencia y la capacidad operativa del ambiente productivo |
