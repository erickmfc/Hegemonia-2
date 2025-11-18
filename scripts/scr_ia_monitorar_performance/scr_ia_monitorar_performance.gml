// ===============================================
// HEGEMONIA GLOBAL - MONITORAMENTO DE PERFORMANCE DA IA
// Sistema de Telemetria e Debug
// ===============================================

/// @function scr_ia_monitorar_performance(_presidente_id)
/// @description Monitora e exibe estatísticas de performance da IA
/// @param {id} _presidente_id - ID do objeto presidente

function scr_ia_monitorar_performance(_presidente_id) {
    with (_presidente_id) {
        
        // === INICIALIZAR STATS SE NÃO EXISTIREM ===
        if (!variable_instance_exists(id, "stats_performance")) {
            stats_performance = {
                unidades_recrutadas: 0,
                unidades_elite_recrutadas: 0,
                ataques_coordenados_executados: 0,
                alvos_eliminados: 0,
                taxa_sucesso_ataque: 0.0,
                recursos_gastos: 0,
                tempo_jogo_segundos: 0,
                unidades_ativas: 0
            };
        }
        
        // === ATUALIZAR TEMPO ===
        stats_performance.tempo_jogo_segundos = current_time / 1000;
        
        // === CONTAR UNIDADES ATIVAS ===
        var _contagem_unidades_ia = scr_ia_contar_unidades_ia();
        stats_performance.unidades_ativas = _contagem_unidades_ia.total;
        
        // === EXIBIR STATS PERIODICAMENTE ===
        if (!variable_instance_exists(id, "timer_debug_stats")) {
            timer_debug_stats = 0;
        }
        timer_debug_stats++;
        
        if (timer_debug_stats >= 600 && variable_global_exists("debug_enabled") && global.debug_enabled) { // A cada 10 segundos
            timer_debug_stats = 0;
            
            show_debug_message("════════════════════════════════════════");
            show_debug_message("📊 ESTATÍSTICAS IA PRESIDENTE 1");
            show_debug_message("════════════════════════════════════════");
            show_debug_message("⏱️  Tempo de Jogo: " + string(round(stats_performance.tempo_jogo_segundos)) + "s");
            show_debug_message("💰 Dinheiro: $" + string(round(global.dinheiro)));
            show_debug_message("🪖 Unidades Ativas: " + string(stats_performance.unidades_ativas));
            show_debug_message("   - Aviões: " + string(_contagem_unidades_ia.avioes));
            show_debug_message("   - Terrestres: " + string(_contagem_unidades_ia.terrestres));
            show_debug_message("   - Navios: " + string(_contagem_unidades_ia.navios));
            show_debug_message("📈 Unidades Recrutadas: " + string(stats_performance.unidades_recrutadas));
            show_debug_message("⭐ Elite Recrutadas: " + string(stats_performance.unidades_elite_recrutadas));
            show_debug_message("⚔️  Ataques Coordenados: " + string(stats_performance.ataques_coordenados_executados));
            show_debug_message("🎯 Alvos Eliminados: " + string(stats_performance.alvos_eliminados));
            show_debug_message("📊 Taxa de Sucesso: " + string(round(stats_performance.taxa_sucesso_ataque * 100)) + "%");
            show_debug_message("💸 Recursos Gastos: $" + string(stats_performance.recursos_gastos));
            show_debug_message("════════════════════════════════════════");
        }
    }
}

/// @function scr_ia_registrar_recrutamento(_presidente_id, _unidade_tipo, _eh_elite)
/// @description Registra um recrutamento nas estatísticas
/// @param {id} _presidente_id - ID do presidente
/// @param {object} _unidade_tipo - Tipo de unidade recrutada
/// @param {bool} _eh_elite - Se é unidade elite

function scr_ia_registrar_recrutamento(_presidente_id, _unidade_tipo, _eh_elite) {
    with (_presidente_id) {
        if (!variable_instance_exists(id, "stats_performance")) {
            stats_performance = { unidades_recrutadas: 0, unidades_elite_recrutadas: 0 };
        }
        
        stats_performance.unidades_recrutadas++;
        if (_eh_elite) {
            stats_performance.unidades_elite_recrutadas++;
        }
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            var _nome = object_get_name(_unidade_tipo);
            show_debug_message("✅ IA Recrutou: " + _nome + (_eh_elite ? " (ELITE)" : ""));
        }
    }
}

