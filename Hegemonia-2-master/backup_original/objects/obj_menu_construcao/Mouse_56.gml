// =========================================================
// HEGEMONIA GLOBAL - LÓGICA DO MENU DE CONSTRUÇÃO
// Bloco 3, Fase 3: Lógica de Seleção (COM SUPORTE A ZOOM)
// =========================================================

// Só executa se o menu estiver visível
if (global.modo_construcao) {
    
    // USAR COORDENADAS GUI PARA COMPATIBILIDADE COM ZOOM
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // Recalcula a área do botão 1 para verificar o clique (COORDENADAS GUI)
    var _btn1_x = x + 20;
    var _btn1_y = y + 20;
    var _btn1_w = 140;
    var _btn1_h = 30;
    
    // Verifica se o mouse está dentro do retângulo do botão 1 (USANDO GUI)
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn1_x, _btn1_y, _btn1_x + _btn1_w, _btn1_y + _btn1_h)) {
        global.construindo_agora = asset_get_index("obj_casa"); // Selecionamos a CASA para construir!
        global.modo_construcao = false;      // Desliga o menu, pois a seleção foi feita.
        show_debug_message("SELECIONADO PARA CONSTRUÇÃO: Casa (GUI: " + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
        exit; // Sai do script para não verificar os outros botões
    }

    // Recalcula a área do botão 2 para verificar o clique (COORDENADAS GUI)
    var _btn2_x = x + 20;
    var _btn2_y = y + 60;
    var _btn2_w = 140;
    var _btn2_h = 30;

    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn2_x, _btn2_y, _btn2_x + _btn2_w, _btn2_y + _btn2_h)) {
        global.construindo_agora = asset_get_index("obj_banco"); // Selecionamos o BANCO para construir!
        global.modo_construcao = false;       // Desliga o menu.
        show_debug_message("SELECIONADO PARA CONSTRUÇÃO: Banco (GUI: " + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
        exit; // Sai do script para não verificar os outros botões
    }

    // Recalcula a área do botão 3 para verificar o clique (COORDENADAS GUI)
    var _btn3_x = x + 20;
    var _btn3_y = y + 100;
    var _btn3_w = 140;
    var _btn3_h = 30;

    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn3_x, _btn3_y, _btn3_x + _btn3_w, _btn3_y + _btn3_h)) {
        global.construindo_agora = asset_get_index("obj_quartel"); // Selecionamos o QUARTEL para construir!
        global.modo_construcao = false;       // Desliga o menu.
        show_debug_message("SELECIONADO PARA CONSTRUÇÃO: Quartel (GUI: " + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
        exit; // Sai do script para não verificar os outros botões
    }
    
    // DEBUG: Mostrar posições quando clicado mas não acertou nenhum botão
    show_debug_message("[MENU CLIQUE] Mouse GUI: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ") | Botão1: (" + string(_btn1_x) + "-" + string(_btn1_x + _btn1_w) + ", " + string(_btn1_y) + "-" + string(_btn1_y + _btn1_h) + ")");
}