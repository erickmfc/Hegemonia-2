// ===============================================
// HEGEMONIA GLOBAL - AEROPORTO MILITAR - CLEANUP EVENT
// Limpeza de memória e data structures
// ===============================================

// ✅ LIMPEZA: Destruir data structures
if (variable_instance_exists(id, "unidades_disponiveis")) {
    if (ds_exists(unidades_disponiveis, ds_type_list)) {
        ds_list_destroy(unidades_disponiveis);
        debug_detailed("✅ Aeroporto: unidades_disponiveis destruído");
    }
}

if (variable_instance_exists(id, "fila_producao")) {
    if (ds_exists(fila_producao, ds_type_queue)) {
        ds_queue_destroy(fila_producao);
        debug_detailed("✅ Aeroporto: fila_producao destruído");
    }
}

// ✅ LIMPEZA: Fechar menu de recrutamento se existir
if (variable_instance_exists(id, "menu_recrutamento")) {
    if (instance_exists(menu_recrutamento)) {
        instance_destroy(menu_recrutamento);
    }
    menu_recrutamento = noone;
}

// ✅ LIMPEZA: Limpar referências
unidade_sendo_treinada = noone;
alvo_atual = noone;

debug_detailed("✅ Aeroporto Militar ID: " + string(id) + " - Limpeza concluída");

