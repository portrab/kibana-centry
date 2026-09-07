# Gestão do Projeto e Ciclo de Desenvolvimento

## Plataforma de Gestão

**Plataforma:** Azure DevOps  
**URL / Acesso:** Não informado  
**Como solicitar acesso:** Através do administrador da plataforma

---

## Modelo de Organização do Trabalho

| Nível | Nome utilizado | O que representa | Exemplo |
|---|---|---|---|
| 1 — mais alto | Épica | Agrupa um objetivo maior de negócio e organiza um conjunto de features relacionadas | Observabilidade e centralização de logs do Centry |
| 2 | Feature | Agrupa entregas relacionadas dentro de uma épica até chegar ao nível implementável | Captura de logs de Rails e Sidekiq |
| 3 | PBI | Unidade principal revisada e desenvolvida pelo time de desenvolvimento | Implementar mascaramento de tokens nos logs |
| 4 — mais baixo | Não formalizado | Não foi informado um nível abaixo de PBI usado formalmente no processo | Não se aplica |

---

## Tamanho e Critérios de um PBI

**Tamanho máximo:** Um PBI deve ser concluído em no máximo 1 semana

**Um bom PBI deve:**
- Ter escopo claro para desenvolvimento dentro de um sprint
- Ser pequeno o suficiente para ser entregue em até 1 semana
- Ser revisável pelo time de desenvolvimento
- Representar uma entrega objetiva dentro da feature

**Um PBI deve ser quebrado quando:**
- Tiver 13 ou mais Story Points
- Exceder a capacidade de entrega dentro de uma semana
- Ficar grande demais para revisão e validação adequada

---

## Modelo de Desenvolvimento

**Metodologia:** Scrum

**Duração do ciclo:** Sprints

**Início do ciclo:** Não informado

---

## Cerimônias e Rituais

| Cerimônia | Frequência | Duração | Objetivo |
|---|---|---|---|
| Daily | Diária | Não informado | Indicar em que cada pessoa está trabalhando e alinhar andamento do time |
| Planning | A cada sprint | Não informado | Planejar o trabalho do ciclo |
| Refinamento | Recorrente no ciclo | Não informado | Detalhar e preparar itens futuros |
| Review | A cada sprint | Não informado | Revisar o que foi entregue |
| Retrospectiva | A cada sprint | Não informado | Identificar melhorias no processo |

---

## Fluxo de Status

| Status | Descrição | Quem move para cá |
|---|---|---|
| Nuevo | Item recém-criado | Não informado |
| Para planeamiento | Aguardando entrada em planejamento | Não informado |
| Em Planeamiento | Em planejamento | Não informado |
| Para desarrollo | Pronto para desenvolvimento | Não informado |
| En desarrollo | Em desenvolvimento | Desenvolvedor |
| Para Code Review | Desenvolvimento concluído, aguardando revisão | Desenvolvedor |
| En Code Review | Em revisão de código | Não informado |
| Para Homologación | Aguardando validação em homologação | Não informado |
| En Homologación | Em homologação | Não informado |
| Retirar WIP | Item pausado ou retirado do trabalho em andamento | Não informado |
| Para Merge Request | Aguardando merge request | Não informado |
| En Merge Request | Em merge request | Não informado |
| Monitoreo en Produción | Item em observação após publicação | Não informado |
| En Producción | Entrega já publicada em produção | Não informado |

---

## Definição de Pronto (Definition of Done)

- O item deve estar publicado em produção
- As tarefas filhas relacionadas devem estar encerradas
- Não devem existir bugs internos abertos associados à mesma tarefa

---

## Acompanhamento e Monitoramento

**Responsável pelo acompanhamento:** Product Owner

**Métricas acompanhadas:**

| Métrica | O que mede | Onde é acompanhada | Frequência |
|---|---|---|---|
| Quantidade de PBIs entregues | Volume de entregas realizadas pelo time | Azure DevOps | Por sprint |
| Quantidade de bugs criados | Incidência de problemas identificados | Azure DevOps | Por sprint |

**Reporte para stakeholders:** O andamento é reportado nas dailies, indicando em que o time está trabalhando e o status atual das atividades
