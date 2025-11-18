// ===============================================
// HEGEMONIA GLOBAL - PRESIDENTE 1 (IA) - CLEANUP EVENT
// Limpeza de memória e data structures
// ===============================================

// ✅ LIMPEZA: Destruir data structures
if (variable_instance_exists(id, "lista_unidades")) {
    if (ds_exists(lista_unidades, ds_type_list)) {
        ds_list_destroy(lista_unidades);
        debug_detailed("✅ Presidente IA: lista_unidades destruído");
    }
}

if (variable_instance_exists(id, "lista_estruturas")) {
    if (ds_exists(lista_estruturas, ds_type_list)) {
        ds_list_destroy(lista_estruturas);
        debug_detailed("✅ Presidente IA: lista_estruturas destruído");
    }
}

if (variable_instance_exists(id, "lista_inimigas_visiveis")) {
    if (ds_exists(lista_inimigas_visiveis, ds_type_list)) {
        ds_list_destroy(lista_inimigas_visiveis);
        debug_detailed("✅ Presidente IA: lista_inimigas_visiveis destruído");
    }
}

if (variable_instance_exists(id, "unidades_em_esquadrao")) {
    if (ds_exists(unidades_em_esquadrao, ds_type_list)) {
        ds_list_destroy(unidades_em_esquadrao);
        debug_detailed("✅ Presidente IA: unidades_em_esquadrao destruído");
    }
}

if (variable_instance_exists(id, "ameacas_detectadas")) {
    if (ds_exists(ameacas_detectadas, ds_type_list)) {
        ds_list_destroy(ameacas_detectadas);
        debug_detailed("✅ Presidente IA: ameacas_detectadas destruído");
    }
}

if (variable_instance_exists(id, "unidades_defesa")) {
    if (ds_exists(unidades_defesa, ds_type_list)) {
        ds_list_destroy(unidades_defesa);
        debug_detailed("✅ Presidente IA: unidades_defesa destruído");
    }
}

if (variable_instance_exists(id, "historico_ameacas")) {
    if (ds_exists(historico_ameacas, ds_type_map)) {
        ds_map_destroy(historico_ameacas);
        debug_detailed("✅ Presidente IA: historico_ameacas destruído");
    }
}

if (variable_instance_exists(id, "tiles_territorio")) {
    if (ds_exists(tiles_territorio, ds_type_list)) {
        ds_list_destroy(tiles_territorio);
        debug_detailed("✅ Presidente IA: tiles_territorio destruído");
    }
}

if (variable_instance_exists(id, "posicoes_costa")) {
    if (ds_exists(posicoes_costa, ds_type_list)) {
        ds_list_destroy(posicoes_costa);
        debug_detailed("✅ Presidente IA: posicoes_costa destruído");
    }
}

// ✅ LIMPEZA: Limpar referências
alvo_atual = noone;
unidade_sendo_treinada = noone;

debug_detailed("✅ Presidente IA ID: " + string(id) + " - Limpeza concluída");

