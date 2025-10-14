// Sistema Principal de Inicialização - Hegemonia Global
// Integra todos os sistemas de melhoria implementados

function scr_inicializar_sistemas_melhorados() {
    scr_log_sistema("INICIALIZACAO", "Iniciando sistemas melhorados do Hegemonia Global");
    
    // 1. Inicializar sistema de configuração
    scr_inicializar_configuracoes();
    
    // 2. Inicializar sistema de debug
    scr_inicializar_sistema_debug();
    
    // 3. Inicializar gerenciamento de memória
    scr_inicializar_gerenciamento_memoria();
    
    // 4. Inicializar sistema de validação
    scr_inicializar_sistema_validacao();
    
    // 5. Inicializar sistema de combate unificado
    scr_inicializar_sistema_combate();
    
    // 6. Inicializar sistema de timers
    scr_inicializar_sistema_timers();
    
    // 7. Inicializar dashboard
    scr_inicializar_dashboard();
    
    // 8. Executar validação inicial
    scr_validar_sistema_completo();
    
    scr_log_sistema("INICIALIZACAO", "Todos os sistemas melhorados foram inicializados com sucesso!");
}

function scr_inicializar_sistema_debug() {
    // Inicializar variáveis globais de debug
    global.debug_timers = {};
    global.debug_counters = {};
    global.debug_last_frame = 0;
    
    scr_log_sistema("DEBUG", "Sistema de debug inicializado");
}

function scr_atualizar_sistemas_melhorados() {
    // Atualizar todos os sistemas a cada frame
    global.debug_last_frame++;
    
    // Atualizar sistema de timers
    scr_atualizar_sistema_timers();
    
    // Atualizar sistema de combate
    scr_atualizar_sistema_combate();
    
    // Atualizar dashboard
    scr_atualizar_dashboard();
    
    // Validação periódica
    scr_validacao_periodica();
    
    // Limpeza automática de memória
    scr_limpeza_automatica_memoria();
}

function scr_relatorio_sistemas_completo() {
    scr_debug_log("SISTEMA", "=== RELATÓRIO COMPLETO DOS SISTEMAS ===", DEBUG_LEVEL.BASIC, true);
    
    // Relatório de configuração
    scr_debug_log("SISTEMA", "Configurações ativas:", DEBUG_LEVEL.BASIC, true);
    scr_debug_log("SISTEMA", "  - Debug Level: " + string(global.config.debug_level), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("SISTEMA", "  - Performance Mode: " + string(global.config.performance_mode), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("SISTEMA", "  - Auto Validation: " + string(global.config.auto_validation), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("SISTEMA", "  - Auto Cleanup: " + string(global.config.auto_cleanup), DEBUG_LEVEL.BASIC, true);
    
    // Relatório de debug
    scr_debug_relatorio_completo();
    
    // Relatório de memória
    scr_relatorio_memoria();
    
    // Relatório de validação
    scr_relatorio_validacao();
    
    // Relatório de combate
    scr_relatorio_combate();
    
    // Relatório de timers
    scr_relatorio_timers();
    
    // Relatório do dashboard
    scr_dashboard_relatorio_completo();
    
    scr_debug_log("SISTEMA", "=== FIM DO RELATÓRIO COMPLETO ===", DEBUG_LEVEL.BASIC, true);
}

function scr_limpar_todos_sistemas() {
    scr_log_sistema("LIMPEZA", "Iniciando limpeza completa de todos os sistemas");
    
    // Limpar data structures
    scr_destruir_todos_ds();
    
    // Limpar timers
    global.sistema_timers.timers = {};
    
    // Limpar contadores de debug
    scr_debug_contador_resetar();
    
    // Limpar problemas detectados
    global.problemas_detectados = [];
    global.correcoes_aplicadas = [];
    
    // Limpar unidades em combate
    global.sistema_combate.unidades_em_combate = [];
    
    scr_log_sistema("LIMPEZA", "Limpeza completa concluída");
}

function scr_alternar_modo_performance() {
    global.config.performance_mode = !global.config.performance_mode;
    
    if (global.config.performance_mode) {
        // Ativar modo performance
        global.config.debug_level = 0;
        global.config.auto_validation = false;
        scr_log_sistema("PERFORMANCE", "Modo de alta performance ativado");
    } else {
        // Desativar modo performance
        global.config.debug_level = 1;
        global.config.auto_validation = true;
        scr_log_sistema("PERFORMANCE", "Modo de alta performance desativado");
    }
}

function scr_alternar_modo_debug() {
    var _novo_nivel = (global.config.debug_level + 1) % 4;
    scr_configurar_debug_nivel(_novo_nivel);
}

function scr_executar_diagnostico_completo() {
    scr_log_sistema("DIAGNOSTICO", "Executando diagnóstico completo do sistema");
    
    // Validação completa
    var _problemas = scr_validar_sistema_completo();
    
    // Relatório completo
    scr_relatorio_sistemas_completo();
    
    // Sugestões de melhoria
    scr_sugerir_melhorias();
    
    scr_log_sistema("DIAGNOSTICO", "Diagnóstico completo concluído");
}

function scr_sugerir_melhorias() {
    scr_debug_log("SUGESTOES", "=== SUGESTÕES DE MELHORIA ===", DEBUG_LEVEL.BASIC, true);
    
    var _sugestoes = [];
    
    // Verificar FPS
    if (global.metricas_sistema.fps_atual < 45) {
        array_push(_sugestoes, "Considerar reduzir qualidade gráfica ou número de objetos");
    }
    
    // Verificar memória
    if (global.metricas_sistema.memoria_uso > 80) {
        array_push(_sugestoes, "Executar limpeza de memória mais frequente");
    }
    
    // Verificar problemas
    if (global.metricas_sistema.problemas_ativos > 3) {
        array_push(_sugestoes, "Investigar e corrigir problemas detectados");
    }
    
    // Verificar performance score
    if (global.metricas_sistema.performance_score < 70) {
        array_push(_sugestoes, "Ativar modo de performance ou otimizar código");
    }
    
    // Exibir sugestões
    if (array_length(_sugestoes) > 0) {
        for (var i = 0; i < array_length(_sugestoes); i++) {
            scr_debug_log("SUGESTOES", "• " + _sugestoes[i], DEBUG_LEVEL.BASIC, true);
        }
    } else {
        scr_debug_log("SUGESTOES", "Sistema funcionando otimamente!", DEBUG_LEVEL.BASIC, true);
    }
    
    scr_debug_log("SUGESTOES", "=== FIM DAS SUGESTÕES ===", DEBUG_LEVEL.BASIC, true);
}
