// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-5 (Clean Up)
// ===============================================

// Limpar lista de patrulha
if (variable_instance_exists(id, "pontos_patrulha")) {
    ds_list_destroy(pontos_patrulha);
}

show_debug_message("✈️ F-5 destruído - Memória limpa");
