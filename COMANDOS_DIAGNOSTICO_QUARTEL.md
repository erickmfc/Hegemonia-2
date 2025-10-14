# 🚀 COMANDOS RÁPIDOS PARA DIAGNÓSTICO

## 🎯 **COMANDOS PRINCIPAIS**

### **DIAGNÓSTICO COMPLETO:**
```gml
scr_diagnostico_quartel_marinha();
```

### **DIAGNÓSTICO DE PROBLEMAS ESPECÍFICOS:**
```gml
scr_diagnostico_problemas_especificos();
```

### **CORREÇÃO AUTOMÁTICA:**
```gml
scr_corrigir_problemas_automaticamente();
```

### **TESTE RÁPIDO DE CLIQUE:**
```gml
scr_teste_clique_quartel();
```

## 🔧 **COMANDOS DE CORREÇÃO RÁPIDA**

### **CORRIGIR LAYER DO MENU:**
```gml
// Corrigir layer do menu automaticamente
with (obj_quartel_marinha) {
    if (menu_recrutamento != noone) {
        instance_destroy(menu_recrutamento);
        menu_recrutamento = noone;
    }
}
```

### **INICIALIZAR SISTEMA DE RECURSOS:**
```gml
// Inicializar sistema de recursos
global.nacao_recursos = ds_map_create();
global.nacao_recursos[? "Dinheiro"] = 10000;
global.nacao_recursos[? "Minério"] = 5000;
global.nacao_recursos[? "Petróleo"] = 3000;
show_debug_message("✅ Sistema de recursos inicializado!");
```

### **CRIAR QUARTEL DE TESTE:**
```gml
// Criar quartel de teste
var _test_quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
if (instance_exists(_test_quartel)) {
    show_debug_message("✅ Quartel de teste criado: " + string(_test_quartel));
} else {
    show_debug_message("❌ Falha ao criar quartel de teste");
}
```

### **TESTAR CRIAÇÃO DO MENU:**
```gml
// Testar criação do menu
var _test_menu = instance_create_layer(0, 0, "rm_mapa_principal", obj_menu_recrutamento_marinha);
if (instance_exists(_test_menu)) {
    show_debug_message("✅ Menu criado com sucesso: " + string(_test_menu));
    instance_destroy(_test_menu);
} else {
    show_debug_message("❌ Falha ao criar menu");
}
```

## 🎮 **SEQUÊNCIA DE TESTES RECOMENDADA**

### **PASSO 1: DIAGNÓSTICO INICIAL**
```gml
scr_diagnostico_quartel_marinha();
```

### **PASSO 2: CORREÇÃO AUTOMÁTICA**
```gml
scr_corrigir_problemas_automaticamente();
```

### **PASSO 3: TESTE DE CLIQUE**
```gml
scr_teste_clique_quartel();
```

### **PASSO 4: DIAGNÓSTICO ESPECÍFICO**
```gml
scr_diagnostico_problemas_especificos();
```

## 🚨 **COMANDOS DE EMERGÊNCIA**

### **LIMPAR TODOS OS MENUS:**
```gml
// Limpar todos os menus abertos
with (obj_menu_recrutamento_marinha) {
    instance_destroy();
}
with (obj_menu_recrutamento) {
    instance_destroy();
}
global.menu_recrutamento_aberto = false;
show_debug_message("✅ Todos os menus foram limpos");
```

### **RESETAR TODOS OS QUARTÉIS:**
```gml
// Resetar seleção de todos os quartéis
with (obj_quartel_marinha) {
    selecionado = false;
    if (menu_recrutamento != noone) {
        instance_destroy(menu_recrutamento);
        menu_recrutamento = noone;
    }
}
with (obj_quartel) {
    selecionado = false;
    if (menu_recrutamento != noone) {
        instance_destroy(menu_recrutamento);
        menu_recrutamento = noone;
    }
}
show_debug_message("✅ Todos os quartéis foram resetados");
```

### **VERIFICAR STATUS GERAL:**
```gml
// Verificar status geral do sistema
show_debug_message("=== STATUS GERAL ===");
show_debug_message("Quartéis navais: " + string(instance_number(obj_quartel_marinha)));
show_debug_message("Quartéis terrestres: " + string(instance_number(obj_quartel)));
show_debug_message("Menus abertos: " + string(instance_number(obj_menu_recrutamento_marinha)));
show_debug_message("Sistema de recursos: " + string(variable_global_exists("nacao_recursos")));
```

## 💡 **DICAS DE USO**

1. **SEMPRE execute o diagnóstico completo primeiro**
2. **Use a correção automática se houver problemas básicos**
3. **Teste o clique após cada correção**
4. **Use comandos de emergência se o sistema travar**

## 🎯 **RESULTADOS ESPERADOS**

### **DIAGNÓSTICO NORMAL:**
- ✅ Todos os objetos existem
- ✅ Layers estão corretas
- ✅ Quartéis estão funcionando
- ✅ Sistema de clique funciona

### **APÓS CORREÇÃO:**
- ✅ Sistema de recursos inicializado
- ✅ Layer criada se necessário
- ✅ Lista de unidades configurada
- ✅ Sistema pronto para uso

**Execute os comandos na ordem recomendada para melhor resultado!**
