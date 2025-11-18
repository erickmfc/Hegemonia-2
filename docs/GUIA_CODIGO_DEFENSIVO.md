# 🛡️ GUIA DE CÓDIGO DEFENSIVO - QUANDO USAR VERIFICAÇÕES

**Data:** 2025-01-27  
**Objetivo:** Diretrizes claras sobre quando usar verificações defensivas no código

---

## 🎯 PRINCÍPIO FUNDAMENTAL

**Use verificações defensivas apenas quando necessário. Código excessivamente defensivo:**
- Torna o código mais difícil de ler
- Adiciona overhead de performance
- Esconde problemas de design
- Cria falsa sensação de segurança

---

## ✅ CASOS ONDE VERIFICAÇÕES SÃO NECESSÁRIAS

### 1. Instâncias que Podem Ser Destruídas

```gml
// ✅ CORRETO: Instância pode ser destruída durante combate
function scr_atacar_alvo(_alvo) {
    if (!instance_exists(_alvo)) {
        return false; // Alvo já foi destruído
    }
    
    // Processar ataque
    _alvo.hp_atual -= dano;
    return true;
}
```

**Quando usar:**
- Acesso a instâncias que podem ser destruídas
- Loops que iteram sobre instâncias
- Eventos que podem executar após destruição

---

### 2. Variáveis Globais que Podem Não Existir

```gml
// ✅ CORRETO: Variável global pode não ter sido inicializada
function scr_obter_recurso(_tipo) {
    if (!variable_global_exists("estoque_recursos")) {
        // Inicializar se não existir
        global.estoque_recursos = ds_map_create();
    }
    
    return global.estoque_recursos[? _tipo];
}
```

**Quando usar:**
- Variáveis globais que podem não ter sido inicializadas
- Sistemas que podem ser carregados em ordem diferente
- Modos de debug/teste

---

### 3. Data Structures que Podem Ser Destruídas

```gml
// ✅ CORRETO: DS pode ter sido destruída
function scr_adicionar_unidade(_unidade) {
    if (!ds_exists(global.lista_unidades, ds_type_list)) {
        global.lista_unidades = ds_list_create();
    }
    
    ds_list_add(global.lista_unidades, _unidade);
}
```

**Quando usar:**
- Data structures que podem ser limpas/destruídas
- Sistemas de pooling que reutilizam DS
- Limpeza automática de memória

---

### 4. Funções Genéricas/Utilitárias

```gml
// ✅ CORRETO: Função genérica deve validar entrada
function scr_obter_hp(_id) {
    if (!instance_exists(_id)) return -1;
    if (!variable_instance_exists(_id, "hp_atual")) return -1;
    return _id.hp_atual;
}
```

**Quando usar:**
- Funções que recebem parâmetros externos
- APIs públicas que podem ser chamadas incorretamente
- Funções de debug/diagnóstico

---

### 5. Acesso a Recursos de Outros Objetos

```gml
// ✅ CORRETO: Outro objeto pode não ter a variável
function scr_processar_colisao(_other) {
    if (!variable_instance_exists(_other.id, "hp_atual")) {
        return; // Objeto não tem HP
    }
    
    _other.hp_atual -= dano;
}
```

**Quando usar:**
- Acesso a variáveis de outros objetos
- Sistemas que trabalham com múltiplos tipos de objetos
- Herança e polimorfismo

---

## ❌ CASOS ONDE VERIFICAÇÕES SÃO DESNECESSÁRIAS

### 1. Variáveis de Instância Própria

```gml
// ❌ ERRADO: Variável própria sempre existe
function scr_atualizar_hp() {
    if (variable_instance_exists(id, "hp_atual")) {
        hp_atual -= dano;
    }
}

// ✅ CORRETO: Acesso direto
function scr_atualizar_hp() {
    hp_atual -= dano;
}
```

**Por quê:** Variáveis de instância própria são garantidas se definidas no Create.

---

### 2. Objetos Definidos no Projeto

```gml
// ❌ ERRADO: Objeto existe no projeto
function scr_criar_quartel() {
    if (object_exists(obj_quartel)) {
        instance_create_layer(x, y, "Instances", obj_quartel);
    }
}

// ✅ CORRETO: Acesso direto
function scr_criar_quartel() {
    instance_create_layer(x, y, "Instances", obj_quartel);
}
```

**Por quê:** Se o objeto não existe, o problema é de configuração do projeto, não de runtime.

---

### 3. Variáveis Locais

```gml
// ❌ ERRADO: Variável local sempre existe no escopo
function scr_calcular() {
    var _temp = 10;
    if (variable_instance_exists(id, "_temp")) {
        _temp += 5;
    }
}

// ✅ CORRETO: Acesso direto
function scr_calcular() {
    var _temp = 10;
    _temp += 5;
}
```

