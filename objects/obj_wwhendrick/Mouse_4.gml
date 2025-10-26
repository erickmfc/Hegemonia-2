// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION
// Clique Direito - Mover para Posição (APENAS SE SELECIONADO)
// ===============================================

// === MOVER PARA POSIÇÃO (APENAS SE SELECIONADO) ===
if (selecionado && mouse_check_button_pressed(mb_right)) {
    // Converter coordenadas do mouse para coordenadas do mundo
    var _world_x = camera_get_view_x(view_camera[0]) + mouse_x;
    var _world_y = camera_get_view_y(view_camera[0]) + mouse_y;
    
    // Usar função herdada do obj_navio_base
    func_ordem_mover(_world_x, _world_y);
    
    // Feedback visual - ✅ CORREÇÃO GM2016: Verificar existência das variáveis
    if (!variable_instance_exists(id, "ultima_acao")) { ultima_acao = ""; }
    if (!variable_instance_exists(id, "cor_feedback")) { cor_feedback = c_green; }
    if (!variable_instance_exists(id, "feedback_timer")) { feedback_timer = 0; }
    
    ultima_acao = "Movendo para (" + string(round(_world_x)) + ", " + string(round(_world_y)) + ")";
    cor_feedback = c_green;
    feedback_timer = 90;
    
    show_debug_message("🚢 Constellation movendo para: (" + string(round(_world_x)) + ", " + string(round(_world_y)) + ")");
}
