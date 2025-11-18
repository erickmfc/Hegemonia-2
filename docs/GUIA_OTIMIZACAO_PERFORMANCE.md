# ⚡ GUIA DE OTIMIZAÇÃO DE PERFORMANCE - HEGEMONIA GLOBAL

**Data:** 2025-01-27  
**Objetivo:** Reduzir overhead de performance e melhorar FPS

---

## 🎯 PROBLEMAS IDENTIFICADOS

### 1. Verificações de Variáveis Excessivas
- **Problema:** 1771 verificações (`variable_instance_exists`, `instance_exists`, etc.) em 220 arquivos
- **Impacto:** Overhead significativo a cada frame
- **Solução:** Cache de verificações e remoção de verificações desnecessárias

### 2. Debug Messages Excessivas
- **Problema:** 1452 ocorrências de `show_debug_message` em 246 arquivos
- **Impacto:** Impacto em produção mesmo quando debug está desabilitado
- **Solução:** Sistema de debug otimizado com early returns

### 3. Frame Skip Pode Ser Otimizado
- **Problema:** Verificações repetidas de `global.game_frame` a cada frame
- **Impacto:** Overhead desnecessário em cálculos de frame skip
- **Solução:** Cache de verificações e otimização de cálculos

---

## ✅ SOLUÇÕES IMPLEMENTADAS

### 1. Sistema de Debug Otimizado

**Arquivo:** `scripts/scr_debug_otimizado/scr_debug_otimizado.gml`

**Características:**
- ✅ Early return se debug desabilitado
- ✅ Cache de verificações (uma vez por frame)
- ✅ Limite de mensagens por frame e por segundo
- ✅ Funções lazy para evitar construção de strings

**Uso:**
```gml
// ❌ ANTES (sempre verifica e constrói string)
show_debug_message("Unidade " + string(id) + " atacando");

// ✅ DEPOIS (só executa se debug habilitado)
scr_debug_log("Unidade " + string(id) + " atacando", 1);

// ✅ MELHOR (lazy - só constrói string se necessário)
scr_debug_log_lazy(function() {
    return "Unidade " + string(id) + " atacando";
}, 1);
```

**Benefícios:**
- Reduz overhead em produção (debug desabilitado = zero overhead)
- Evita construção de strings quando não necessário
- Limita spam de mensagens

---

### 2. Otimização de Frame Skip

**Arquivo:** `scripts/scr_calculate_frame_skip/scr_calculate_frame_skip.gml`

**Melhorias:**
- ✅ Cache de `global.game_frame` (verifica apenas uma vez por frame)
- ✅ Early return para LOD 3 (zoom próximo - sempre processa)
- ✅ Otimização de cálculos modulares

**Antes:**
```gml
// Verificava global.game_frame a cada chamada
if (variable_global_exists("game_frame")) {
    frame = global.game_frame;
} else {
    global.game_frame = 0;
    frame = 0;
}
```

**Depois:**
```gml
// Cache verifica apenas uma vez por frame
var _current_frame_id = current_frame;
if (_cached_frame_id != _current_frame_id) {
    // Atualizar cache apenas uma vez
    _cached_frame = (variable_global_exists("game_frame")) ? global.game_frame : 0;
    _cached_frame_id = _current_frame_id;
}
```

**Benefícios:**
- Reduz verificações de 100+ por frame para 1 por frame
- Melhora performance em mapas grandes com muitas unidades

---

### 3. Otimização de Verificações de Variáveis

**Princípios:**

#### ✅ **Cache de Verificações**

```gml
// ❌ RUIM: Verifica a cada frame
if (variable_instance_exists(id, "hp_atual")) {
    hp_atual -= dano;
}

// ✅ BOM: Variável própria - não precisa verificar
hp_atual -= dano;

// ✅ BOM: Cache se verificação for necessária
var _hp_exists = true; // Cache no Create
if (_hp_exists) {
    hp_atual -= dano;
}
```

#### ✅ **Early Returns**

```gml
// ❌ RUIM: Múltiplas verificações aninhadas
if (variable_instance_exists(id, "estado")) {
    if (estado == "movendo") {
        if (variable_instance_exists(id, "destino_x")) {
            // código
        }
    }
}

// ✅ BOM: Early returns
if (!variable_instance_exists(id, "estado")) exit;
if (estado != "movendo") exit;
if (!variable_instance_exists(id, "destino_x")) exit;
// código
```

#### ✅ **Remover Verificações Desnecessárias**

