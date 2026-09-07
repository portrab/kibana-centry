# Detalhamento do Escopo Macro do Projeto

## Visão Geral do Produto

Centry é um sistema legado de integração com marketplaces que ainda precisa operar com suporte efetivo enquanto ocorre a migração de clientes para Anymarket. Este projeto adiciona uma camada de observabilidade focada em requests e responses das integrações, para reduzir a dependência de acesso técnico à produção e melhorar a capacidade de investigação operacional. Quando concluído, o time terá uma visão centralizada dos logs das integrações, rastreabilidade por produto e sincronização, mecanismos de busca para suporte, alertas sobre falhas relevantes e dashboards com métricas operacionais essenciais.

---

## Roadmap

| Ordem | Módulo | O que entrega ao negócio |
|---|---|---|
| 1 | Centralização de logs de integrações | Dá visibilidade centralizada das chamadas feitas a marketplaces sem depender de consola de produção. |
| 2 | Trazabilidade de requests/responses por produto | Permite entender o estado e o histórico detalhado das sincronizações por produto. |
| 3 | Alertas e monitoramento operacional | Ajuda a detectar falhas críticas com mais rapidez e reduzir tempo de reação. |
| 4 | Dashboards e métricas operacionais | Fornece visão analítica sobre volume de chamadas, falhas e comportamento dos workers. |

---

## Módulos e Features

---

### Módulo: Centralização de logs de integrações

Este módulo resolve a falta de visibilidade centralizada sobre as chamadas realizadas pelo Centry aos marketplaces e outras integrações externas. Ele será usado principalmente por desenvolvimento e suporte para consultar evidências operacionais sem acessar a consola de produção. O valor entregue é reduzir a investigação manual e criar uma base única de consulta para o comportamento das integrações.

#### Feature: Coleta de logs de requests em Rails e Sidekiq

A feature deve registrar os requests realizados a marketplaces a partir da aplicação Rails e também dos workers executados em Sidekiq, cobrindo todas as integrações relevantes. O foco inicial não é capturar logs genéricos de erros internos do Rails, mas sim os eventos diretamente ligados às chamadas externas feitas pelo sistema. Isso diferencia a solução de uma implementação genérica de logging, porque o escopo inicial é claramente restrito à observabilidade das integrações com marketplaces.

#### Feature: Visualização centralizada de logs operacionais

A feature deve permitir que os usuários consultem em um único lugar os logs das integrações já capturados. O uso esperado é somente leitura: suporte e desenvolvimento poderão ver os registros e utilizá-los para análise e reporte de incidentes, sem qualquer ação de correção ou reprocessamento a partir dessa interface. O objetivo é substituir a dependência da consola de produção por uma visão operacional acessível e consistente.

#### Feature: Registro estruturado de dados mínimos por log

Cada log precisa armazenar um conjunto mínimo de informações para que a análise seja realmente útil no contexto do produto: data, marketplace, endpoint, payload, resposta recebida, HTTP status, worker relacionado, company_id, integration_config_id e product_id. Além disso, como o projeto lida com integrações reais, campos sensíveis como tokens e api_keys não devem ser persistidos em claro. Quando payloads ou responses forem muito grandes, o comportamento esperado é armazená-los de forma comprimida para equilibrar utilidade analítica e restrições de performance e volume.

---

### Módulo: Trazabilidade de requests/responses por produto

Este módulo resolve a dificuldade de entender, com detalhes, o que ocorreu na sincronização de um produto específico. Ele é útil para investigar incidentes operacionais e esclarecer o estado das integrações por item, especialmente quando o histórico atual é insuficiente. O valor entregue é permitir leitura contextualizada de requests e responses com vínculo à sincronização real do produto.

#### Feature: Histórico detalhado de sincronização por produto

A feature deve apresentar a trilha das interações de integração relacionadas a um produto específico, permitindo entender em que estado a sincronização se encontra e o que ocorreu ao longo do fluxo. O foco não é apenas a requisição isolada, mas a leitura operacional por produto, que é a forma mais útil para o contexto atual do Centry. Isso amplia o histórico existente, hoje parcial, para uma visão mais confiável e acionável.

#### Feature: Relação entre request e sincronização concreta

Cada request registrado deve poder ser associado a uma sincronização específica, para que a investigação não fique desconectada do processo real do negócio. Essa associação é importante porque o problema atual não é somente ver uma chamada HTTP, mas compreender qual sincronização ela afetou e em qual contexto ocorreu. Sempre que aplicável, a informação também deve indicar o worker relacionado ao processamento.

#### Feature: Exibição de detalhes técnicos relevantes da chamada

