// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION
// Clique Esquerdo - Adicionar Ponto de Patrulha (APENAS SE SELECIONADO)
// ===============================================

// === ADICIONAR PONTO DE PATRULHA (APENAS SE SELECIONADO) ===
if (selecionado && mouse_check_button_pressed(mb_left)) {
    // Converter coordenadas do mouse para coordenadas do mundo
    var _world_x = camera_get_view_x(view_camera[0]) + mouse_x;
    var _world_y = camera_get_view_y(view_camera[0]) + mouse_y;
    
    // Usar função herdada do obj_navio_base
    func_adicionar_ponto(_world_x, _world_y);
    
    // Feedback visual
    ultima_acao = "Ponto adicionado: (" + string(round(_world_x)) + ", " + string(round(_world_y)) + ")";
    cor_feedback = c_blue;
    feedback_timer = 90;
    
    show_debug_message("🚢 Constellation adicionou ponto de patrulha: (" + string(round(_world_x)) + ", " + string(round(_world_y)) + ")");
}
