/// @description Limpeza de memória - Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE - CLEANUP EVENT
// Limpeza de memória e data structures
// ===============================================

// ✅ CORREÇÃO GM2040: Chamar CleanUp do objeto pai PRIMEIRO
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// ✅ LIMPEZA: Limpar referências específicas do Independence
alvo_unidade = noone;
canhao_instancia = noone;

