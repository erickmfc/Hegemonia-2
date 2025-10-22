// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO ESPAÇADO E MODERNO
// Design melhorado com muito mais espaço e visual profissional
// =========================================================

// Só desenha se o modo de construção estiver ativo
if (global.modo_construcao) {
    
    // === CONFIGURAÇÃO DE FONTE MELHORADA ===
    draw_set_font(fnt_ui_main);
    
    // === DIMENSÕES DO MENU MAIOR E MAIS ESPAÇADO ===
    var _menu_width = 600;   // Muito maior para mais espaço
    var _menu_height = 540;  // Mais alto para acomodar 6 botões
    var _menu_x = display_get_gui_width() / 2 - _menu_width / 2;
    var _menu_y = display_get_gui_height() / 2 - _menu_height / 2;
    
    // === FUNDO DO MENU COM SOMBRA ===
    // Sombra atrás do menu
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.3);
    draw_rectangle(_menu_x + 4, _menu_y + 4, _menu_x + _menu_width + 4, _menu_y + _menu_height + 4, false);
    
    // Fundo principal com gradiente simulado
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(25, 25, 35)); // Azul muito escuro
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_width, _menu_y + _menu_height, false);
    
    // Borda externa elegante
    draw_set_color(make_color_rgb(70, 70, 90));
    draw_rectangle(_menu_x - 3, _menu_y - 3, _menu_x + _menu_width + 3, _menu_y + _menu_height + 3, false);
    
    // Borda interna sutil
    draw_set_color(make_color_rgb(45, 45, 55));
    draw_rectangle(_menu_x - 1, _menu_y - 1, _menu_x + _menu_width + 1, _menu_y + _menu_height + 1, false);
    
    // === CABEÇALHO DO MENU MELHORADO ===
    var _header_height = 60; // Mais alto para respirar
    draw_set_color(make_color_rgb(40, 40, 60));
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_width, _menu_y + _header_height, false);
    
    // Linha decorativa no cabeçalho
    draw_set_color(make_color_rgb(100, 150, 200));
    draw_line(_menu_x, _menu_y + _header_height - 2, _menu_x + _menu_width, _menu_y + _header_height - 2);
    
    // Título do menu limpo (fonte 10% do tamanho original)
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(255, 255, 255));
    scr_desenhar_texto_ui(_menu_x + _menu_width / 2, _menu_y + _header_height / 2, "MENU DE CONSTRUÇÃO", 0.15, 0.15); // 10% do tamanho original (1.5 * 0.1)
    
    // === BOTÕES EM LISTA VERTICAL ===
    var _btn_width = 300;    // Botões mais largos para lista
    var _btn_height = 50;    // Botões mais altos
    var _btn_spacing_y = 70;  // Espaçamento vertical muito maior
    var _btn_start_x = _menu_x + 50;  // Margem maior
    var _btn_start_y = _menu_y + _header_height + 40; // Mais espaço do cabeçalho
    
    // === LISTA VERTICAL DE BOTÕES ===
    // Botão 1: Casa
    var _btn1_x = _btn_start_x;
    var _btn1_y = _btn_start_y;
    scr_desenhar_botao_moderno(_btn1_x, _btn1_y, _btn_width, _btn_height, "Construir Casa", true);
    
    // Botão 2: Banco
    var _btn2_x = _btn_start_x;
    var _btn2_y = _btn_start_y + _btn_spacing_y;
    scr_desenhar_botao_moderno(_btn2_x, _btn2_y, _btn_width, _btn_height, "Construir Banco", true);
    
    // Botão 3: Fazenda
    var _btn3_x = _btn_start_x;
    var _btn3_y = _btn_start_y + (_btn_spacing_y * 2);
    scr_desenhar_botao_moderno(_btn3_x, _btn3_y, _btn_width, _btn_height, "Construir Fazenda", true);
    
    // Botão 4: Quartel
    var _btn4_x = _btn_start_x;
    var _btn4_y = _btn_start_y + (_btn_spacing_y * 3);
    scr_desenhar_botao_moderno(_btn4_x, _btn4_y, _btn_width, _btn_height, "Construir Quartel", true);
    
    // Botão 5: Quartel Marinha
    var _btn5_x = _btn_start_x;
    var _btn5_y = _btn_start_y + (_btn_spacing_y * 4);
    scr_desenhar_botao_moderno(_btn5_x, _btn5_y, _btn_width, _btn_height, "Quartel Marinha", true);
    
    // Botão 6: Aeroporto Militar
    var _btn6_x = _btn_start_x;
    var _btn6_y = _btn_start_y + (_btn_spacing_y * 5);
    scr_desenhar_botao_moderno(_btn6_x, _btn6_y, _btn_width, _btn_height, "Aeroporto Militar", true);
    
    // === SEÇÃO DE RECURSOS REMOVIDA ===
    // Recursos e instruções desnecessárias removidas para interface mais limpa
    
    // === BOTÃO DE FECHAR ===
    var _close_btn_size = 30;
    var _close_x = _menu_x + _menu_width - _close_btn_size - 10;
    var _close_y = _menu_y + 10;
    
    // Verificar se mouse está sobre o botão de fechar
    var _mouse_gui_x_close = device_mouse_x_to_gui(0);
    var _mouse_gui_y_close = device_mouse_y_to_gui(0);
    var _hover_close = point_in_rectangle(_mouse_gui_x_close, _mouse_gui_y_close, _close_x, _close_y, _close_x + _close_btn_size, _close_y + _close_btn_size);
    
    if (_hover_close) {
        draw_set_color(make_color_rgb(255, 100, 100));
    } else {
        draw_set_color(make_color_rgb(200, 200, 200));
    }
    
    draw_rectangle(_close_x, _close_y, _close_x + _close_btn_size, _close_y + _close_btn_size, false);
    
    // X no botão de fechar
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    scr_desenhar_texto_ui(_close_x + _close_btn_size / 2, _close_y + _close_btn_size / 2, "X", 1.5, 1.5);
    
    // Reseta configurações
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}
