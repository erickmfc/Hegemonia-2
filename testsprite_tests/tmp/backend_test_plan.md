# Plano de Testes Backend - Hegemonia Global

## 1. Visão Geral dos Testes Backend

### 1.1 Objetivo
Testar toda a lógica de negócio, sistemas de dados e funcionalidades core do jogo Hegemonia Global, garantindo estabilidade e correção dos sistemas internos.

### 1.2 Escopo
- Sistemas de dados e estruturas
- Lógica de negócio
- Algoritmos de pathfinding
- Sistemas de combate
- Gerenciamento de recursos
- Estados do jogo

## 2. Categorias de Teste

### 2.1 Testes de Sistema de Dados

#### 2.1.1 Gerenciamento de Recursos
- **Teste**: Validação do sistema de recursos
- **Critérios**:
  - Inicialização correta de todos os recursos
  - Cálculos de produção/consumo
  - Validação de limites mínimos/máximos
  - Persistência de dados
- **Arquivos**: `objects/obj_resource_manager/`, `objects/obj_game_manager/Create_0.gml`

#### 2.1.2 Estruturas de Dados
- **Teste**: Validação de estruturas de dados
- **Critérios**:
  - Criação correta de ds_maps
  - Operações de adição/remoção
  - Limpeza de memória
  - Integridade dos dados
- **Arquivos**: `objects/obj_game_manager/Create_0.gml` (linhas 57-88)

#### 2.1.3 Sistema de Grid
- **Teste**: Validação do sistema de grid
- **Critérios**:
  - Criação correta do grid
  - Mapeamento de coordenadas
  - Validação de posições
  - Atualização de estados
- **Arquivos**: `objects/obj_game_manager/Create_0.gml` (linhas 194-212)

### 2.2 Testes de Lógica de Negócio

#### 2.2.1 Sistema de Construção
- **Teste**: Lógica de construção de edifícios
- **Critérios**:
  - Validação de posicionamento
  - Verificação de recursos necessários
  - Cálculo de custos
  - Atualização de estado do grid
- **Arquivos**: `objects/obj_controlador_construcao/`, `objects/obj_build_manager/`

#### 2.2.2 Sistema de Pesquisa
- **Teste**: Lógica do sistema de pesquisa
- **Critérios**:
  - Validação de tecnologias disponíveis
  - Cálculo de tempo de pesquisa
  - Desbloqueio de novas tecnologias
  - Gerenciamento de slots
- **Arquivos**: `objects/obj_research_center/`

#### 2.2.3 Sistema de Recrutamento
- **Teste**: Lógica de recrutamento de unidades
- **Critérios**:
  - Validação de recursos necessários
  - Cálculo de tempo de recrutamento
  - Criação de unidades
  - Atualização de população
- **Arquivos**: `objects/obj_menu_recrutamento/`, `objects/obj_quartel/`

### 2.3 Testes de Algoritmos

#### 2.3.1 Sistema de Pathfinding
- **Teste**: Algoritmo de pathfinding
- **Critérios**:
  - Cálculo correto de rotas
  - Evitação de obstáculos
  - Performance adequada
  - Validação de destinos
- **Arquivos**: `objects/obj_game_manager/Create_0.gml` (linhas 220-238)

#### 2.3.2 Sistema de Combate
- **Teste**: Algoritmos de combate
- **Critérios**:
  - Cálculo de dano
  - Validação de alcance
  - Sistema de precisão
  - Mecânicas de defesa
- **Arquivos**: `scripts/scr_combate_unificado/`, `objects/obj_tiro_*`

#### 2.3.3 Sistema de Movimento
- **Teste**: Algoritmos de movimento
- **Critérios**:
  - Movimento suave de unidades
  - Colisão com obstáculos
  - Formações militares
  - Patrulhas
- **Arquivos**: `scripts/movimento_inteligente/`, `scripts/patrulha_inteligente/`

### 2.4 Testes de Estado do Jogo

#### 2.4.1 Gerenciamento de Estado
- **Teste**: Controle de estados do jogo
- **Critérios**:
  - Transições de estado corretas
  - Persistência de dados
  - Sincronização entre sistemas
  - Recuperação de erros