**Por quê:** Variáveis locais são garantidas no escopo onde foram declaradas.

---

### 4. Enums e Constantes

```gml
// ❌ ERRADO: Enum sempre existe
function scr_definir_estado() {
    if (variable_global_exists("EstadoUnidade")) {
        estado = EstadoUnidade.PARADO;
    }
}

// ✅ CORRETO: Acesso direto
function scr_definir_estado() {
    estado = EstadoUnidade.PARADO;
}
```

**Por quê:** Enums são definidos em tempo de compilação.

---

### 5. Variáveis Inicializadas no Create

```gml
// Create_0.gml
hp_atual = 100;
hp_max = 100;

// Step_0.gml
// ❌ ERRADO: Variável foi inicializada no Create
if (variable_instance_exists(id, "hp_atual")) {
    var _percent = hp_atual / hp_max;
}

// ✅ CORRETO: Acesso direto
var _percent = hp_atual / hp_max;
```

**Por quê:** Variáveis inicializadas no Create são garantidas em todos os eventos.

---

## 🎯 DECISÃO RÁPIDA: USAR OU NÃO?

### Use verificação se:
- ✅ O recurso pode não existir
- ✅ O recurso pode ser destruído durante execução
- ✅ A função é genérica/pública
- ✅ Há risco real de erro em runtime

### Não use verificação se:
- ❌ O recurso é garantido (variável própria, objeto do projeto)
- ❌ A verificação adiciona complexidade sem benefício
- ❌ O código fica mais difícil de ler
- ❌ O problema é de configuração, não de runtime

---

## 📊 EXEMPLOS PRÁTICOS

### Exemplo 1: Sistema de Combate

```gml
// ✅ BOM: Verificação necessária (alvo pode ser destruído)
function scr_processar_ataque(_alvo) {
    if (!instance_exists(_alvo)) return false;
    if (!variable_instance_exists(_alvo.id, "hp_atual")) return false;
    
    _alvo.hp_atual -= dano;
    return true;
}

// ❌ RUIM: Verificação desnecessária (variável própria)
function scr_receber_dano(_dano) {
    if (variable_instance_exists(id, "hp_atual")) {
        hp_atual -= _dano;
    }
}

// ✅ BOM: Acesso direto
function scr_receber_dano(_dano) {
    hp_atual -= _dano;
}
```

### Exemplo 2: Sistema de Recursos

```gml
// ✅ BOM: Verificação necessária (DS pode não existir)
function scr_adicionar_recurso(_tipo, _quantidade) {
    if (!ds_exists(global.estoque_recursos, ds_type_map)) {
        global.estoque_recursos = ds_map_create();
    }
    global.estoque_recursos[? _tipo] += _quantidade;
}

// ❌ RUIM: Verificação desnecessária (variável local)
function scr_calcular_total() {
    var _total = 0;
    if (variable_instance_exists(id, "_total")) {
        _total = dinheiro + minerio;
    }
}

// ✅ BOM: Acesso direto
function scr_calcular_total() {
    var _total = dinheiro + minerio;
    return _total;
}
```

---

## 🔧 REFATORAÇÃO: REDUZINDO CÓDIGO DEFENSIVO

### Antes (Excessivo):
```gml
function scr_atacar() {
    if (instance_exists(alvo)) {
        if (variable_instance_exists(alvo.id, "hp_atual")) {
            if (variable_instance_exists(id, "dano")) {
                alvo.hp_atual -= dano;
                if (variable_instance_exists(alvo.id, "hp_max")) {
                    if (alvo.hp_atual <= 0) {
                        if (instance_exists(alvo)) {
                            instance_destroy(alvo);
                        }
                    }
                }
            }
        }
    }
}
```

### Depois (Adequado):
```gml
function scr_atacar() {
    if (!instance_exists(alvo)) return;
    
    alvo.hp_atual -= dano;
    
    if (alvo.hp_atual <= 0) {
        instance_destroy(alvo);
    }
}
```

**Benefícios:**
- Código mais limpo e legível
- Menos overhead de performance
- Mais fácil de manter
- Erros são mais fáceis de identificar

---

## 📚 RESUMO

| Situação | Usar Verificação? | Motivo |
|----------|-------------------|--------|
| Variável própria | ❌ Não | Sempre existe |
| Objeto do projeto | ❌ Não | Problema de configuração |
| Variável local | ❌ Não | Sempre existe no escopo |
| Instância externa | ✅ Sim | Pode ser destruída |
| Variável global | ✅ Sim | Pode não existir |
| Data structure | ✅ Sim | Pode ser destruída |
| Função genérica | ✅ Sim | Parâmetros externos |

---

**Última atualização:** 2025-01-27

