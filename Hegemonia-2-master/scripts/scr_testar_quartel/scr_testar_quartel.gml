// ===============================================
// HEGEMONIA GLOBAL - TESTE DE QUARTÉIS
// Sistema de Teste Individual para Cada Quartel
// ===============================================

/// @description Testar quartel específico
/// @param {string} tipo_quartel Tipo do quartel ("terrestre", "naval")
/// @return {struct} Resultado do teste
function scr_testar_quartel(tipo_quartel) {
    var _resultado = {
        sucesso: false,
        erros: [],
        avisos: [],
        estatisticas: {}
    };
    
    show_debug_message("=== INICIANDO TESTE DO QUARTEL " + tipo_quartel + " ===");
    
    // === TESTE 1: VERIFICAR OBJETO DO QUARTEL ===
    var _obj_quartel = noone;
    switch (tipo_quartel) {
        case "terrestre":
            _obj_quartel = obj_quartel;
            break;
        case "naval":
            _obj_quartel = obj_quartel_marinha;
            break;
        default:
            _resultado.erros[array_length(_resultado.erros)] = "Tipo de quartel inválido: " + tipo_quartel;
            return _resultado;
    }
    
    if (!object_exists(_obj_quartel)) {
        _resultado.erros[array_length(_resultado.erros)] = "Objeto " + string(_obj_quartel) + " não existe";
        return _resultado;
    }
    
    // === TESTE 2: VERIFICAR OBJETO DO MENU ===
    var _obj_menu = noone;
    switch (tipo_quartel) {
        case "terrestre":
            _obj_menu = obj_menu_recrutamento;
            break;
        case "naval":
            _obj_menu = obj_menu_recrutamento_marinha;
            break;
    }
    
    if (!object_exists(_obj_menu)) {
        _resultado.erros[array_length(_resultado.erros)] = "Objeto do menu " + string(_obj_menu) + " não existe";
        return _resultado;
    }
    
    // === TESTE 3: CRIAR QUARTEL DE TESTE ===
    var _quartel_teste = instance_create_layer(100, 100, "Instances", _obj_quartel);
    if (!instance_exists(_quartel_teste)) {
        _resultado.erros[array_length(_resultado.erros)] = "Falha ao criar quartel de teste";
        return _resultado;
    }
    
    // === TESTE 4: VERIFICAR VARIÁVEIS ESSENCIAIS ===
    var _variaveis_essenciais = [
        "estrutura_id", "estrutura_tipo", "nacao_proprietaria",
        "custo_dinheiro", "custo_minerio", "custo_petroleo", "custo_populacao",
        "hp_max", "hp_atual", "armadura",
        "producao_por_ciclo", "tipo_recurso",
        "pode_upgradar", "nivel_maximo",
        "posicao_valida", "requer_agua", "requer_terra", "requer_eletricidade",
        "estrutura_construida", "estrutura_funcionando", "estrutura_danificada",
        "manutencao_necessaria", "custo_manutencao", "tempo_manutencao",
        "pode_ser_atacada", "conexoes_necessarias", "conexoes_ativas",
        "efeitos_visuais", "efeitos_sonoros", "debug_ativo", "ultima_atualizacao"
    ];
    
    var _variaveis_ok = 0;
    var _variaveis_total = array_length(_variaveis_essenciais);
    
    for (var i = 0; i < _variaveis_total; i++) {
        if (variable_instance_exists(_quartel_teste, _variaveis_essenciais[i])) {
            _variaveis_ok++;
        } else {
            _resultado.avisos[array_length(_resultado.avisos)] = "Variável ausente: " + _variaveis_essenciais[i];
        }
    }
    
    _resultado.estatisticas.variaveis_ok = _variaveis_ok;
    _resultado.estatisticas.variaveis_total = _variaveis_total;
    _resultado.estatisticas.variaveis_percentual = (_variaveis_ok / _variaveis_total) * 100;
    
    // === TESTE 5: VERIFICAR CONFIGURAÇÃO ===
    if (function_exists("scr_config_estruturas")) {
        var _config = scr_config_estruturas(tipo_quartel);
        if (_config == undefined) {
            _resultado.erros[array_length(_resultado.erros)] = "Configuração não encontrada para " + tipo_quartel;
        } else {
            _resultado.estatisticas.config_custo_dinheiro = _config.custo_dinheiro;
            _resultado.estatisticas.config_hp_max = _config.hp_max;
            _resultado.estatisticas.config_armadura = _config.armadura;
        }
    } else {
        _resultado.avisos[array_length(_resultado.avisos)] = "Função scr_config_estruturas não existe";
    }
    
    // === TESTE 6: TESTAR FUNCIONALIDADES ===
    
    // Testar abertura de menu
    if (function_exists("scr_abrir_menu_recrutamento")) {
        if (scr_abrir_menu_recrutamento(_quartel_teste, tipo_quartel)) {
            _resultado.estatisticas.menu_aberto = true;
            if (function_exists("scr_fechar_menu_recrutamento")) {
                scr_fechar_menu_recrutamento();
            }
        } else {
            _resultado.avisos[array_length(_resultado.avisos)] = "Falha ao abrir menu de recrutamento";
        }
    } else {
        _resultado.avisos[array_length(_resultado.avisos)] = "Função scr_abrir_menu_recrutamento não existe";
    }
    
    // Testar verificação de recrutamento
    if (function_exists("scr_quartel_pode_recrutar")) {
        if (scr_quartel_pode_recrutar(_quartel_teste)) {
            _resultado.estatisticas.pode_recrutar = true;
        } else {
            _resultado.avisos[array_length(_resultado.avisos)] = "Quartel não pode recrutar";
        }
    } else {
        _resultado.avisos[array_length(_resultado.avisos)] = "Função scr_quartel_pode_recrutar não existe";
    }
    
    // === TESTE 7: VERIFICAR UNIDADES ASSOCIADAS ===
    var _unidades_teste = [];
    switch (tipo_quartel) {
        case "terrestre":
            _unidades_teste = ["infantaria"];
            break;
        case "naval":
            _unidades_teste = ["fragata", "destroyer", "submarino", "porta_avioes"];
            break;
    }
    
    var _unidades_ok = 0;
    if (function_exists("scr_config_unidades")) {
        for (var i = 0; i < array_length(_unidades_teste); i++) {
            var _config_unidade = scr_config_unidades(_unidades_teste[i]);
            if (_config_unidade != undefined) {
                _unidades_ok++;
            } else {
                _resultado.avisos[array_length(_resultado.avisos)] = "Configuração de unidade não encontrada: " + _unidades_teste[i];
            }
        }
    } else {
        _resultado.avisos[array_length(_resultado.avisos)] = "Função scr_config_unidades não existe";
    }
    
    _resultado.estatisticas.unidades_ok = _unidades_ok;
    _resultado.estatisticas.unidades_total = array_length(_unidades_teste);
    _resultado.estatisticas.unidades_percentual = (_unidades_ok / array_length(_unidades_teste)) * 100;
    
    // === TESTE 8: LIMPEZA ===
    instance_destroy(_quartel_teste);
    
    // === RESULTADO FINAL ===
    if (array_length(_resultado.erros) == 0) {
        _resultado.sucesso = true;
        show_debug_message("✅ TESTE DO QUARTEL " + tipo_quartel + " CONCLUÍDO COM SUCESSO");
    } else {
        show_debug_message("❌ TESTE DO QUARTEL " + tipo_quartel + " FALHOU");
    }
    
    // Mostrar estatísticas
    show_debug_message("📊 ESTATÍSTICAS:");
    show_debug_message("- Variáveis: " + string(_resultado.estatisticas.variaveis_ok) + "/" + string(_resultado.estatisticas.variaveis_total) + " (" + string(_resultado.estatisticas.variaveis_percentual) + "%)");
    show_debug_message("- Unidades: " + string(_resultado.estatisticas.unidades_ok) + "/" + string(_resultado.estatisticas.unidades_total) + " (" + string(_resultado.estatisticas.unidades_percentual) + "%)");
    
    if (_resultado.estatisticas.menu_aberto) {
        show_debug_message("- Menu: ✅ Funcionando");
    } else {
        show_debug_message("- Menu: ❌ Com problemas");
    }
    
    if (_resultado.estatisticas.pode_recrutar) {
        show_debug_message("- Recrutamento: ✅ Funcionando");
    } else {
        show_debug_message("- Recrutamento: ❌ Com problemas");
    }
    
    // Mostrar erros
    if (array_length(_resultado.erros) > 0) {
        show_debug_message("❌ ERROS ENCONTRADOS:");
        for (var i = 0; i < array_length(_resultado.erros); i++) {
            show_debug_message("  - " + _resultado.erros[i]);
        }
    }
    
    // Mostrar avisos
    if (array_length(_resultado.avisos) > 0) {
        show_debug_message("⚠️ AVISOS:");
        for (var i = 0; i < array_length(_resultado.avisos); i++) {
            show_debug_message("  - " + _resultado.avisos[i]);
        }
    }
    
    show_debug_message("=== FIM DO TESTE DO QUARTEL " + tipo_quartel + " ===");
    
    return _resultado;
}

