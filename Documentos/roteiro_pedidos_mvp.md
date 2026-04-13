# Roteiro de Pedidos para Construção do MVP

Este documento organiza a construção do MVP do sistema **Meu Remédio / MedControl** em etapas pequenas, validáveis e executáveis. A ideia é que cada pedido gere uma entrega concreta para inspeção antes de avançar para a próxima fase.

## Como usar este roteiro

- pedir uma etapa por vez
- validar visualmente e funcionalmente antes de seguir
- ajustar o que for necessário antes da próxima implementação
- manter o MVP sempre executável ao final de cada passo

## Bloco 1: Fundação do Projeto

### Passo 1. Criar a estrutura inicial do Flutter

**Objetivo**
Criar o projeto base em Flutter com organização inicial de pastas e uma tela simples de validação.

**Entregável**
- projeto Flutter criado
- estrutura inicial de diretórios
- app executando com tela `Hello World`

**Pedido sugerido**
`Criar a estrutura inicial do projeto Flutter com uma tela Hello World e organização básica de pastas para o MVP do MedControl.`

**Validação**
- o projeto compila
- o app abre corretamente
- a tela inicial aparece sem erros

### Passo 2. Definir a base visual do app

**Objetivo**
Criar tema inicial, tipografia, cores, espaçamentos e base visual voltada para acessibilidade.

**Entregável**
- tema global
- padrões de botão
- padrões de texto
- layout base com foco em legibilidade

**Pedido sugerido**
`Criar a base visual do app Flutter com tema simples, botões grandes, textos legíveis e foco em acessibilidade para idosos.`

**Validação**
- boa legibilidade
- contraste aceitável
- botões e áreas de toque adequados

### Passo 3. Criar a navegação principal

**Objetivo**
Montar a estrutura de navegação entre as áreas principais do sistema.

**Entregável**
- navegação configurada
- rotas principais criadas
- menu ou barra de navegação inicial

**Pedido sugerido**
`Criar a navegação principal do app com acesso para início, medicamentos, agendamentos, histórico, aferições e configurações.`

**Validação**
- todas as telas abrem
- a navegação é estável
- não há rotas quebradas

### Passo 4. Criar a tela inicial do sistema

**Objetivo**
Construir a home do sistema com acessos rápidos às funcionalidades principais.

**Entregável**
- tela inicial funcional
- cards ou atalhos para módulos principais
- estrutura preparada para evolução

**Pedido sugerido**
`Criar a tela inicial do sistema com atalhos para medicamentos, agendamentos, histórico, aferições e backup.`

**Validação**
- a tela inicial abre corretamente
- os atalhos navegam para as áreas certas

## Bloco 2: Persistência e Dados Base

### Passo 5. Configurar o Isar

**Objetivo**
Preparar a persistência local offline do sistema.

**Entregável**
- dependências configuradas
- banco local inicializado
- estrutura base de persistência pronta

**Pedido sugerido**
`Configurar o Isar no projeto Flutter e preparar a base de persistência local do MVP.`

**Validação**
- banco abre corretamente
- app inicia sem erro de persistência

### Passo 6. Criar o cadastro do paciente

**Objetivo**
Implementar o cadastro básico do paciente com geração do identificador interno.

**Entregável**
- formulário de paciente
- campos `nome` e `idade`
- geração automática do `idInterno`
- persistência local

**Pedido sugerido**
`Implementar o cadastro básico do paciente com nome, idade e geração automática do idInterno, salvando no Isar.`

**Validação**
- cadastro salva corretamente
- dados persistem ao reabrir o app

### Passo 7. Criar os modelos base do domínio

**Objetivo**
Modelar as entidades principais do MVP.

**Entregável**
- entidades do domínio no Flutter/Isar
- paciente
- medicamento
- agendamento de medicação
- registro de dose
- aferição de saúde
- configuração de backup

**Pedido sugerido**
`Criar os modelos base do domínio no Flutter com Isar para paciente, medicamento, agendamento, registro de dose, aferição e configuração de backup.`

**Validação**
- modelos compilam
- banco gera estrutura corretamente

## Bloco 3: Medicamentos e Agendamentos

### Passo 8. Criar o cadastro de medicamentos

**Objetivo**
Permitir criar, listar, editar e excluir medicamentos.

