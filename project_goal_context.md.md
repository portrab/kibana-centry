# Objetivo do Projeto

## Identificação do Sistema

**Nome do sistema:** Centry

**Status:** Produção

**Repositório de código:** Repositório privado `belanit-inventario`

**Última atualização:** 2026-09-07 — Pablo Guzman, Desenvolvedor

### Ambientes

| Ambiente | URL |
|---|---|
| Desenvolvimento | Não informado |
| Homologação | Não existe / não informado |
| Produção | Não informado |

---

## Problema a Ser Resolvido

**Situação atual:** Hoje, a investigação de erros e comportamentos no Centry depende fortemente de acesso manual à consola de produção. Para analisar falhas da aplicação, é necessário executar funções diretamente na consola Rails em produção. Para erros em processos assíncronos, utiliza-se a morgue do Sidekiq. Também existe um histórico de sincronizações por produto, mas ele mostra apenas parte das respostas das APIs e não oferece detalhes suficientes sobre o que foi enviado, qual foi a resposta completa recebida e como o processo se comportou ponta a ponta.

**Causa raiz:** O sistema não possui observabilidade centralizada nem trilhas de rastreabilidade suficientes para os processos internos, workers e chamadas para APIs externas. As informações relevantes estão dispersas entre consola Rails, ambiente de produção, morgue do Sidekiq e históricos parciais de sincronização.

**Impacto:** O principal impacto recai sobre o time técnico responsável por dar suporte ao legado, especialmente Pablo Guzman, que precisa responder dúvidas sobre comportamentos, integrações e execução de workers sem contar com uma ferramenta centralizada de análise. Isso reduz a autonomia do time de suporte, que hoje não consegue investigar incidentes ou fluxos operacionais sem depender de alguém com acesso técnico à produção. Como consequência, a análise de problemas é mais lenta, mais manual e mais arriscada, além de criar gargalo no atendimento e na investigação de integrações com marketplaces.

---

## Objetivo do Projeto

**Onde devemos chegar com o projeto entregue:**

- Permitir que o time de suporte investigue comportamentos e incidentes sem necessidade de acesso à consola de produção.
- Visualizar requests e responses das integrações com marketplaces e outras plataformas em um único lugar, com contexto suficiente para análise operacional.
- Detectar falhas de workers e integrações em menos tempo, com maior rastreabilidade do que ocorre em cada processo.
- Disponibilizar métricas operacionais sobre volume e momento das requisições realizadas para os diferentes marketplaces integrados.

---

## Visão Geral do Sistema

### Propósito

Centry é um sistema legado de integração com marketplaces e plataformas de e-commerce. Seu papel é intermediar sincronizações, trocas de dados e execução de processos entre clientes e canais externos, como marketplaces, lojas e plataformas comerciais. Mesmo existindo um movimento de migração de clientes para Anymarket, o Centry continua em operação e precisa de sustentação adequada. Este projeto existe para melhorar a capacidade de observação e suporte sobre esse sistema enquanto ele seguir ativo.

### Público-Alvo e Usuários

**Perfil 1 — Desenvolvedor responsável pelo legado**  
_Descrição: profissional técnico responsável por investigar falhas, entender o comportamento da aplicação e manter o funcionamento do sistema legado._  
_O que faz e quando faz: analisa incidentes, acompanha integrações, valida execução de workers e investiga comportamentos reportados por outras áreas, principalmente quando há falhas ou dúvidas operacionais._

**Perfil 2 — Time de Suporte**  
_Descrição: equipe operacional que atende dúvidas, investiga comportamentos e acompanha problemas reportados no uso do sistema e das integrações._  
_O que faz e quando faz: consulta informações sobre processos da aplicação, busca evidências sobre falhas em sincronizações e precisa entender o que aconteceu em integrações sem depender integralmente de acesso técnico à produção._

**Perfil 3 — Product Owner**  
_Descrição: responsável por priorizar e decidir, junto ao time técnico, o que entra ou não no projeto de evolução do Centry._  
_O que faz e quando faz: define prioridades, aprova escopo e acompanha as decisões sobre investimentos no sistema legado enquanto ele continua ativo._

### Contexto de Mercado e Posicionamento

**Contexto de mercado:** O sistema atua no contexto de integração de operações de e-commerce e marketplaces, conectando clientes a canais como marketplaces chilenos e plataformas de loja virtual. Esse mercado exige confiabilidade nas sincronizações, capacidade de resposta rápida a falhas e boa visibilidade operacional sobre integrações externas.

