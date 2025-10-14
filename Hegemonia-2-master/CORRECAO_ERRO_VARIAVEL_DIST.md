# CORREÇÃO DE ERRO: Variável 'dist' não definida

## 🚨 **PROBLEMA IDENTIFICADO:**
```
ERROR in action number 1
of Step Event0 for object obj_soldado_antiaereo:
Variable <unknown_object>.dist(100081, -2147483648) not set before reading it.
at gml_Object_obj_soldado_antiaereo_Step_0 (line 349) - var target_x = x + (dir_x / dist_norm) * (dist - dist_ideal);
```

## 🔍 **CAUSA DO ERRO:**
- **Variável não definida**: Uso de `dist` em vez de `dist_alvo`
- **Linhas afetadas**: 335 e 349 do arquivo `obj_soldado_antiaereo/Step_0.gml`
- **Contexto**: Cálculo de movimento para aproximação do alvo

## ✅ **CORREÇÃO IMPLEMENTADA:**

### **Linha 335:**
```gml
// ❌ ANTES:
var target_x = x + (dir_x / dist_norm) * (dist - dist_ideal);
var target_y = y + (dir_y / dist_norm) * (dist - dist_ideal);

// ✅ DEPOIS:
var target_x = x + (dir_x / dist_norm) * (dist_alvo - dist_ideal);
var target_y = y + (dir_y / dist_norm) * (dist_alvo - dist_ideal);
```

### **Linha 349:**
```gml
// ❌ ANTES:
var target_x = x + (dir_x / dist_norm) * (dist - dist_ideal);
var target_y = y + (dir_y / dist_norm) * (dist - dist_ideal);

// ✅ DEPOIS:
var target_x = x + (dir_x / dist_norm) * (dist_alvo - dist_ideal);
var target_y = y + (dir_y / dist_norm) * (dist_alvo - dist_ideal);
```

## 🎯 **RESULTADO:**
- ✅ **Erro corrigido**: Soldado anti-aéreo não trava mais
- ✅ **Movimento funcional**: Aproximação do alvo funciona corretamente
- ✅ **Lógica correta**: Usa `dist_alvo` que é calculada anteriormente

## 📋 **CONTEXTO DA CORREÇÃO:**
- **Função**: Movimento de aproximação para ataque
- **Variável correta**: `dist_alvo` (distância até o alvo)
- **Variável incorreta**: `dist` (não definida)

---
**Data da correção**: 2025-01-27  
**Status**: ✅ **RESOLVIDO**
