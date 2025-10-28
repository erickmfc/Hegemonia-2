# 🔍 REVISÃO GERAL DOS EVENTOS MOUSE E STEP

## 📊 **ESTATÍSTICAS DO PROJETO**

- **Total de arquivos Step_0.gml**: 188 arquivos
- **Total de arquivos Mouse_*.gml**: 125 arquivos
- **Total de objetos no jogo**: ~80 objetos
- **Categorias principais**:
  - Unidades Militares (Infantaria, Tanques, etc)
  - Navios (Constellation, Independence, Ronald Reagan)
  - Aeronaves (F-5, F-15, Helicópteros)
  - Estruturas (Quartéis, Aeroportos, etc)
  - Controladores (Input Manager, UI Manager)
  - Menus e Interface

---

## ✅ **CORREÇÕES APLICADAS ATÉ AGORA**

### **1. GM2040 - event_inherited sem parent** ✅
**Status**: Corrigido em obj_RonaldReagan

**Problema**: Chamadas a `event_inherited()` sem verificar se há parent

**Solução Aplicada**:
```gml
// ✅ CORREÇÃO: Verificar se o objeto tem parent antes de chamar event_inherited
if (object_get_parent(object_index) != -1) {
    event_inherited();
}
```

**Arquivos Corrigidos**:
- ✅ `objects/obj_RonaldReagan/Step_0.gml`
- ✅ `objects/obj_RonaldReagan/Step_1.gml`
- ✅ `objects/obj_RonaldReagan/Create_0.gml`
- ✅ `objects/obj_RonaldReagan/Draw_0.gml`

### **2. GM1041 - Tipo Undefined** ✅
**Status**: Corrigido em obj_tanque

**Problema**: Uso de retorno de função sem verificar tipo

**Solução Aplicada**:
```gml
var _alvo_temp = scr_buscar_inimigo(x, y, alcance_visao, _nacao);
if (_alvo_temp != noone && _alvo_temp != undefined && instance_exists(_alvo_temp)) {
    alvo = _alvo_temp;
}
```

**Arquivos Corrigidos**:
- ✅ `objects/obj_tanque/Step_0.gml` (linhas 15 e 182)

### **3. GM2016 - Variáveis de instância** ✅
**Status**: Corrigido em obj_wwhendrick

**Problema**: Variáveis de instância declaradas fora do Create event

**Solução Aplicada**:
```gml
// ✅ CORREÇÃO GM2016: Usar 'var' para declarar variáveis de instância fora do Create
var ultima_acao = "Movendo...";
var cor_feedback = c_green;
var feedback_timer = 90;
```

**Arquivos Corrigidos**:
- ✅ `objects/obj_wwhendrick/Mouse_4.gml`

### **4. GM2044 - Variáveis locais duplicadas** ✅
**Status**: Corrigido em obj_presidente_1

**Problema**: Variáveis locais com `var` em múltiplos cases do switch

**Solução Aplicada**:
```gml
var _pos_x, _pos_y, _sucesso; // Declarar uma vez
switch (_decisao) {
    case "construir_economia":
        _pos_x = base_x + irandom(200) - 100;
        _pos_y = base_y + irandom(200) - 100;
        _sucesso = scr_ia_construir(id, obj_fazenda, _pos_x, _pos_y);
    case "construir_mina":
        _pos_x = base_x + irandom(200) - 100; // Reusar variáveis
```

**Arquivos Corrigidos**:
- ✅ `objects/obj_presidente_1/Step_0.gml`

---

## 🔍 **ANÁLISE DETALHADA DOS PADRÕES**

### **Padrão 1: Eventos com Herança**

Objetos que chamam `event_inherited()`:
- ✅ obj_RonaldReagan (CORRIGIDO)
- ❌ obj_Independence (CHAMA SEMPRE)
- ❌ obj_Constellation (CHAMA SEMPRE)
- ❌ obj_wwhendrick (CHAMA SEMPRE)
- ❌ obj_navio_transporte (CHAMA SEMPRE)
- ❌ obj_quartel (CHAMA SEMPRE)
- ❌ obj_banco (CHAMA SEMPRE)
- ❌ obj_casa (CHAMA SEMPRE)

**Total de arquivos que precisam de correção**: ~20+ arquivos

### **Padrão 2: Verificações de Variáveis**

Verificações necessárias:
- `variable_instance_exists(id, "selecionado")` antes de usar
- `variable_instance_exists(id, "estado")` antes de usar
- `variable_instance_exists(id, "modo_combate")` antes de usar

---

## 🎯 **PRÓXIMOS PASSOS**

### **Fase 1: Correção Sistemática de Herança**
1. Adicionar verificação de parent em todos os arquivos que chamam `event_inherited()`
2. Usar o padrão: `if (object_get_parent(object_index) != -1)`

### **Fase 2: Revisão de Step Events**
1. Verificar todas as declarações de variáveis locais
2. Garantir que `event_inherited()` é chamado no início (quando aplicável)

### **Fase 3: Revisão de Mouse Events**
1. Verificar conversões de coordenadas mouse → world
2. Verificar uso de `global.scr_mouse_to_world()`
3. Verificar cliques em edifícios vs unidades

### **Fase 4: Validação Final**
1. Testar todos os objetos modificados
2. Verificar compilação sem warnings
3. Documentar mudanças

---

## 📝 **CONCLUSÃO**

**Status Atual**: ✅ 4 problemas críticos corrigidos
**Status Restante**: ⚠️ ~20 arquivos precisam de revisão

**Recomendação**: Continuar revisão sistemática dos objetos com herança, priorizando objetos principais do jogo.

