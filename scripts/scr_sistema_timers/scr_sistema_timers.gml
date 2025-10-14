// Sistema de Timers e Otimização de Verificações - Hegemonia Global
// Evita verificações custosas a cada frame

// Sistema global de timers
global.sistema_timers = {
    timers: {},
    verificacoes_periodicas: {},
    performance_counters: {}
};

// Tipos de verificações
enum TIPO_VERIFICACAO {
    ALVOS_INIMIGOS,
    RECURSOS_SISTEMA,
    OBJETOS_ORFAOS,
    PERFORMANCE_FPS,
    MEMORIA_USAGE,
    VALIDACAO_INTEGRIDADE,
    LIMPEZA_DADOS,
    ESTATISTICAS_COMBATE
}

function scr_inicializar_sistema_timers() {
    scr_log_sistema("TIMERS", "Sistema de timers inicializado");
    
    global.sistema_timers.timers = {};
    global.sistema_timers.verificacoes_periodicas = {};
    global.sistema_timers.performance_counters = {};
    
    // Configurar verificações periódicas padrão
    scr_configurar_verificacao_periodica(TIPO_VERIFICACAO.ALVOS_INIMIGOS, 30); // A cada 30 frames
    scr_configurar_verificacao_periodica(TIPO_VERIFICACAO.RECURSOS_SISTEMA, 60); // A cada 60 frames
    scr_configurar_verificacao_periodica(TIPO_VERIFICACAO.OBJETOS_ORFAOS, 300); // A cada 5 segundos
    scr_configurar_verificacao_periodica(TIPO_VERIFICACAO.PERFORMANCE_FPS, 60); // A cada segundo
    scr_configurar_verificacao_periodica(TIPO_VERIFICACAO.MEMORIA_USAGE, 180); // A cada 3 segundos
    scr_configurar_verificacao_periodica(TIPO_VERIFICACAO.VALIDACAO_INTEGRIDADE, 300); // A cada 5 segundos
    scr_configurar_verificacao_periodica(TIPO_VERIFICACAO.LIMPEZA_DADOS, 1800); // A cada 30 segundos
    scr_configurar_verificacao_periodica(TIPO_VERIFICACAO.ESTATISTICAS_COMBATE, 120); // A cada 2 segundos
}

function scr_configurar_verificacao_periodica(tipo, intervalo_frames) {
    global.sistema_timers.verificacoes_periodicas[$ tipo] = {
        intervalo: intervalo_frames,
        ultima_execucao: 0,
        ativo: true,
        contador_execucoes: 0
    };
    
    scr_debug_log("TIMERS", "Verificação configurada: " + string(tipo) + " a cada " + string(intervalo_frames) + " frames", DEBUG_LEVEL.DETAILED);
}

function scr_atualizar_sistema_timers() {
    // Atualizar todas as verificações periódicas
    var _tipos = variable_global_get_names(global.sistema_timers.verificacoes_periodicas);
    
    for (var i = 0; i < array_length(_tipos); i++) {
        var _tipo = _tipos[i];
        var _verificacao = global.sistema_timers.verificacoes_periodicas[$ _tipo];
        
        if (_verificacao.ativo) {
            scr_verificar_timer(_tipo, _verificacao);
        }
    }
    
    // Atualizar timers específicos
    scr_atualizar_timers_especificos();
}

function scr_verificar_timer(tipo, verificacao) {
    var _frames_decorridos = global.debug_last_frame - verificacao.ultima_execucao;
    
    if (_frames_decorridos >= verificacao.intervalo) {
        verificacao.ultima_execucao = global.debug_last_frame;
        verificacao.contador_execucoes++;
        
        scr_executar_verificacao(tipo);
    }
}

