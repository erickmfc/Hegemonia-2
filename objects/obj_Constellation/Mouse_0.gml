// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION FUNCIONAL
// Sistema de Seleção e Movimento
// ===============================================

// === SELEÇÃO ===
if (mouse_check_button_pressed(mb_left)) {
    // Desmarcar outras unidades
    with (obj_infantaria) { selecionado = false; }
    with (obj_soldado_antiaereo) { selecionado = false; }
    with (obj_tanque) { selecionado = false; }
    with (obj_blindado_antiaereo) { selecionado = false; }
    with (obj_lancha_patrulha) { selecionado = false; }
    with (obj_caca_f5) { selecionado = false; }
    with (obj_helicoptero_militar) { selecionado = false; }
    
    // Marcar este Constellation
    selecionado = true;
    ultima_acao = "Selecionado";
    cor_feedback = c_blue;
    feedback_timer = 60;
    debug_info.acoes++;
    
    show_debug_message("🎯 Constellation SELECIONADO!");
    show_debug_message("   Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("   Estado: " + estado);
    show_debug_message("   HP: " + string(hp_atual) + "/" + string(hp_max));
}