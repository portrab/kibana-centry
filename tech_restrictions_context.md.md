# Restrições e Decisões Técnicas

## Tecnologias Proibidas

| O que não usar | Motivo | Alternativa recomendada |
|---|---|---|
| Envio síncrono de logs a partir do request principal | Pode aumentar latência da aplicação web e impactar diretamente a experiência e a estabilidade do sistema produtivo | Captura local com escrita assíncrona em arquivo ou intermediário desacoplado antes do envio à plataforma externa |
| Persistência de tokens ou api_keys em texto aberto nos logs | Expõe credenciais sensíveis em uma trilha operacional que tende a ter acesso mais amplo | Mascaramento ou sanitização dos campos sensíveis antes da persistência |
| Qualquer mecanismo de logging que bloqueie a aplicação quando houver falha de gravação | A observabilidade não pode interromper o fluxo operacional do monólito nem o processamento dos workers | Logging tolerante a falhas, com descarte controlado, buffer ou fallback assíncrono |

---

## Restrições de Ambiente

| Restrição | Descrição | Impacto no projeto |
|---|---|---|
| Stack legado em Ruby/Rails antigos | O Centry opera sobre Ruby 2.3.8 e Rails 4.2.1, o que limita bibliotecas, versões e abordagens modernas de observabilidade | A solução precisa privilegiar compatibilidade com o legado e evitar dependências que exijam upgrade de runtime ou mudanças estruturais amplas |

---

## Restrições de Segurança e Compliance

| Requisito | Descrição | Como é atendido |
|---|---|---|
| Proteção de credenciais sensíveis | Tokens e api_keys não podem ser persistidos em claro nos logs | Os dados sensíveis devem ser mascarados ou removidos antes da gravação e do envio ao sistema externo de observabilidade |

---

## Decisões Tomadas e Não Reverter

| Decisão | Contexto | Por que não reverter |
|---|---|---|
| Não alterar a lógica de negócio das sincronizações | O objetivo do projeto é adicionar observabilidade ao Centry sem interferir no comportamento funcional das integrações existentes | Reverter essa decisão ampliaria escopo, risco operacional e chance de introduzir regressões em um sistema legado ainda crítico |
| Capturar logs tanto da aplicação Rails quanto do Sidekiq | O problema de rastreabilidade envolve fluxos síncronos e assíncronos do sistema | Reverter reduziria cobertura operacional e manteria pontos cegos justamente nas rotinas de integração e processamento em background |
| Centralizar logs fora do monólito | A análise operacional não deve depender apenas do ambiente local da aplicação ou da leitura manual em produção | Reverter manteria a dificuldade atual de consulta, correlação e investigação dos eventos do sistema |
| Usar arquivo ou fila intermediária antes da ferramenta final | Foi decidido evitar envio direto do monólito para a plataforma de observabilidade | Reverter aumentaria acoplamento com a ferramenta final e elevaria o risco de impacto em performance ou indisponibilidade por falha no destino |
| Priorizar impacto mínimo em performance | O sistema está em produção e continua suportando operação real enquanto a solução é implantada | Reverter essa prioridade colocaria em risco estabilidade, latência e capacidade operacional do ambiente produtivo |
