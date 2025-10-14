# 📚 **DOCUMENTAÇÃO COMPLETA DE VARIÁVEIS - HEGEMONIA GLOBAL**

## **🏗️ ESTRUTURAS BASE (p_estrutura_base)**

### **Variáveis de Identificação**
- `estrutura_id` (real) - ID único da estrutura
- `estrutura_tipo` (string) - Tipo da estrutura ("base", "quartel", "casa", etc.)
- `nacao_proprietaria` (real) - Nação que possui a estrutura (1-10)

### **Variáveis de Recursos**
- `custo_dinheiro` (real) - Custo em dinheiro para construir
- `custo_minerio` (real) - Custo em minério para construir
- `custo_petroleo` (real) - Custo em petróleo para construir
- `custo_populacao` (real) - Custo em população para construir

### **Variáveis de Vida**
- `hp_max` (real) - Pontos de vida máximo
- `hp_atual` (real) - Pontos de vida atual
- `armadura` (real) - Redução de dano recebido

### **Variáveis de Produção**
- `producao_por_ciclo` (real) - Quantidade produzida por ciclo
- `tipo_recurso` (string) - Tipo de recurso produzido ("populacao", "dinheiro", etc.)
- `armazenamento_maximo` (real) - Capacidade máxima de armazenamento
- `armazenamento_atual` (real) - Quantidade atual armazenada

### **Variáveis de Upgrade**
- `pode_upgradar` (bool) - Se a estrutura pode ser melhorada
- `custo_upgrade_dinheiro` (real) - Custo em dinheiro para upgrade
- `custo_upgrade_minerio` (real) - Custo em minério para upgrade
- `nivel_maximo` (real) - Nível máximo de upgrade

### **Variáveis de Posicionamento**
- `posicao_valida` (bool) - Se a posição é válida para construção
- `requer_agua` (bool) - Se precisa estar na água
- `requer_terra` (bool) - Se precisa estar na terra
- `requer_eletricidade` (bool) - Se precisa de energia

### **Variáveis de Estado**
- `estrutura_construida` (bool) - Se a estrutura foi construída
- `estrutura_funcionando` (bool) - Se a estrutura está funcionando
- `estrutura_danificada` (bool) - Se a estrutura está danificada

### **Variáveis de Manutenção**
- `manutencao_necessaria` (bool) - Se precisa de manutenção
- `custo_manutencao` (real) - Custo da manutenção
- `tempo_manutencao` (real) - Tempo restante de manutenção

### **Variáveis de Segurança**
- `pode_ser_atacada` (bool) - Se pode ser atacada
- `conexoes_necessarias` (array) - Conexões necessárias para funcionar
- `conexoes_ativas` (array) - Conexões ativas

### **Variáveis de Efeitos**
- `efeitos_visuais` (array) - Efeitos visuais ativos
- `efeitos_sonoros` (array) - Efeitos sonoros ativos

### **Variáveis de Debug**
- `debug_ativo` (bool) - Se debug está ativo
- `ultima_atualizacao` (real) - Timestamp da última atualização

---

## **⚔️ UNIDADES MILITARES (p_unidade_militar)**

### **Variáveis de Identificação**
- `unidade_id` (real) - ID único da unidade
- `unidade_tipo` (string) - Tipo da unidade ("militar")
- `unidade_categoria` (string) - Categoria ("terrestre", "naval", "aerea")
- `unidade_classe` (string) - Classe ("basica", "pesada", "elite", "heroica")

### **Variáveis de Combate**
- `hp_max` (real) - Pontos de vida máximo
- `hp_atual` (real) - Pontos de vida atual
- `dano_base` (real) - Dano base de ataque
- `dano_variavel` (real) - Variação de dano
- `alcance_ataque` (real) - Alcance de ataque em tiles
- `velocidade_movimento` (real) - Velocidade de movimento
- `velocidade_ataque` (real) - Velocidade de ataque (frames entre ataques)

### **Variáveis de Custo**
- `custo_dinheiro` (real) - Custo em dinheiro para recrutar
- `custo_minerio` (real) - Custo em minério para recrutar
- `custo_petroleo` (real) - Custo em petróleo para recrutar
- `custo_populacao` (real) - Custo em população para recrutar
- `tempo_treino` (real) - Tempo de treinamento em segundos

### **Variáveis de Experiência**
- `nivel` (real) - Nível atual da unidade
- `experiencia` (real) - Experiência atual
- `experiencia_para_proximo_nivel` (real) - Experiência necessária para próximo nível
- `bonus_nivel_dano` (real) - Bônus de dano por nível
- `bonus_nivel_hp` (real) - Bônus de HP por nível

### **Variáveis de Estado**
- `estado` (string) - Estado atual ("parado", "movendo", "atacando", "defendendo")
- `estado_anterior` (string) - Estado anterior
- `tempo_no_estado` (real) - Tempo no estado atual

### **Variáveis de IA**
- `alvo_inimigo` (real) - ID do alvo inimigo
- `alvo_aliado` (real) - ID do alvo aliado
- `objetivo_primario` (string) - Objetivo primário ("atacar", "defender", "explorar")
- `objetivo_secundario` (string) - Objetivo secundário

### **Variáveis de Movimento**
- `destino_x` (real) - Posição X de destino
- `destino_y` (real) - Posição Y de destino
- `velocidade_atual` (real) - Velocidade atual
- `pode_mover_agua` (bool) - Se pode se mover na água
- `pode_mover_terra` (bool) - Se pode se mover na terra
- `pode_mover_montanha` (bool) - Se pode se mover na montanha

