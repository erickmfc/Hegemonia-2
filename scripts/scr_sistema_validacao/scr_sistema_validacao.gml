// Sistema de Validação Contínua e Auto-Correção - Hegemonia Global
// Detecta e corrige problemas automaticamente

// Estrutura para problemas detectados
global.problemas_detectados = [];
global.correcoes_aplicadas = [];

// Contadores de validação
global.validacao_stats = {
    total_validacoes: 0,
    problemas_encontrados: 0,
    correcoes_aplicadas: 0,
    ultima_validacao: 0
};

function scr_inicializar_sistema_validacao() {
    scr_log_sistema("VALIDACAO", "Sistema de validação inicializado");
    
    global.problemas_detectados = [];
    global.correcoes_aplicadas = [];
    
    // Configurar timer de validação
    global.timer_validacao = global.config.validation_interval;
}

function scr_validar_sistema_completo() {
    global.validacao_stats.total_validacoes++;
    global.validacao_stats.ultima_validacao = current_time;
    
    scr_debug_log("VALIDACAO", "Iniciando validação completa do sistema", DEBUG_LEVEL.BASIC);
    
    var _problemas = [];
    
    // Validar objetos
    _problemas = array_concat(_problemas, scr_validar_objetos());
    
    // Validar recursos
    _problemas = array_concat(_problemas, scr_validar_recursos());
    
    // Validar data structures
    _problemas = array_concat(_problemas, scr_validar_data_structures());
    
    // Validar integridade do sistema
    _problemas = array_concat(_problemas, scr_validar_integridade_sistema());
    
    // Validar performance
    _problemas = array_concat(_problemas, scr_validar_performance());
    
    global.problemas_detectados = _problemas;
    global.validacao_stats.problemas_encontrados += array_length(_problemas);
    
    scr_debug_log("VALIDACAO", "Validação concluída. Problemas encontrados: " + string(array_length(_problemas)), DEBUG_LEVEL.BASIC);
    
    // Auto-correção se habilitada
    if (global.config.auto_correction && array_length(_problemas) > 0) {
        scr_corrigir_problemas_automaticamente(_problemas);
    }
    
    return _problemas;
}

function scr_validar_objetos() {
    var _problemas = [];
    
    scr_debug_log("VALIDACAO", "Validando objetos do sistema", DEBUG_LEVEL.DETAILED);
    
    // Verificar objetos críticos
    var _objetos_criticos = [
        "obj_controlador_unidades",
        "obj_gerenciador_recursos",
        "obj_sistema_combate",
        "obj_interface_usuario"
    ];
    
    for (var i = 0; i < array_length(_objetos_criticos); i++) {
        var _obj_name = _objetos_criticos[i];
        var _obj_count = instance_number(asset_get_index(_obj_name));
        
        if (_obj_count == 0) {
            array_push(_problemas, {
                tipo: "OBJETO_CRITICO_AUSENTE",
                objeto: _obj_name,
                severidade: "CRITICO",
                descricao: "Objeto crítico " + _obj_name + " não encontrado",
                timestamp: current_time
            });
        } else if (_obj_count > 1) {
            array_push(_problemas, {
                tipo: "OBJETO_DUPLICADO",
                objeto: _obj_name,
                severidade: "ALTO",
                descricao: "Múltiplas instâncias de " + _obj_name + " (" + string(_obj_count) + ")",
                timestamp: current_time
            });
        }
    }
    
    // Verificar objetos órfãos
    var _total_objects = instance_number(all);
    var _expected_objects = scr_calcular_objetos_esperados();
    
    if (_total_objects > _expected_objects * 1.5) {
        array_push(_problemas, {
            tipo: "MUITOS_OBJETOS",
            severidade: "MEDIO",
            descricao: "Muitos objetos ativos: " + string(_total_objects) + " (esperado: ~" + string(_expected_objects) + ")",
            timestamp: current_time
        });
    }
    
    return _problemas;
}

function scr_validar_recursos() {
    var _problemas = [];
    
    scr_debug_log("VALIDACAO", "Validando recursos do sistema", DEBUG_LEVEL.DETAILED);
    
    // Verificar recursos negativos
    if (global.recursos != undefined) {
        var _recursos = ["madeira", "pedra", "comida", "ouro"];
        
        for (var i = 0; i < array_length(_recursos); i++) {
            var _recurso = _recursos[i];
            var _valor = global.recursos[$ _recurso];
            
            if (_valor < 0) {
                array_push(_problemas, {
                    tipo: "RECURSO_NEGATIVO",
                    recurso: _recurso,
                    valor: _valor,
                    severidade: "ALTO",
                    descricao: "Recurso " + _recurso + " com valor negativo: " + string(_valor),
                    timestamp: current_time
                });
            }
        }
    }
    
    return _problemas;
}

