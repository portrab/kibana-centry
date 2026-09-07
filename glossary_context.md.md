# Glossário do Projeto

## Termos do Domínio

| Termo | Tradução EN | Definição | Evitar (sinônimos incorretos) |
|---|---|---|---|
| Centry | Centry | Sistema legado de integração com marketplaces e plataformas de e-commerce utilizado para sincronizar dados entre clientes e canais externos. No contexto deste projeto, é a aplicação que continuará operando enquanto ocorre a migração de clientes para Anymarket e que precisa de melhor observabilidade para suporte e investigação operacional. | Tratar como se já fosse o Anymarket ou como se fosse apenas um painel administrativo. |
| Marketplace | Marketplace | Canal externo de venda ou operação comercial com o qual o Centry se integra para enviar e receber informações. No contexto atual, inclui principalmente marketplaces chilenos, como Falabella, Ripley e Mercado Libre, além de outras plataformas conectadas ao sistema. | Usar como sinônimo de qualquer sistema externo sem diferenciar canal comercial de outras integrações. |
| Integração | Integration | Conexão funcional entre o Centry e um sistema externo, normalmente um marketplace ou plataforma de e-commerce, por meio da qual dados são sincronizados. Uma integração depende de configuração própria por cliente e é o contexto onde requests, responses e erros operacionais são analisados. | Confundir com sincronização individual ou com um único request isolado. |
| Sincronização | Synchronization | Processo pelo qual o Centry tenta enviar ou atualizar informações de um produto em um marketplace ou canal externo. No projeto, a sincronização é a unidade operacional que precisa de rastreabilidade para entender o que foi executado, com qual resultado e quais requests fizeram parte do processo. | Chamar qualquer erro do produto de erro de sincronização sem vínculo com uma tentativa real de integração. |
| Worker | Worker | Processo assíncrono responsável por executar tarefas em segundo plano dentro do Centry, como etapas de integração e sincronização. No contexto da observabilidade, o worker é relevante porque pode estar associado a requests específicos e também porque falhas em workers precisam ser monitoradas. | Tratar como usuário, serviço externo ou sinônimo de fila. |
| Sidekiq | Sidekiq | Ferramenta usada pelo Centry para execução e gestão de workers assíncronos. Hoje ela já faz parte da operação de análise de falhas por meio da morgue de jobs, e continuará sendo uma referência operacional para investigar erros relacionados a processamento assíncrono. | Usar como sinônimo de worker ou como se fosse o próprio processo de negócio. |
| Request | Request | Chamada enviada pelo Centry para um marketplace ou plataforma externa durante uma integração ou sincronização. No escopo do projeto, cada request precisa ser registrado com contexto suficiente para análise, incluindo endpoint, payload, método HTTP, status da resposta, duração e vínculos operacionais. | Chamar de log qualquer request sem distinguir a chamada realizada do registro que a descreve. |
| Response | Response | Resposta devolvida por um sistema externo após um request feito pelo Centry. A response é essencial para análise operacional porque ajuda a entender se a integração foi aceita, rejeitada ou falhou tecnicamente, e deve ser armazenada com cuidado quando o volume for muito grande. | Resumir toda response apenas como erro sem preservar o retorno relevante do canal externo. |
| Produto | Product | Item pertencente a uma empresa cliente e que é sincronizado pelo Centry com marketplaces ou plataformas externas. No contexto deste projeto, o produto é uma das principais chaves de rastreabilidade, porque a análise desejada precisa mostrar o histórico de sincronização de cada item com mais detalhe. | Confundir com sincronização, catálogo inteiro ou empresa cliente. |
| company_id | company_id | Identificador interno da empresa ou cliente dentro do Centry. É um dos campos mínimos para busca e rastreabilidade dos logs, pois permite filtrar e analisar eventos de integração no contexto correto de cada cliente atendido pelo sistema. | Usar como se identificasse integração, produto ou marketplace. |
| integration_config_id | integration_config_id | Identificador da configuração de integração de uma empresa com um marketplace ou canal externo. Uma mesma empresa pode ter mais de um integration_config_id, e esse campo é fundamental para saber com qual conexão específica um request ou sincronização está relacionado. | Confundir com company_id ou tratar como identificador universal do cliente. |

---

## Status e Ciclos de Vida

### Sincronização de Produto

A sincronização de produto no Centry é representada hoje por um estado simples que reflete o resultado da tentativa de sincronização. Embora não exista um fluxo rico com múltiplos estados formais, há um comportamento operacional importante: o valor pode começar vazio em sincronizações assíncronas e só depois ser concluído como sucesso ou erro.

| Status | Descrição | Transições permitidas |
|---|---|---|
| Vazio / Nulo | Estado temporário de uma sincronização assíncrona ainda em andamento ou aguardando finalização do ciclo. Indica que o processamento foi iniciado, mas o resultado final ainda não foi consolidado. | Pode evoluir para True ou False. |
| True | Indica que o produto foi sincronizado corretamente com o canal externo, sem erro no resultado final da operação. | Estado final; uma nova tentativa futura inicia um novo ciclo operacional. |
| False | Indica que houve tentativa de sincronização do produto, mas o processo terminou com erro. O problema pode estar relacionado à integração, ao payload, à resposta do canal ou ao processamento envolvido. | Estado final; uma nova tentativa futura inicia um novo ciclo operacional. |

### Worker

Os workers possuem importância operacional no sistema, mas não foi informado um ciclo de vida formal de negócio para eles no contexto atual. O que importa para este projeto é sua associação com requests e a capacidade de identificar falhas relevantes, como workers mortos.

| Status | Descrição | Transições permitidas |
|---|---|---|
| Sem ciclo formal documentado | Não há, até o momento, um conjunto formal de estados de negócio documentado para workers dentro do projeto. Eles são tratados principalmente como elementos operacionais de execução assíncrona. | Não aplicável no contexto atual. |

---

## Relações Entre Termos

- Um produto pode ter muitas sincronizações ao longo do tempo.
- Uma sincronização gera um ou mais requests para marketplaces ou plataformas externas.
- Um request pode ser executado no contexto de um worker assíncrono.
- Um worker pode processar sincronizações relacionadas a produtos.
- Um company_id identifica a empresa cliente dona dos produtos e integrações observadas.
- Um integration_config_id identifica a configuração específica que conecta uma empresa a um marketplace.
- Uma empresa pode possuir mais de um integration_config_id, dependendo da quantidade de integrações configuradas.
- Cada response está associada ao request que originou a chamada ao sistema externo.

---

## Siglas e Abreviações

Não usamos siglas de negócio específicas neste projeto até o momento.

| Sigla | Significado | Contexto de uso |
|---|---|---|
| N/A | Não aplicável | Não há siglas de negócio formalmente adotadas pelo time neste contexto. |

---

## Histórico de Alterações

| Data | Termo | Alteração | Motivo |
|---|---|---|---|
| 2026-09-07 | Sincronização | Adicionado | Registrar o conceito central de rastreabilidade do projeto. |
| 2026-09-07 | integration_config_id | Adicionado | Documentar o identificador necessário para análise das integrações por configuração específica. |
| 2026-09-07 | company_id | Adicionado | Documentar a principal referência de cliente usada nas buscas e filtros operacionais. |
| 2026-09-07 | Worker | Adicionado | Registrar o papel operacional dos processos assíncronos no contexto da observabilidade. |
| 2026-09-07 | Request / Response | Adicionado | Tornar explícitos os objetos centrais da iniciativa de logs e rastreabilidade. |