**Entregável**
- formulário de medicamento
- listagem de medicamentos
- edição e exclusão
- persistência local

**Pedido sugerido**
`Implementar o cadastro de medicamentos com nome, dosagem, observações, quantidade atual e quantidade mínima.`

**Validação**
- cadastro completo funciona
- edição e exclusão funcionam
- lista reflete os dados salvos

### Passo 9. Criar a tela de detalhes do medicamento

**Objetivo**
Separar a visualização detalhada do medicamento e preparar vínculo com agendamentos.

**Entregável**
- tela de detalhes
- exibição dos dados do medicamento
- acesso aos agendamentos associados

**Pedido sugerido**
`Criar a tela de detalhes do medicamento exibindo seus dados e a área de agendamentos vinculados.`

**Validação**
- o medicamento abre corretamente
- informações estão consistentes

### Passo 10. Implementar os agendamentos de medicação

**Objetivo**
Permitir criar agendamentos recorrentes.

**Entregável**
- cadastro de agendamento
- recorrência diária
- recorrência semanal
- recorrência a cada `x` dias
- múltiplos agendamentos independentes para o mesmo medicamento no mesmo dia

**Pedido sugerido**
`Implementar o cadastro de agendamentos de medicação com recorrência diária, semanal e a cada x dias, permitindo múltiplos agendamentos no mesmo dia para o mesmo medicamento.`

**Validação**
- agendamentos salvam corretamente
- recorrências aparecem corretamente
- mais de um agendamento no mesmo dia funciona

### Passo 11. Criar a agenda do dia

**Objetivo**
Exibir ao usuário as medicações previstas para o dia atual.

**Entregável**
- tela de agenda diária
- lista ordenada por horário
- status visual das doses

**Pedido sugerido**
`Criar a tela de agenda do dia mostrando os medicamentos previstos hoje com horário e status.`

**Validação**
- agenda mostra os itens corretos
- horários estão ordenados

## Bloco 4: Alertas, Confirmação e Histórico

### Passo 12. Configurar notificações locais

**Objetivo**
Integrar notificações do Android para os agendamentos.

**Entregável**
- serviço de notificação local
- disparo básico de alerta
- integração com agendamentos

**Pedido sugerido**
`Configurar notificações locais no Android e integrar com os agendamentos de medicação.`

**Validação**
- alerta dispara
- integração com o horário cadastrado funciona

### Passo 13. Implementar adiamento e confirmação de dose

**Objetivo**
Permitir interação com o alerta até o usuário confirmar a medicação.

**Entregável**
- ação de confirmar dose
- ação de adiar dose
- repetição de alerta até confirmação

**Pedido sugerido**
`Implementar a lógica de confirmação e adiamento da medicação, mantendo repetição do alerta até confirmação.`

**Validação**
- confirmar encerra a pendência
- adiar reprograma corretamente

### Passo 14. Criar o registro de doses e o histórico

**Objetivo**
Registrar todas as ações do paciente e permitir consulta posterior.

**Entregável**
- persistência de registros de dose
- tela de histórico
- filtros por período, medicamento e status

**Pedido sugerido**
`Implementar o registro de doses e a tela de histórico com filtros por período, medicamento e status.`

**Validação**
- histórico mostra dados corretos
- filtros funcionam

### Passo 15. Implementar o controle de estoque

**Objetivo**
Controlar automaticamente a quantidade do medicamento.

**Entregável**
- baixa automática ao confirmar dose
- alerta de estoque mínimo
- exibição do estado de estoque

**Pedido sugerido**
`Implementar o controle de estoque com baixa automática por dose confirmada e alerta quando a quantidade mínima for atingida.`

**Validação**
- quantidade reduz corretamente
- alerta de estoque baixo aparece

## Bloco 5: Aferições de Saúde

### Passo 16. Criar o cadastro de aferições

**Objetivo**
Permitir registrar pressão, saturação e glicemia.

**Entregável**
- formulário de aferição
- lançamento individual ou conjunto
- persistência local

**Pedido sugerido**
`Implementar o cadastro de aferições permitindo registrar pressão, saturação e glicemia separadamente ou no mesmo lançamento.`

**Validação**
- registros salvam corretamente
- campos opcionais funcionam como esperado

