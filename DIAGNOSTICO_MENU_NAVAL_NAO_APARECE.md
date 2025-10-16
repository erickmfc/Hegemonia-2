# 🔍 DIAGNÓSTICO: MENU NAVAL NÃO APARECE

## 📋 **PROBLEMA IDENTIFICADO**

O menu de recrutamento naval não está sendo mostrado no jogo, mesmo quando o quartel é clicado.

---

## 🔍 **POSSÍVEIS CAUSAS IDENTIFICADAS**

### **1. ❌ PROBLEMA DE LAYER**
**Causa**: Menu sendo criado na layer "GUI" que pode não existir ou não estar visível

**Sintomas**:
- Menu é criado mas não aparece na tela
- Debug mostra "Menu criado com sucesso" mas nada é visível

**Solução**:
```gml
// Verificar se layer existe antes de criar
if (!layer_exists("GUI")) {
    layer_create(-100, "GUI");
}

// OU criar na layer "Instances" (mais segura)
menu_recrutamento = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
```

### **2. ❌ PROBLEMA DE COORDENADAS**
**Causa**: Menu sendo criado na posição (0,0) que pode estar fora da tela

**Sintomas**:
- Menu existe mas está em posição incorreta
- Menu aparece mas fora da área visível

**Solução**:
```gml
// Criar menu na posição central da tela
var _center_x = display_get_gui_width() / 2;
var _center_y = display_get_gui_height() / 2;
menu_recrutamento = instance_create_layer(_center_x, _center_y, "GUI", obj_menu_recrutamento_marinha);
```

### **3. ❌ PROBLEMA DE VISIBILIDADE**
**Causa**: Menu sendo criado mas com `visible = false` ou `alpha = 0`

**Sintomas**:
- Menu existe mas é invisível
- Debug mostra menu criado mas nada aparece

**Solução**:
```gml
// Garantir que menu é visível
if (instance_exists(menu_recrutamento)) {
    menu_recrutamento.visible = true;
    menu_recrutamento.image_alpha = 1.0;
}
```

### **4. ❌ PROBLEMA DE DEPTH**
**Causa**: Menu sendo criado com depth muito baixo, ficando atrás de outros objetos

**Sintomas**:
- Menu existe mas está atrás de outros elementos
- Menu aparece mas é coberto por outros objetos

**Solução**:
```gml
// Criar menu com depth alto para ficar na frente
menu_recrutamento = instance_create_layer(0, 0, "GUI", obj_menu_recrutamento_marinha);
if (instance_exists(menu_recrutamento)) {
    menu_recrutamento.depth = -1000; // Depth muito alto
}
```

### **5. ❌ PROBLEMA DE EVENTOS**
**Causa**: Create event do menu não está executando ou tem erro

**Sintomas**:
- Menu é criado mas não inicializa corretamente
- Variáveis do menu não são definidas

**Solução**:
```gml
// Verificar se Create event executou
if (instance_exists(menu_recrutamento)) {
    if (!variable_instance_exists(menu_recrutamento, "meu_quartel_id")) {
        // Create event não executou, configurar manualmente
        menu_recrutamento.meu_quartel_id = id;
    }
}
```

### **6. ❌ PROBLEMA DE CONFLITO**
**Causa**: Outro sistema está destruindo o menu imediatamente após criação

**Sintomas**:
- Menu é criado mas é destruído no mesmo frame
- Debug mostra criação e destruição rápida

**Solução**:
```gml
// Verificar se menu ainda existe após criação
if (instance_exists(menu_recrutamento)) {
    show_debug_message("✅ Menu criado e ainda existe");
} else {
    show_debug_message("❌ Menu foi destruído imediatamente!");
}
```

---

## 🛠️ **SOLUÇÕES IMPLEMENTADAS**

### **1. ✅ Script de Diagnóstico Criado**
**Arquivo**: `scr_diagnostico_menu_naval.gml`

**Para usar**:
```gml
// No quartel naval ou em qualquer lugar:
scr_diagnostico_menu_naval(id_do_quartel);
```