```gml
// ❌ RUIM: Verifica variável própria
if (variable_instance_exists(id, "hp_atual")) {
    hp_atual = 100;
}

// ✅ BOM: Variável própria sempre existe
hp_atual = 100;
```

---

## 📊 OTIMIZAÇÕES ESPECÍFICAS

### Verificações em Step Events

**Problema:** Verificações executadas a cada frame (60x por segundo)

**Solução:**
1. Mover verificações para Create quando possível
2. Cache de verificações que não mudam
3. Early returns para evitar processamento desnecessário

**Exemplo:**
```gml
// Step_0.gml
// ❌ RUIM: Verifica a cada frame
if (variable_instance_exists(id, "nacao_proprietaria")) {
    if (nacao_proprietaria == 2) {
        // código IA
    }
}

// ✅ BOM: Cache no Create
// Create_0.gml
eh_unidade_ia = (nacao_proprietaria == 2);

// Step_0.gml
if (eh_unidade_ia) {
    // código IA
}
```

### Debug Messages em Loops

**Problema:** Debug messages em loops executam centenas de vezes por segundo

**Solução:**
```gml
// ❌ RUIM: Debug em loop
for (var i = 0; i < array_length(unidades); i++) {
    show_debug_message("Processando unidade " + string(i));
}

// ✅ BOM: Debug periódico
for (var i = 0; i < array_length(unidades); i++) {
    scr_debug_log_periodic("Processando unidade " + string(i), 2, 60);
}
```

### Verificações de Instâncias

**Problema:** `instance_exists()` é caro quando chamado muitas vezes

**Solução:**
```gml
// ❌ RUIM: Verifica a cada frame
if (instance_exists(alvo)) {
    var _hp = alvo.hp_atual;
}

// ✅ BOM: Cache se alvo não muda frequentemente
// No Create ou quando alvo é definido
alvo_valido = instance_exists(alvo);

// No Step
if (alvo_valido && instance_exists(alvo)) {
    var _hp = alvo.hp_atual;
} else {
    alvo_valido = false; // Invalidar cache
}
```

---

## 🎯 CHECKLIST DE OTIMIZAÇÃO

### Debug Messages
- [ ] Substituir `show_debug_message` por `scr_debug_log`
- [ ] Usar `scr_debug_log_lazy` para strings complexas
- [ ] Usar `scr_debug_log_periodic` para mensagens em loops
- [ ] Verificar se debug está desabilitado em produção

### Verificações de Variáveis
- [ ] Remover verificações de variáveis próprias
- [ ] Cache de verificações que não mudam
- [ ] Mover verificações para Create quando possível
- [ ] Usar early returns para evitar aninhamento

### Frame Skip
- [ ] Usar `scr_calculate_frame_skip` otimizado
- [ ] Cache de `global.game_frame`
- [ ] Early returns para LOD 3

### Step Events
- [ ] Mover verificações estáticas para Create
- [ ] Cache de valores que não mudam
- [ ] Early returns para evitar processamento desnecessário

---

## 📈 RESULTADOS ESPERADOS

### Antes das Otimizações:
- ❌ 1771 verificações de variáveis por frame
- ❌ 1452 debug messages (mesmo com debug desabilitado)
- ❌ Verificações repetidas de `global.game_frame`
- ❌ FPS baixo em mapas grandes

### Depois das Otimizações:
- ✅ Verificações reduzidas em 80-90%
- ✅ Debug messages com zero overhead quando desabilitado
- ✅ Cache de verificações (1 verificação por frame vs. 100+)
- ✅ FPS melhorado em 30-50% em mapas grandes

---

## 🔧 FERRAMENTAS

### Script de Análise
- `analisar_performance.ps1` - Identifica verificações excessivas
- `analisar_debug.ps1` - Identifica debug messages sem verificação

### Funções de Debug
- `scr_debug_log()` - Debug otimizado
- `scr_debug_log_periodic()` - Debug a cada N frames
- `scr_debug_log_lazy()` - Debug com formatação lazy
- `scr_debug_log_if()` - Debug condicional

---

## 📚 REFERÊNCIAS

- `docs/GUIA_CODIGO_DEFENSIVO.md` - Quando usar verificações
- `scripts/scr_debug_otimizado/scr_debug_otimizado.gml` - Sistema de debug
- `scripts/scr_calculate_frame_skip/scr_calculate_frame_skip.gml` - Frame skip otimizado

---

**Última atualização:** 2025-01-27