function scr_executar_verificacao(tipo) {
    scr_debug_log("TIMERS", "Executando verificação: " + string(tipo), DEBUG_LEVEL.DETAILED);
    
    switch(tipo) {
        case TIPO_VERIFICACAO.ALVOS_INIMIGOS:
            scr_verificar_alvos_inimigos();
            break;
            
        case TIPO_VERIFICACAO.RECURSOS_SISTEMA:
            scr_verificar_recursos_sistema();
            break;
            
        case TIPO_VERIFICACAO.OBJETOS_ORFAOS:
            scr_verificar_objetos_orfaos();
            break;
            
        case TIPO_VERIFICACAO.PERFORMANCE_FPS:
            scr_verificar_performance_fps();
            break;
            
        case TIPO_VERIFICACAO.MEMORIA_USAGE:
            scr_verificar_memoria_usage();
            break;
            
        case TIPO_VERIFICACAO.VALIDACAO_INTEGRIDADE:
            scr_verificar_validacao_integridade();
            break;
            
        case TIPO_VERIFICACAO.LIMPEZA_DADOS:
            scr_verificar_limpeza_dados();
            break;
            
        case TIPO_VERIFICACAO.ESTATISTICAS_COMBATE:
            scr_verificar_estatisticas_combate();
            break;
    }
}

function scr_verificar_alvos_inimigos() {
    // Verificação otimizada de alvos inimigos
    var _unidades_em_combate = global.sistema_combate.unidades_em_combate;
    
    for (var i = 0; i < array_length(_unidades_em_combate); i++) {
        var _unidade = _unidades_em_combate[i];
        
        if (instance_exists(_unidade)) {
            // Verificar se alvo ainda é válido
            if (_unidade.alvo_atual != noone && !instance_exists(_unidade.alvo_atual)) {
                _unidade.alvo_atual = noone;
                scr_definir_estado_combate(_unidade, ESTADO_COMBATE.PROCURANDO_ALVO);
            }
        }
    }
    
    scr_debug_log("TIMERS", "Verificação de alvos inimigos concluída", DEBUG_LEVEL.DETAILED);
}

function scr_verificar_recursos_sistema() {
    // Verificação otimizada de recursos
    if (global.recursos != undefined) {
        var _recursos = ["madeira", "pedra", "comida", "ouro"];
        
        for (var i = 0; i < array_length(_recursos); i++) {
            var _recurso = _recursos[i];
            var _valor = global.recursos[$ _recurso];
            
            if (_valor < 0) {
                scr_debug_log("TIMERS", "Recurso negativo detectado: " + _recurso + " = " + string(_valor), DEBUG_LEVEL.BASIC);
                
                // Auto-correção
                if (global.config.auto_correction) {
                    global.recursos[$ _recurso] = 0;
                    scr_debug_log("TIMERS", "Recurso corrigido automaticamente: " + _recurso, DEBUG_LEVEL.BASIC);
                }
            }
        }
    }
    
    scr_debug_log("TIMERS", "Verificação de recursos concluída", DEBUG_LEVEL.DETAILED);
}

function scr_verificar_objetos_orfaos() {
    // Verificação otimizada de objetos órfãos
    var _objetos_orfaos = 0;
    
    // Verificar data structures órfãos
    var _lists_orfaos = 0;
    for (var i = 0; i < array_length(global.data_structures.lists); i++) {
        var _list = global.data_structures.lists[i];
        if (!ds_exists(_list, ds_type_list)) {
            _lists_orfaos++;
        }
    }
    
    if (_lists_orfaos > 0) {
        scr_debug_log("TIMERS", "DS_Lists órfãos encontrados: " + string(_lists_orfaos), DEBUG_LEVEL.BASIC);
        
        // Limpeza automática
        if (global.config.auto_cleanup) {
            scr_limpar_ds_orfaos();
        }
    }
    
    scr_debug_log("TIMERS", "Verificação de objetos órfãos concluída", DEBUG_LEVEL.DETAILED);
}

