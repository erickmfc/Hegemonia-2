// =========================================================
// SISTEMA GLOBAL DE CONFIGURAÇÃO DE FONTES E UI
// Resolve problemas de fonte pequena em todo o jogo
// =========================================================

function scr_config_ui_global() {
    
    // === CONFIGURAÇÃO GLOBAL DE FONTE MELHORADA ===
    if (font_exists(fnt_ui_main)) {
        draw_set_font(fnt_ui_main);
        show_debug_message("✅ Fonte fnt_ui_main aplicada globalmente");
    } else {
        // Fallback para fonte padrão com tamanho maior
        draw_set_font(-1);
        show_debug_message("⚠️ Usando fonte padrão como fallback");
    }
    
    // === CONFIGURAÇÕES DE ALINHAMENTO ===
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // === CONFIGURAÇÕES DE COR ===
    draw_set_color(c_white);
    draw_set_alpha(1);
    
    // === CONFIGURAÇÕES DE ESCALA MELHORADAS ===
    // Escala aumentada para melhor legibilidade
    if (!variable_global_exists("ui_scale")) {
        global.ui_scale = 1.2; // Escala aumentada para melhor legibilidade
    }
    
    // === CONFIGURAÇÕES DE QUALIDADE DE TEXTO ===
    // Configurações para melhor renderização de texto
    if (!variable_global_exists("text_quality")) {
        global.text_quality = "high"; // Qualidade alta para texto
    }
    
    // === VERIFICAÇÃO DE CONFIGURAÇÕES ===
    show_debug_message("🎨 Configurações de UI aplicadas:");
    show_debug_message("   - Fonte: " + (font_exists(fnt_ui_main) ? "fnt_ui_main" : "padrão"));
    show_debug_message("   - Escala: " + string(global.ui_scale));
    show_debug_message("   - Qualidade: " + string(global.text_quality));
    show_debug_message("   - Alinhamento: esquerda/topo");
}


// =========================================================
// FUNÇÃO PARA DESENHAR TEXTO COM ESCALA
// =========================================================

