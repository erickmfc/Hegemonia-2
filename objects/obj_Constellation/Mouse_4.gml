// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION FUNCIONAL
// Sistema de Seleção
// ===============================================

// === SELEÇÃO ===
if (mouse_check_button_pressed(mb_left)) {
    // Desmarcar outras Constellations
    with (obj_Constellation) {
        selecionado = false;
    }
    
    // Marcar esta Constellation
    selecionado = true;
    ultima_acao = "Selecionada";
    cor_feedback = c_blue;
    feedback_timer = 60;
    
    // Atualizar debug_info
    debug_info.acoes++;
    
    show_debug_message("🎯 Constellation SELECIONADA!");
    show_debug_message("   Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("   Estado: " + estado);
    show_debug_message("   HP: " + string(hp_atual) + "/" + string(hp_max));
    show_debug_message("   Ações: " + string(debug_info.acoes));
}