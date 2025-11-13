/// @description Mouse Left Pressed - Ir para room de instruções

// Leva o jogador para a sala de instruções
var _room_instrucao = asset_get_index("instrucao");
if (_room_instrucao == -1) {
    // fallback: tentar outros nomes possíveis
    _room_instrucao = asset_get_index("rm_instrucao");
}

if (_room_instrucao != -1) {
    room_goto(_room_instrucao);
    show_debug_message("📚 Indo para room de instruções...");
} else {
    show_debug_message("[MENU] Sala de instruções não encontrada (instrucao).");
}
