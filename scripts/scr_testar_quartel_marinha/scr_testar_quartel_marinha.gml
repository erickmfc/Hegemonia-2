// ===============================================
// HEGEMONIA GLOBAL - TESTE DO QUARTEL DA MARINHA
// Script de Teste Completo
// ===============================================

/// @description Testar quartel da marinha
/// @return {struct} Resultado do teste
function scr_testar_quartel_marinha() {
    var _resultado = {
        sucesso: false,
        erros: [],
        avisos: [],
        estatisticas: {}
    };
    
    show_debug_message("=== INICIANDO TESTE DO QUARTEL DA MARINHA ===");
    
    // === TESTE 1: VERIFICAR OBJETO DO QUARTEL ===
    if (!object_exists(obj_quartel_marinha)) {
        _resultado.erros[array_length(_resultado.erros)] = "Objeto obj_quartel_marinha não existe";
        return _resultado;
    }
    
    // === TESTE 2: VERIFICAR OBJETO DO MENU ===
    if (!object_exists(obj_menu_recrutamento_marinha)) {
        _resultado.erros[array_length(_resultado.erros)] = "Objeto obj_menu_recrutamento_marinha não existe";
        return _resultado;
    }
    
    // === TESTE 3: VERIFICAR OBJETO DA LANCHA ===
    if (!object_exists(obj_lancha_patrulha)) {
        _resultado.erros[array_length(_resultado.erros)] = "Objeto obj_lancha_patrulha não existe";
        return _resultado;
    }
    
    // === TESTE 4: VERIFICAR SCRIPTS ===
    if (!script_exists(scr_selecionar_quartel)) {
        _resultado.erros[array_length(_resultado.erros)] = "Script scr_selecionar_quartel não existe";
    }
    
    if (!script_exists(scr_logica_quartel_comum)) {
        _resultado.erros[array_length(_resultado.erros)] = "Script scr_logica_quartel_comum não existe";
    }
    
    // === TESTE 5: CRIAR QUARTEL DE TESTE ===
    var _quartel_teste = instance_create_layer(200, 200, "Instances", obj_quartel_marinha);
    if (!instance_exists(_quartel_teste)) {
        _resultado.erros[array_length(_resultado.erros)] = "Falha ao criar quartel de teste";
        return _resultado;
    }
    
    // === TESTE 6: VERIFICAR VARIÁVEIS DO QUARTEL ===
    var _variaveis_obrigatorias = [
        "custo_dinheiro", "custo_minerio", "hp_max", "hp_atual",
        "fila_producao", "timer_producao", "produzindo", "unidades_produzidas",
        "unidades_disponiveis", "selecionado", "menu_recrutamento"
    ];
    
    for (var i = 0; i < array_length(_variaveis_obrigatorias); i++) {
        var _variavel = _variaveis_obrigatorias[i];
        if (!variable_instance_exists(_quartel_teste, _variavel)) {
            _resultado.erros[array_length(_resultado.erros)] = "Variável " + _variavel + " não existe no quartel";
        }
    }
    
    // === TESTE 7: VERIFICAR UNIDADES DISPONÍVEIS ===
    if (ds_list_size(_quartel_teste.unidades_disponiveis) == 0) {
        _resultado.erros[array_length(_resultado.erros)] = "Nenhuma unidade disponível no quartel";
    } else {
        var _unidade = ds_list_find_value(_quartel_teste.unidades_disponiveis, 0);
        if (_unidade == undefined) {
            _resultado.erros[array_length(_resultado.erros)] = "Dados da primeira unidade inválidos";
        } else {
            _resultado.estatisticas.unidades_disponiveis = ds_list_size(_quartel_teste.unidades_disponiveis);
            _resultado.estatisticas.primeira_unidade = _unidade.nome;
        }
    }
    
    // === TESTE 8: VERIFICAR FILA DE PRODUÇÃO ===
    if (!ds_queue_empty(_quartel_teste.fila_producao)) {
        _resultado.avisos[array_length(_resultado.avisos)] = "Fila de produção não está vazia";
    }
    
    // === TESTE 9: TESTAR SELEÇÃO ===
    var _sucesso_selecao = scr_selecionar_quartel(_quartel_teste, obj_menu_recrutamento_marinha);
    if (!_sucesso_selecao) {
        _resultado.erros[array_length(_resultado.erros)] = "Falha na seleção do quartel";
    } else {
        _resultado.estatisticas.selecao_funcionando = true;
    }
    
    // === TESTE 10: VERIFICAR MENU CRIADO ===
    if (_quartel_teste.menu_recrutamento != noone && instance_exists(_quartel_teste.menu_recrutamento)) {
        _resultado.estatisticas.menu_criado = true;
        _resultado.estatisticas.menu_id = _quartel_teste.menu_recrutamento;
    } else {
        _resultado.erros[array_length(_resultado.erros)] = "Menu de recrutamento não foi criado";
    }
    
    // === RESULTADO FINAL ===
    if (array_length(_resultado.erros) == 0) {
        _resultado.sucesso = true;
        show_debug_message("✅ TESTE DO QUARTEL DA MARINHA: SUCESSO!");
    } else {
        show_debug_message("❌ TESTE DO QUARTEL DA MARINHA: FALHOU!");
        for (var i = 0; i < array_length(_resultado.erros); i++) {
            show_debug_message("ERRO: " + _resultado.erros[i]);
        }
    }
    
    // Limpar teste
    if (instance_exists(_quartel_teste)) {
        instance_destroy(_quartel_teste);
    }
    
    return _resultado;
}
