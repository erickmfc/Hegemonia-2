/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// =========================================================
// HEGEMONIA GLOBAL - CONSTELLATION MOUSE RIGHT CLICK
// Sistema de Movimento com Clique Direito
// =========================================================

// Se o Constellation está selecionado, mover para a posição clicada
if (selecionado) {
    show_debug_message("🖱️ CONSTELLATION - Clique direito detectado!");
    
    // Obter coordenadas do mouse no mundo
    var _coords = global.scr_mouse_to_world();
    var _mouse_world_x = _coords[0];
    var _mouse_world_y = _coords[1];
    
    // Definir destino
    alvo_x = _mouse_world_x;
    alvo_y = _mouse_world_y;
    estado = ConstellationState.MOVENDO;
    estado_string = "movendo";
    
    show_debug_message("🚢 Constellation: Ordem de movimento para (" + string(round(_mouse_world_x)) + ", " + string(round(_mouse_world_y)) + ")");
    show_debug_message("🚢 Estado alterado para: MOVENDO");
} else {
    show_debug_message("⚠️ Constellation não está selecionado - clique direito ignorado");
}
