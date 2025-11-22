/// @description Limpeza de memória - Constellation
// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION - CLEANUP EVENT
// Limpeza de memória e data structures
// ===============================================

// ✅ CORREÇÃO GM2040: Chamar CleanUp do objeto pai PRIMEIRO
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// ✅ LIMPEZA: Limpar referências específicas do Constellation
alvo_unidade = noone;