**Posicionamento:** Centry não está sendo tratado como uma nova plataforma estratégica de crescimento, mas como um sistema legado crítico que ainda precisa operar com suporte adequado enquanto os clientes são migrados. O valor deste projeto está em dar visibilidade operacional e rastreabilidade a uma aplicação que ainda sustenta integrações importantes, reduzindo dependência de análise manual e acesso privilegiado à produção.

**Público-alvo de mercado:** O sistema atende operações de clientes que vendem em marketplaces e plataformas de e-commerce e dependem de integrações com canais como Falabella, Ripley, Mercado Libre, Shopify, Bsale, WooCommerce e Prestashop.

### Contexto de Uso pelo Cliente

Dentro da operação, o Centry funciona como camada integradora entre clientes e múltiplos canais externos, suportando sincronizações e trocas de informação via APIs. Ele se relaciona com marketplaces chilenos, como Falabella, Ripley e Mercado Libre, além de plataformas como Shopify, Bsale, WooCommerce e Prestashop, entre outras. No dia a dia, a sustentação do sistema depende de entender o que foi processado, o que foi enviado às APIs, que respostas foram recebidas e como os workers executaram cada etapa. Hoje essa análise é difícil e fragmentada, o que justifica a necessidade de uma solução de observabilidade mais adequada.

---

## Contexto de Negócio

**Sobre o negócio:** O projeto está inserido em um cenário de sustentação de sistema legado. Embora exista um movimento de migração dos clientes do Centry para Anymarket, o sistema continua relevante enquanto permanecer em operação. Portanto, o objetivo de negócio não é expandir o produto, mas reduzir o custo operacional e aumentar a capacidade de suporte, investigação e entendimento do que ocorre nas integrações ainda ativas.

**Domínio e segmento:** O sistema se insere no domínio de integrações para e-commerce e marketplaces, com foco em sincronização de dados e execução de processos entre clientes e plataformas externas.

**Processo atual (como as pessoas fazem hoje):** Quando ocorre um erro, dúvida operacional ou necessidade de entender o comportamento de uma integração, a investigação é feita manualmente por alguém com conhecimento técnico e acesso à produção. Essa pessoa consulta a consola Rails, executa funções, verifica a morgue do Sidekiq para workers com falha e analisa históricos parciais de sincronização por produto. O fluxo é lento, fragmentado e pouco acessível para o time de suporte.

**Restrições e regras de negócio relevantes:** Há preocupação com impacto em performance e com a política de retenção de logs. O projeto também deve respeitar o caráter transitório do sistema no contexto da migração para Anymarket, evitando investimentos que impliquem reestruturação ampla do produto ou mudanças em regras de negócio das sincronizações.

---

## Escopo Macro do Projeto

| # | Módulo / Epic | Prioridade |
|---|---|---|
| 1 | Centralização de logs da aplicação | Alta |
| 2 | Trazabilidade de requests e responses para marketplaces | Alta |
| 3 | Dashboards e métricas operacionais | Média |
| 4 | Busca e filtros para suporte | Alta |
| 5 | Alertas e monitoramento proativo | Média |

---

## Escopo Negativo do Projeto

| O que não será feito | Motivo |
|---|---|
| Corrigir todos os bugs existentes da aplicação | O objetivo do projeto é melhorar observabilidade e rastreabilidade, não atuar como iniciativa ampla de correção do legado. |
| Substituir o Centry | O projeto busca dar suporte melhor ao sistema atual enquanto ele continuar em operação. |
| Modificar regras de negócio das sincronizações | A iniciativa é focada em visibilidade operacional, não em alterar o comportamento funcional das integrações. |
| Conduzir a migração de clientes para Anymarket como parte desta entrega | A migração é um movimento paralelo e não faz parte do escopo desta iniciativa de observabilidade. |

---

## Pessoas e Interesses (Stakeholders)

| Nome | Empresa / Área | Papel no Projeto |
|---|---|---|
| Pablo Guzman | Desenvolvimento | Desenvolvedor responsável pelo legado e usuário principal da solução |
| Product Owner | Produto | Decisor e priorizador do projeto |
| Time de Suporte | Suporte | Área usuária da ferramenta e principal beneficiária da autonomia operacional |

---

> **Próximo passo:** com este documento preenchido e revisado, acione o `makuco-specify` referenciando este arquivo para gerar as specs de cada módulo listado no Escopo Macro.
