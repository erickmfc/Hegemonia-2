# CORREÇÃO DE ERRO: global.debug_mode

## 🚨 **PROBLEMA IDENTIFICADO:**
```
ERROR in action number 1
of Create Event for object obj_game_manager:
global variable name 'debug_mode' index (111) not set before reading it.
at gml_Object_obj_game_manager_Create_0 (line 31) - if (global.debug_mode) {
```

## 🔍 **CAUSA DO ERRO:**
- **Inconsistência de nomenclatura**: Definido `global.debug_enabled` mas usado `global.debug_mode`
- **Ordem de inicialização**: Tentativa de usar variável antes de defini-la

## ✅ **CORREÇÃO IMPLEMENTADA:**

### **1. obj_game_manager/Create_0.gml:**
```gml
// ❌ ANTES (linha 31):
if (global.debug_mode) {
    show_debug_message("Sistema de debug ULTRA otimizado inicializado. Modo: " + string(global.debug_mode));
}

// ✅ DEPOIS (linha 31):
if (global.debug_enabled) {
    show_debug_message("Sistema de debug ULTRA otimizado inicializado. Modo: " + string(global.debug_enabled));
}
```

### **2. obj_research_center/Step_0.gml:**
```gml
// ❌ ANTES (linha 12):
var debug_enabled = (global.debug_mode != undefined) ? global.debug_mode : false;

// ✅ DEPOIS (linha 12):
var debug_enabled = (global.debug_enabled != undefined) ? global.debug_enabled : false;
```

## 🎯 **RESULTADO:**
- ✅ **Erro corrigido**: Sistema de debug funciona corretamente
- ✅ **Consistência**: Todas as referências usam `global.debug_enabled`
- ✅ **Funcionalidade**: Debug otimizado operacional

## 📋 **VARIÁVEIS DE DEBUG CORRETAS:**
- `global.debug_enabled` - Habilita/desabilita debug
- `global.debug_current_frame` - Contador de messages por frame
- `global.debug_max_per_frame` - Limite de messages por frame
- `global.debug_log()` - Função para debug otimizado
- `global.debug_reset_frame()` - Reset do contador por frame

---
**Data da correção**: 2025-01-27  
**Status**: ✅ **RESOLVIDO**