function scr_verificar_performance_fps() {
    var _fps_atual = fps;
    var _fps_minimo = 30;
    
    if (_fps_atual < _fps_minimo) {
        scr_debug_log("TIMERS", "FPS baixo detectado: " + string(_fps_atual) + " (mínimo: " + string(_fps_minimo) + ")", DEBUG_LEVEL.BASIC);
        
        // Ativar modo de performance se necessário
        if (!global.config.performance_mode) {
            global.config.performance_mode = true;
            scr_debug_log("TIMERS", "Modo de performance ativado automaticamente", DEBUG_LEVEL.BASIC);
        }
    }
    
    scr_debug_log("TIMERS", "FPS atual: " + string(_fps_atual), DEBUG_LEVEL.DETAILED);
}

function scr_verificar_memoria_usage() {
    var _uso_memoria = scr_calcular_uso_memoria();
    var _limite_memoria = global.config.memory_threshold;
    
    if (_uso_memoria > _limite_memoria) {
        scr_debug_log("TIMERS", "Uso de memória alto: " + string(_uso_memoria) + "% (limite: " + string(_limite_memoria) + "%)", DEBUG_LEVEL.BASIC);
        
        // Limpeza automática
        if (global.config.auto_cleanup) {
            scr_limpeza_automatica_memoria();
        }
    }
    
    scr_debug_log("TIMERS", "Uso de memória: " + string(_uso_memoria) + "%", DEBUG_LEVEL.DETAILED);
}

function scr_verificar_validacao_integridade() {
    // Executar validação completa do sistema
    var _problemas = scr_validar_sistema_completo();
    
    if (array_length(_problemas) > 0) {
        scr_debug_log("TIMERS", "Problemas de integridade detectados: " + string(array_length(_problemas)), DEBUG_LEVEL.BASIC);
    }
}

function scr_verificar_limpeza_dados() {
    // Limpeza periódica de dados
    scr_debug_log("TIMERS", "Executando limpeza periódica de dados", DEBUG_LEVEL.BASIC);
    
    // Limpar timers antigos
    scr_debug_limpar_timers();
    
    // Limpar contadores antigos
    scr_limpar_contadores_antigos();
    
    // Limpeza de memória se necessário
    scr_limpeza_automatica_memoria();
}

function scr_verificar_estatisticas_combate() {
    // Atualizar estatísticas de combate
    var _unidades_combate = array_length(global.sistema_combate.unidades_em_combate);
    
    if (_unidades_combate > 0) {
        scr_debug_log("TIMERS", "Unidades em combate: " + string(_unidades_combate), DEBUG_LEVEL.DETAILED);
    }
}

function scr_criar_timer(nome, duracao_frames, callback = "") {
    global.sistema_timers.timers[$ nome] = {
        duracao: duracao_frames,
        tempo_restante: duracao_frames,
        ativo: true,
        callback: callback,
        criado_em: global.debug_last_frame
    };
    
    scr_debug_log("TIMERS", "Timer criado: " + nome + " (" + string(duracao_frames) + " frames)", DEBUG_LEVEL.DETAILED);
}

function scr_atualizar_timer(nome) {
    if (!variable_global_exists("sistema_timers") || global.sistema_timers.timers[$ nome] == undefined) {
        return false;
    }
    
    var _timer = global.sistema_timers.timers[$ nome];
    
    if (_timer.ativo) {
        _timer.tempo_restante--;
        
        if (_timer.tempo_restante <= 0) {
            _timer.ativo = false;
            
            scr_debug_log("TIMERS", "Timer expirado: " + nome, DEBUG_LEVEL.DETAILED);
            
            // Executar callback se definido
            if (_timer.callback != "" && function_exists(_timer.callback)) {
                execute_string(_timer.callback + "()");
            }
            
            return true; // Timer expirado
        }
    }
    
    return false; // Timer ainda ativo
}

function scr_atualizar_timers_especificos() {
    var _timers = variable_global_get_names(global.sistema_timers.timers);
    
    for (var i = 0; i < array_length(_timers); i++) {
        var _nome = _timers[i];
        scr_atualizar_timer(_nome);
    }
}

function scr_timer_ativo(nome) {
    if (global.sistema_timers.timers[$ nome] == undefined) {
        return false;
    }
    
    return global.sistema_timers.timers[$ nome].ativo;
}