- **Arquivos**: `objects/obj_game_manager/`

#### 2.4.2 Sistema de Debug
- **Teste**: Sistema de debug e logging
- **Critérios**:
  - Mensagens de debug apropriadas
  - Controle de verbosidade
  - Performance do sistema de debug
  - Limpeza de logs
- **Arquivos**: `objects/obj_game_manager/Create_0.gml` (linhas 89-92)

## 3. Casos de Teste Específicos

### 3.1 Teste de Construção Completa
1. Verificar recursos disponíveis
2. Selecionar edifício para construção
3. Validar posição no grid
4. Calcular custos
5. Deduzir recursos
6. Criar instância do edifício
7. Atualizar grid de pathfinding

### 3.2 Teste de Sistema de Combate
1. Posicionar unidade atacante
2. Identificar alvo válido
3. Calcular alcance
4. Verificar linha de visão
5. Calcular dano
6. Aplicar dano ao alvo
7. Atualizar status da unidade

### 3.3 Teste de Pathfinding
1. Definir ponto de origem
2. Definir ponto de destino
3. Calcular rota
4. Verificar obstáculos
5. Validar rota final
6. Executar movimento

## 4. Testes de Performance

### 4.1 Testes de Memória
- **Objetivo**: Verificar uso eficiente de memória
- **Critérios**:
  - Limpeza adequada de estruturas de dados
  - Sem vazamentos de memória
  - Uso otimizado de ds_maps e arrays

### 4.2 Testes de CPU
- **Objetivo**: Verificar performance computacional
- **Critérios**:
  - Algoritmos de pathfinding eficientes
  - Cálculos de combate otimizados
  - Sistema de debug com baixo overhead

### 4.3 Testes de Escalabilidade
- **Objetivo**: Verificar comportamento com muitos objetos
- **Critérios**:
  - Performance com 100+ unidades
  - Performance com 50+ edifícios
  - Sistema de grid eficiente

## 5. Testes de Integridade

### 5.1 Testes de Validação de Dados
- **Objetivo**: Verificar integridade dos dados
- **Critérios**:
  - Valores de recursos dentro de limites
  - Coordenadas válidas
  - Estados consistentes

### 5.2 Testes de Recuperação de Erros
- **Objetivo**: Verificar tratamento de erros
- **Critérios**:
  - Recuperação de estados inválidos
  - Tratamento de exceções
  - Logs de erro apropriados

## 6. Critérios de Aceitação

### 6.1 Funcionalidade
- 100% dos sistemas funcionando corretamente
- Sem bugs críticos
- Lógica de negócio validada

### 6.2 Performance
- Tempo de resposta < 16ms para operações críticas
- Uso de memória < 500MB
- CPU usage < 50% em operação normal

### 6.3 Estabilidade
- Sem crashes durante gameplay normal
- Recuperação adequada de erros
- Dados consistentes

## 7. Ferramentas de Teste

### 7.1 Testes Unitários
- Validação de funções individuais
- Testes de estruturas de dados
- Validação de algoritmos

### 7.2 Testes de Integração
- Validação de sistemas interconectados
- Testes de fluxos completos
- Validação de estados globais

### 7.3 Testes de Stress
- Testes com alta carga
- Validação de limites
- Testes de longa duração

## 8. Cronograma de Testes

### 8.1 Fase 1: Testes Unitários (Semana 1)
- Sistemas de dados
- Algoritmos básicos
- Validações de entrada

### 8.2 Fase 2: Testes de Integração (Semana 2)
- Sistemas interconectados
- Fluxos de trabalho
- Estados globais

### 8.3 Fase 3: Testes de Performance (Semana 3)
- Testes de stress
- Otimizações
- Validação final

## 9. Relatórios e Métricas

### 9.1 Métricas de Qualidade
- Cobertura de testes
- Taxa de bugs por sistema
- Performance benchmarks

### 9.2 Relatórios
- Relatório diário de execução
- Relatório semanal de progresso
- Relatório final de qualidade
