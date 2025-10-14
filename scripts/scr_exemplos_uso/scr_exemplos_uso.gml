// Guia de Uso dos Sistemas Melhorados - Hegemonia Global
// Exemplos práticos de como usar todos os sistemas implementados

// ========================================
// INICIALIZAÇÃO DO SISTEMA
// ========================================

// No evento Create do objeto principal do jogo (ex: obj_game_manager):
function scr_exemplo_inicializacao() {
    // Inicializar todos os sistemas melhorados
    scr_inicializar_sistemas_melhorados();
    
    // Aplicar melhorias de unificação
    scr_aplicar_melhorias_unificacao();
    
    // Executar diagnóstico inicial
    scr_executar_diagnostico_completo();
}

// No evento Step do objeto principal:
function scr_exemplo_atualizacao() {
    // Atualizar todos os sistemas
    scr_atualizar_sistemas_melhorados();
}

// ========================================
// SISTEMA DE DEBUG CONFIGURÁVEL
// ========================================

function scr_exemplo_debug() {
    // Configurar nível de debug
    scr_configurar_debug_nivel(2); // Detailed
    
    // Logs por categoria
    scr_debug_log("COMBATE", "Unidade atacando alvo", DEBUG_LEVEL.BASIC);
    scr_debug_log("MOVIMENTO", "Calculando rota", DEBUG_LEVEL.DETAILED);
    scr_debug_log("RECURSOS", "Recurso coletado", DEBUG_LEVEL.BASIC);
    
    // Debug de performance
    scr_debug_performance_inicio("calculo_rota");
    // ... código custoso ...
    scr_debug_performance_fim("calculo_rota", 16); // Limite de 16ms
    
    // Contadores
    scr_debug_contador_incrementar("COMBATE", "ataques_realizados");
    scr_debug_contador_mostrar("COMBATE", "ataques_realizados");
}

// ========================================
// SISTEMA DE COMBATE UNIFICADO
// ========================================

function scr_exemplo_combate() {
    // Selecionar unidades
    var _unidades_selecionadas = [obj_infantaria_1, obj_infantaria_2];
    
    // Comandos de combate
    scr_processar_comando_combate(COMANDO_COMBATE.ATACAR_ALVO, _unidades_selecionadas, {
        alvo: obj_inimigo_1
    });
    
    scr_processar_comando_combate(COMANDO_COMBATE.ATACAR_AREA, _unidades_selecionadas, {
        x: 500,
        y: 300,
        raio: 100
    });
    
    scr_processar_comando_combate(COMANDO_COMBATE.DEFENDER_POSICAO, _unidades_selecionadas, {
        x: 400,
        y: 200
    });
    
    // Parar combate
    scr_processar_comando_combate(COMANDO_COMBATE.PARAR_COMBATE, _unidades_selecionadas);
}

// ========================================
// SISTEMA DE TIMERS E OTIMIZAÇÃO
// ========================================

function scr_exemplo_timers() {
    // Criar timer personalizado
    scr_criar_timer("timer_construcao", 300, "scr_construcao_concluida"); // 5 segundos
    
    // Verificar se timer está ativo
    if (scr_timer_ativo("timer_construcao")) {
        var _tempo_restante = scr_timer_tempo_restante("timer_construcao");
        scr_debug_log("TIMERS", "Construção em " + string(_tempo_restante) + " frames", DEBUG_LEVEL.BASIC);
    }
    
    // Pausar/retomar timer
    scr_pausar_timer("timer_construcao");
    scr_retomar_timer("timer_construcao");
    
    // Destruir timer
    scr_destruir_timer("timer_construcao");
}

// ========================================
// SISTEMA DE GERENCIAMENTO DE MEMÓRIA
// ========================================

function scr_exemplo_memoria() {
    // Criar data structures com tracking
    var _lista_unidades = scr_criar_ds_list_tracked();
    var _fila_comandos = scr_criar_ds_queue_tracked();
    var _grid_mapa = scr_criar_ds_grid_tracked(100, 100);
    
    // Usar normalmente
    ds_list_add(_lista_unidades, obj_infantaria_1);
    ds_queue_enqueue(_fila_comandos, "mover");
    ds_grid_set(_grid_mapa, 50, 50, 1);
    
    // Destruir quando não precisar mais
    scr_destruir_ds_list_tracked(_lista_unidades);
    scr_destruir_ds_queue_tracked(_fila_comandos);
    scr_destruir_ds_grid_tracked(_grid_mapa);
    
    // Verificar uso de memória
    var _uso_memoria = scr_calcular_uso_memoria();
    scr_debug_log("MEMORIA", "Uso atual: " + string(_uso_memoria) + "%", DEBUG_LEVEL.BASIC);
}

// ========================================
// SISTEMA DE VALIDAÇÃO E AUTO-CORREÇÃO
// ========================================

function scr_exemplo_validacao() {
    // Executar validação manual
    var _problemas = scr_validar_sistema_completo();
    
    if (array_length(_problemas) > 0) {
        scr_debug_log("VALIDACAO", "Problemas encontrados: " + string(array_length(_problemas)), DEBUG_LEVEL.BASIC);
        
        // Auto-correção
        if (global.config.auto_correction) {
            scr_corrigir_problemas_automaticamente(_problemas);
        }
    }
    
    // Verificar integridade após mudanças
    scr_verificar_integridade_unificacao();
}

// ========================================
// DASHBOARD DE MONITORAMENTO
// ========================================