### Passo 17. Criar a listagem e consulta de aferições

**Objetivo**
Permitir visualizar o histórico de aferições por período.

**Entregável**
- lista de aferições
- filtros por período
- visualização organizada

**Pedido sugerido**
`Criar a tela de consulta de aferições com filtro por período e visualização organizada dos registros.`

**Validação**
- filtros retornam corretamente
- histórico é legível

### Passo 18. Criar relatórios e gráficos de evolução

**Objetivo**
Apresentar acompanhamento visual das aferições.

**Entregável**
- relatórios resumidos
- gráficos de evolução
- visualização por indicador

**Pedido sugerido**
`Implementar relatórios e gráficos de evolução para pressão, saturação e glicemia no app Flutter.`

**Validação**
- gráficos carregam corretamente
- dados batem com os registros

## Bloco 6: Backup e Restauração

### Passo 19. Criar a tela de configuração de backup

**Objetivo**
Permitir informar o endereço da API.

**Entregável**
- tela de configuração
- campo para URL base da API
- persistência local da configuração

**Pedido sugerido**
`Criar a tela de configuração de backup com campo para definir e salvar o endereço da API FastAPI.`

**Validação**
- endereço é salvo corretamente
- valor persiste no app

### Passo 20. Implementar backup manual

**Objetivo**
Enviar snapshot dos dados locais para a API.

**Entregável**
- cliente HTTP
- serialização dos dados
- envio manual do backup

**Pedido sugerido**
`Implementar o backup manual enviando os dados locais do app para a API FastAPI.`

**Validação**
- envio ocorre sem erro
- resposta da API é tratada

### Passo 21. Implementar restauração

**Objetivo**
Recuperar dados da API para o dispositivo.

**Entregável**
- leitura do backup remoto
- confirmação do usuário em caso de conflito
- restauração local dos dados

**Pedido sugerido**
`Implementar a restauração de backup no app, com confirmação do usuário quando houver conflito entre dados locais e remotos.`

**Validação**
- restauração traz dados corretamente
- conflitos exigem confirmação

## Bloco 7: Refinamento do MVP

### Passo 22. Revisar acessibilidade e UX

**Objetivo**
Melhorar usabilidade para o público idoso.

**Entregável**
- melhorias de legibilidade
- melhorias de fluxo
- estados vazios e mensagens adequadas

**Pedido sugerido**
`Revisar a interface do app com foco em acessibilidade para idosos, melhorando legibilidade, contraste e clareza das ações.`

**Validação**
- navegação mais clara
- telas mais fáceis de entender

### Passo 23. Revisar arquitetura e organização do código

**Objetivo**
Organizar a base para continuidade do projeto.

**Entregável**
- refino de estrutura
- separação melhor de camadas
- limpeza de código

**Pedido sugerido**
`Revisar a organização do código do MVP, melhorando separação de camadas, nomes e estrutura de pastas.`

**Validação**
- código mais limpo
- módulos mais claros

### Passo 24. Fechar o MVP validável

**Objetivo**
Concluir uma versão mínima pronta para demonstração.

**Entregável**
- MVP funcional
- fluxo principal validado
- correções finais

**Pedido sugerido**
`Fazer uma revisão final do MVP, corrigindo problemas restantes e deixando a versão pronta para demonstração.`

**Validação**
- fluxo principal completo funciona
- app está estável para apresentação

## Sugestão de Ordem de Pedidos

Se quiser seguir de forma bem prática, esta é a ordem recomendada:

1. estrutura inicial Flutter
2. base visual
3. navegação principal
4. tela inicial
5. configuração do Isar
6. cadastro do paciente
7. modelos base
8. cadastro de medicamento
9. tela de detalhes do medicamento
10. agendamentos
11. agenda do dia
12. notificações locais
13. adiamento e confirmação
14. histórico
15. estoque
16. cadastro de aferições
17. consulta de aferições
18. relatórios e gráficos
19. configuração de backup
20. backup manual
21. restauração
22. acessibilidade e UX
23. revisão de arquitetura
24. fechamento do MVP

## Estratégia Recomendada

A melhor dinâmica é:

- pedir um passo
- validar
- ajustar se necessário
- só então seguir para o próximo

Assim o MVP cresce de forma controlada, visível e com menos retrabalho.
