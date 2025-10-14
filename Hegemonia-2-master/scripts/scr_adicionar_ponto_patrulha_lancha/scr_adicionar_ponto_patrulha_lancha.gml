// =========================================================
// SCRIPT PARA ADICIONAR PONTO DE PATRULHA DA LANCHA
// Função externa para adicionar ponto de patrulha
// =========================================================

function scr_adicionar_ponto_patrulha_lancha(_lancha_id, _novo_x, _novo_y) {
    if (instance_exists(_lancha_id)) {
        with (_lancha_id) {
            var _ponto = [_novo_x, _novo_y];
            ds_list_add(pontos_patrulha, _ponto);
            show_debug_message("📍 Ponto de patrulha adicionado: (" + string(_novo_x) + ", " + string(_novo_y) + ")");
        }
    } else {
        show_debug_message("❌ Lancha não encontrada para adicionar ponto de patrulha");
    }
}
