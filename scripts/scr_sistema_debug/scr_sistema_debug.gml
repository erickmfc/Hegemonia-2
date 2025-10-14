// Sistema de Debug Inteligente - Hegemonia Global
// Sistema otimizado de debug com controle de performance

// Enums para níveis de debug
enum DEBUG_LEVEL {
    OFF = 0,
    BASIC = 1,
    DETAILED = 2,
    FULL = 3
}

enum DEBUG_CATEGORY {
    COMBATE,
    MOVIMENTO,
    RECURSOS,
    PERFORMANCE,
    VALIDACAO,
    MEMORIA,
    COMANDOS,
    SISTEMA,
    UNIDADES,
    NAVAL
}

// Variáveis globais para controle de debug
global.debug_timers = {};
global.debug_counters = {};
global.debug_last_frame = 0;

function scr_debug_log(categoria, mensagem, nivel = DEBUG_LEVEL.BASIC, forcar = false) {
    // Verificar se debug está ativo para esta categoria
    if (!forcar && !scr_debug_ativo(categoria)) return;
    
    // Verificar nível de debug
    if (!forcar && global.config.debug_level < nivel) return;
    
    // Controle de frequência para evitar spam
    var _key = categoria + "_" + string(nivel);
    if (!scr_debug_deve_logar(_key)) return;
    
    // Formatar mensagem
    var _timestamp = "[" + string(current_time) + "]";
    var _category_tag = "[" + categoria + "]";
    var _level_tag = scr_debug_obter_tag_nivel(nivel);
    
    var _mensagem_final = _timestamp + _category_tag + _level_tag + " " + mensagem;
    
    // Log no console
    show_debug_message(_mensagem_final);
    
    // Log em arquivo se configurado
    if (global.config.debug_log_file) {
        scr_debug_log_arquivo(_mensagem_final);
    }
}

function scr_debug_deve_logar(key) {
    // Sistema de throttling para evitar spam
    if (!variable_global_exists("debug_timers")) {
        global.debug_timers = {};
    }
    
    var _last_time = global.debug_timers[$ key];
    var _current_time = current_time;
    
    // Permitir log se passou mais de 100ms desde o último
    if (_last_time == undefined || (_current_time - _last_time) > 100) {
        global.debug_timers[$ key] = _current_time;
        return true;
    }
    
    return false;
}

function scr_debug_obter_tag_nivel(nivel) {
    switch(nivel) {
        case DEBUG_LEVEL.BASIC: return " ℹ️";
        case DEBUG_LEVEL.DETAILED: return " 🔍";
        case DEBUG_LEVEL.FULL: return " 🔬";
        default: return "";
    }
}

function scr_debug_log_arquivo(mensagem) {
    // Implementar log em arquivo se necessário
    // Por enquanto apenas debug no console
}

function scr_debug_performance_inicio(tag) {
    if (!scr_debug_ativo("PERFORMANCE")) return;
    
    global.debug_timers[$ tag + "_start"] = current_time;
}

function scr_debug_performance_fim(tag, limite_ms = 16) {
    if (!scr_debug_ativo("PERFORMANCE")) return;
    
    var _start_time = global.debug_timers[$ tag + "_start"];
    if (_start_time == undefined) return;
    
    var _tempo_decorrido = current_time - _start_time;
    
    if (_tempo_decorrido > limite_ms) {
        scr_debug_log("PERFORMANCE", tag + " demorou " + string(_tempo_decorrido) + "ms (limite: " + string(limite_ms) + "ms)", DEBUG_LEVEL.BASIC);
    }
    
    // Limpar timer
    global.debug_timers[$ tag + "_start"] = undefined;
}

function scr_debug_contador_incrementar(categoria, chave) {
    if (!scr_debug_ativo(categoria)) return;
    
    if (!variable_global_exists("debug_counters")) {
        global.debug_counters = {};
    }
    
    var _key = categoria + "_" + chave;
    if (global.debug_counters[$ _key] == undefined) {
        global.debug_counters[$ _key] = 0;
    }
    
    global.debug_counters[$ _key]++;
}

