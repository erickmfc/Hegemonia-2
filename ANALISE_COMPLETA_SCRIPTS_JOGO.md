# 📜 ANÁLISE COMPLETA DOS SCRIPTS DO JOGO

## 📊 **ESTATÍSTICAS GERÁIS**

- **Total de scripts**: 387 arquivos `.gml`
- **Total de definições**: 211 arquivos `.yy`
- **Total de pastas**: ~170 diretórios

---

## 🎯 **CATEGORIAS DE SCRIPTS**

### **1. SCRIPTS PRINCIPAIS (Produção)**

#### **🗺️ Inicialização e Configuração**
- `scr_enums_navais` - Enums para navios
- `scr_inicializar_sistema` - Sistema de inicialização
- `scr_config_unidades` - Configuração de unidades
- `scr_config_estruturas` - Configuração de estruturas
- `scr_sistema_principal` - Sistema principal do jogo

#### **🎮 Input e Controle**
- `scr_mouse_to_world` - Conversão mouse → world
- `scr_check_controls_click` - Verificação de cliques
- `scr_draw_controls` - Desenho de controles
- `scr_play_video`, `scr_stop_video`, `scr_toggle_play_pause` - Controle de vídeo
- `scr_set_volume` - Controle de volume
- `scr_restart_video` - Reiniciar vídeo

#### **⚔️ Combate e IA**
- `scr_buscar_inimigo` - Sistema de busca de inimigos
- `scr_combate_unificado` - Sistema de combate
- `scr_sistema_combate_unificado` - Combate avançado
- `scr_disparar_missil` - Disparo de mísseis
- `scr_missil_prioridade_calor` - Mísseis com busca térmica
- `scr_ia_atacar` - IA de ataque
- `scr_ia_decisao_economia` - IA econômica
- `scr_ia_formar_esquadrao` - IA de formação
- `scr_ia_recrutar_unidade` - IA de recrutamento
- `scr_ia_construir` - IA de construção

#### **🏗️ Construção e Edifícios**
- `scr_construir_navio` - Construção de navios
- `scr_verificar_espaco_edificio` - Verificação de espaço
- `scr_identificar_tipo_unidade` - Identificação de unidades
- `scr_ia_construir` - IA de construção

#### **🚢 Sistema Naval**
- `scr_enums_navais` - Enums navais
- `scr_naval_defaults` - Configurações padrão navais
- `scr_processar_clique_unidade_naval` - Processamento de cliques
- `scr_recrutar_navio` - Recrutamento naval
- `scr_iniciar_recrutamento_naval` - Iniciar recrutamento

#### **📦 C-100 (Carga)**
- `scr_c100_add_carga` - Adicionar carga
- `scr_c100_can_load` - Verificar se pode carregar
- `scr_c100_config` - Configuração do C-100
- `scr_c100_remove_all` - Remover todas as cargas
- `scr_c100_spawn_desembarque` - Spawn de desembarque
- `scr_ui_c100_painel` - UI do painel C-100
- `scr_is_aereo_em_voo` - Verificação de voo

#### **💰 Recursos Econômicos**
- `scr_imprimir_dinheiro` - Sistema de dinheiro
- `scr_verificar_recursos_unificados` - Verificação de recursos
- `scr_validar_recursos` - Validação de recursos
- `scr_recursos_unificados` - Recursos unificados

#### **🎯 Lógica de Unidades**
- `scr_logica_unidade_comum` - Lógica comum
- `scr_identificar_tipo_unidade` - Identificação
- `scr_producao_unidades` - Produção de unidades
- `scr_criar_unidade_unificado` - Criação unificada

#### **🔧 Utilitários**
- `scr_mouse_to_world` - Conversão de coordenadas
- `scr_integrar_sistema` - Integração de sistemas
- `scr_camera_culling` - Otimização de câmera
- `scr_debug_log` - Sistema de debug

---

### **2. SCRIPTS DE TESTE (Debug)**

#### **🧪 Testes Gerais**
- `scr_testar_sistema` - Teste geral do sistema
- `scr_testar_quartel` - Teste de quartel
- `scr_testar_quartel_marinha` - Teste de quartel marinho
- `scr_teste_completo_sistema` - Teste completo
- `scr_teste_completo_quartel_marinha` - Teste completo do quartel

#### **🧪 Testes Específicos**
- `scr_teste_constellation` - Teste do Constellation
- `scr_teste_obj_fragata` - Teste da fragata
- `scr_teste_navegacao_navios` - Teste de navegação
- `scr_teste_movimento_navios_corrigido` - Teste de movimento
- `scr_teste_sistema_misseis` - Teste de mísseis
- `scr_teste_misseis_simples` - Teste de mísseis simples
- `scr_teste_sistema_zoom` - Teste de zoom
- `scr_teste_selecao_navios` - Teste de seleção
- `scr_teste_producao_naval` - Teste de produção naval
- `scr_teste_zoom_robusto` - Teste de zoom robusto
- `scr_teste_sprite_quartel_marinha` - Teste de sprite
- `scr_teste_step_event` - Teste de step event

