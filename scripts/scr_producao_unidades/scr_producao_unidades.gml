// ===============================================
// HEGEMONIA GLOBAL - SCRIPT DE PRODUÇÃO UNIFICADO
// Sistema Simplificado para Quartéis
// ===============================================

/// @description Iniciar produção de unidade em quartel
/// @param quartel_id ID do quartel
/// @param unidade_index Índice da unidade na lista
/// @param quantidade Quantidade de unidades a produzir
function iniciar_producao_unidade(quartel_id, unidade_index, quantidade) {
    var _quartel = quartel_id;
    
    // Verificar se quartel existe
    if (!instance_exists(_quartel)) {
        show_debug_message("❌ Quartel não encontrado!");
        return false;
    }
    
    // Obter dados da unidade
    var _unidade_data = ds_list_find_value(_quartel.unidades_disponiveis, unidade_index);
    if (_unidade_data == undefined) {
        show_debug_message("❌ Unidade não encontrada!");
        return false;
    }
    
    // Verificar recursos
    if (!verificar_recursos_unidade(_unidade_data, quantidade)) {
        show_debug_message("❌ Recursos insuficientes!");
        return false;
    }
    
    // Deduzir recursos
    deduzir_recursos_unidade(_unidade_data, quantidade);
    
    // Adicionar unidades à fila
    for (var i = 0; i < quantidade; i++) {
        ds_queue_enqueue(_quartel.fila_producao, _unidade_data);
    }
    
    // Iniciar produção
    _quartel.produzindo = true;
    _quartel.timer_producao = 0;
    
    // Configurar alarme para primeira unidade
    if (quantidade > 0) {
        _quartel.alarm[0] = _unidade_data.tempo_treino;
    }
    
    show_debug_message("✅ Produção iniciada: " + string(quantidade) + "x " + _unidade_data.nome);
    return true;
}

/// @description Verificar se há recursos suficientes
/// @param unidade_data Dados da unidade
/// @param quantidade Quantidade desejada
function verificar_recursos_unidade(unidade_data, quantidade) {
    var _custo_total_dinheiro = unidade_data.custo_dinheiro * quantidade;
    var _custo_total_populacao = unidade_data.custo_populacao * quantidade;
    
    // Usar sistema centralizado de recursos
    if (!verificar_recurso_disponivel("dinheiro", _custo_total_dinheiro)) {
        show_debug_message("❌ Dinheiro insuficiente: " + string(obter_recurso_disponivel("dinheiro")) + "/" + string(_custo_total_dinheiro));
        return false;
    }
    
    if (!verificar_recurso_disponivel("populacao", _custo_total_populacao)) {
        show_debug_message("❌ População insuficiente: " + string(obter_recurso_disponivel("populacao")) + "/" + string(_custo_total_populacao));
        return false;
    }
    
    return true;
}

/// @description Deduzir recursos do estoque
/// @param unidade_data Dados da unidade
/// @param quantidade Quantidade
function deduzir_recursos_unidade(unidade_data, quantidade) {
    var _custo_total_dinheiro = unidade_data.custo_dinheiro * quantidade;
    var _custo_total_populacao = unidade_data.custo_populacao * quantidade;
    
    // Usar sistema centralizado de recursos
    deduzir_recurso_seguro("dinheiro", _custo_total_dinheiro);
    deduzir_recurso_seguro("populacao", _custo_total_populacao);
    
    show_debug_message("💰 Recursos deduzidos: $" + string(_custo_total_dinheiro) + ", População: " + string(_custo_total_populacao));
}

/// @description Criar unidade com verificação de segurança
/// @param quartel_id ID do quartel
/// @param unidade_data Dados da unidade
/// @param spawn_x Posição X de spawn
/// @param spawn_y Posição Y de spawn
function criar_unidade_segura(quartel_id, unidade_data, spawn_x, spawn_y) {
    var _quartel = quartel_id;
    var _tipo_quartel = "terrestre";
    
    // Determinar tipo de quartel
    if (_quartel.object_index == obj_quartel_marinha) {
        _tipo_quartel = "naval";
    }
    
    // Validar objeto usando sistema de validação
    var _obj_unidade = validar_objeto_unidade(unidade_data.objeto, _tipo_quartel);
    
    // Determinar layer baseado no tipo de quartel
    var _layer = "Instances";
    if (_quartel.object_index == obj_quartel_marinha) {
        _layer = "rm_mapa_principal";
    }
    
    // Criar unidade
    var _unidade_criada = instance_create_layer(spawn_x, spawn_y, _layer, _obj_unidade);
    
    if (instance_exists(_unidade_criada)) {
        _unidade_criada.nacao_proprietaria = _quartel.nacao_proprietaria;
        show_debug_message("✅ " + unidade_data.nome + " criada com sucesso!");
        return _unidade_criada;
    } else {
        show_debug_message("❌ Falha ao criar unidade!");
        return noone;
    }
}