**O que faz**:
- ✅ Verifica se quartel existe
- ✅ Verifica se objeto do menu existe
- ✅ Verifica se layer GUI existe
- ✅ Limpa menus existentes
- ✅ Tenta criar menu
- ✅ Verifica se menu foi criado
- ✅ Verifica eventos do menu
- ✅ Verifica recursos e fontes

### **2. ✅ Correção no Quartel Naval**
**Problema**: Menu sendo criado na layer "GUI" que pode não existir

**Solução**: Verificar e criar layer se necessário
```gml
// Verificar se layer GUI existe, se não, criar
if (!layer_exists("GUI")) {
    show_debug_message("Criando layer GUI...");
    layer_create(-100, "GUI");
}
```

### **3. ✅ Verificação de Recursos**
**Problema**: Menu pode não aparecer se recursos não existem

**Solução**: Verificar e criar recursos se necessário
```gml
// Verificar dinheiro
if (!variable_global_exists("dinheiro")) {
    global.dinheiro = 10000;
}

// Verificar fontes
if (!font_exists(fnt_ui_main)) {
    // Usar fonte padrão
}
```

---

## 🧪 **COMO TESTAR**

### **1. Executar Diagnóstico**
```gml
// No quartel naval ou em qualquer lugar:
scr_diagnostico_menu_naval(id_do_quartel);
```

### **2. Verificar Debug Messages**
O script mostrará:
- ✅ Se quartel existe
- ✅ Se objeto do menu existe
- ✅ Se layer GUI existe
- ✅ Se menu foi criado
- ✅ Se menu está configurado
- ✅ Se eventos executaram

### **3. Testar Criação Manual**
```gml
// Teste simples:
var _menu = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
if (instance_exists(_menu)) {
    show_debug_message("✅ Menu criado manualmente!");
} else {
    show_debug_message("❌ Falha ao criar menu manualmente!");
}
```

---

## 📊 **CHECKLIST DE VERIFICAÇÃO**

### **✅ VERIFICAÇÕES BÁSICAS:**
1. **Quartel existe?** - Verificar se `instance_exists(quartel)`
2. **Objeto menu existe?** - Verificar se `object_exists(obj_menu_recrutamento_marinha)`
3. **Layer existe?** - Verificar se `layer_exists("GUI")`
4. **Menu foi criado?** - Verificar se `instance_exists(menu)`
5. **Menu é visível?** - Verificar se `menu.visible == true`

### **✅ VERIFICAÇÕES AVANÇADAS:**
1. **Create event executou?** - Verificar se `variable_instance_exists(menu, "meu_quartel_id")`
2. **Step event executa?** - Verificar se `variable_instance_exists(menu, "debug_step_executado")`
3. **Draw event executa?** - Verificar se menu aparece na tela
4. **Recursos existem?** - Verificar se `global.dinheiro` existe
5. **Fontes existem?** - Verificar se `font_exists(fnt_ui_main)`

---

## 🎯 **PRÓXIMOS PASSOS**

### **1. Executar Diagnóstico**
```gml
scr_diagnostico_menu_naval(id_do_quartel);
```

### **2. Analisar Resultados**
- Se menu foi criado mas não aparece → Problema de layer/coordenadas
- Se menu não foi criado → Problema de objeto/layer
- Se menu é destruído → Problema de conflito

### **3. Aplicar Correção Específica**
- **Layer**: Criar layer GUI ou usar "Instances"
- **Coordenadas**: Usar posição central da tela
- **Visibilidade**: Garantir `visible = true`
- **Depth**: Usar depth alto
- **Conflito**: Verificar outros sistemas

---

## ✅ **RESULTADO ESPERADO**

Após executar o diagnóstico e aplicar as correções:

1. ✅ Menu aparece na tela quando quartel é clicado
2. ✅ Menu mostra informações do quartel
3. ✅ Botões funcionam corretamente
4. ✅ Menu fecha com Escape
5. ✅ Sistema de recrutamento funciona

**Execute o diagnóstico para identificar a causa específica!** 🔍

---

*Diagnóstico completo criado para resolver o problema do menu não aparecer!*