---

### **3. SCRIPTS DE DIAGNÓSTICO**

#### **🔍 Diagnósticos**
- `scr_diagnostico_quartel_marinha` - Diagnóstico do quartel
- `scr_diagnostico_navios_completo` - Diagnóstico de navios
- `scr_diagnostico_producao_naval` - Diagnóstico de produção
- `scr_diagnostico_objetos_quartel` - Diagnóstico de objetos
- `scr_diagnostico_problemas_completo` - Diagnóstico completo
- `scr_diagnostico_fantasma_construcao` - Diagnóstico de fantasma
- `scr_diagnostico_click_navios` - Diagnóstico de cliques
- `scr_diagnostico_menu_naval` - Diagnóstico de menu
- `scr_debug_quartel_marinha` - Debug do quartel

---

### **4. SCRIPTS DE CORREÇÃO**

#### **🔧 Correções**
- `scr_corrigir_objeto_automaticamente` - Correção automática
- `scr_corrigir_step_event` - Correção de step event
- `scr_corrigir_quartel_clique` - Correção de clique
- `scr_atualizar_codigo_existente` - Atualização de código
- `scr_integrar_sistema` - Integração de sistema

---

### **5. SCRIPTS DE VALIDAÇÃO**

#### **✅ Validações**
- `scr_verificacao_completa_jogo` - Verificação completa
- `scr_verificacao_limpeza_memoria` - Limpeza de memória
- `scr_validacao_terreno` - Validação de terreno
- `scr_validacao_final_producao_naval` - Validação de produção
- `scr_validacao_final_navegacao_navios` - Validação de navegação
- `scr_validacao_debug_system` - Validação de debug
- `scr_validador_objetos` - Validador de objetos
- `scr_validar_recursos` - Validação de recursos
- `scr_verificar_integridade` - Verificação de integridade
- `scr_verificar_objeto` - Verificação de objeto

---

### **6. SCRIPTS ESPECÍFICOS DE AERONAVES**

#### **✈️ Aeronaves**
- `scr_f5_logica` - Lógica do F-5
- `scr_helicoptero_logica` - Lógica do helicóptero
- `scr_lancar_missil_ar_ar` - Mísseis ar-ar
- `scr_lancar_missil_ar_terra` - Mísseis ar-terra
- `scr_lancar_misseis` - Lançamento de mísseis

---

### **7. SCRIPTS DE UI E CONTROLES**

#### **🎨 Interface**
- `scr_desenhar_botao_moderno` - Botões modernos
- `scr_desenhar_card_unidade_naval` - Cards de unidades
- `scr_ui_c100_painel` - Painel do C-100
- `sc_ui_helpers` - Helpers de UI

---

### **8. SCRIPTS DE COMANDOS TÁTICOS**

#### **🎯 Comandos**
- `sc_comandos_militares` - Comandos militares
- `sc_comandos_taticos` - Comandos táticos
- `scr_comandos_infantaria` - Comandos de infantaria
- `sc_formacoes_taticas` - Formações táticas

---

## 🔍 **SCRIPTS PROBLEMÁTICOS IDENTIFICADOS**

### **⚠️ Scripts com Warnings (GM2039)**

1. **`scr_inicializar_sistema`** (linha 21:5)
   - Uso deprecated de script como função
   
2. **`scr_mouse_to_world`**
   - Potencial problema com chamada global

### **⚠️ Scripts com Warning GM1045**

1. **`scr_camera_culling`** (linhas 13:9 e 42:5)
   - Type `Array<Real>` vs `Array` no JSDoc

---

## ✅ **RECOMENDAÇÕES**

### **1. Limpeza de Scripts**
- **Remover scripts de teste** que não são usados
- **Remover scripts de diagnóstico** que são temporários
- **Consolidar scripts duplicados**

### **2. Organização**
- **Criar pastas por categoria**
- **Separar scripts de produção de testes**
- **Documentar melhor scripts principais**

### **3. Correções**
- **Corrigir warnings GM2039** (scripts deprecated)
- **Corrigir warnings GM1045** (tipos de array)
- **Atualizar JSDoc** para tipos corretos

---

## 📝 **CONCLUSÃO**

O jogo possui **387 scripts**, sendo:
- ✅ **~100 scripts principais** (produção)
- 🧪 **~200 scripts de teste** (debug)
- 🔍 **~50 scripts de diagnóstico**
- 🔧 **~30 scripts de correção/validação**

**Recomendação**: Fazer limpeza de scripts não utilizados para melhorar organização e performance.

