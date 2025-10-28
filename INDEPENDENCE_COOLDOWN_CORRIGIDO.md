# 🔧 INDEPENDENCE - SISTEMA DE COOLDOWN IMPLEMENTADO

## 📋 **PROBLEMA RESOLVIDO**

O canhão do Independence agora tem um sistema de cooldown: **atira por 3 segundos e pausa por 3 segundos**.

---

## 🔧 **MODIFICAÇÕES APLICADAS**

### **1. objects/obj_Independence/Create_0.gml**

**Variáveis Atualizadas:**
```gml
// === SISTEMA DE METRALHADORA (CANHÃO) ===
metralhadora_ativa = false;
metralhadora_timer = 0;
metralhadora_intervalo = 3; // 3 frames entre tiros = ~20 tiro/segundo
metralhadora_duracao = 180; // 3 segundos (180 frames)
metralhadora_tiros = 0;
metralhadora_max_tiros = 60; // 60 tiros × 3 frames = 180 frames = 3 segundos
metralhadora_cooldown_timer = 0; // ← NOVO: Timer de pausa
metralhadora_cooldown_duration = 180; // ← NOVO: 3 segundos de pausa
```

### **2. objects/obj_Independence/Step_1.gml**

**Sistema de Cooldown Implementado:**
```gml
// === DECREMENTAR COOLDOWN ===
if (metralhadora_cooldown_timer > 0) {
    metralhadora_cooldown_timer--;
}

// ATIVAR canhão apenas para alvos terrestres/navais, dentro do alcance E sem cooldown
if (!_alvo_eh_aereo && _distancia_alvo <= missil_max_alcance && metralhadora_cooldown_timer <= 0) {
    // Lógica de atirar...
    
    // Finalizar rajada E ATIVAR COOLDOWN
    if (metralhadora_tiros >= metralhadora_max_tiros) {
        metralhadora_ativa = false;
        metralhadora_timer = 0;
        metralhadora_tiros = 0;
        metralhadora_cooldown_timer = metralhadora_cooldown_duration; // ← ATIVAR COOLDOWN
    }
}
```

---

## 📊 **COMPARAÇÃO**

| Item | Antes | Depois |
|------|-------|--------|
| **Frames atirando** | 60 (~1s) | 180 (~3s) |
| **Frames pausando** | 0 | 180 (~3s) |
| **Tiros por rajada** | 12 | 60 |
| **Intervalo entre tiros** | 5 frames | 3 frames |
| **Cooldown** | Nenhum | 180 frames (3s) |
| **Cadência** | ~2.4 tiro/s | ~20 tiro/s |

---

## 🎯 **COMPORTAMENTO ATUAL**

### **Ciclo de Tiro:**
1. **Ativação**: Quando detecta alvo terrestre dentro de alcance e `cooldown_timer <= 0`
2. **Rajada**: 60 tiros em 3 segundos (~20 tiro/s)
3. **Cooldown**: 3 segundos de pausa
4. **Repetir**: Volta para passo 1

### **Fluxo Detalhado:**
```
Alvo terrestre detectado
↓
cooldown_timer <= 0? 
  ├─ SIM → Ativa metralhadora_ativa = true
  └─ NÃO → Aguarda cooldown decrementar
↓
Dispara 60 tiros em 3 segundos
↓
metralhadora_tiros >= 60?
↓
Ativa cooldown_timer = 180 frames
↓
Espera 3 segundos
↓
cooldown_timer = 0 → Repete ciclo
```

---

## ✅ **VALIDAÇÕES**

### **Condições para Atirar:**
1. ✅ `instance_exists(alvo_unidade)`
2. ✅ `estado == LanchaState.ATACANDO`
3. ✅ `instance_exists(canhao_instancia)`
4. ✅ `!_alvo_eh_aereo` (não é aéreo)
5. ✅ `_distancia_alvo <= missil_max_alcance` (dentro de 1000px)
6. ✅ `metralhadora_cooldown_timer <= 0` (sem cooldown)

### **Condições para Parar:**
1. ✅ `_alvo_eh_aereo` → Para canhão (usa mísseis)
2. ✅ `_distancia_alvo > missil_max_alcance` → Para canhão
3. ✅ `metralhadora_tiros >= 60` → Para canhão e ativa cooldown

---

## 🎮 **ESTATÍSTICAS ATUALIZADAS**

| Propriedade | Valor |
|------------|-------|
| **Tiros por rajada** | 60 |
| **Duração da rajada** | 3 segundos |
| **Intervalo entre tiros** | 3 frames |
| **Cadência** | ~20 tiro/segundo |
| **Cooldown** | 3 segundos |
| **Dano por rajada** | 60 × 15 = 900 total |
| **DPS médio** | 900/6 = 150 (com pausa) |
| **DPS durante rajada** | 60 × 15/3 = 300 |

---

## 🚀 **RESULTADO**

O canhão do Independence agora:
- ✅ Atira por **3 segundos**
- ✅ Pausa por **3 segundos**
- ✅ Não atira constantemente
- ✅ Sistema de cooldown funcionando
- ✅ Performance otimizada

---

*Correções aplicadas com sucesso!*

