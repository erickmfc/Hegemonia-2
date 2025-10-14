// Sistema de Configuração Centralizada - Hegemonia Global
// Gerencia todas as configurações do jogo de forma unificada

function scr_inicializar_configuracoes() {
    // Configurações globais do sistema
    global.config = {
        // Sistema de Debug
        debug_level: 1,              // 0=off, 1=basic, 2=detailed, 3=full
        debug_console: true,         // Mostrar console de debug
        debug_performance: false,     // Debug de performance
        
        // Performance
        performance_mode: true,       // Modo de alta performance
        max_fps: 60,                 // FPS máximo
        frame_skip: false,           // Pular frames se necessário
        
        // Sistema de Validação
        auto_validation: true,       // Validação automática
        validation_interval: 300,    // Intervalo em frames (5 segundos a 60fps)
        auto_correction: true,       // Auto-correção de problemas
        
        // Limpeza de Memória
        auto_cleanup: true,          // Limpeza automática
        cleanup_interval: 1800,      // Intervalo em frames (30 segundos)
        memory_threshold: 80,        // Threshold de memória (%)
        
        // Sistema de Combate
        combat_mode: "unified",      // "unified", "automatic", "manual"
        combat_debug: false,         // Debug específico de combate
        
        // Sistema de Unidades
        max_units_per_player: 50,    // Máximo de unidades por jogador
        unit_pool_size: 100,        // Tamanho do pool de unidades
        
        // Sistema de Recursos
        resource_debug: false,       // Debug de recursos
        resource_validation: true,   // Validação de recursos
    };
    
    // Configurações de Debug por Categoria
    global.debug_categories = {
        COMBATE: 1,          // Debug de combate
        MOVIMENTO: 1,        // Debug de movimento
        RECURSOS: 0,         // Debug de recursos
        PERFORMANCE: 0,      // Debug de performance
        VALIDACAO: 2,        // Debug de validação
        MEMORIA: 0,          // Debug de memória
        COMANDOS: 1,         // Debug de comandos
        SISTEMA: 2,          // Debug do sistema
    };
    
    // Configurações de Performance
    global.performance = {
        frame_count: 0,
        last_fps_check: 0,
        current_fps: 60,
        performance_warnings: 0,
        memory_usage: 0,
    };
    
    scr_log_sistema("CONFIGURAÇÕES", "Sistema de configuração inicializado");
}

function scr_obter_config(categoria, chave = "") {
    if (chave == "") {
        return global.config[$ categoria];
    }
    return global.config[$ categoria][$ chave];
}

function scr_definir_config(categoria, chave, valor) {
    if (is_struct(global.config[$ categoria])) {
        global.config[$ categoria][$ chave] = valor;
    } else {
        global.config[$ categoria] = valor;
    }
    scr_log_sistema("CONFIGURAÇÕES", "Configuração alterada: " + categoria + "." + chave + " = " + string(valor));
}

function scr_debug_ativo(categoria = "") {
    if (categoria == "") {
        return global.config.debug_level > 0;
    }
    
    var _debug_level = global.config.debug_level;
    var _category_level = global.debug_categories[$ categoria];
    
    return _debug_level >= _category_level;
}

function scr_log_debug(categoria, mensagem, nivel = 1) {
    if (!scr_debug_ativo(categoria)) return;
    
    var _timestamp = "[" + string(current_time) + "]";
    var _prefix = "[" + categoria + "]";
    
    switch(nivel) {
        case 1: show_debug_message(_timestamp + _prefix + " " + mensagem); break;
        case 2: show_debug_message(_timestamp + _prefix + " ⚠️ " + mensagem); break;
        case 3: show_debug_message(_timestamp + _prefix + " ❌ " + mensagem); break;
        case 4: show_debug_message(_timestamp + _prefix + " ✅ " + mensagem); break;
    }
}

function scr_log_sistema(categoria, mensagem) {
    scr_log_debug("SISTEMA", categoria + ": " + mensagem, 4);
}

function scr_configurar_debug_nivel(nivel) {
    global.config.debug_level = clamp(nivel, 0, 3);
    scr_log_sistema("CONFIGURAÇÕES", "Nível de debug alterado para: " + string(nivel));
}

function scr_configurar_performance_modo(ativo) {
    global.config.performance_mode = ativo;
    if (ativo) {
        global.config.debug_level = 0; // Desativa debug em modo performance
        scr_log_sistema("CONFIGURAÇÕES", "Modo de alta performance ativado");
    } else {
        scr_log_sistema("CONFIGURAÇÕES", "Modo de alta performance desativado");
    }
}
