// =========================================================
// HEGEMONIA GLOBAL - LÓGICA DO MENU DE CONSTRUÇÃO
// Bloco 3, Fase 2 (Revisada): Desenho Manual da UI (COM SUPORTE A ZOOM)
// =========================================================

// DEBUG: Sempre mostra que Draw_64 está sendo executado
if (current_time mod 1000 < 17) {
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    show_debug_message("[DRAW DEBUG] Draw_64 executando. Modo construção: " + string(global.modo_construcao) + 
                      " | Visível: " + string(visible) + 
                      " | Mouse GUI: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
}

// Só desenha qualquer coisa se o modo de construção estiver ativo
if (global.modo_construcao) {
    // DEBUG: Confirma que o menu está sendo desenhado (apenas uma vez a cada 2 segundos)
    if (current_time mod 2000 < 17) {
        show_debug_message("[MENU] Menu de construção ativo e visível");
    }
    
    // Desenha o sprite de fundo do próprio menu
    draw_self();

    // --- Botão 1: Construir Casa ---
    // Define a área e a posição do nosso primeiro botão de texto
    var _btn1_x = x + 20;
    var _btn1_y = y + 20;
    var _btn1_w = 140; // Largura (width)
    var _btn1_h = 30;  // Altura (height)
    
    // Desenha um retângulo para o fundo do botão
    draw_set_color(c_dkgray);
    draw_rectangle(_btn1_x, _btn1_y, _btn1_x + _btn1_w, _btn1_y + _btn1_h, false);
    
    // Escreve o texto do botão
    draw_set_halign(fa_center); // Alinha o texto no centro
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_btn1_x + _btn1_w / 2, _btn1_y + _btn1_h / 2, "Construir Casa");


    // --- Botão 2: Construir Banco ---
    var _btn2_x = x + 20;
    var _btn2_y = y + 60; // Posicionado abaixo do primeiro
    var _btn2_w = 140;
    var _btn2_h = 30;
    
    draw_set_color(c_dkgray);
    draw_rectangle(_btn2_x, _btn2_y, _btn2_x + _btn2_w, _btn2_y + _btn2_h, false);
    
    draw_set_color(c_white);
    draw_text(_btn2_x + _btn2_w / 2, _btn2_y + _btn2_h / 2, "Construir Banco");

    // --- Botão 3: Construir Quartel ---
    var _btn3_x = x + 20;
    var _btn3_y = y + 100; // Posicionado abaixo do segundo
    var _btn3_w = 140;
    var _btn3_h = 30;
    
    draw_set_color(c_dkgray);
    draw_rectangle(_btn3_x, _btn3_y, _btn3_x + _btn3_w, _btn3_y + _btn3_h, false);
    
    draw_set_color(c_white);
    draw_text(_btn3_x + _btn3_w / 2, _btn3_y + _btn3_h / 2, "Construir Quartel");

    // Reseta o alinhamento para não afetar outros textos no jogo
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}