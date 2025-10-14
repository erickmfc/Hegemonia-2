// =========================================================
// SCRIPT PARA ORDEM DE MOVIMENTO DA LANCHA
// Função externa para controlar movimento da lancha
// =========================================================

function scr_ordem_mover_lancha(_lancha_id, _novo_destino_x, _novo_destino_y) {
    if (instance_exists(_lancha_id)) {
        with (_lancha_id) {
            destino_x = _novo_destino_x;
            destino_y = _novo_destino_y;
            estado = "movendo";
            show_debug_message("🚢 Lancha recebeu ordem de movimento para: (" + string(destino_x) + ", " + string(destino_y) + ")");
        }
    } else {
        show_debug_message("❌ Lancha não encontrada para ordem de movimento");
    }
}
