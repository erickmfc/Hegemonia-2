// =========================================================
// SCRIPT PARA LIMPAR PATRULHA DA LANCHA
// Função externa para limpar patrulha da lancha
// =========================================================

function scr_limpar_patrulha_lancha(_lancha_id) {
    if (instance_exists(_lancha_id)) {
        with (_lancha_id) {
            ds_list_clear(pontos_patrulha);
            estado = "parado";
            show_debug_message("🗑️ Patrulha da lancha foi limpa");
        }
    } else {
        show_debug_message("❌ Lancha não encontrada para limpar patrulha");
    }
}
