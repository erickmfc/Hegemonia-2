# 🌊 WW-HENDRICK CONFIGURADO NO QUARTEL DE MARINHA

## 📋 **MODIFICAÇÕES REALIZADAS**

### **1. Menu do Quartel de Marinha**

**Antes:**
- obj_submarino_base no menu (custava $2000)

**Agora:**
- Apenas obj_wwhendrick no menu
- Custo: $2500
- População: 12
- Tempo: 10 segundos

### **2. Sistema de Seleção**

**Adicionado em obj_input_manager/Step_0.gml:**
```90:94:objects/obj_input_manager/Step_0.gml
        } else if (instance_exists(_unidade_wwhendrick)) {
            // Seleciona Ww-Hendrick
            global.unidade_selecionada = _unidade_wwhendrick;
            _unidade_wwhendrick.selecionado = true;
            show_debug_message("🌊 Ww-Hendrick selecionado!");
```

**Prioridade:** Ww-Hendrick é verificado ANTES dos outros navios

### **3. Sistema de Clique**

**Mouse_0.gml - Submersão/Emergência:**
```6:25:objects/obj_wwhendrick/Mouse_0.gml
// Clique esquerdo - Alternar Submersão/Emergência com confirmação
if (submerso) {
    show_debug_message("🌊 Ww-Hendrick está submerso. Pressione K para emergir, ou clique para perguntar.");
    // Perguntar se quer emergir
    var _resposta = show_question("🌊 Ww-Hendrick está SUBMERSO\n\nDeseja EMERGIR?");
    if (_resposta) {
        func_emergir();
    } else {
        show_debug_message("Ww-Hendrick continuando submerso.");
    }
} else {
    show_debug_message("🌊 Ww-Hendrick está na superfície. Pressione K para submergir, ou clique para perguntar.");
    // Perguntar se quer submergir
    var _resposta = show_question("🌊 Ww-Hendrick está NA SUPERFÍCIE\n\nDeseja SUBMERGIR?");
    if (_resposta) {
        func_submergir();
    } else {
        show_debug_message("Ww-Hendrick continuando na superfície.");
    }
}
```

### **4. Visual Draw**

**Indicadores específicos do submarino:**
```10:30:objects/obj_wwhendrick/Draw_0.gml
if (selecionado) {
    // Círculo de seleção específico do submarino
    draw_set_color(c_cyan);
    draw_set_alpha(0.3);
    draw_circle(x, y, 30, false);
    draw_set_alpha(1.0);
    
    // Indicador de nome
    draw_set_halign(fa_center);
    draw_set_color(c_cyan);
    draw_text_transformed(x, y - 80, "WW-HENDRICK", 0.9, 0.9, 0);
    
    // Indicador de profundidade
    if (submerso) {
        draw_set_color(c_red);
        draw_text_transformed(x, y - 95, "SUBMERSO", 0.8, 0.8, 0);
    } else {
        draw_set_color(c_green);
        draw_text_transformed(x, y - 95, "SUPERFÍCIE", 0.8, 0.8, 0);
    }
}
```

---

## ✅ **STATUS**

✅ **IMPLEMENTAÇÃO COMPLETA**
- obj_submarino_base removido do menu
- obj_wwhendrick no menu ($2500)
- Sistema de seleção funcionando
- Clique esquerdo funcionando (submersão/emersão)
- Visual com indicadores de profundidade
- Sem erros de linting

