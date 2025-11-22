# 🛩️ REVISÃO COMPLETA DO F-35 LIGHTNING II

## 📋 **RESUMO EXECUTIVO**

O F-35 Lightning II foi completamente implementado com sistema de mísseis múltiplos e está 100% funcional e integrado.

---

## 🎯 **ESPECIFICAÇÕES TÉCNICAS DO F-35**

### **1. ATRIBUTOS DE VOO**
- **Velocidade Máxima**: 4.5 pixels/frame
- **Aceleração**: 0.06
- **Desaceleração**: 0.03
- **Velocidade de Rotação**: 3.5
- **Altura Máxima de Voo**: 25 pixels

### **2. ATRIBUTOS DE COMBATE**
- **HP Atual**: 300
- **HP Máximo**: 300
- **Nação Proprietária**: 1 (Jogador)
- **Radar Alcance**: 650 pixels
- **Alcance de Ataque**: 600 pixels
- **Modo Ataque**: ATIVO por padrão (true)

### **3. TAMANHO DO SPRITE**
- **Escala X**: 0.12 (12% do tamanho original)
- **Escala Y**: 0.12 (12% do tamanho original)
- **Status**: ✅ Aumentado em 4x do tamanho anterior

---

## 🚀 **SISTEMA DE MÍSSEIS MÚLTIPLOS**

### **Estrutura de Intervalos Independentes**

O F-35 utiliza 4 tipos de mísseis, cada um com seu próprio timer e intervalo de disparo:

#### **1. SKY (obj_SkyFury_ar)** 🛩️
- **Intervalo**: 3 segundos (180 frames a 60 FPS)
- **Uso**: Alvos aéreos (aviões, helicópteros)
- **Velocidade**: 14 pixels/frame
- **Dano**: 60
- **Alcance**: 1500px
- **Sistema**: Pool de projéteis
- **Lançamento**: `scr_get_projectile_from_pool(obj_SkyFury_ar, x, y, "Instances")`

#### **2. IRON (obj_Ironclad_terra)** 🏗️
- **Intervalo**: 5 segundos (300 frames a 60 FPS)
- **Uso**: Alvos terrestres (tanques, infantaria, blindados)
- **Velocidade**: 9 pixels/frame
- **Dano**: 80
- **Alcance**: 1200px
- **Sistema**: Pool de projéteis
- **Lançamento**: `scr_get_projectile_from_pool(obj_Ironclad_terra, x, y, "Instances")`

#### **3. HASH (obj_hash)** 💣
- **Intervalo**: 6 segundos (360 frames a 60 FPS)
- **Uso**: Alvos terrestres e submarinos
- **Velocidade**: 8 pixels/frame
- **Dano**: 1000 (super pesado)
- **Alcance**: Máximo do jogo
- **Sistema**: Criação direta (não usa pool)
- **Lançamento**: `instance_create_layer(x, y, "Instances", obj_hash)`

#### **4. LIT (obj_lit)** 🔥
- **Intervalo**: 7 segundos (420 frames a 60 FPS)
- **Uso**: TODOS os tipos de alvo (versátil)
- **Dano Direto**: 80-140
- **Dano em Área**: 1500
- **Predição**: Sim (calcula posição futura do alvo)
- **Sistema**: Pool + Fallback
- **Lançamento**: `scr_get_projectile_from_pool(obj_lit, x, y, "Instances")` com fallback para criação direta

---

## 🎮 **SISTEMA DE COMBATE**

### **Detecção de Alvos**

O F-35 detecta automaticamente o tipo de alvo e seleciona o míssil apropriado:

```gml
// AÉREOS
obj_caca_f5, obj_f6, obj_f15, obj_su35, 
obj_helicoptero_militar, obj_c100, obj_caca_f35
→ Sky (SkyFury)

// TERRESTRES
obj_infantaria, obj_tanque, obj_soldado_antiaereo, 
obj_blindado_antiaereo
→ Iron (Ironclad) + Hash (simultaneamente)

// SUBMARINOS
obj_submarino_base, obj_wwhendrick
→ Hash (HASH é anti-submarino)

// MÚLTIPLOS
Lit pode ser lançado contra qualquer tipo
```

### **Máquina de Estados**

| Estado | Descrição | Transição |
|--------|-----------|-----------|
| **pousado** | Parado no chão | Decolagem ao receber ordem |
| **decolando** | Decolando (altitude aumentando) | Automático para "movendo" ou "patrulhando" |
| **pousando** | Aterrissando (altitude diminuindo) | Automático para "pousado" |
| **movendo** | Voo para destino | Pouso ao chegar |
| **patrulhando** | Patrulhando pontos pré-definidos | Interrupção por ataque ou parada |
| **atacando** | Perseguindo e atacando alvo | Retorno ao estado anterior quando alvo destruído |

### **Sistema de Patrulha Seguro**

✅ Verificação de lista não vazia antes de operações módulo
✅ Validação de índice dentro dos limites
✅ Tratamento de pontos inválidos (arrays)
✅ Fallback para estado pousado se lista vazia

---

## 🎯 **INTERFACE DE SELEÇÃO (Draw_64)**

Quando selecionado, o F-35 exibe uma caixa de informações com:

- **Nome**: F-35
- **HP**: Porcentagem com cor dinâmica (vermelho < 30%, amarelo < 60%, branco > 60%)
- **Estado de Voo**: PARADO ou VOANDO
- **Modo de Ataque**: MODO ATAQUE (vermelho) ou MODO PASSIVO (cinza)
- **Status dos Mísseis**: "X/4 prontos" (verde) ou "Recarregando" (laranja)

---

