# 🛡️ GUIA DE TRATAMENTO DE ERROS ROBUSTO - HEGEMONIA GLOBAL

**Data:** 2025-01-27  
**Objetivo:** Padrões e práticas para tratamento de erros robusto em todo o código

---

## 📋 REGRAS FUNDAMENTAIS

### **1. SEMPRE VERIFICAR EXISTÊNCIA ANTES DE USAR**

#### **Instâncias:**
```gml
// ❌ ERRADO:
var _hp = obj_infantaria.hp_atual;

// ✅ CORRETO:
if (instance_exists(obj_infantaria)) {
    var _hp = obj_infantaria.hp_atual;
}
```

#### **Objetos:**
```gml
// ❌ ERRADO:
instance_create_layer(x, y, "Instances", obj_quartel);

// ✅ CORRETO:
if (object_exists(obj_quartel)) {
    instance_create_layer(x, y, "Instances", obj_quartel);
} else {
    show_debug_message("❌ ERRO: obj_quartel não existe!");
}
```

#### **Data Structures:**
```gml
// ❌ ERRADO:
var _value = global.estoque_recursos[? "Dinheiro"];

// ✅ CORRETO:
if (variable_global_exists("estoque_recursos")) {
    if (ds_exists(global.estoque_recursos, ds_type_map)) {
        var _value = global.estoque_recursos[? "Dinheiro"];
    }
}
```

#### **Variáveis de Instância:**
```gml
// ❌ ERRADO:
var _hp = other.hp_atual;

// ✅ CORRETO:
if (variable_instance_exists(other.id, "hp_atual")) {
    var _hp = other.hp_atual;
}
```

#### **Variáveis Globais:**
```gml
// ❌ ERRADO:
var _dinheiro = global.dinheiro;

// ✅ CORRETO:
if (variable_global_exists("dinheiro")) {
    var _dinheiro = global.dinheiro;
} else {
    // Valor padrão ou inicialização
    global.dinheiro = 1000;
    var _dinheiro = global.dinheiro;
}
```

---

## 🔍 FUNÇÕES DE VERIFICAÇÃO

### **Verificações Comuns:**

| Verificação | Função | Uso |
|------------|--------|-----|
| Instância existe | `instance_exists(id)` | Verificar se instância ainda existe |
| Objeto existe | `object_exists(obj)` | Verificar se objeto está no projeto |
| Data structure existe | `ds_exists(ds, type)` | Verificar se DS foi criada e não destruída |
| Variável de instância | `variable_instance_exists(id, "var")` | Verificar se variável existe na instância |
| Variável global | `variable_global_exists("var")` | Verificar se variável global existe |
| Script existe | `asset_get_index("script") != -1` | Verificar se script existe |

---

## 📝 PADRÕES DE CÓDIGO SEGURO

### **1. Acesso a Instâncias com `with`:**

```gml
// ✅ CORRETO:
if (object_exists(obj_infantaria)) {
    with (obj_infantaria) {
        if (variable_instance_exists(id, "hp_atual")) {
            if (hp_atual <= 0) {
                instance_destroy();
            }
        }
    }
}
```

### **2. Criação de Instâncias:**

```gml
// ✅ CORRETO:
function criar_unidade(_tipo, _x, _y) {
    if (!object_exists(_tipo)) {
        show_debug_message("❌ ERRO: Objeto não existe: " + string(_tipo));
        return noone;
    }
    
    if (!instance_exists(obj_game_manager)) {
        show_debug_message("❌ ERRO: Game Manager não existe!");
        return noone;
    }
    
    var _inst = instance_create_layer(_x, _y, "Instances", _tipo);
    
    if (!instance_exists(_inst)) {
        show_debug_message("❌ ERRO: Falha ao criar instância!");
        return noone;
    }
    
    return _inst;
}
```

### **3. Uso de Data Structures:**

```gml
// ✅ CORRETO:
function adicionar_recurso(_tipo, _quantidade) {
    if (!variable_global_exists("estoque_recursos")) {
        global.estoque_recursos = ds_map_create();
    }
    
    if (!ds_exists(global.estoque_recursos, ds_type_map)) {
        global.estoque_recursos = ds_map_create();
    }
    
    var _atual = 0;
    if (ds_map_exists(global.estoque_recursos, _tipo)) {
        _atual = global.estoque_recursos[? _tipo];
    }
    
    global.estoque_recursos[? _tipo] = _atual + _quantidade;
}
```

### **4. Loops com Instâncias:**

```gml
// ✅ CORRETO:
var _count = 0;
if (object_exists(obj_infantaria)) {
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria")) {
            if (nacao_proprietaria == 1) {
                _count++;
            }
        }
    }
}
```

