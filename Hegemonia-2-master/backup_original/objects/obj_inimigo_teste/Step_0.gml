// ================================================
// HEGEMONIA GLOBAL - OBJETO: INIMIGO TESTE NOVO
// Step Event - OBJETO COMPLETAMENTE NOVO
// ================================================

// === VERIFICAÇÃO DE DESTRUIÇÃO ===
if (hp_atual <= 0) {
    show_debug_message("💀 OBJETO NOVO destruído! ID: " + string(id));
    instance_destroy();
    exit;
}

// === SISTEMA DE ARRASTAR E SOLTAR ===
if (pode_ser_arrastado) {
    // Verificar se clicou no inimigo
    if (mouse_check_button_pressed(mb_left)) {
        if (point_distance(mouse_x, mouse_y, x, y) <= raio_selecao) {
            selecionado = true;
            show_debug_message("🎯 OBJETO NOVO selecionado para arrastar - ID: " + string(id));
        }
    }
    
    // Se está sendo arrastado, seguir o mouse
    if (selecionado) {
        x = mouse_x;
        y = mouse_y;
        
        show_debug_message("🎯 OBJETO NOVO sendo arrastado - Posição: " + string(x) + ", " + string(y));
        
        // Verificar se soltou o botão do mouse
        if (mouse_check_button_released(mb_left)) {
            selecionado = false;
            show_debug_message("🎯 OBJETO NOVO posicionado em: " + string(x) + ", " + string(y));
        }
    }
}

// === VERIFICAÇÕES DE DEBUG ===
if (timer_verificacao == 0) {
    timer_verificacao = 1;
    show_debug_message("🎯 Step Event OBJETO NOVO funcionando - ID: " + string(id));
    show_debug_message("🎯 Posição atual: " + string(x) + ", " + string(y));
    show_debug_message("🎯 HP: " + string(hp_atual) + "/" + string(hp_max));
}
