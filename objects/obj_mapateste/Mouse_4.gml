/// @description Mapa Teste - Carrega Room1
// Parar música do menu se estiver tocando
audio_stop_all();

// Carregar room Room1
// ✅ CORREÇÃO GM1041: Verificar se o asset é uma room válida e fazer cast correto
var _asset_id = asset_get_index("Room1");
if (_asset_id >= 0) {
    // ✅ CORREÇÃO: Usar asset_get_type para verificar
    if (asset_get_type(_asset_id) == asset_room) {
        var _room_mapa = _asset_id;
        room_goto(_room_mapa);
        show_debug_message("🗺️ Mapa - Carregando room: Room1");
    } else {
        show_debug_message("❌ Erro: 'Room1' não é uma room válida!");
    }
} else {
    show_debug_message("❌ Erro: Room 'Room1' não encontrada!");
}
