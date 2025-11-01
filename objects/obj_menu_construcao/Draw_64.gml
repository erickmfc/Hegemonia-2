// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO ESPAÇADO E MODERNO
// Design melhorado com muito mais espaço e visual profissional
// =========================================================

// Só desenha se o modo de construção estiver ativo
if (global.modo_construcao) {
    
    // ✅ OTIMIZADO: Calcular coordenadas do mouse UMA VEZ por frame
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // === CONFIGURAÇÃO DE FONTE MELHORADA ===
    draw_set_font(fnt_ui_main);
    
    // === DIMENSÕES DO MENU AJUSTADAS ===
    var _menu_width = 360;   // Largura aumentada para melhor proporção
    var _menu_height = 480;  // Altura aumentada para caber todos os botões com espaço
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
    
    // === CABEÇALHO ===
    var _header_height = 50; // Altura confortável para o título
    draw_set_color(make_color_rgb(40, 40, 60));
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_width, _menu_y + _header_height, false);
    
    // Linha decorativa no cabeçalho
    draw_set_color(make_color_rgb(100, 150, 200));
    draw_line(_menu_x, _menu_y + _header_height - 2, _menu_x + _menu_width, _menu_y + _header_height - 2);
    
    // Título do menu (reduzido 50%)
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(255, 255, 255));
    scr_desenhar_texto_ui(_menu_x + _menu_width / 2, _menu_y + _header_height / 2, "MENU DE CONSTRUÇÃO", 0.65, 0.65); // Reduzido 50% de 1.3
    
    // === BOTÕES ESPAÇADOS ===
    var _btn_width = 280;    // Largura adequada para textos completos
    var _btn_height = 38;    // Altura confortável para legibilidade
    var _btn_spacing_y = 38;  // Espaçamento vertical equilibrado
    var _btn_start_x = _menu_x + (_menu_width - 280) / 2;  // Centralizado
    var _btn_start_y = _menu_y + _header_height + 20; // Margem superior
    
    // === LISTA VERTICAL DE BOTÕES ===
    // ✅ OTIMIZADO: Passar coordenadas do mouse calculadas uma vez
    // Botão 1: Casa
    var _btn1_x = _btn_start_x;
    var _btn1_y = _btn_start_y;
    scr_desenhar_botao_moderno(_btn1_x, _btn1_y, _btn_width, _btn_height, "Construir Casa", true, _mouse_gui_x, _mouse_gui_y);
    
    // Botão 2: Banco
    var _btn2_x = _btn_start_x;
    var _btn2_y = _btn_start_y + _btn_spacing_y;
    scr_desenhar_botao_moderno(_btn2_x, _btn2_y, _btn_width, _btn_height, "Construir Banco", true, _mouse_gui_x, _mouse_gui_y);
    
    // Botão 3: Fazenda
    var _btn3_x = _btn_start_x;
    var _btn3_y = _btn_start_y + (_btn_spacing_y * 2);
    scr_desenhar_botao_moderno(_btn3_x, _btn3_y, _btn_width, _btn_height, "Construir Fazenda", true, _mouse_gui_x, _mouse_gui_y);
    
    // Botão 4: Quartel
    var _btn4_x = _btn_start_x;
    var _btn4_y = _btn_start_y + (_btn_spacing_y * 3);
    scr_desenhar_botao_moderno(_btn4_x, _btn4_y, _btn_width, _btn_height, "Construir Quartel", true, _mouse_gui_x, _mouse_gui_y);
    
    // Botão 5: Quartel Marinha
    var _btn5_x = _btn_start_x;
    var _btn5_y = _btn_start_y + (_btn_spacing_y * 4);
    scr_desenhar_botao_moderno(_btn5_x, _btn5_y, _btn_width, _btn_height, "Quartel Marinha", true, _mouse_gui_x, _mouse_gui_y);
    
    // Botão 6: Aeroporto Militar
    var _btn6_x = _btn_start_x;
    var _btn6_y = _btn_start_y + (_btn_spacing_y * 5);
    scr_desenhar_botao_moderno(_btn6_x, _btn6_y, _btn_width, _btn_height, "Aeroporto Militar", true, _mouse_gui_x, _mouse_gui_y);
    
    // === SEÇÃO DE RECURSOS REMOVIDA ===
    // Recursos e instruções desnecessárias removidas para interface mais limpa
    
    // === BOTÃO DE FECHAR ===
    var _close_btn_size = 30;
    var _close_x = _menu_x + _menu_width - _close_btn_size - 10;
    var _close_y = _menu_y + 10;
    
    // ✅ OTIMIZADO: Usar coordenadas já calculadas
    var _hover_close = point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _close_x, _close_y, _close_x + _close_btn_size, _close_y + _close_btn_size);
    
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
