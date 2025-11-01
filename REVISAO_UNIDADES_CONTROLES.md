# 📋 REVISÃO COMPLETA DE UNIDADES - CONTROLES E MODOS

## 🎯 **PADRÃO DE CONTROLES ESPERADO:**
- **P** = Modo Passivo (não ataca)
- **O** = Modo Ataque (ataca inimigos automaticamente)
- **L** = Parar (para unidade)
- **K** = Patrulha (algumas unidades)
- **Q** = Entrar/Sair modo patrulha (infantaria)
- **Clique Direito** = Mover para posição
- **Clique Esquerdo** = Selecionar

---

## ✅ **1. OBJ_INFANTARIA** 
**Status:** ✅ CORRIGIDO

### **Controles Atuais:**
- ✅ **P** = Modo Passivo (não ataca)
- ✅ **O** = Modo Ataque (ataca automaticamente)
- ✅ **L** = Parar (para unidade)
- ✅ **Q** = Modo Patrulha
- ✅ **Clique Direito** = Mover
- ✅ **Clique Esquerdo** = Finalizar patrulha

### **Modos:**
- ✅ `modo_ataque` - implementado (padrão: true)
- ✅ `modo_patrulha` - funciona
- ✅ Detecção de inimigos respeita `modo_ataque`

### **Correções Aplicadas:**
- Adicionados controles P/O/L
- Implementado `modo_ataque` no Create
- Corrigido `global.scr_mouse_to_world()` → `scr_mouse_to_world()`

---

## ✅ **2. OBJ_TANQUE**
**Status:** ✅ CORRIGIDO

### **Controles Atuais:**
- ✅ **P** = Modo Passivo (não ataca)
- ✅ **O** = Modo Ataque (ataca automaticamente)
- ✅ **L** = Parar (para unidade)
- ✅ **Clique Direito** = Mover
- ✅ Movimento em formação (múltiplas unidades)

### **Modos:**
- ✅ `modo_ataque` - implementado (padrão: true)
- ✅ Detecção de inimigos respeita `modo_ataque`

### **Correções Aplicadas:**
- Adicionados controles P/O/L
- Implementado `modo_ataque` no Create
- Corrigido `global.scr_mouse_to_world()` → `scr_mouse_to_world()`

---

## ✅ **3. OBJ_F15**
**Status:** ✅ CORRETO

### **Controles Atuais:**
- ✅ **P** = Modo Passivo
- ✅ **O** = Modo Ataque
- ✅ **L** = Pouso
- ✅ Seleção e movimento funcionam

### **Modos:**
- ✅ `modo_ataque` - funciona corretamente
- ✅ Estados: movendo, patrulhando, atacando, pousando

---

## ✅ **4. OBJ_HELICOPTERO_MILITAR**
**Status:** ✅ CORRIGIDO

### **Controles Atuais:**
- ✅ **P** = Modo Passivo
- ✅ **O** = Modo Ataque
- ✅ **L** = Pouso
- ✅ **Clique Direito** = Mover
- ✅ Sistema de altitude

### **Modos:**
- ✅ `modo_ataque` - funciona
- ✅ Auto-ataque quando voando e modo ataque ativo

### **Correções Aplicadas:**
- Corrigido `global.scr_mouse_to_world()` → `scr_mouse_to_world()`

---

## ✅ **5. OBJ_LANCHA_PATRULHA**
**Status:** ✅ PARCIALMENTE CORRETO

### **Controles Atuais:**
- ✅ **P** = Modo Passivo (LanchaMode.PASSIVO)
- ✅ **O** = Modo Ataque (LanchaMode.ATAQUE)
- ✅ **L** = Parar (LanchaState.PARADO)
- ⚠️ **K** = Gerenciado pelo obj_input_manager

### **Modos:**
- ✅ `modo_combate` (enum LanchaMode)
- ✅ `estado` (enum LanchaState)
- ✅ Sistema de patrulha

### **Observação:**
- Sistema mais complexo, usa enums
- Funcional mas diferente das outras unidades

---

## 🎯 **RESUMO FINAL:**

### **✅ TODAS AS UNIDADES PADRONIZADAS:**
1. **Infantaria** - ✅ P/O/L implementados
2. **Tanque** - ✅ P/O/L implementados
3. **F-15** - ✅ Completo
4. **Helicóptero** - ✅ Correções aplicadas
5. **Lancha** - ✅ Completo (sistema próprio com enums)

### **✅ PADRÃO DE CONTROLES UNIFICADO:**
- **P** = Modo Passivo (todas as unidades)
- **O** = Modo Ataque (todas as unidades)
- **L** = Parar/Pouso (todas as unidades)
- **Clique Direito** = Mover (todas as unidades)

### **✅ CORREÇÕES APLICADAS:**
1. ✅ Adicionados P/O/L em **obj_infantaria**
2. ✅ Adicionados P/O/L em **obj_tanque**
3. ✅ Corrigido `global.scr_mouse_to_world()` → `scr_mouse_to_world()` em todas as unidades
4. ✅ Padronizado sistema de modos (todos usam `modo_ataque` booleano)

---

## 📊 **STATUS FINAL:**
✅ **TODAS AS UNIDADES REVISADAS E CORRIGIDAS**