### **Variáveis de Detecção**
- `raio_visao` (real) - Raio de visão
- `raio_ataque` (real) - Raio de ataque
- `detecta_invisivel` (bool) - Se detecta unidades invisíveis
- `detecta_submarino` (bool) - Se detecta submarinos

### **Variáveis de Cooldowns**
- `cooldown_ataque` (real) - Cooldown de ataque
- `cooldown_movimento` (real) - Cooldown de movimento
- `cooldown_especial` (real) - Cooldown de habilidade especial

### **Variáveis de Habilidades**
- `habilidades_disponiveis` (array) - Lista de habilidades disponíveis
- `habilidade_ativa` (string) - Habilidade atualmente ativa
- `tempo_habilidade` (real) - Tempo restante da habilidade

### **Variáveis de Equipamentos**
- `equipamento_primario` (string) - Equipamento primário
- `equipamento_secundario` (string) - Equipamento secundário
- `equipamento_especial` (string) - Equipamento especial
- `bonus_equipamento` (real) - Bônus total dos equipamentos

### **Variáveis de Moral**
- `moral_atual` (real) - Moral atual
- `moral_maxima` (real) - Moral máxima
- `moral_minima` (real) - Moral mínima
- `bonus_moral` (real) - Bônus de moral

### **Variáveis de Supply**
- `supply_atual` (real) - Supply atual
- `supply_maximo` (real) - Supply máximo
- `supply_consumo_por_turno` (real) - Consumo de supply por turno
- `sem_supply` (bool) - Se está sem supply

### **Variáveis de Comando**
- `comandante` (real) - ID do comandante
- `unidades_sob_comando` (array) - Lista de unidades sob comando
- `hierarquia` (real) - Nível hierárquico

### **Variáveis de Formação**
- `formacao_atual` (string) - Formação atual
- `posicao_formacao` (real) - Posição na formação
- `unidades_formacao` (array) - Unidades na mesma formação

### **Variáveis de Comunicação**
- `radio_ativo` (bool) - Se o rádio está ativo
- `frequencia_radio` (real) - Frequência do rádio
- `pode_comunicar` (bool) - Se pode se comunicar

### **Variáveis de Manutenção**
- `manutencao_necessaria` (bool) - Se precisa de manutenção
- `tempo_sem_manutencao` (real) - Tempo sem manutenção
- `eficiencia_combate` (real) - Eficiência de combate

### **Variáveis de Debug**
- `debug_ativo` (bool) - Se debug está ativo
- `ultima_atualizacao` (real) - Timestamp da última atualização
- `eventos_log` (array) - Log de eventos

---

## **🏭 QUARTÉIS ESPECÍFICOS**

### **Quartel de Marinha (obj_quartel_marinha)**
- `menu_recrutamento_ativo` (bool) - Se o menu de recrutamento está ativo
- `recrutamento_em_andamento` (bool) - Se há recrutamento em andamento
- `unidade_sendo_treinada` (real) - ID da unidade sendo treinada
- `tempo_treinamento_restante` (real) - Tempo restante de treinamento
- `esta_treinando` (bool) - Se está treinando uma unidade
- `unidades_para_criar` (real) - Quantidade de unidades para criar
- `unidades_criadas` (real) - Quantidade de unidades já criadas
- `quantidade_recrutar` (real) - Quantidade a recrutar
- `recrutar_fragata` (bool) - Flag para recrutar fragata
- `recrutar_destroyer` (bool) - Flag para recrutar destroyer
- `recrutar_submarino` (bool) - Flag para recrutar submarino
- `recrutar_porta_avioes` (bool) - Flag para recrutar porta-aviões

---

## **🌍 VARIÁVEIS GLOBAIS**

### **Recursos**
- `global.dinheiro` (real) - Dinheiro disponível
- `global.minerio` (real) - Minério disponível
- `global.petroleo` (real) - Petróleo disponível
- `global.populacao` (real) - População disponível

### **Contadores**
- `global.estruturas_criadas` (real) - Contador de estruturas criadas
- `global.unidades_criadas` (real) - Contador de unidades criadas
- `global.militares_navais_totais` (real) - Contador de militares navais

### **Controle de UI**
- `global.menu_recrutamento_aberto` (bool) - Se menu de recrutamento está aberto
- `global.construindo_agora` (real) - Objeto sendo construído

### **Configurações**
- `global.config_global` (ds_map) - Mapa de configurações globais
- `global.debug_performance` (bool) - Se debug de performance está ativo

---

## **📝 CONVENÇÕES DE NOMENCLATURA**

### **Prefixos**
- `estrutura_` - Variáveis específicas de estruturas
- `unidade_` - Variáveis específicas de unidades
- `global.` - Variáveis globais

### **Sufixos**
- `_max` - Valor máximo
- `_atual` - Valor atual
- `_base` - Valor base
- `_total` - Valor total

### **Tipos de Dados**
- `real` - Números decimais
- `bool` - Verdadeiro/Falso
- `string` - Texto
- `array` - Lista de valores
- `ds_map` - Estrutura de dados chave-valor
- `ds_list` - Lista de dados

---

## **🔧 MANUTENÇÃO**

### **Adicionando Novas Variáveis**
1. Adicionar na documentação
2. Inicializar no Create event
3. Limpar no CleanUp event
4. Documentar uso e propósito

### **Modificando Variáveis Existentes**
1. Atualizar documentação
2. Verificar compatibilidade
3. Atualizar scripts que usam a variável
4. Testar funcionalidade

### **Removendo Variáveis**
1. Verificar dependências
2. Remover de todos os eventos
3. Atualizar documentação
4. Testar sistema