## 📊 **MENU DO AEROPORTO**

### **Integração Completa**

✅ Nome: "F-35 Lightning II"
✅ Custo: $2000 dinheiro
✅ População: 5
✅ Tempo de Treino: 3 segundos (180 frames)
✅ Descrição: "Caça de 5ª geração com sistema de mísseis múltiplos (Sky, Iron, Hash, Lit)"
✅ Sprite no Menu: 0.1875 de escala (75% menor que F-15)

---

## 🖱️ **SISTEMA DE SELEÇÃO**

### **Inclusão Completa do F35**

✅ Detecção de clique (instance_position)
✅ Adicionado aos loops de desseleção
✅ Integrado em verificações de tipo de unidade aérea
✅ Suporte completo para patrulha
✅ Mensagens de debug específicas
✅ Compatível com sistema de seleção por área

---

## ⌨️ **CONTROLES DO JOGADOR**

| Tecla | Ação | Descrição |
|-------|------|-----------|
| **P** | Modo Passivo | F-35 não ataca automaticamente |
| **O** | Modo Ataque | F-35 ataca inimigos automaticamente |
| **L** | Pouso | F-35 inicia sequência de pouso |
| **K** | Patrulha | Inicia modo de patrulha (clique para adicionar pontos) |

---

## 📁 **ARQUIVOS MODIFICADOS/CRIADOS**

### **Objetos do F-35**
- ✅ `objects/obj_caca_f35/obj_caca_f35.yy` - Configuração do objeto
- ✅ `objects/obj_caca_f35/Create_0.gml` - Inicialização
- ✅ `objects/obj_caca_f35/Step_0.gml` - Lógica de jogo
- ✅ `objects/obj_caca_f35/Draw_64.gml` - Interface de seleção

### **Integração no Aeroporto**
- ✅ `objects/obj_aeroporto_militar/Create_0.gml` - F-35 adicionado ao menu
- ✅ `objects/obj_menu_recrutamento_aereo/Draw_64.gml` - Sprite no menu

### **Integração no Sistema de Seleção**
- ✅ `objects/obj_input_manager/Step_0.gml` - Seleção e controle do F-35

---

## 🔧 **SISTEMA DE MÍSSEIS - DETALHES TÉCNICOS**

### **Pool de Projéteis**

Sky, Iron e Lit usam o sistema de pool para otimização:
```gml
// Uso correto
var _missil = scr_get_projectile_from_pool(obj_tipo_missil, x, y, "Instances");
if (instance_exists(_missil)) {
    _missil.alvo = alvo_em_mira;
    _missil.target = alvo_em_mira;
    _missil.dono = id;
    _missil_timer = intervalo_correspondente;
}
```

### **Criação Direta**

Hash e Lit (fallback) usam criação direta:
```gml
// Hash
var _missil_hash = instance_create_layer(x, y, "Instances", obj_hash);

// Lit (fallback)
var _missil_lit = instance_create_layer(x, y, "Instances", obj_lit);
```

---

## ✅ **CHECKLIST DE FUNCIONALIDADES**

### **Implementação**
- ✅ Velocidade 4.5 configurada
- ✅ Tamanho 0.12 escala (4x maior que antes)
- ✅ Sistema de 4 mísseis com intervalos
- ✅ Detecção automática de tipo de alvo
- ✅ Modo ataque/passivo
- ✅ Patrulha com segurança contra divisão por zero

### **Integração**
- ✅ Adicionado ao menu do aeroporto
- ✅ Selecionável no mapa
- ✅ Controles funcionando
- ✅ Interface de seleção exibindo corretamente
- ✅ Sprite no menu do aeroporto (0.1875 escala)

### **Correção de Erros**
- ✅ Erro GM1041 resolvido (timer_ataque não existe)
- ✅ Erro divisão por zero resolvido (patrulha segura)
- ✅ Verificação de instância antes de usar variáveis

---

## 🐛 **ERROS CONHECIDOS / CORREÇÕES APLICADAS**

| Erro | Status | Solução |
|------|--------|---------|
| Variable timer_ataque não definida | ✅ CORRIGIDO | Draw_64.gml usa timers individuais de mísseis |
| Divisão por zero em patrulha | ✅ CORRIGIDO | Verificação de lista não vazia |
| F-35 não selecionável | ✅ CORRIGIDO | Adicionado ao obj_input_manager |
| Imagem muito grande no aeroporto | ✅ CORRIGIDO | Escala 0.1875 (reduzido 75%) |

---

## 📈 **COMPARAÇÃO COM OUTROS CAÇAS**

| Especificação | F-5 | F-15 | SU-35 | **F-35** |
|---|---|---|---|---|
| **Velocidade** | 3.5 | 5.1 | 3.7 | **4.5** |
| **HP** | 200 | 800 | 800 | **300** |
| **Radar** | 600 | 550 | 798 | **650** |
| **Mísseis** | LIT | Sky, Iron, Hash | Sky, Iron, Hash | **Sky, Iron, Hash, Lit** |
| **Intervalo** | 60 frames | 85 frames | 85 frames | **3s-7s (variável)** |

---

## 🎯 **CONCLUSÃO**

O F-35 é uma unidade **versátil e bem-equilibrada** que:
- ✅ Oferece flexibilidade com 4 tipos diferentes de mísseis
- ✅ Tem velocidade moderada (4.5) - não é a mais rápida mas competitiva
- ✅ HP moderado (300) - menos que caças superiores mas robusto
- ✅ Sistema de mísseis independentes permite estratégia
- ✅ Totalmente integrado ao jogo e funcionando sem erros

**Status**: 🟢 PRONTO PARA USO

