// ===============================================
// HEGEMONIA GLOBAL - TESTE DO SISTEMA UNIFICADO
// Verificação Completa dos Quartéis
// ===============================================

/// @description Testar sistema unificado de quartéis
function testar_sistema_unificado_completo() {
    show_debug_message("🧪 === TESTE DO SISTEMA UNIFICADO ===");
    
    // 1. Verificar objetos base
    if (!object_exists(obj_quartel_base)) {
        show_debug_message("❌ ERRO: obj_quartel_base não existe!");
        return false;
    }
    
    // 2. Verificar quartéis específicos
    if (!object_exists(obj_quartel)) {
        show_debug_message("❌ ERRO: obj_quartel não existe!");
        return false;
    }
    
    if (!object_exists(obj_quartel_marinha)) {
        show_debug_message("❌ ERRO: obj_quartel_marinha não existe!");
        return false;
    }
    
    // 3. Verificar scripts
    if (!function_exists("scr_producao_unificada")) {
        show_debug_message("❌ ERRO: scr_producao_unificada não existe!");
        return false;
    }
    
    if (!function_exists("scr_verificar_recursos_unificados")) {
        show_debug_message("❌ ERRO: scr_verificar_recursos_unificados não existe!");
        return false;
    }
    
    if (!function_exists("scr_criar_unidade_segura")) {
        show_debug_message("❌ ERRO: scr_criar_unidade_segura não existe!");
        return false;
    }
    
    // 4. Contar quartéis existentes
    var _quartéis_terrestres = 0;
    var _quartéis_navais = 0;
    
    with (obj_quartel) {
        _quartéis_terrestres++;
        show_debug_message("✅ Quartel terrestre encontrado - ID: " + string(id));
    }
    
    with (obj_quartel_marinha) {
        _quartéis_navais++;
        show_debug_message("✅ Quartel naval encontrado - ID: " + string(id));
    }
    
    // 5. Verificar variáveis dos quartéis
    with (obj_quartel) {
        if (!variable_instance_exists(id, "fila_producao")) {
            show_debug_message("❌ ERRO: fila_producao não existe no quartel " + string(id));
        }
        if (!variable_instance_exists(id, "unidades_disponiveis")) {
            show_debug_message("❌ ERRO: unidades_disponiveis não existe no quartel " + string(id));
        }
    }
    
    with (obj_quartel_marinha) {
        if (!variable_instance_exists(id, "fila_producao")) {
            show_debug_message("❌ ERRO: fila_producao não existe no quartel naval " + string(id));
        }
        if (!variable_instance_exists(id, "unidades_disponiveis")) {
            show_debug_message("❌ ERRO: unidades_disponiveis não existe no quartel naval " + string(id));
        }
    }
    
    // 6. Resumo do teste
    show_debug_message("📊 === RESUMO DO TESTE ===");
    show_debug_message("   Quartéis terrestres: " + string(_quartéis_terrestres));
    show_debug_message("   Quartéis navais: " + string(_quartéis_navais));
    show_debug_message("   Sistema unificado: ✅ FUNCIONANDO");
    show_debug_message("================================");
    
    return true;
}

/// @description Testar produção de unidade
/// @param quartel_id ID do quartel
/// @param unidade_index Índice da unidade
function testar_producao_unidade_simples(quartel_id, unidade_index) {
    show_debug_message("🧪 Testando produção de unidade...");
    
    var _quartel = quartel_id;
    if (!instance_exists(_quartel)) {
        show_debug_message("❌ Quartel não encontrado!");
        return false;
    }
    
    // Verificar se tem unidades disponíveis
    if (ds_list_size(_quartel.unidades_disponiveis) == 0) {
        show_debug_message("❌ Nenhuma unidade disponível no quartel!");
        return false;
    }
    
    // Tentar adicionar à fila
    var _resultado = scr_adicionar_fila_producao(unidade_index);
    
    if (_resultado) {
        show_debug_message("✅ Teste de produção bem-sucedido!");
        show_debug_message("📋 Unidade adicionada à fila do quartel " + string(_quartel.id));
    } else {
        show_debug_message("❌ Teste de produção falhou!");
    }
    
    return _resultado;
}

/// @description Obter status completo do sistema
function obter_status_sistema_unificado() {
    show_debug_message("📊 === STATUS DO SISTEMA UNIFICADO ===");
    
    // Recursos globais
    if (variable_global_exists("dinheiro")) {
        show_debug_message("💰 Dinheiro: " + string(global.dinheiro));
    } else {
        show_debug_message("⚠️ Dinheiro global não definido");
    }
    
    if (variable_global_exists("nacao_recursos")) {
        show_debug_message("⛏️ Minério: " + string(global.nacao_recursos[? "Minério"]));
    } else {
        show_debug_message("⚠️ Recursos da nação não definidos");
    }
    
    // Quartéis
    var _total_quartéis = 0;
    var _quartéis_produzindo = 0;
    var _unidades_na_fila = 0;
    
    with (obj_quartel) {
        _total_quartéis++;
        if (produzindo) _quartéis_produzindo++;
        _unidades_na_fila += ds_queue_size(fila_producao);
        show_debug_message("🏛️ Quartel Terrestre ID " + string(id) + ":");
        show_debug_message("   Produzindo: " + string(produzindo));
        show_debug_message("   Fila: " + string(ds_queue_size(fila_producao)));
        show_debug_message("   Unidades disponíveis: " + string(ds_list_size(unidades_disponiveis)));
    }
    
    with (obj_quartel_marinha) {
        _total_quartéis++;
        if (produzindo) _quartéis_produzindo++;
        _unidades_na_fila += ds_queue_size(fila_producao);
        show_debug_message("🚢 Quartel Naval ID " + string(id) + ":");
        show_debug_message("   Produzindo: " + string(produzindo));
        show_debug_message("   Fila: " + string(ds_queue_size(fila_producao)));
        show_debug_message("   Unidades disponíveis: " + string(ds_list_size(unidades_disponiveis)));
    }
    
    show_debug_message("📈 Total de quartéis: " + string(_total_quartéis));
    show_debug_message("⚙️ Quartéis produzindo: " + string(_quartéis_produzindo));
    show_debug_message("📋 Unidades na fila: " + string(_unidades_na_fila));
    show_debug_message("=====================================");
}