/// @description Testar todos os quartéis
function scr_testar_todos_quartels() {
    show_debug_message("=== INICIANDO TESTE COMPLETO DE QUARTÉIS ===");
    
    var _resultados = {};
    
    // Testar quartel terrestre
    _resultados.terrestre = scr_testar_quartel("terrestre");
    
    // Testar quartel naval
    _resultados.naval = scr_testar_quartel("naval");
    
    // Resumo final
    show_debug_message("=== RESUMO FINAL DOS TESTES ===");
    
    var _total_testes = 2;
    var _testes_sucesso = 0;
    
    if (_resultados.terrestre.sucesso) {
        _testes_sucesso++;
        show_debug_message("✅ Quartel Terrestre: PASSOU");
    } else {
        show_debug_message("❌ Quartel Terrestre: FALHOU");
    }
    
    if (_resultados.naval.sucesso) {
        _testes_sucesso++;
        show_debug_message("✅ Quartel Naval: PASSOU");
    } else {
        show_debug_message("❌ Quartel Naval: FALHOU");
    }
    
    show_debug_message("📊 RESULTADO GERAL: " + string(_testes_sucesso) + "/" + string(_total_testes) + " testes passaram");
    
    if (_testes_sucesso == _total_testes) {
        show_debug_message("🎉 TODOS OS TESTES PASSARAM! Sistema funcionando perfeitamente.");
    } else {
        show_debug_message("⚠️ ALGUNS TESTES FALHARAM. Verifique os erros acima.");
    }
    
    show_debug_message("=== FIM DO TESTE COMPLETO ===");
    
    return _resultados;
}