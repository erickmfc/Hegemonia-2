# 📋 ERROS COMUNS - HEGEMONIA GLOBAL

## 🔴 Lista Completa de Erros e Soluções

---

## 1. VARIABLE NOT SET BEFORE READING IT

**ERRO**: `Variable <variable_name> not set before reading it`  
**CAUSA**: Variável usada antes de ser definida.  
**EXEMPLO ERRADO**:
```gml
// Step_0.gml
alcance_visao = 1000; // ← Variável não definida no Create_0
```

**SOLUÇÃO**:
```gml
// Create_0.gml (sempre definir PRIMEIRO)
event_inherited();
alcance_visao = 1000;

// Step_0.gml (usar depois)
show_debug_message("Alcance: " + string(alcance_visao));
```

**PREVENÇÃO**: Sempre definir variáveis no Create_0.gml antes de usar.

---

## 2. FUNCTION CANNOT BE FOUND

**ERRO**: `Function <function_name> cannot be found`  
**CAUSA**: Função chamada não existe.  
**EXEMPLO ERRADO**:
```gml
func_minha_funcao(); // ← Função não existe
```

**SOLUÇÃO**:
```gml
// Verificar se existe
if (script_exists(func_minha_funcao)) {
    func_minha_funcao();
}

// OU criar a função
func_minha_funcao = function() {
    show_debug_message("Função chamada!");
};
```

**PREVENÇÃO**: Verificar existência com `script_exists()`.

---

## 3. OBJECT DOES NOT EXIST

**ERRO**: `Object obj_meu_navio does not exist`  
**CAUSA**: Objeto referenciado não existe.  
**EXEMPLO ERRADO**:
```gml
var _navio = instance_create_layer(x, y, "Instances", obj_meu_navio);
// ← obj_meu_navio não existe
```

**SOLUÇÃO**:
```gml
// Verificar existência
if (object_exists(obj_meu_navio)) {
    var _navio = instance_create_layer(x, y, "Instances", obj_meu_navio);
} else {
    show_debug_message("ERRO: obj_meu_navio não existe!");
}
```

**PREVENÇÃO**: Sempre usar `object_exists()` antes de criar instância.

---

## 4. UNDEFINED GLOBAL VARIABLE

**ERRO**: `Undefined global variable global.dinheiro`  
**CAUSA**: `global.variavel` não foi criada.  
**EXEMPLO ERRADO**:
```gml
global.dinheiro = 1000; // ← Criação incorreta
```

**SOLUÇÃO**:
```gml
// Criar no obj_game_manager (ou no primeiro objeto do jogo)
global.dinheiro = 1000;

// Usar depois
show_debug_message("Dinheiro: " + string(global.dinheiro));
```

**PREVENÇÃO**: Criar variáveis global no início do jogo.

---

## 5. DIVISION BY ZERO

**ERRO**: `Division by zero`  
**CAUSA**: Divisão por zero.  
**EXEMPLO ERRADO**:
```gml
var _dano_medio = hp_atual / 0; // ← Divisão por zero
```

**SOLUÇÃO**:
```gml
// Validar antes de dividir
if (total_tiros > 0) {
    var _dano_medio = dano_total / total_tiros;
} else {
    var _dano_medio = 0;
}
```

**PREVENÇÃO**: Sempre validar divisor antes de dividir.

---

## 6. ARRAY INDEX OUT OF BOUNDS

**ERRO**: `Array index out of bounds`  
**CAUSA**: Acesso a índice inválido.  
**EXEMPLO ERRADO**:
```gml
var _array = [1, 2, 3];
var _valor = _array[10]; // ← Índice 10 não existe
```

**SOLUÇÃO**:
```gml
var _array = [1, 2, 3];
if (_index >= 0 && _index < array_length(_array)) {
    var _valor = _array[_index];
} else {
    show_debug_message("ERRO: Índice inválido!");
}
```

**PREVENÇÃO**: Sempre validar índice antes de acessar.

---

## 7. CANNOT ACCESS DS_LIST

