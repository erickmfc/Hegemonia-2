// ================================================
// HEGEMONIA GLOBAL - M1A ABRAMS
// Destroy Event - Limpeza
// ================================================

// Limpar listas de patrulha
if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
    ds_list_destroy(pontos_patrulha);
}

if (variable_instance_exists(id, "patrulha") && ds_exists(patrulha, ds_type_list)) {
    ds_list_destroy(patrulha);
}

// Invalidar cache de inimigos (se aplicável)
if (variable_instance_exists(id, "alvo") && alvo != noone) {
    // Alvo será limpo automaticamente quando a instância for destruída
}

show_debug_message("🗑️ M1A Abrams destruído - limpeza concluída");