function scr_exemplo_dashboard() {
    // Alternar dashboard
    scr_alternar_dashboard();
    
    // Configurar posição e tamanho
    scr_configurar_dashboard(50, 50, 400, 300);
    
    // Exportar métricas
    var _metricas = scr_dashboard_exportar_metricas();
    scr_debug_log("DASHBOARD", "Métricas exportadas", DEBUG_LEVEL.BASIC);
    
    // Gerar relatório completo
    scr_dashboard_relatorio_completo();
}

// ========================================
// SISTEMA DE CONFIGURAÇÃO
// ========================================

function scr_exemplo_configuracao() {
    // Obter configurações
    var _debug_level = scr_obter_config("debug_level");
    var _performance_mode = scr_obter_config("performance_mode");
    
    // Alterar configurações
    scr_definir_config("debug_level", 2);
    scr_definir_config("performance_mode", true);
    
    // Alternar modos
    scr_alternar_modo_performance();
    scr_alternar_modo_debug();
}

// ========================================
// SISTEMA DE UNIFICAÇÃO
// ========================================

function scr_exemplo_unificacao() {
    // Verificar variáveis duplicadas antes da unificação
    scr_debug_log("UNIFICACAO", "Verificando variáveis duplicadas...", DEBUG_LEVEL.BASIC);
    
    // Aplicar unificação
    scr_aplicar_melhorias_unificacao();
    
    // Verificar integridade
    scr_verificar_integridade_unificacao();
    
    // Gerar relatório
    scr_relatorio_unificacao();
}

// ========================================
// EXEMPLOS DE INTEGRAÇÃO
// ========================================

// Exemplo: Sistema de construção com todos os recursos
function scr_exemplo_construcao_completa() {
    // Debug de performance
    scr_debug_performance_inicio("construcao_completa");
    
    // Validar recursos antes da construção
    var _problemas = scr_validar_recursos_sistema();
    if (array_length(_problemas) > 0) {
        scr_debug_log("CONSTRUCAO", "Problemas de recursos detectados", DEBUG_LEVEL.BASIC);
        return;
    }
    
    // Criar timer para construção
    scr_criar_timer("construcao_edificio", 600, "scr_construcao_finalizada");
    
    // Usar data structures com tracking
    var _lista_materiais = scr_criar_ds_list_tracked();
    ds_list_add(_lista_materiais, "madeira");
    ds_list_add(_lista_materiais, "pedra");
    
    // Sistema de combate para defender construção
    var _unidades_defesa = [obj_infantaria_1, obj_infantaria_2];
    scr_processar_comando_combate(COMANDO_COMBATE.DEFENDER_POSICAO, _unidades_defesa, {
        x: x,
        y: y
    });
    
    // Limpar recursos
    scr_destruir_ds_list_tracked(_lista_materiais);
    
    // Finalizar debug de performance
    scr_debug_performance_fim("construcao_completa", 50);
    
    scr_debug_log("CONSTRUCAO", "Construção iniciada com todos os sistemas integrados", DEBUG_LEVEL.BASIC);
}

// Exemplo: Sistema de combate com monitoramento
function scr_exemplo_combate_monitorado() {
    // Iniciar monitoramento de performance
    scr_debug_performance_inicio("sistema_combate");
    
    // Processar combate
    scr_atualizar_sistema_combate();
    
    // Verificar problemas
    var _problemas = scr_validar_sistema_completo();
    if (array_length(_problemas) > 0) {
        scr_debug_log("COMBATE", "Problemas detectados durante combate", DEBUG_LEVEL.BASIC);
    }
    
    // Atualizar dashboard
    scr_atualizar_dashboard();
    
    // Finalizar monitoramento
    scr_debug_performance_fim("sistema_combate", 16);
    
    // Relatório de combate
    scr_relatorio_combate();
}

// ========================================
// FUNÇÕES DE CALLBACK PARA TIMERS
// ========================================

function scr_construcao_concluida() {
    scr_debug_log("CONSTRUCAO", "Construção concluída!", DEBUG_LEVEL.BASIC);
    
    // Validar sistema após construção
    scr_validar_sistema_completo();
    
    // Atualizar recursos
    scr_verificar_recursos_sistema();
}

function scr_construcao_finalizada() {
    scr_debug_log("CONSTRUCAO", "Edifício construído com sucesso!", DEBUG_LEVEL.BASIC);
    
    // Limpar timer
    scr_destruir_timer("construcao_edificio");
    
    // Atualizar métricas
    scr_dashboard_historico_performance();
}

// ========================================
// SISTEMA DE RELATÓRIOS COMPLETOS
// ========================================

function scr_exemplo_relatorio_completo() {
    // Gerar relatório de todos os sistemas
    scr_relatorio_sistemas_completo();
    
    // Relatórios específicos
    scr_relatorio_memoria();
    scr_relatorio_validacao();
    scr_relatorio_combate();
    scr_relatorio_timers();
    scr_dashboard_relatorio_completo();
    scr_relatorio_unificacao();
    
    // Sugestões de melhoria
    scr_sugerir_melhorias();
}

// ========================================
// SISTEMA DE LIMPEZA E MANUTENÇÃO
// ========================================

function scr_exemplo_manutencao() {
    // Limpeza completa do sistema
    scr_limpar_todos_sistemas();
    
    // Re-inicializar sistemas
    scr_inicializar_sistemas_melhorados();
    
    // Executar diagnóstico
    scr_executar_diagnostico_completo();
    
    scr_debug_log("MANUTENCAO", "Manutenção completa concluída", DEBUG_LEVEL.BASIC);
}