**ERRO**: `Cannot access ds_list`  
**CAUSA**: Tentar usar ds_list destruída.  
**EXEMPLO ERRADO**:
```gml
ds_list_destroy(unidades_disponiveis);
ds_list_add(unidades_disponiveis, 1); // ← Lista já foi destruída
```

**SOLUÇÃO**:
```gml
// Verificar antes de usar
if (ds_exists(unidades_disponiveis, ds_type_list)) {
    ds_list_add(unidades_disponiveis, 1);
} else {
    show_debug_message("ERRO: Lista não existe!");
}
```

**PREVENÇÃO**: Sempre verificar com `ds_exists()`.

---

## 8. INSTANCE DOES NOT EXIST

**ERRO**: `Instance does not exist`  
**CAUSA**: Acesso a instância destruída.  
**EXEMPLO ERRADO**:
```gml
if (instance_exists(alvo_unidade)) {
    alvo_unidade.hp_atual -= 10;
}
// ... outro código ...
alvo_unidade.x = 100; // ← Instância pode ter sido destruída
```

**SOLUÇÃO**:
```gml
if (instance_exists(alvo_unidade)) {
    alvo_unidade.hp_atual -= 10;
    alvo_unidade.x = 100; // Tudo dentro do if
}
```

**PREVENÇÃO**: Sempre verificar `instance_exists()` antes de usar.

---

## 9. STRING CANNOT BE CONVERTED TO NUMBER

**ERRO**: `String cannot be converted to number`  
**CAUSA**: Uso de string como número.  
**EXEMPLO ERRADO**:
```gml
var _valor = "100" + 5; // ← Resultado: "1005" (string)
var _soma = _valor + 10; // ← ERRO: não pode somar string + número
```

**SOLUÇÃO**:
```gml
var _valor = real("100") + 5; // ← Correto: 105
var _soma = _valor + 10; // ← Resultado: 115
```

**PREVENÇÃO**: Converter com `real()` ou `string()`.

---

## 10. CANNOT FIND CONSTRUCTOR FOR SET

**ERRO**: `Cannot find constructor for set`  
**CAUSA**: Inicialização de `ds_set` incorreta.  
**EXEMPLO ERRADO**:
```gml
var _set = ds_set_create(); // ← Correto
var _set2 = ds_set_clear(_set); // ← ERRO: usar 2x
```

**SOLUÇÃO**:
```gml
// Criar
var _set = ds_set_create();

// Usar
ds_set_add(_set, 100);
ds_set_clear(_set); // Limpar

// Destruir
ds_set_destroy(_set);
```

**PREVENÇÃO**: Nunca chamar `ds_set_create()` duas vezes na mesma variável.

---

## 11. VARIABLE <variable> NOT SET BEFORE READING IT (NÃO É DONO)

**ERRO**: Variável usada fora do objeto.  
**CAUSA**: Acesso a `other.variable` sem `other.`  
**EXEMPLO ERRADO**:
```gml
with (obj_navio_base) {
    velocidade_movimento = 5; // ← Mesma variável, mas não especifica objeto
}
```

**SOLUÇÃO**:
```gml
// Para variável do objeto ALVO
with (obj_navio_base) {
    other.velocidade_movimento = 5; // ← other. = objeto que chamou "with"
}

// OU (para variável do objeto ATUAL)
with (obj_navio_base) {
    velocidade_movimento = 5; // ← Variável do obj_navio_base
}
```

**PREVENÇÃO**: Usar `other.` para variáveis do objeto que chamou `with`.

---

## 12. CAMNOT ACCESS THIS IN CURRENT SCOPE

**ERRO**: `Cannot access this in current scope`  
**CAUSA**: Uso de `this`/`self` em contexto errado.  
**EXEMPLO ERRADO**:
```gml
with (obj_inimigo) {
    show_debug_message(this.id); // ← ERRO: "this" não existe em "with"
}
```

