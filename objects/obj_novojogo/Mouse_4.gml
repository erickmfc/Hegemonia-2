/// @description Novo Jogo - Vai para room de carregamento
// Parar música do menu se estiver tocando
audio_stop_all();

// ✅ CORREÇÃO: Ir para room "carregamento" primeiro (não direto para teste)
var _asset_id = asset_get_index("carregamento");
if (_asset_id >= 0) {
    if (asset_get_type(_asset_id) == asset_room) {
        var _room_carregamento = _asset_id;
        room_goto(_room_carregamento);
        show_debug_message("🎮 Novo Jogo - Carregando room: carregamento");
    } else {
        show_debug_message("❌ Erro: 'carregamento' não é uma room válida!");
    }
} else {
    show_debug_message("❌ Erro: Room 'carregamento' não encontrada!");
}
