// ===============================================
// HEGEMONIA GLOBAL - OBJETO CARREGAMENTO
// Atualização do Progresso de Carregamento
// ===============================================

// Incrementar tempo atual (delta_time em segundos)
tempo_atual += (1.0 / game_get_speed(gamespeed_fps));

// Calcular progresso (0.0 a 1.0)
progresso = min(1.0, tempo_atual / tempo_total);

// Se chegou ao final, mudar de room
if (tempo_atual >= tempo_total) {
    // Carregar room de teste
    var _asset_id = asset_get_index(room_destino);
    if (_asset_id >= 0) {
        if (asset_get_type(_asset_id) == asset_room) {
            var _room_teste = _asset_id;
            show_debug_message("✅ Carregamento completo! Indo para room: " + room_destino);
            room_goto(_room_teste);
        } else {
            show_debug_message("❌ Erro: '" + room_destino + "' não é uma room válida!");
        }
    } else {
        show_debug_message("❌ Erro: Room '" + room_destino + "' não encontrada!");
    }
}