function scr_debug_contador_mostrar(categoria, chave) {
    if (!scr_debug_ativo(categoria)) return;
    
    var _key = categoria + "_" + chave;
    var _valor = global.debug_counters[$ _key];
    
    if (_valor != undefined) {
        scr_debug_log(categoria, chave + ": " + string(_valor), DEBUG_LEVEL.BASIC);
    }
}

function scr_debug_contador_resetar(categoria = "") {
    if (categoria == "") {
        global.debug_counters = {};
        scr_debug_log("SISTEMA", "Todos os contadores resetados", DEBUG_LEVEL.BASIC);
    } else {
        var _keys = variable_global_get_names(global.debug_counters);
        for (var i = 0; i < array_length(_keys); i++) {
            if (string_pos(categoria, _keys[i]) == 1) {
                global.debug_counters[$ _keys[i]] = undefined;
            }
        }
        scr_debug_log("SISTEMA", "Contadores de " + categoria + " resetados", DEBUG_LEVEL.BASIC);
    }
}

function scr_debug_frame_limite() {
    // Debug apenas a cada X frames para evitar spam
    global.debug_last_frame++;
    
    if (global.debug_last_frame % 60 == 0) { // A cada segundo
        scr_debug_log("PERFORMANCE", "FPS atual: " + string(fps), DEBUG_LEVEL.BASIC);
        scr_debug_log("PERFORMANCE", "Objetos ativos: " + string(instance_number(all)), DEBUG_LEVEL.BASIC);
    }
}

function scr_debug_memoria_status() {
    if (!scr_debug_ativo("MEMORIA")) return;
    
    var _memoria_usada = scr_calcular_uso_memoria();
    var _threshold = global.config.memory_threshold;
    
    if (_memoria_usada > _threshold) {
        scr_debug_log("MEMORIA", "Uso de memória alto: " + string(_memoria_usada) + "% (limite: " + string(_threshold) + "%)", DEBUG_LEVEL.BASIC);
    }
}

function scr_debug_limpar_timers() {
    // Limpar timers antigos para evitar vazamento de memória
    var _current_time = current_time;
    var _keys = variable_global_get_names(global.debug_timers);
    
    for (var i = 0; i < array_length(_keys); i++) {
        var _key = _keys[i];
        var _time = global.debug_timers[$ _key];
        
        // Remover timers mais antigos que 10 segundos
        if (_time != undefined && (_current_time - _time) > 10000) {
            global.debug_timers[$ _key] = undefined;
        }
    }
}

function scr_debug_relatorio_completo() {
    scr_debug_log("SISTEMA", "=== RELATÓRIO DE DEBUG COMPLETO ===", DEBUG_LEVEL.BASIC, true);
    
    // Performance
    scr_debug_log("PERFORMANCE", "FPS: " + string(fps), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("PERFORMANCE", "Objetos ativos: " + string(instance_number(all)), DEBUG_LEVEL.BASIC, true);
    
    // Memória
    var _memoria = scr_calcular_uso_memoria();
    scr_debug_log("MEMORIA", "Uso de memória: " + string(_memoria) + "%", DEBUG_LEVEL.BASIC, true);
    
    // Contadores
    var _keys = variable_global_get_names(global.debug_counters);
    for (var i = 0; i < array_length(_keys); i++) {
        var _valor = global.debug_counters[$ _keys[i]];
        if (_valor != undefined && _valor > 0) {
            scr_debug_log("SISTEMA", _keys[i] + ": " + string(_valor), DEBUG_LEVEL.BASIC, true);
        }
    }
    
    scr_debug_log("SISTEMA", "=== FIM DO RELATÓRIO ===", DEBUG_LEVEL.BASIC, true);
}