**SOLUÇÃO**:
```gml
with (obj_inimigo) {
    show_debug_message(id); // ← Sem "this", já estamos no escopo do objeto
}
```

**PREVENÇÃO**: Não usar `this`/`self` dentro de blocos `with`.

---

## 13. EXPECTED A FUNCTION

**ERRO**: `Expected a function`  
**CAUSA**: Variável não é função.  
**EXEMPLO ERRADO**:
```gml
func_atacar = 100; // ← Não é função
func_atacar(); // ← ERRO
```

**SOLUÇÃO**:
```gml
func_atacar = function() {
    show_debug_message("Ataque!");
};

// OU verificar antes
if (is_method(func_atacar)) {
    func_atacar();
}
```

**PREVENÇÃO**: Sempre usar `function()` para criar funções.

---

## 14. DS_QUEUE IS EMPTY

**ERRO**: `ds_queue is empty`  
**CAUSA**: Dequeue em fila vazia.  
**EXEMPLO ERRADO**:
```gml
var _unidade = ds_queue_dequeue(fila_producao); // ← Fila vazia
```

**SOLUÇÃO**:
```gml
if (!ds_queue_empty(fila_producao)) {
    var _unidade = ds_queue_dequeue(fila_producao);
} else {
    show_debug_message("ERRO: Fila vazia!");
}
```

**PREVENÇÃO**: Sempre verificar `ds_queue_empty()` antes de dequeue.

---

## 15. CALLING A FUNCTION WITH INCORRECT NUMBER OF ARGUMENTS

**ERRO**: `Calling a function with incorrect number of arguments`  
**CAUSA**: Número de parâmetros errado.  
**EXEMPLO ERRADO**:
```gml
func_atacar_alvo(_alvo, _dano, _distancia); // ← Espera 2 parâmetros, passou 3
```

**SOLUÇÃO**:
```gml
// Verificar assinatura
func_atacar_alvo = function(alvo, dano) {
    // ... código ...
};

// Chamar corretamente
func_atacar_alvo(_alvo, _dano); // ← 2 parâmetros
```

**PREVENÇÃO**: Verificar número de parâmetros antes de chamar.

---

## 16. LAYER DOES NOT EXIST

**ERRO**: `Layer does not exist`  
**CAUSA**: Tentar criar em layer inexistente.  
**EXEMPLO ERRADO**:
```gml
var _unit = instance_create_layer(x, y, "Instnces", obj_tanque); // ← Typo
```

**SOLUÇÃO**:
```gml
// Verificar existência
if (layer_exists("Instances")) {
    var _unit = instance_create_layer(x, y, "Instances", obj_tanque);
} else {
    show_debug_message("ERRO: Layer não existe!");
}
```

**PREVENÇÃO**: Verificar `layer_exists()` ou não ter typos.

---

## 17. VARIABLE_INSTANCE_EXISTS RETURNS FALSE

**ERRO**: `variable_instance_exists` retorna false.  
**CAUSA**: Variável não existe na instância.  
**EXEMPLO ERRADO**:
```gml
if (variable_instance_exists(alvo, "hp_atual")) {
    alvo.hp_atual -= 10; // ← Variável não existe
}
```

**SOLUÇÃO**:
```gml
// Criar variável ANTES de usar
alvo.hp_atual = 100; // ← CRIAR primeiro

if (variable_instance_exists(alvo, "hp_atual")) {
    alvo.hp_atual -= 10; // ← Usar depois
}
```

**PREVENÇÃO**: Criar variáveis no Create_0 do objeto alvo.

---

## 18. ANGLE_LERP RETURNS NaN

**ERRO**: `angle_lerp returns NaN`  
**CAUSA**: Ângulos inválidos.  
**EXEMPLO ERRADO**:
```gml
var _angle = angle_lerp(0, 360); // ← Valores incorretos
```

**SOLUÇÃO**:
```gml
// Validar ângulos
var _angle1 = angle_normalize(0);
var _angle2 = angle_normalize(360);

// Usar valores válidos
var _angle = angle_lerp(_angle1, _angle2, 0.5);
```

