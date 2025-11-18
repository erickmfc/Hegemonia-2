/// @description Limpeza de memória - Infantaria
// ===============================================
// HEGEMONIA GLOBAL - INFANTARIA - CLEANUP EVENT
// Limpeza de memória e data structures
// ===============================================

// ✅ LIMPEZA: Destruir data structures de patrulha
if (variable_instance_exists(id, "patrulha")) {
    if (ds_exists(patrulha, ds_type_list)) {
        ds_list_destroy(patrulha);
    }
}

if (variable_instance_exists(id, "pontos_patrulha")) {
    if (ds_exists(pontos_patrulha, ds_type_list)) {
        ds_list_destroy(pontos_patrulha);
    }
}

// ✅ LIMPEZA: Limpar referências
alvo = noone;
seguir_alvo = noone;
