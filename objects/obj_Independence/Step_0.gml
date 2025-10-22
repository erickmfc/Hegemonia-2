/// @description Step Event 0 - Sistema Base da Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE
// Step Event - APENAS HERANÇA DO SISTEMA BASE
// ===============================================

// === CHAMAR SISTEMA DO OBJETO PAI PRIMEIRO ===
// Isso garante que o sistema de movimento do obj_navio_base seja executado
event_inherited();

// === DEBUG DE CONTROLES (APENAS QUANDO SELECIONADA) ===
if (selecionado) {
    // Debug de controles a cada segundo
    debug_timer++;
    
    if (debug_timer >= 60) { // A cada 1 segundo (60 frames)
        show_debug_message("🚢 INDEPENDENCE DEBUG - Estado: " + string(estado) + " | Destino: (" + string(destino_x) + ", " + string(destino_y) + ") | Posição: (" + string(x) + ", " + string(y) + ")");
        show_debug_message("🚢 INDEPENDENCE CONTROLES - P: Passivo | O: Ataque | L: Parar | K: Patrulha");
        show_debug_message("🚢 INDEPENDENCE MOVIMENTO - Velocidade: " + string(velocidade_movimento) + " | Distância: " + string(point_distance(x, y, destino_x, destino_y)));
        debug_timer = 0; // Reset timer
    }
    
    // Debug de teclas pressionadas
    if (keyboard_check_pressed(ord("P"))) {
        show_debug_message("🚢 INDEPENDENCE: Tecla P pressionada - Modo Passivo");
    }
    if (keyboard_check_pressed(ord("O"))) {
        show_debug_message("🚢 INDEPENDENCE: Tecla O pressionada - Modo Ataque");
    }
    if (keyboard_check_pressed(ord("L"))) {
        show_debug_message("🚢 INDEPENDENCE: Tecla L pressionada - Parar");
    }
    if (keyboard_check_pressed(ord("K"))) {
        show_debug_message("🚢 INDEPENDENCE: Tecla K pressionada - Patrulha");
    }
}