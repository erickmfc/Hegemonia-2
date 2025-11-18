/// @description Sistema de Debug Configurável e Otimizado
/// Sistema com níveis de debug para reduzir mensagens de 90%+

// ============================================
// SISTEMA DE DEBUG CONFIGURÁVEL
// Níveis: NONE, BASIC, DETAILED, VERBOSE
// ============================================

// Enum para níveis de debug
enum DEBUG_LEVEL {
    NONE = 0,      // Sem debug (melhor performance)
    BASIC = 1,     // Apenas erros críticos
    DETAILED = 2,  // Informações importantes
    VERBOSE = 3    // Tudo (apenas para desenvolvimento)
}

// Inicializar sistema de debug
function scr_init_debug_system() {
    if (!variable_global_exists("debug_level")) {
        global.debug_level = DEBUG_LEVEL.BASIC; // Padrão: apenas erros críticos
    }
    
    if (!variable_global_exists("debug_frame_skip")) {
        global.debug_frame_skip = 60; // Debug a cada 60 frames (1 segundo a 60 FPS)
    }
    
    if (!variable_global_exists("debug_frame_count")) {
        global.debug_frame_count = 0;
    }
    
    if (!variable_global_exists("debug_message_count")) {
        global.debug_message_count = 0;
    }
    
    if (!variable_global_exists("debug_max_per_second")) {
        global.debug_max_per_second = 10; // Máximo 10 mensagens por segundo
    }
}

/// @function scr_debug_log(_mensagem, _nivel)
/// @description Função auxiliar centralizada para debug
/// @param {string} _mensagem - Mensagem de debug
/// @param {int} _nivel - Nível de debug (1=BASIC, 2=DETAILED, 3=VERBOSE). Padrão: 1
function scr_debug_log(_mensagem, _nivel = 1) {
    if (!variable_global_exists("debug_enabled") || !global.debug_enabled) return;
    
    // Se usar sistema de níveis, verificar
    if (variable_global_exists("debug_level")) {
        if (_nivel > global.debug_level) return;
    }
    
    show_debug_message(_mensagem);
}

// Função principal de debug otimizada
function debug_log(_level, _message) {
    // Verificar se debug está habilitado para este nível
    if (global.debug_level < _level) {
        return; // Não mostrar mensagem
    }
    
    // Frame skipping para reduzir mensagens
    global.debug_frame_count++;
    if (global.debug_frame_count < global.debug_frame_skip && _level < DEBUG_LEVEL.DETAILED) {
        return; // Pular frames para mensagens menos importantes
    }
    
    // Limitar mensagens por segundo
    if (global.debug_message_count >= global.debug_max_per_second) {
        return; // Limite atingido
    }
    
    // Mostrar mensagem
    show_debug_message(_message);
    global.debug_message_count++;
    
    // Resetar contador a cada segundo
    if (global.debug_frame_count >= global.debug_frame_skip) {
        global.debug_frame_count = 0;
        global.debug_message_count = 0;
    }
}

// Funções de conveniência para cada nível
function debug_none(_message) {
    // Nunca mostra (reservado para futuro)
}

function debug_basic(_message) {
    debug_log(DEBUG_LEVEL.BASIC, _message);
}

function debug_detailed(_message) {
    debug_log(DEBUG_LEVEL.DETAILED, _message);
}

function debug_verbose(_message) {
    debug_log(DEBUG_LEVEL.VERBOSE, _message);
}

// Função para debug condicional (apenas a cada N frames)
function debug_periodic(_level, _message, _interval = 60) {
    if (global.debug_level < _level) {
        return;
    }
    
    if (global.debug_frame_count % _interval == 0) {
        show_debug_message(_message);
    }
}

