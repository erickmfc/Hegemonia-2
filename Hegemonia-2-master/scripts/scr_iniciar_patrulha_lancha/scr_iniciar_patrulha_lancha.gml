// =========================================================
// SCRIPT PARA INICIAR PATRULHA DA LANCHA
// Função externa para iniciar patrulha da lancha
// =========================================================

function scr_iniciar_patrulha_lancha(_lancha_id) {
    if (instance_exists(_lancha_id)) {
        with (_lancha_id) {
            if (ds_list_size(pontos_patrulha) > 0) {
                estado = "patrulhando";
                indice_patrulha_atual = 0;
                var _ponto = pontos_patrulha[| 0];
                destino_x = _ponto[0];
                destino_y = _ponto[1];
                show_debug_message("🔄 Lancha iniciou patrulha com " + string(ds_list_size(pontos_patrulha)) + " pontos");
            } else {
                show_debug_message("⚠️ Não é possível iniciar patrulha: Nenhum ponto definido");
            }
        }
    } else {
        show_debug_message("❌ Lancha não encontrada para iniciar patrulha");
    }
}