A feature deve exibir, além dos campos mínimos já definidos, o método HTTP e a duração da chamada, pois essas informações ajudam a diferenciar falhas de negócio, falhas de integração e degradação de performance. O objetivo não é transformar a solução em uma ferramenta técnica genérica de APM, mas oferecer dados suficientes para suporte e desenvolvimento compreenderem o comportamento das integrações no nível necessário ao produto.

#### Feature: Busca com filtros obrigatórios para investigação

A consulta de requests e responses deve contar com filtros obrigatórios para evitar buscas amplas demais e ajudar na performance da solução. Os filtros obrigatórios definidos até agora são: cliente, marketplace, endpoint, HTTP status, método HTTP e produto. Essa regra de uso diferencia a busca de uma pesquisa livre genérica, pois reflete a necessidade operacional de encontrar rapidamente o recorte correto sem sobrecarregar o sistema.

---

### Módulo: Alertas e monitoramento operacional

Este módulo resolve a detecção tardia de falhas críticas no comportamento do sistema, especialmente em workers e em cenários de alto volume de erro. Ele será usado inicialmente por desenvolvimento e pela liderança funcional do projeto para acompanhar condições anormais sem depender apenas de análise reativa. O valor entregue é reduzir o tempo para perceber incidentes importantes e reagir com mais rapidez.

#### Feature: Geração de alertas para workers mortos

A feature deve identificar situações em que existam workers mortos e transformar esse evento em um alerta visível. Como hoje a verificação depende de consulta manual, esse recurso antecipa a percepção de problemas críticos em processos assíncronos. O escopo da feature é sinalizar o incidente, não corrigi-lo automaticamente.

#### Feature: Geração de alertas para alto volume de falhas

A feature deve alertar quando houver volume anormalmente alto de falhas nas integrações monitoradas. O objetivo é permitir que o time perceba degradações operacionais de forma mais rápida, especialmente em integrações com marketplaces. Os critérios exatos de limiar ainda poderão ser refinados depois, mas o tipo de evento já está definido como requisito de escopo.

#### Feature: Distribuição de alertas em dashboard e por e-mail

Os alertas precisam ser visíveis em dashboard e, idealmente, também enviados por e-mail. Os destinatários iniciais são Pablo Guzman e o Product Owner, pois ambos participam das decisões e da resposta operacional ao sistema legado. Isso garante que a solução não seja apenas passiva, exigindo que alguém abra a ferramenta para descobrir um problema já em andamento.

---

### Módulo: Dashboards e métricas operacionais

Este módulo resolve a falta de visão agregada sobre o comportamento das integrações e dos workers do Centry. Seu principal usuário é o time de desenvolvimento, que precisa enxergar padrões, volumes e falhas com menos esforço analítico manual. O valor entregue é apoiar acompanhamento operacional e priorização técnica com base em dados consolidados.

#### Feature: Dashboard de volume de requests por marketplace

A feature deve apresentar a quantidade de requests realizados por marketplace, permitindo identificar concentração de tráfego, picos de uso e distribuição operacional entre integrações. Essa visualização ajuda a contextualizar a carga do sistema e a interpretar melhor outras falhas observadas. O valor para o negócio está em entender a operação real do legado ainda ativo.

#### Feature: Dashboard de erros por endpoint

A feature deve consolidar os erros por endpoint para destacar quais integrações ou pontos específicos da comunicação externa apresentam mais falhas. Isso facilita a priorização de investigação e a identificação de comportamentos problemáticos recorrentes. Em vez de depender de leitura caso a caso, o time poderá observar tendências agregadas.

#### Feature: Dashboard de workers com mais falhas

A feature deve mostrar quais workers concentram maior número de falhas, ajudando o time de desenvolvimento a localizar áreas mais instáveis da operação assíncrona. Como os workers têm papel importante na execução das sincronizações, essa métrica conecta diretamente a observabilidade técnica à sustentação do processo de integração. O uso é analítico e de priorização, não de gestão automática dos workers.

---

## Fora do Escopo

> Liste o que foi explicitamente excluído. Registrar o que não será feito evita discussões recorrentes e alinhamentos tardios.

| Item excluído | Motivo |
|---|---|
| Correção ampla de bugs do Centry | O projeto é focado em observabilidade e rastreabilidade, não em saneamento geral do legado. |
| Substituição do Centry por outra plataforma | A iniciativa existe para apoiar a sustentação do sistema atual enquanto ele continua ativo. |
| Migração de clientes para Anymarket | A migração é um movimento paralelo e não faz parte desta entrega. |
| Alteração das regras de negócio de sincronização | O objetivo é observar melhor o comportamento atual, sem mudar a lógica funcional das integrações. |
| Inclusão imediata de logs genéricos de erros internos do Rails | No escopo inicial, a observabilidade está limitada aos requests das integrações com marketplaces. |
