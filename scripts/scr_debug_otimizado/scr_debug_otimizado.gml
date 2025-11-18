/// @description Sistema de debug otimizado para produção
/// @author Hegemonia Global
/// @version 2.0

// ============================================
// SISTEMA DE DEBUG OTIMIZADO
// Reduz impacto de performance em produção
// ============================================

// Inicializar sistema de debug
function scr_init_debug_otimizado() {
    // Verificar se já foi inicializado
    if (variable_global_exists("debug_otimizado_init")) {
        return;
    }
    
    // Configurações padrão
    global.debug_enabled = false; // Desabilitado por padrão em produção
    global.debug_level = 0; // 0 = OFF, 1 = BASIC, 2 = DETAILED, 3 = VERBOSE
    global.debug_max_per_frame = 5; // Máximo de mensagens por frame
    global.debug_max_per_second = 20; // Máximo de mensagens por segundo
    global.debug_frame_count = 0;
    global.debug_message_count = 0;
    global.debug_last_second = current_time;
    global.debug_otimizado_init = true;
    
    // Cache de verificações (evita verificar a cada chamada)
    global.debug_cache_enabled = false;
    global.debug_cache_level = 0;
    global.debug_cache_frame = -1;
}

// Função principal de debug otimizada
// ✅ OTIMIZAÇÃO: Verifica apenas uma vez por frame se debug está habilitado
function scr_debug_log(_message, _level = 1) {
    // ✅ OTIMIZAÇÃO CRÍTICA: Early return se debug desabilitado
    // Cache da verificação para evitar múltiplas verificações no mesmo frame
    var _current_frame = current_frame;
    if (global.debug_cache_frame != _current_frame) {
        // Atualizar cache apenas uma vez por frame
        global.debug_cache_enabled = (variable_global_exists("debug_enabled") && global.debug_enabled);
        global.debug_cache_level = (variable_global_exists("debug_level")) ? global.debug_level : 0;
        global.debug_cache_frame = _current_frame;
    }
    
    // Early return se debug desabilitado (mais rápido que verificar a cada vez)
    if (!global.debug_cache_enabled || global.debug_cache_level < _level) {
        return;
    }
    
    // Limitar mensagens por frame
    if (global.debug_message_count >= global.debug_max_per_frame) {
        return;
    }
    
    // Limitar mensagens por segundo
    var _current_time = current_time;
    if (_current_time - global.debug_last_second >= 1000) {
        // Resetar contador a cada segundo
        global.debug_message_count = 0;
        global.debug_last_second = _current_time;
    }
    
    // Mostrar mensagem
    show_debug_message(_message);
    global.debug_message_count++;
}

// Função de debug condicional (apenas a cada N frames)
// ✅ OTIMIZAÇÃO: Evita spam de mensagens
function scr_debug_log_periodic(_message, _level = 1, _interval = 60) {
    // Verificar se deve logar (early return)
    if (!global.debug_cache_enabled || global.debug_cache_level < _level) {
        return;
    }
    
    // Logar apenas a cada N frames
    if (current_frame mod _interval == 0) {
        scr_debug_log(_message, _level);
    }
}

// Função de debug apenas quando condição é verdadeira
// ✅ OTIMIZAÇÃO: Evita construir strings quando não necessário
function scr_debug_log_if(_condition, _message, _level = 1) {
    if (!_condition) return;
    scr_debug_log(_message, _level);
}

// Função de debug com formatação lazy (só formata se necessário)
// ✅ OTIMIZAÇÃO: Evita construir strings quando debug está desabilitado
function scr_debug_log_lazy(_message_func, _level = 1) {
    // Verificar se deve logar antes de chamar função
    if (!global.debug_cache_enabled || global.debug_cache_level < _level) {
        return;
    }
    
    // Só chamar função de formatação se debug estiver habilitado
    var _message = _message_func();
    scr_debug_log(_message, _level);
}

// Resetar contadores (chamar no início de cada frame)
function scr_debug_reset_frame() {
    global.debug_frame_count++;
    
    // Resetar contador de mensagens a cada segundo
    var _current_time = current_time;
    if (_current_time - global.debug_last_second >= 1000) {
        global.debug_message_count = 0;
        global.debug_last_second = _current_time;
    }
    
    // Invalidar cache a cada frame
    global.debug_cache_frame = -1;
}

// Habilitar/desabilitar debug em runtime
function scr_debug_set_enabled(_enabled) {
    global.debug_enabled = _enabled;
    global.debug_cache_enabled = _enabled;
    global.debug_cache_frame = -1; // Invalidar cache
}

// Definir nível de debug
function scr_debug_set_level(_level) {
    global.debug_level = _level;
    global.debug_cache_level = _level;
    global.debug_cache_frame = -1; // Invalidar cache
}

