// Mouse Left Pressed - Iniciar Jogo
// Leva o jogador para a sala principal do jogo
// Fallback: tenta rm_mapa_principal; se não existir, usa Room1
var _room_main = asset_get_index("rm_mapa_principal");
if (_room_main == -1) {
    _room_main = asset_get_index("Room1");
}

if (_room_main != -1) {
    room_goto(_room_main);
} else {
    show_debug_message("[MENU] Sala principal não encontrada (Room1/rm_mapa_principal).");
}


