// Mouse Left Pressed - Regras
// Leva o jogador para a sala de regras
var _room_rules = asset_get_index("rm_regras");
if (_room_rules == -1) {
    // fallback: pasta rooms/regras pode ter sido nomeada diferente
    _room_rules = asset_get_index("regras");
}

if (_room_rules != -1) {
    room_goto(_room_rules);
} else {
    show_debug_message("[MENU] Sala de regras não encontrada (rm_regras).");
}