**PREVENÇÃO**: Usar `angle_normalize()` antes.

---

## 19. WITH STATEMENT CANNOT BE NULL

**ERRO**: `With statement cannot be null`  
**CAUSA**: Objeto inexistente em `with`.  
**EXEMPLO ERRADO**:
```gml
with (noone) {
    show_debug_message("Teste"); // ← noone não existe
}
```

**SOLUÇÃO**:
```gml
// Verificar antes de with
if (instance_exists(_objeto)) {
    with (_objeto) {
        show_debug_message("Teste");
    }
}
```

**PREVENÇÃO**: Sempre verificar existência antes de `with`.

---

## 20. CANNOT DESTROY INSTANCE

**ERRO**: `Cannot destroy instance`  
**CAUSA**: Tentar destruir instância já destruída.  
**EXEMPLO ERRADO**:
```gml
instance_destroy();
// ... código ...
instance_destroy(); // ← ERRO: já destruído
```

**SOLUÇÃO**:
```gml
if (instance_exists(id)) {
    instance_destroy();
} else {
    // Já foi destruído
}
```

**PREVENÇÃO**: Verificar `instance_exists()` antes de destruir.

---

## 📚 CHECKLIST DE PREVENÇÃO

### **ANTES DE USAR VARIÁVEL:**
- [ ] Variável foi definida no Create_0.gml?
- [ ] Verificado com `variable_instance_exists()`?
- [ ] Não está acessando de objeto errado?

### **ANTES DE CRIAR INSTÂNCIA:**
- [ ] Objeto existe com `object_exists()`?
- [ ] Layer existe com `layer_exists()`?
- [ ] Parâmetros estão corretos?

### **ANTES DE USAR DS STRUCTURE:**
- [ ] Verificado com `ds_exists()`?
- [ ] Não está vazia (se for queue/list)?
- [ ] Criada com função correta?

### **ANTES DE CHAMAR FUNÇÃO:**
- [ ] Função existe com `script_exists()`?
- [ ] Número de parâmetros correto?
- [ ] Parâmetros são do tipo correto?

### **EM BLOCOS WITH:**
- [ ] Uso correto de `other.`?
- [ ] Não uso de `this`?
- [ ] Variáveis do objeto correto?

---

## 🛠️ MÉTODOS DE DEBUG

### **1. Verificar Existência:**
```gml
// Objeto
if (object_exists(obj_meu_navio)) { }

// Instância
if (instance_exists(_instancia)) { }

// Estrutura de dados
if (ds_exists(_lista, ds_type_list)) { }

// Variável
if (variable_instance_exists(alvo, "hp_atual")) { }

// Layer
if (layer_exists("Instances")) { }

// Script/Função
if (script_exists(scr_minha_funcao)) { }
```

### **2. Debug de Valores:**
```gml
show_debug_message("Variável: " + string(minha_variavel));
show_debug_message("Tipo: " + typeof(minha_variavel));
show_debug_message("ID: " + string(id));
```

### **3. Verificar Estado:**
```gml
show_debug_message("Estado: " + string(estado));
show_debug_message("HP: " + string(hp_atual) + "/" + string(hp_max));
show_debug_message("Alvo: " + string(alvo_unidade));
```

---

## ✅ BOAS PRÁTICAS

### **1. Sempre usar event_inherited() no início:**
```gml
// Create_0.gml
event_inherited(); // ✅ PRIMEIRA LINHA

// Variáveis depois
nome_unidade = "Meu Navio";
```

### **2. Validar antes de usar:**
```gml
if (instance_exists(alvo)) {
    alvo.hp_atual -= 10;
}
```

### **3. Debug constante:**
```gml
show_debug_message("DEBUG: Estado=" + string(estado));
```

### **4. Verificar erros de inicialização:**
```gml
if (!variable_instance_exists(id, "minha_variavel")) {
    minha_variavel = valor_padrao;
}
```

---

*Guia completo de erros comuns em Hegemonia Global!*

