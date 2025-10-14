// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA MOUSE EVENT (4)
// Sistema de Movimento da Lancha
// =========================================================

// --- VERIFICAÇÃO DE SEGURANÇA ---
if (!variable_instance_exists(id, "selecionado")) {
    selecionado = false;
}

// --- MOVIMENTO APENAS SE SELECIONADO ---
if (selecionado && mouse_check_button_pressed(mb_right)) {
    // Obter coordenadas do mundo (não da tela)
    var _world_x = camera_get_view_x(view_camera[0]) + mouse_x;
    var _world_y = camera_get_view_y(view_camera[0]) + mouse_y;
    
    // Definir novo destino
    destino_x = _world_x;
    destino_y = _world_y;
    estado = "movendo";
    
    // Limpar patrulha se estava patrulhando
    if (estado_anterior == "patrulhando") {
        estado_anterior = "parado";
    }
    
    show_debug_message("🚢 Lancha recebeu ordem de movimento");
    show_debug_message("📍 Destino: (" + string(destino_x) + ", " + string(destino_y) + ")");
    show_debug_message("📏 Distância: " + string(round(point_distance(x, y, destino_x, destino_y))) + " pixels");
    
    // Feedback visual temporário
    var _distancia = point_distance(x, y, destino_x, destino_y);
    var _tempo_estimado = _distancia / velocidade_maxima;
    show_debug_message("⏱️ Tempo estimado: " + string(round(_tempo_estimado)) + " segundos");
}