function scr_desenhar_texto_ui(_x, _y, _text, _scale_x = 1.0, _scale_y = 1.0) {
    // Aplicar fonte
    if (font_exists(fnt_ui_main)) {
        draw_set_font(fnt_ui_main);
    } else {
        draw_set_font(-1);
    }
    
    // Aplicar escala global melhorada
    var _final_scale_x = _scale_x * global.ui_scale;
    var _final_scale_y = _scale_y * global.ui_scale;
    
    // Garantir escala mínima para legibilidade
    if (_final_scale_x < 0.8) _final_scale_x = 0.8;
    if (_final_scale_y < 0.8) _final_scale_y = 0.8;
    
    // Desenhar texto com escala e qualidade alta
    draw_text_transformed(_x, _y, _text, _final_scale_x, _final_scale_y, 0);
    
    // Adicionar contorno sutil para melhor legibilidade
    if (global.text_quality == "high") {
        draw_set_color(make_color_rgb(0, 0, 0));
        draw_set_alpha(0.3);
        draw_text_transformed(_x + 1, _y + 1, _text, _final_scale_x, _final_scale_y, 0);
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

// =========================================================
// FUNÇÃO PARA DESENHAR BOTÃO COM DESIGN PADRONIZADO
// =========================================================

function scr_desenhar_botao_ui(_x, _y, _width, _height, _text, _enabled = true, _scale = 1.0) {
    
    // Aplicar escala global
    var _final_scale = _scale * global.ui_scale;
    var _scaled_width = _width * _final_scale;
    var _scaled_height = _height * _final_scale;
    
    // Verificar hover
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _hover = point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _x, _y, _x + _scaled_width, _y + _scaled_height);
    
    // Cores baseadas no estado
    var _bg_color, _text_color, _border_color;
    
    if (!_enabled) {
        _bg_color = make_color_rgb(60, 60, 60);
        _text_color = make_color_rgb(120, 120, 120);
        _border_color = make_color_rgb(40, 40, 40);
    } else if (_hover) {
        _bg_color = make_color_rgb(80, 120, 160);
        _text_color = make_color_rgb(255, 255, 255);
        _border_color = make_color_rgb(100, 140, 180);
    } else {
        _bg_color = make_color_rgb(60, 100, 140);
        _text_color = make_color_rgb(255, 255, 255);
        _border_color = make_color_rgb(80, 120, 160);
    }
    
    // Desenhar botão
    draw_set_color(_bg_color);
    draw_rectangle(_x, _y, _x + _scaled_width, _y + _scaled_height, false);
    
    draw_set_color(_border_color);
    draw_rectangle(_x - 1, _y - 1, _x + _scaled_width + 1, _y + _scaled_height + 1, false);
    
    // Texto centralizado
    if (font_exists(fnt_ui_main)) {
        draw_set_font(fnt_ui_main);
    } else {
        draw_set_font(-1);
    }
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_text_color);
    
    draw_text(_x + _scaled_width / 2, _y + _scaled_height / 2, _text);
    
    // Sombra no texto
    if (_enabled) {
        draw_set_color(make_color_rgb(0, 0, 0));
        draw_text(_x + _scaled_width / 2 + 1, _y + _scaled_height / 2 + 1, _text);
        draw_set_color(_text_color);
        draw_text(_x + _scaled_width / 2, _y + _scaled_height / 2, _text);
    }
    
    // Reset alinhamento
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// =========================================================
// FUNÇÃO PARA VERIFICAR E CORRIGIR CONFIGURAÇÕES DE UI
// =========================================================

function scr_verificar_ui_sistema() {
    
    show_debug_message("🔍 VERIFICAÇÃO COMPLETA DO SISTEMA DE UI:");
    
    // Verificar fonte
    if (font_exists(fnt_ui_main)) {
        show_debug_message("✅ Fonte fnt_ui_main: OK");
    } else {
        show_debug_message("❌ Fonte fnt_ui_main: NÃO ENCONTRADA");
    }
    
    // Verificar variáveis globais
    if (variable_global_exists("ui_scale")) {
        show_debug_message("✅ Escala UI: " + string(global.ui_scale));
    } else {
        global.ui_scale = 1.2; // Escala melhorada
        show_debug_message("⚠️ Escala UI: CRIADA (1.2)");
    }
    
    // Verificar qualidade de texto
    if (variable_global_exists("text_quality")) {
        show_debug_message("✅ Qualidade texto: " + string(global.text_quality));
    } else {
        global.text_quality = "high";
        show_debug_message("⚠️ Qualidade texto: CRIADA (high)");
    }
    
    // Verificar configurações de display
    show_debug_message("📺 Display: " + string(display_get_gui_width()) + "x" + string(display_get_gui_height()));
    
    // Verificar objetos de UI essenciais
    var _ui_objects = [
        "obj_menu_construcao",
        "obj_menu_recrutamento", 
        "obj_menu_recrutamento_marinha",
        "obj_research_center",
        "obj_menu_de_acao",
        "obj_simple_dashboard",
        "obj_ui_manager"
    ];
    
    for (var i = 0; i < array_length(_ui_objects); i++) {
        var _obj_name = _ui_objects[i];
        var _obj_index = asset_get_index(_obj_name);
        if (_obj_index != -1) {
            show_debug_message("✅ " + _obj_name + ": OK");
        } else {
            show_debug_message("❌ " + _obj_name + ": NÃO ENCONTRADO");
        }
    }
    
    // Teste de legibilidade
    show_debug_message("📝 TESTE DE LEGIBILIDADE:");
    show_debug_message("   - Escala mínima garantida: 0.8");
    show_debug_message("   - Contorno sutil ativo: " + (global.text_quality == "high" ? "SIM" : "NÃO"));
    show_debug_message("   - Todas as palavras devem ser legíveis");
}