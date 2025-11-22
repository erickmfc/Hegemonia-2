// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-5 - CLEANUP EVENT
// Limpeza de memória e data structures
// ===============================================

// ✅ LIMPEZA: Destruir data structures de patrulha
if (variable_instance_exists(id, "pontos_patrulha")) {
    if (ds_exists(pontos_patrulha, ds_type_list)) {
        ds_list_destroy(pontos_patrulha);
    }
}

// ✅ LIMPEZA: Limpar referências
alvo_em_mira = noone;
