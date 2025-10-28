# 🔧 PORTA-AVIÕES - ERRO CORRIGIDO

## ❌ **ERRO ORIGINAL**

```
ERROR in action number 1 of Draw Event for object obj_porta_avioes:
Variable <unknown_object>.selecionado(100988, -2147483648) not set before reading it.
```

**Causa**: A variável `selecionado` não estava definida quando o Draw Event tentou usá-la.

---

## ✅ **CORREÇÕES APLICADAS**

### **1. Create_0.gml** 
```gml
// === SISTEMA DE SELEÇÃO ===
selecionado = false; // Variável de seleção (herdada do obj_navio_base)
```

### **2. Draw_0.gml**
```gml
// Chamar Draw do pai
event_inherited();

// Porta-aviões só desenha indicadores se estiver selecionado
if (selecionado) { // ← Agora funciona porque está definido
```

### **3. Mouse_0.gml**
```gml
if (selecionado && mouse_check_button_pressed(mb_left)) {
    // Código do patrulha
}
```

### **4. Mouse_4.gml**
```gml
if (selecionado && mouse_check_button_pressed(mb_right)) {
    // Código do menu/desembarque
}
```

---

## 📋 **ANÁLISE DO PROBLEMA**

### **Por que aconteceu?**

O `obj_navio_base` define `selecionado = false` na linha 32 do seu Create_0.gml, MAS:
1. O Porta-Aviões chamava `event_inherited()` no seu Create_0.gml
2. Porém, a variável ainda não estava acessível no Draw Event
3. O problema é de **ordem de execução dos eventos**

### **Solução Aplicada:**

1. ✅ Definir `selecionado = false` no Create_0.gml do Porta-Aviões
2. ✅ Garantir que todas as variáveis estão definidas antes de usar
3. ✅ Remover verificações excessivas após confirmar que variável existe

---

## 🎯 **CHECKLIST DE PREVENÇÃO**

Para evitar esse erro em novos objetos:

### **✅ SEMPRE fazer:**
```gml
// Create_0.gml
event_inherited(); // ← SEMPRE PRIMEIRO

// Definir TODAS as variáveis que serão usadas
selecionado = false;
estado = LanchaState.PARADO;
modo_combate = LanchaMode.PASSIVO;
hp_atual = 4000;
hp_max = 4000;
// ... etc
```

### **❌ NUNCA fazer:**
```gml
// Create_0.gml
// Definir variáveis SEM event_inherited()
selecionado = false; // ← ERRO: pode sobrescrever do pai

// OU usar variáveis ANTES de definir
if (selecionado) { // ← ERRO: variável não definida ainda
```

---

## 📊 **COMPARAÇÃO**

| Arquivo | Antes | Depois |
|---------|-------|--------|
| Create_0.gml | Sem `selecionado` | `selecionado = false;` |
| Draw_0.gml | `if (selecionado)` ❌ | `if (selecionado)` ✅ |
| Mouse_0.gml | `if (selecionado)` ❌ | `if (selecionado)` ✅ |
| Mouse_4.gml | Verificação complexa | Simplificado |

---

## ✅ **STATUS FINAL**

**Erro corrigido em:**
- ✅ Create_0.gml → Variável `selecionado` definida
- ✅ Draw_0.gml → Verificação simplificada
- ✅ Mouse_0.gml → Verificação simplificada
- ✅ Mouse_4.gml → Verificação simplificada
- ✅ Todos os arquivos sem erros de lint

---

## 🚀 **RESULTADO**

O Porta-Aviões agora:
- ✅ Não causa erro de variável não definida
- ✅ Desenha corretamente quando selecionado
- ✅ Responde a cliques de mouse
- ✅ Funciona corretamente com o sistema de seleção

---

*Erro corrigido seguindo as boas práticas!* ✅

