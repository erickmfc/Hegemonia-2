// =========================================================
// HEGEMONIA GLOBAL - MENU DE AÇÃO
// Interface de comandos militares com fonte legível
// =========================================================

// === MENU REMOVIDO TEMPORARIAMENTE ===
// Todo o código foi comentado para remover o menu
/*
// Aplicar configurações de UI global
scr_config_ui_global();

// Só desenha se o menu estiver ativo
if (global.mostrar_painel_comandos) {
    
    // === DIMENSÕES DO MENU ===
    var _menu_width = 350;
    var _menu_height = 200;
    var _menu_x = display_get_gui_width() - _menu_width - 20;
    var _menu_y = 20;
    
    // === FUNDO DO MENU ===
    draw_set_color(make_color_rgb(25, 35, 50));
    draw_set_alpha(0.95);
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_width, _menu_y + _menu_height, false);
    
    // Borda
    draw_set_color(make_color_rgb(70, 100, 140));
    draw_set_alpha(0.8);
    draw_rectangle(_menu_x - 2, _menu_y - 2, _menu_x + _menu_width + 2, _menu_y + _menu_height + 2, false);
    
    // === CABEÇALHO ===
    var _header_height = 40;
    draw_set_color(make_color_rgb(40, 50, 70));
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_width, _menu_y + _header_height, false);
    
    // Título
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(255, 255, 255));
    scr_desenhar_texto_ui(_menu_x + _menu_width / 2, _menu_y + _header_height / 2, "COMANDOS MILITARES", 1.1, 1.1);
    
    // === BOTÕES DE COMANDO ===
    var _btn_width = 150;
    var _btn_height = 35;
    var _btn_spacing = 45;
    var _btn_start_x = _menu_x + 20;
    var _btn_start_y = _menu_y + _header_height + 20;
    
    // Botão 1: Atacar
    scr_desenhar_botao_ui(_btn_start_x, _btn_start_y, _btn_width, _btn_height, "⚔️ ATACAR", true);
    
    // Botão 2: Patrulhar
    scr_desenhar_botao_ui(_btn_start_x + _btn_width + 20, _btn_start_y, _btn_width, _btn_height, "🚶 PATRULHAR", true);
    
    // Botão 3: Defender
    scr_desenhar_botao_ui(_btn_start_x, _btn_start_y + _btn_spacing, _btn_width, _btn_height, "🛡️ DEFENDER", true);
    
    // Botão 4: Parar
    scr_desenhar_botao_ui(_btn_start_x + _btn_width + 20, _btn_start_y + _btn_spacing, _btn_width, _btn_height, "⏹️ PARAR", true);
    
    // === INFORMAÇÕES DA UNIDADE ===
    var _info_y = _btn_start_y + (_btn_spacing * 2) + 10;
    draw_set_color(make_color_rgb(200, 200, 200));
    draw_set_halign(fa_left);
    
    var _unidade_texto = "Nenhuma unidade selecionada";
    if (instance_exists(global.unidade_selecionada)) {
        _unidade_texto = "Unidade ID: " + string(global.unidade_selecionada);
    }
    
    scr_desenhar_texto_ui(_btn_start_x, _info_y, _unidade_texto, 0.9, 0.9);
    
    // === BOTÃO FECHAR ===
    var _close_x = _menu_x + _menu_width - 80;
    var _close_y = _menu_y + _menu_height - 40;
    scr_desenhar_botao_ui(_close_x, _close_y, 60, 25, "FECHAR", true, 0.8);
    
    // Reset configurações
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}
*/