function scr_validar_data_structures() {
    var _problemas = [];
    
    scr_debug_log("VALIDACAO", "Validando data structures", DEBUG_LEVEL.DETAILED);
    
    // Verificar lists órfãos
    for (var i = 0; i < array_length(global.data_structures.lists); i++) {
        var _list = global.data_structures.lists[i];
        if (!ds_exists(_list, ds_type_list)) {
            array_push(_problemas, {
                tipo: "DS_LIST_ORFAO",
                ds_id: _list,
                severidade: "MEDIO",
                descricao: "DS_List órfão encontrado: " + string(_list),
                timestamp: current_time
            });
        }
    }
    
    // Verificar queues órfãos
    for (var i = 0; i < array_length(global.data_structures.queues); i++) {
        var _queue = global.data_structures.queues[i];
        if (!ds_exists(_queue, ds_type_queue)) {
            array_push(_problemas, {
                tipo: "DS_QUEUE_ORFAO",
                ds_id: _queue,
                severidade: "MEDIO",
                descricao: "DS_Queue órfão encontrado: " + string(_queue),
                timestamp: current_time
            });
        }
    }
    
    return _problemas;
}

function scr_validar_integridade_sistema() {
    var _problemas = [];
    
    scr_debug_log("VALIDACAO", "Validando integridade do sistema", DEBUG_LEVEL.DETAILED);
    
    // Verificar variáveis globais críticas
    var _variaveis_criticas = ["config", "recursos", "unidades_selecionadas"];
    
    for (var i = 0; i < array_length(_variaveis_criticas); i++) {
        var _var = _variaveis_criticas[i];
        if (!variable_global_exists(_var)) {
            array_push(_problemas, {
                tipo: "VARIAVEL_GLOBAL_AUSENTE",
                variavel: _var,
                severidade: "CRITICO",
                descricao: "Variável global crítica ausente: " + _var,
                timestamp: current_time
            });
        }
    }
    
    // Verificar configurações
    if (global.config != undefined) {
        if (global.config.debug_level < 0 || global.config.debug_level > 3) {
            array_push(_problemas, {
                tipo: "CONFIG_INVALIDA",
                config: "debug_level",
                valor: global.config.debug_level,
                severidade: "MEDIO",
                descricao: "Valor de debug_level inválido: " + string(global.config.debug_level),
                timestamp: current_time
            });
        }
    }
    
    return _problemas;
}

function scr_validar_performance() {
    var _problemas = [];
    
    scr_debug_log("VALIDACAO", "Validando performance do sistema", DEBUG_LEVEL.DETAILED);
    
    // Verificar FPS
    var _fps_atual = fps;
    var _fps_minimo = 30;
    
    if (_fps_atual < _fps_minimo) {
        array_push(_problemas, {
            tipo: "FPS_BAIXO",
            fps_atual: _fps_atual,
            fps_minimo: _fps_minimo,
            severidade: "ALTO",
            descricao: "FPS muito baixo: " + string(_fps_atual) + " (mínimo: " + string(_fps_minimo) + ")",
            timestamp: current_time
        });
    }
    
    // Verificar uso de memória
    var _uso_memoria = scr_calcular_uso_memoria();
    var _limite_memoria = global.config.memory_threshold;
    
    if (_uso_memoria > _limite_memoria) {
        array_push(_problemas, {
            tipo: "MEMORIA_ALTA",
            uso_atual: _uso_memoria,
            limite: _limite_memoria,
            severidade: "ALTO",
            descricao: "Uso de memória alto: " + string(_uso_memoria) + "% (limite: " + string(_limite_memoria) + "%)",
            timestamp: current_time
        });
    }
    
    return _problemas;
}