/// @function scr_ia_registrar_ataque_coordenado(_presidente_id)
/// @description Registra execução de ataque coordenado
/// @param {id} _presidente_id - ID do presidente

function scr_ia_registrar_ataque_coordenado(_presidente_id) {
    with (_presidente_id) {
        if (!variable_instance_exists(id, "stats_performance")) {
            stats_performance = { ataques_coordenados_executados: 0 };
        }
        
        stats_performance.ataques_coordenados_executados++;
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚔️  IA Executou Ataque Coordenado #" + string(stats_performance.ataques_coordenados_executados));
        }
    }
}

/// @function scr_ia_gerar_relatorio_final()
/// @description Gera relatório final da IA ao final do jogo

function scr_ia_gerar_relatorio_final() {
    show_debug_message("╔════════════════════════════════════════════════╗");
    show_debug_message("║        RELATÓRIO FINAL - IA PRESIDENTE 1      ║");
    show_debug_message("╚════════════════════════════════════════════════╝");
    show_debug_message("🎮 Resultado: " + (global.jogador_ganhou ? "DERROTA" : "VITÓRIA"));
    show_debug_message("═════════════════════════════════════════════════");
    
    with (obj_presidente_1) {
        if (variable_instance_exists(id, "stats_performance")) {
            show_debug_message("📊 ESTATÍSTICAS FINAIS:");
            show_debug_message("  • Unidades Recrutadas: " + string(stats_performance.unidades_recrutadas));
            show_debug_message("  • Elite Recrutadas: " + string(stats_performance.unidades_elite_recrutadas));
            show_debug_message("  • Ataques Coordenados: " + string(stats_performance.ataques_coordenados_executados));
            show_debug_message("  • Alvos Eliminados: " + string(stats_performance.alvos_eliminados));
            show_debug_message("  • Taxa de Sucesso: " + string(round(stats_performance.taxa_sucesso_ataque * 100)) + "%");
            show_debug_message("  • Dinheiro Gasto: $" + string(stats_performance.recursos_gastos));
            show_debug_message("  • Tempo Total: " + string(round(stats_performance.tempo_jogo_segundos)) + "s");
        }
    }
    
    show_debug_message("═════════════════════════════════════════════════");
    show_debug_message("✅ Fim do relatório");
}

/// @function scr_ia_debug_listar_unidades()
/// @description Lista todas as unidades da IA em debug

function scr_ia_debug_listar_unidades() {
    show_debug_message("═══════════════════════════════════════");
    show_debug_message("📋 UNIDADES DA IA PRESIDENTE 1");
    show_debug_message("═══════════════════════════════════════");
    
    var _count_f15 = 0, _count_f6 = 0, _count_tanques = 0, _count_infantaria = 0;
    var _count_defesa_aerea = 0, _count_navios = 0;
    
    with (obj_f15) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _count_f15++;
        }
    }
    with (obj_f6) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _count_f6++;
        }
    }
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _count_tanques++;
        }
    }
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _count_infantaria++;
        }
    }
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _count_defesa_aerea++;
        }
    }
    with (obj_RonaldReagan) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _count_navios++;
        }
    }
    with (obj_Independence) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _count_navios++;
        }
    }
    
    show_debug_message("✈️  F-15: " + string(_count_f15));
    show_debug_message("✈️  F-6: " + string(_count_f6));
    show_debug_message("🪖 Tanques: " + string(_count_tanques));
    show_debug_message("👷 Infantaria: " + string(_count_infantaria));
    show_debug_message("🛡️  Defesa Aérea: " + string(_count_defesa_aerea));
    show_debug_message("⚓ Navios: " + string(_count_navios));
    show_debug_message("═══════════════════════════════════════");
    show_debug_message("📊 Total: " + string(_count_f15 + _count_f6 + _count_tanques + _count_infantaria + 
                                              _count_defesa_aerea + _count_navios) + " unidades");
    show_debug_message("═══════════════════════════════════════");
}