function scr_timer_tempo_restante(nome) {
    if (global.sistema_timers.timers[$ nome] == undefined) {
        return 0;
    }
    
    return global.sistema_timers.timers[$ nome].tempo_restante;
}

function scr_pausar_timer(nome) {
    if (global.sistema_timers.timers[$ nome] != undefined) {
        global.sistema_timers.timers[$ nome].ativo = false;
        scr_debug_log("TIMERS", "Timer pausado: " + nome, DEBUG_LEVEL.DETAILED);
    }
}

function scr_retomar_timer(nome) {
    if (global.sistema_timers.timers[$ nome] != undefined) {
        global.sistema_timers.timers[$ nome].ativo = true;
        scr_debug_log("TIMERS", "Timer retomado: " + nome, DEBUG_LEVEL.DETAILED);
    }
}

function scr_destruir_timer(nome) {
    if (global.sistema_timers.timers[$ nome] != undefined) {
        global.sistema_timers.timers[$ nome] = undefined;
        scr_debug_log("TIMERS", "Timer destruído: " + nome, DEBUG_LEVEL.DETAILED);
    }
}

function scr_limpar_ds_orfaos() {
    // Limpar referências órfãs de data structures
    scr_debug_log("TIMERS", "Limpando data structures órfãos", DEBUG_LEVEL.BASIC);
    
    // Limpar lists órfãos
    for (var i = array_length(global.data_structures.lists) - 1; i >= 0; i--) {
        var _list = global.data_structures.lists[i];
        if (!ds_exists(_list, ds_type_list)) {
            array_delete(global.data_structures.lists, i, 1);
        }
    }
    
    // Limpar queues órfãos
    for (var i = array_length(global.data_structures.queues) - 1; i >= 0; i--) {
        var _queue = global.data_structures.queues[i];
        if (!ds_exists(_queue, ds_type_queue)) {
            array_delete(global.data_structures.queues, i, 1);
        }
    }
}

function scr_limpar_contadores_antigos() {
    // Limpar contadores de debug antigos
    var _current_time = current_time;
    var _keys = variable_global_get_names(global.debug_counters);
    
    for (var i = 0; i < array_length(_keys); i++) {
        var _key = _keys[i];
        var _valor = global.debug_counters[$ _key];
        
        // Resetar contadores muito antigos
        if (_valor != undefined && _valor > 10000) {
            global.debug_counters[$ _key] = 0;
        }
    }
}

function scr_relatorio_timers() {
    scr_debug_log("TIMERS", "=== RELATÓRIO DE TIMERS ===", DEBUG_LEVEL.BASIC, true);
    
    // Timers ativos
    var _timers_ativos = 0;
    var _timers = variable_global_get_names(global.sistema_timers.timers);
    
    for (var i = 0; i < array_length(_timers); i++) {
        var _timer = global.sistema_timers.timers[$ _timers[i]];
        if (_timer.ativo) {
            _timers_ativos++;
        }
    }
    
    scr_debug_log("TIMERS", "Timers ativos: " + string(_timers_ativos), DEBUG_LEVEL.BASIC, true);
    
    // Verificações periódicas
    var _verificacoes = variable_global_get_names(global.sistema_timers.verificacoes_periodicas);
    scr_debug_log("TIMERS", "Verificações periódicas: " + string(array_length(_verificacoes)), DEBUG_LEVEL.BASIC, true);
    
    for (var i = 0; i < array_length(_verificacoes); i++) {
        var _verificacao = global.sistema_timers.verificacoes_periodicas[$ _verificacoes[i]];
        scr_debug_log("TIMERS", "  - " + _verificacoes[i] + ": " + string(_verificacao.contador_execucoes) + " execuções", DEBUG_LEVEL.BASIC, true);
    }
    
    scr_debug_log("TIMERS", "=== FIM DO RELATÓRIO ===", DEBUG_LEVEL.BASIC, true);
}
