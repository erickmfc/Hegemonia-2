# 🔧 Correção: Arrays de Inimigos — obj_RonaldReagan

**Data:** 26 de Outubro de 2025  
**Erro:** Variable obj_RonaldReagan._inimigos_aereos not set before reading it  
**Status:** ✅ CORRIGIDO

---

## 🐛 Problema Encontrado

### Erro:
```
Variable obj_RonaldReagan._inimigos_aereos(101956, -2147483648) not set before reading it.
 at gml_Object_obj_RonaldReagan_Step_1 (line 58) - array_push(other._inimigos_aereos, id);
```

### Causa:
Arrays eram declarados com `var` (variáveis locais), mas acessados via `other.` dentro de loops `with`.

**Código PROBLEMÁTICO:**
```gml
// ❌ ERRADO - var cria variável LOCAL
var _inimigos_navais = [];
var _inimigos_aereos = [];
var _inimigos_terrestres = [];

// Dentro de 'with' blocks:
with (obj_helicoptero_militar) {
    array_push(other._inimigos_aereos, id); // ❌ Tenta acessar variável que não existe
}
```

**Problema:** Variáveis com `var` são locais ao escopo e não são acessíveis via `other.variável`.

---

## ✅ Solução Aplicada

### Correção:
Arrays agora são variáveis de instância (sem `var`).

**Código CORRIGIDO:**
```gml
// ✅ CORRETO - Variáveis de instância
// Inicializar arrays de inimigos (NÃO usar var - precisa ser variável de instância)
if (!variable_instance_exists(id, "_inimigos_navais")) _inimigos_navais = [];
if (!variable_instance_exists(id, "_inimigos_aereos")) _inimigos_aereos = [];
if (!variable_instance_exists(id, "_inimigos_terrestres")) _inimigos_terrestres = [];

// Limpar arrays a cada step
_inimigos_navais = [];
_inimigos_aereos = [];
_inimigos_terrestres = [];

// Dentro de 'with' blocks:
with (obj_helicoptero_militar) {
    array_push(other._inimigos_aereos, id); // ✅ Agora funciona!
}
```

---

## 📝 Explicação Técnica

### Diferença entre `var` e Variável de Instância:

| Tipo | Escopo | Acessível via `other.` | Persiste entre steps |
|------|--------|----------------------|---------------------|
| `var` | LOCAL ao escopo | ❌ NÃO | ❌ NÃO |
| `sem var` | INSTÂNCIA | ✅ SIM | ✅ SIM |

### Por que importa?
No GameMaker:
- **`var name`** = Variável local, destruída ao final do bloco
- **`name`** = Variável de instância, persistente e acessível

### Exemplo:
```gml
// Step Event:
var _local = [];  // ← Local, destruída ao final

with (obj_other) {
    other._local[0] = 1;  // ❌ ERRO! _local não existe para 'other'
}

// Step Event:
_local = [];  // ← Instância, acessível via other

with (obj_other) {
    other._local[0] = 1;  // ✅ FUNCIONA!
}
```

---

## 🔧 Detalhes da Correção

### Arquivo: `obj_RonaldReagan/Step_1.gml`

**Linhas alteradas:** 19-27

**Antes:**
```gml
var _inimigos_navais = [];
var _inimigos_aereos = [];
var _inimigos_terrestres = [];
```

**Depois:**
```gml
// Inicializar arrays de inimigos (NÃO usar var - precisa ser variável de instância)
if (!variable_instance_exists(id, "_inimigos_navais")) _inimigos_navais = [];
if (!variable_instance_exists(id, "_inimigos_aereos")) _inimigos_aereos = [];
if (!variable_instance_exists(id, "_inimigos_terrestres")) _inimigos_terrestres = [];

// Limpar arrays a cada step
_inimigos_navais = [];
_inimigos_aereos = [];
_inimigos_terrestres = [];
```

---

## 📊 Arrays Corrigidos

| Array | Tipo | Acessado via | Status |
|-------|------|-------------|--------|
| `_inimigos_navais` | Instância | `other._inimigos_navais` | ✅ |
| `_inimigos_aereos` | Instância | `other._inimigos_aereos` | ✅ |
| `_inimigos_terrestres` | Instância | `other._inimigos_terrestres` | ✅ |

---

## ✅ Verificação

**Teste realizado:**
- ✅ Arrays inicializados corretamente
- ✅ Acessíveis via `other.` dentro de loops `with`
- ✅ Limpos a cada step
- ✅ Sem erros de compilação
- ✅ Sem erros de runtime

---

## 📝 Lição Aprendida

**Regra Geral:** Se uma variável precisa ser acessada via `other.` dentro de um loop `with`, **NÃO use `var`**.

**Padrão Correto:**
```gml
// ✅ Use variável de instância (sem var)
_minha_array = [];

// Se precisar acessar de dentro de 'with':
with (obj_other) {
    array_push(other._minha_array, id); // Funciona!
}

// ❌ NÃO use var para arrays acessados via other
var _minha_array = []; // Local, não acessível via other
```

---

## 🎯 Status Final

**Erro:** ✅ CORRIGIDO  
**Compilação:** ✅ SEM ERROS  
**Runtime:** ✅ FUNCIONANDO  

---

**Autor:** AI Assistant  
**Data:** 26 de Outubro de 2025  
**Versão:** 3.1
