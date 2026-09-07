# Definição de Arquitetura

## Padrão Arquitetural Adotado

**Padrão:** Plugins / extensões sobre monólito Rails

**Justificativa:** O Centry é hoje um monólito Rails em produção, com acoplamento operacional às integrações, workers e persistências já existentes. Como a necessidade deste projeto é adicionar observabilidade sem reestruturar o legado nem alterar a lógica de negócio das sincronizações, a abordagem dominante é estender o monólito com mecanismos de captura de logs e rastreabilidade, integrando esses eventos a uma plataforma externa de observabilidade. Esse padrão reduz risco de entrega, exige menos mudanças estruturais no sistema legado e permite evolução incremental por pontos de extensão, preservando o ritmo viável para um sistema que já está em sustentação e migração gradual de clientes.

---

## Como o Sistema está Organizado

O Centry é organizado como um monólito Rails que concentra a lógica principal da aplicação e se integra a um frontend em Vue 2, aos workers assíncronos executados via Sidekiq e às bases PostgreSQL e MongoDB. A aplicação Rails atua como núcleo do sistema, acessando uma ou outra base de dados conforme a necessidade funcional. O processamento assíncrono é enfileirado pela aplicação e consumido por instâncias de Sidekiq, que executam os workers relacionados às sincronizações e integrações. A solução de observabilidade será acoplada a esse fluxo como extensão do monólito, capturando eventos de Rails e Sidekiq e encaminhando-os, por meio de arquivo ou fila intermediária, para uma ferramenta externa de consulta como Kibana ou equivalente.

---

## Decisões Arquiteturais Importantes

| Decisão | O que foi decidido | Justificativa |
|---|---|---|
| Ponto de captura de eventos | Os logs de observabilidade serão capturados tanto na aplicação Rails quanto nos workers executados pelo Sidekiq. | Isso permite cobrir tanto chamadas síncronas quanto processamento assíncrono ligado às integrações, que são partes centrais do problema operacional atual. |
| Plataforma de observabilidade | Os logs e eventos serão centralizados fora do monólito, em uma ferramenta externa de observabilidade. | A centralização externa evita depender da consola de produção para análise e separa a camada de consulta operacional da execução do sistema legado. |
| Interface de consulta | Kibana é a opção inicial de visualização e consulta, mas ferramentas similares continuam permitidas se se mostrarem mais adequadas ao contexto. | O objetivo do projeto é a capacidade de observação, não a obrigatoriedade de uma marca específica, mantendo flexibilidade de implementação sem perder o direcionamento da solução. |
| Preservação da lógica de negócio | A iniciativa não deve alterar a lógica de negócio das sincronizações existentes. | O escopo do projeto é melhorar observabilidade e rastreabilidade, reduzindo risco em um sistema legado que ainda precisa operar enquanto ocorre migração de clientes. |
| Tratamento de payloads e responses grandes | Payloads e responses muito grandes devem ser armazenados de forma comprimida. | Isso ajuda a equilibrar utilidade analítica com restrições de performance, volume e retenção de logs no ambiente produtivo. |
| Proteção de dados sensíveis | Tokens e api_keys devem ser ocultados ou mascarados antes da persistência dos logs. | A observabilidade não pode expor credenciais sensíveis, especialmente em uma solução que amplia o acesso de consulta para além de quem hoje usa a consola de produção. |
| Caminho de envio para a plataforma externa | O envio dos logs não será direto da aplicação para a ferramenta final; haverá um arquivo ou fila intermediária antes da ingestão. | Essa decisão reduz acoplamento com a ferramenta de destino e ajuda a controlar impacto de performance no sistema produtivo. |

---

## Diagramas

**C1 — Contexto:** _Ainda não existe. Deve ser gerado em `architecture/diagrams/c4/c1-context.png` para representar o Centry, os usuários internos e os sistemas externos integrados._  
**C2 — Containers:** _Ainda não existe. Deve ser gerado em `architecture/diagrams/c4/c2-containers.png` para representar o monólito Rails, frontend Vue 2, Sidekiq, Redis, PostgreSQL, MongoDB e a plataforma externa de observabilidade._  
**C3 — Componentes:** _Ainda não existe. Deve ser gerado em `architecture/diagrams/c4/c3-components.png` para mostrar os pontos de captura de logs, o fluxo de enfileiramento/arquivo intermediário e a relação com sincronizações e integrações._

---

> **Lembrete:** este documento descreve a intenção arquitetural. Quando houver divergência entre o que está aqui e o que está no código, o código deve ser corrigido — ou este documento deve ser atualizado com um ADR justificando a mudança.
