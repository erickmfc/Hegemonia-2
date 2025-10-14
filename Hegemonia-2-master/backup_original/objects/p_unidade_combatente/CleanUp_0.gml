// ===============================================
// HEGEMONIA GLOBAL - OBJETO PAI: UNIDADE COMBATENTE
// Clean Up Event - Limpeza de Memória
// ===============================================

if (ds_exists(rota_de_patrulha, ds_type_list)) {
    ds_list_destroy(rota_de_patrulha);
}
