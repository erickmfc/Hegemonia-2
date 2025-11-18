/// @description Limpeza de memória - Porta-Aviões Ronald Reagan
// ===============================================
// HEGEMONIA GLOBAL - RONALD REAGAN - CLEANUP EVENT
// Limpeza de memória e data structures
// ===============================================

// ✅ LIMPEZA: Destruir data structures de patrulha
if (variable_instance_exists(id, "pontos_patrulha")) {
    if (ds_exists(pontos_patrulha, ds_type_list)) {
        ds_list_destroy(pontos_patrulha);
    }
}

// ✅ LIMPEZA: Destruir listas de embarcados
if (variable_instance_exists(id, "avioes_embarcados")) {
    if (ds_exists(avioes_embarcados, ds_type_list)) {
        ds_list_destroy(avioes_embarcados);
    }
}

if (variable_instance_exists(id, "unidades_embarcadas")) {
    if (ds_exists(unidades_embarcadas, ds_type_list)) {
        ds_list_destroy(unidades_embarcadas);
    }
}

if (variable_instance_exists(id, "soldados_embarcados")) {
    if (ds_exists(soldados_embarcados, ds_type_list)) {
        ds_list_destroy(soldados_embarcados);
    }
}

if (variable_instance_exists(id, "avioes_visiveis")) {
    if (ds_exists(avioes_visiveis, ds_type_list)) {
        ds_list_destroy(avioes_visiveis);
    }
}

// ✅ LIMPEZA: Destruir fila de desembarque
if (variable_instance_exists(id, "desembarque_fila")) {
    if (ds_exists(desembarque_fila, ds_type_queue)) {
        ds_queue_destroy(desembarque_fila);
    }
}

// ✅ LIMPEZA: Limpar referências
alvo_unidade = noone;
seguir_alvo = noone;
