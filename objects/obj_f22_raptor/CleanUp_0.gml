// ===============================================
// HEGEMONIA GLOBAL - CAÇA SU-35 (Clean Up)
// ===============================================

// Limpar lista de patrulha
if (variable_instance_exists(id, "pontos_patrulha")) {
    ds_list_destroy(pontos_patrulha);
}

show_debug_message("✈️ SU-35 destruído - Memória limpa");