---

## 🛠️ SISTEMA DE VALIDAÇÃO AUTOMÁTICA

### **Validação Periódica:**

O sistema executa validação automática a cada 5-10 segundos:

```gml
// No obj_game_manager Step Event:
scr_validacao_periodica();
```

### **O que é validado:**

1. **Variáveis Globais Críticas:**
   - `game_frame`, `dinheiro`, `populacao`, `alimento`, etc.
   - Auto-correção: inicializa com valores padrão se faltarem

2. **Instâncias Órfãs:**
   - Detecta instâncias fora dos limites do mapa
   - Detecta instâncias sem variáveis críticas
   - Auto-correção: destrói instâncias órfãs

3. **Data Structures:**
   - Verifica integridade de DS globais
   - Detecta DS corrompidas
   - Auto-correção: recria DS se necessário

4. **Objetos Críticos:**
   - Verifica se objetos essenciais existem
   - Verifica se há instâncias necessárias
   - Auto-correção: cria instâncias faltantes

5. **Recursos:**
   - Valida valores de recursos (não negativos)
   - Auto-correção: corrige valores inválidos

6. **Performance:**
   - Monitora número de instâncias
   - Monitora FPS
   - Alerta se houver problemas

---

## ⚠️ CASOS ESPECIAIS

### **1. Verificação em Loops:**

```gml
// ✅ CORRETO:
var _lista = ds_list_create();
// ... adicionar IDs à lista ...

for (var i = 0; i < ds_list_size(_lista); i++) {
    var _id = ds_list_find_value(_lista, i);
    
    // ✅ SEMPRE VERIFICAR antes de usar
    if (instance_exists(_id)) {
        with (_id) {
            // código seguro
        }
    } else {
        // Remover ID inválido da lista
        ds_list_delete(_lista, i);
        i--; // Ajustar índice
    }
}
```

### **2. Verificação em Collision Events:**

```gml
// ✅ CORRETO:
// Collision Event com obj_infantaria
if (instance_exists(other)) {
    if (variable_instance_exists(other.id, "hp_atual")) {
        if (hp_atual > 0) {
            // Processar colisão
        }
    }
}
```

### **3. Verificação em Alarm Events:**

```gml
// ✅ CORRETO:
// Alarm Event
if (instance_exists(id)) {
    if (variable_instance_exists(id, "alvo")) {
        if (instance_exists(alvo)) {
            // Processar alarme
        } else {
            alvo = noone; // Limpar referência inválida
        }
    }
}
```

---

## 🎯 CHECKLIST DE SEGURANÇA

Antes de usar qualquer recurso, verifique:

- [ ] `instance_exists()` para instâncias
- [ ] `object_exists()` para objetos
- [ ] `ds_exists()` para data structures
- [ ] `variable_instance_exists()` para variáveis de instância
- [ ] `variable_global_exists()` para variáveis globais
- [ ] `asset_get_index() != -1` para assets (scripts, sprites, etc.)

---

## 📊 ESTATÍSTICAS DE VALIDAÇÃO

O sistema mantém estatísticas de validação:

```gml
// Acessar estatísticas (se disponível):
if (variable_global_exists("validacao_stats")) {
    var _total = global.validacao_stats.total_validacoes;
    var _problemas = global.validacao_stats.problemas_encontrados;
    var _correcoes = global.validacao_stats.correcoes_aplicadas;
}
```

---

## 🔧 CONFIGURAÇÃO

### **Intervalo de Validação:**

```gml
// No Create Event do obj_game_manager:
global.validation_interval = 300; // 5 segundos (60 FPS * 5)
global.timer_validacao = global.validation_interval;
```

### **Habilitar/Desabilitar Validação:**

```gml
// Desabilitar validação (não recomendado):
global.validation_interval = -1; // Desabilita

// Habilitar validação mais frequente:
global.validation_interval = 180; // 3 segundos
```

---

## ✅ BENEFÍCIOS

1. **Redução de Erros:** Previne crashes por recursos não encontrados
2. **Auto-Correção:** Corrige problemas automaticamente
3. **Estabilidade:** Sistema mais robusto e confiável
4. **Debug:** Facilita identificação de problemas
5. **Performance:** Detecta problemas de performance precocemente

---

## 🚀 PRÓXIMOS PASSOS

1. ✅ Sistema de validação implementado
2. ✅ Guia de boas práticas criado
3. ⏳ Aplicar padrões em código existente (gradualmente)
4. ⏳ Adicionar mais verificações conforme necessário