function scr_corrigir_problemas_automaticamente(problemas) {
    scr_debug_log("VALIDACAO", "Iniciando auto-correção de " + string(array_length(problemas)) + " problemas", DEBUG_LEVEL.BASIC);
    
    var _correcoes_aplicadas = 0;
    
    for (var i = 0; i < array_length(problemas); i++) {
        var _problema = problemas[i];
        var _corrigido = false;
        
        switch(_problema.tipo) {
            case "RECURSO_NEGATIVO":
                _corrigido = scr_corrigir_recurso_negativo(_problema);
                break;
                
            case "DS_LIST_ORFAO":
            case "DS_QUEUE_ORFAO":
                _corrigido = scr_corrigir_ds_orfao(_problema);
                break;
                
            case "CONFIG_INVALIDA":
                _corrigido = scr_corrigir_config_invalida(_problema);
                break;
                
            case "MEMORIA_ALTA":
                _corrigido = scr_corrigir_memoria_alta(_problema);
                break;
                
            case "FPS_BAIXO":
                _corrigido = scr_corrigir_fps_baixo(_problema);
                break;
        }
        
        if (_corrigido) {
            _correcoes_aplicadas++;
            array_push(global.correcoes_aplicadas, {
                problema: _problema,
                timestamp: current_time,
                sucesso: true
            });
        }
    }
    
    global.validacao_stats.correcoes_aplicadas += _correcoes_aplicadas;
    
    scr_debug_log("VALIDACAO", "Auto-correção concluída. Correções aplicadas: " + string(_correcoes_aplicadas), DEBUG_LEVEL.BASIC);
}

function scr_corrigir_recurso_negativo(problema) {
    if (global.recursos != undefined && global.recursos[$ problema.recurso] < 0) {
        global.recursos[$ problema.recurso] = 0;
        scr_debug_log("VALIDACAO", "Recurso " + problema.recurso + " corrigido para 0", DEBUG_LEVEL.BASIC);
        return true;
    }
    return false;
}

function scr_corrigir_ds_orfao(problema) {
    // Remover referência órfã da lista de tracking
    switch(problema.tipo) {
        case "DS_LIST_ORFAO":
            scr_remover_ds_da_lista(global.data_structures.lists, problema.ds_id);
            break;
        case "DS_QUEUE_ORFAO":
            scr_remover_ds_da_lista(global.data_structures.queues, problema.ds_id);
            break;
    }
    
    scr_debug_log("VALIDACAO", "Referência órfã removida: " + string(problema.ds_id), DEBUG_LEVEL.BASIC);
    return true;
}

function scr_corrigir_config_invalida(problema) {
    if (problema.config == "debug_level") {
        global.config.debug_level = clamp(global.config.debug_level, 0, 3);
        scr_debug_log("VALIDACAO", "debug_level corrigido para: " + string(global.config.debug_level), DEBUG_LEVEL.BASIC);
        return true;
    }
    return false;
}

function scr_corrigir_memoria_alta(problema) {
    scr_limpeza_automatica_memoria();
    scr_debug_log("VALIDACAO", "Limpeza de memória executada", DEBUG_LEVEL.BASIC);
    return true;
}

function scr_corrigir_fps_baixo(problema) {
    // Reduzir qualidade gráfica temporariamente
    if (global.config.performance_mode == false) {
        global.config.performance_mode = true;
        scr_debug_log("VALIDACAO", "Modo de performance ativado para melhorar FPS", DEBUG_LEVEL.BASIC);
        return true;
    }
    return false;
}

function scr_calcular_objetos_esperados() {
    // Cálculo aproximado de objetos esperados
    var _base = 10; // Objetos base do sistema
    var _por_jogador = 20; // Objetos por jogador
    var _jogadores = 2; // Assumindo 2 jogadores
    
    return _base + (_por_jogador * _jogadores);
}

function scr_relatorio_validacao() {
    scr_debug_log("VALIDACAO", "=== RELATÓRIO DE VALIDAÇÃO ===", DEBUG_LEVEL.BASIC, true);
    
    scr_debug_log("VALIDACAO", "Total de validações: " + string(global.validacao_stats.total_validacoes), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("VALIDACAO", "Problemas encontrados: " + string(global.validacao_stats.problemas_encontrados), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("VALIDACAO", "Correções aplicadas: " + string(global.validacao_stats.correcoes_aplicadas), DEBUG_LEVEL.BASIC, true);
    
    if (array_length(global.problemas_detectados) > 0) {
        scr_debug_log("VALIDACAO", "Problemas atuais:", DEBUG_LEVEL.BASIC, true);
        for (var i = 0; i < array_length(global.problemas_detectados); i++) {
            var _problema = global.problemas_detectados[i];
            scr_debug_log("VALIDACAO", "  - " + _problema.tipo + ": " + _problema.descricao, DEBUG_LEVEL.BASIC, true);
        }
    }
    
    scr_debug_log("VALIDACAO", "=== FIM DO RELATÓRIO ===", DEBUG_LEVEL.BASIC, true);
}

function scr_validacao_periodica() {
    if (!global.config.auto_validation) return;
    
    global.timer_validacao--;
    
    if (global.timer_validacao <= 0) {
        global.timer_validacao = global.config.validation_interval;
        scr_validar_sistema_completo();
    }
}
