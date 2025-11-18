// ===============================================
// HEGEMONIA GLOBAL - GAME MANAGER STEP
// Sistema de Debug Ultra Otimizado + Seleção Global
// ===============================================

// Incrementar contador global de frames
if (!variable_global_exists("game_frame")) {
    global.game_frame = 0;
}
global.game_frame++;

// Resetar contador de debug a cada frame
// ✅ CORREÇÃO GM2043: Verificar se função existe antes de chamar
if (variable_global_exists("debug_reset_frame")) {
    if (is_function(global.debug_reset_frame)) {
        global.debug_reset_frame();
    }
}

// === SISTEMA DE LOD E OTIMIZAÇÃO PARA MAPAS GRANDES ===
// Executar apenas a cada 5 frames para não sobrecarregar
// ✅ CORREÇÃO: Usar global.game_frame ao invés de current_frame
// ✅ DESABILITADO: Estava fazendo unidades sumirem ao mudar de local
if (global.game_frame mod 5 == 0) {
    // Gerenciar ativação/desativação de instâncias
    // scr_manage_instance_lod(); // DESABILITADO - causava sumiço de unidades
}

// ✅ OTIMIZAÇÃO: Reconstruir spatial grid a cada 60 frames (1 segundo a 60 FPS)
// ✅ CORREÇÃO GM2043: Verificar se script existe antes de chamar
if (variable_global_exists("spatial_grid_initialized") && global.spatial_grid_initialized) {
    if (global.game_frame mod 60 == 0) {
        var _script_rebuild = asset_get_index("scr_rebuild_spatial_grid");
        if (_script_rebuild != -1) {
            scr_rebuild_spatial_grid();
        }
    }
}

// === SISTEMA DE DESTRUIÇÃO DE ESTRUTURAS ===
// Verificar estruturas com HP <= 0 a cada 60 frames (1 segundo)
// ✅ CORREÇÃO GM2043: Verificar se script existe antes de chamar
if (global.game_frame mod 60 == 0) {
    var _script_destruicao = asset_get_index("scr_verificar_destruicao_estruturas");
    if (_script_destruicao != -1) {
        scr_verificar_destruicao_estruturas();
    }
}

// === ✅ NOVO: CORRIGIR UNIDADES EM TERRENO ERRADO ===
// Verificar e corrigir unidades em terreno inválido a cada 5 segundos
if (global.game_frame mod 300 == 0) {
    var _script_corrigir = asset_get_index("scr_corrigir_unidades_terreno_errado");
    if (_script_corrigir != -1) {
        scr_corrigir_unidades_terreno_errado();
    }
}

// === SISTEMA DE VALIDAÇÃO PERIÓDICA ===
// ✅ NOVO: Validação automática a cada 5-10 segundos
// Verifica variáveis globais, instâncias órfãs, data structures e corrige problemas
// ✅ CORREÇÃO GM2043: Verificar se script existe antes de chamar
var _script_validacao = asset_get_index("scr_validacao_periodica");
if (_script_validacao != -1) {
    scr_validacao_periodica();
}

// === SISTEMA DE LIMPEZA AUTOMÁTICA DE MEMÓRIA ===
// ✅ NOVO: Limpeza automática a cada 10 segundos (600 frames)
// Remove referências órfãs, projéteis inativos, partículas antigas
// ✅ CORREÇÃO GM2043: Verificar se script existe antes de chamar
if (global.game_frame mod 600 == 0) {
    var _script_limpeza = asset_get_index("scr_limpeza_automatica_memoria");
    if (_script_limpeza != -1) {
        scr_limpeza_automatica_memoria();
    }
}

// --- SISTEMA DE DEBUG GLOBAL ---
// A seleção agora é gerenciada pelo obj_controlador_unidades
// Este objeto foca apenas no debug e inicialização

// === GERENCIAMENTO DE INFLATION ===
// Reduzir inflação gradualmente se não usar a Casa da Moeda
if (global.taxa_inflacao > 0) {
    global.taxa_inflacao -= global.inflacao_decay;
    if (global.taxa_inflacao < 0) {
        global.taxa_inflacao = 0;
    }
}

// === SISTEMA DE ESTABILIDADE SOCIAL ===
// Calcular estabilidade baseada na inflação
var _perda_estabilidade = global.taxa_inflacao * global.instabilidade_por_inflacao;
global.estabilidade_social = 100 - (_perda_estabilidade * 100);

// Limitar estabilidade entre 0 e 100
if (global.estabilidade_social < 0) {
    global.estabilidade_social = 0;
} else if (global.estabilidade_social > 100) {
    global.estabilidade_social = 100;
}

// === CONSEQUÊNCIAS DE ALTA INFLATION ===
// Se inflação muito alta, penalizar produção
if (global.taxa_inflacao > 0.3) {
    // Reduzir produção de recursos em 20%
    global.penalidade_producao = 0.8;
} else {
    global.penalidade_producao = 1.0;
}

// === CONSEQUÊNCIAS AVANÇADAS DE ALTA INFLATION ===
if (global.taxa_inflacao > 0.4) {
    // Reduzir produção de todas as estruturas
    global.penalidade_producao = 0.5;
    show_debug_message("⚠️ CRISE ECONÔMICA: Produção reduzida em 50%!");
}

if (global.taxa_inflacao > 0.6) {
    // Instabilidade social extrema
    global.estabilidade_social = 0;
    show_debug_message("🚨 INSTABILIDADE SOCIAL: Risco de revolta popular!");
}

    // === SISTEMA DE IMPOSTOS (FUTURO) ===
    // TODO: Implementar coleta de impostos mensal
    // if (global.game_frame % (room_speed * 1800) == 0) {
    //     // --- SISTEMA DE ARRECADAÇÃO DE IMPOSTOS ---
    //     
    //     // 1. Calcula a base de arrecadação
    //     // Cada cidadão gera atividade econômica
    //     var base_economica = global.populacao * global.base_economica_por_cidadao;
    //     
    //     // 2. Calcula o valor arrecadado com base na taxa de impostos
    //     var impostos_coletados = base_economica * global.taxa_impostos;
    //     
    //     // 3. Adiciona o dinheiro ao tesouro da nação
    //     global.dinheiro += impostos_coletados;
    //     global.estoque_recursos[? "Dinheiro"] = global.dinheiro;
    //     
    //     // 4. Feedback para o jogador
    //     show_debug_message("💰 IMPOSTOS DO MÊS ARRECADADOS: " + string(impostos_coletados) + " CG");
    //     show_debug_message("📊 Base econômica: " + string(base_economica) + " CG");
    //     show_debug_message("📈 Taxa de impostos: " + string(round(global.taxa_impostos * 100)) + "%");
    // }

    // === SISTEMA FINANCEIRO - PAGAMENTO DE JUROS ===
    // Pagamento automático de juros mensal (a cada 30 segundos)
    // ✅ CORREÇÃO GM2043: Verificar se variáveis existem antes de usar
    if (variable_global_exists("divida_total") && variable_global_exists("game_frame") && 
        variable_global_exists("room_speed") && global.divida_total > 0 && 
        global.game_frame % (room_speed * 30) == 0) {
        // Verificar se tem dinheiro suficiente para pagar juros
        // ✅ CORREÇÃO GM2043: Verificar se variáveis existem antes de usar
        if (variable_global_exists("dinheiro") && variable_global_exists("juros_mensais") &&
            global.dinheiro >= global.juros_mensais) {
            // Pagar juros
            global.dinheiro -= global.juros_mensais;
            // ✅ CORREÇÃO GM2043: Verificar se estoque_recursos existe antes de atualizar
            if (variable_global_exists("estoque_recursos") && ds_exists(global.estoque_recursos, ds_type_map)) {
                ds_map_replace(global.estoque_recursos, "Dinheiro", global.dinheiro);
            }
            
            show_debug_message("💸 JUROS PAGOS: $" + string(global.juros_mensais));
            show_debug_message("💰 Dinheiro restante: $" + string(global.dinheiro));
            show_debug_message("📊 Dívida restante: $" + string(global.divida_total));
        } else {
            // Não tem dinheiro suficiente - dívida aumenta
            // ✅ CORREÇÃO GM2043: Verificar se variáveis existem antes de usar
            if (variable_global_exists("juros_mensais") && variable_global_exists("dinheiro") &&
                variable_global_exists("divida_total")) {
                var _juros_nao_pagos = global.juros_mensais - global.dinheiro;
                global.divida_total += _juros_nao_pagos;
                global.dinheiro = 0;
                // ✅ CORREÇÃO GM2043: Verificar se estoque_recursos existe antes de atualizar
                if (variable_global_exists("estoque_recursos") && ds_exists(global.estoque_recursos, ds_type_map)) {
                    ds_map_replace(global.estoque_recursos, "Dinheiro", global.dinheiro);
                }
            }
            
            show_debug_message("⚠️ JUROS NÃO PAGOS!");
            show_debug_message("💸 Juros devidos: $" + string(global.juros_mensais));
            show_debug_message("💰 Dinheiro disponível: $" + string(global.dinheiro));
            show_debug_message("📈 Dívida aumentou para: $" + string(global.divida_total));
            show_debug_message("🚨 ATENÇÃO: Dívida em crescimento!");
        }
    }

// === SISTEMA DE CONSUMO SIMPLIFICADO ===
// Executa a cada ciclo (30 minutos)
// ✅ CORREÇÃO GM2043: Verificar se variáveis existem antes de usar
if (variable_global_exists("game_frame") && variable_global_exists("room_speed") &&
    global.game_frame % (room_speed * 1800) == 0) {
    
    // === CONSUMO DE ALIMENTO ===
    // ✅ CORREÇÃO GM2043: Verificar se variáveis existem antes de usar
    if (variable_global_exists("populacao") && variable_global_exists("alimento")) {
        var consumo_total = global.populacao * 0.5; // 0.5 Alimento por pessoa por ciclo
        
        if (global.alimento >= consumo_total) {
            // População bem alimentada
            global.alimento -= consumo_total;
            // ✅ CORREÇÃO GM2043: Verificar se estoque_recursos existe antes de atualizar
            if (variable_global_exists("estoque_recursos") && ds_exists(global.estoque_recursos, ds_type_map)) {
                ds_map_replace(global.estoque_recursos, "Alimento", global.alimento);
            }
        
            // Crescimento populacional (1% por ciclo se bem alimentada)
            // MAS APENAS SE NÃO EXCEDER O LIMITE POPULACIONAL
            var crescimento = floor(global.populacao * 0.01);
            var _nova_populacao = global.populacao + crescimento;
            
            // Verificar se não excede o limite populacional
            // ✅ CORREÇÃO GM2043: Verificar se variáveis existem antes de usar
            if (variable_global_exists("limite_populacional") && _nova_populacao <= global.limite_populacional) {
                global.populacao = _nova_populacao;
                // ✅ CORREÇÃO GM2043: Verificar se estoque_recursos existe antes de atualizar
                if (variable_global_exists("estoque_recursos") && ds_exists(global.estoque_recursos, ds_type_map)) {
                    ds_map_replace(global.estoque_recursos, "População", global.populacao);
                }
                show_debug_message("📈 Crescimento: +" + string(crescimento) + " pessoas");
            } else {
                // Crescimento limitado pelo limite populacional
                // ✅ CORREÇÃO GM2043: Verificar se variáveis existem antes de usar
                if (variable_global_exists("limite_populacional")) {
                    var _crescimento_limite = global.limite_populacional - global.populacao;
                    if (_crescimento_limite > 0) {
                        global.populacao += _crescimento_limite;
                        // ✅ CORREÇÃO GM2043: Verificar se estoque_recursos existe antes de atualizar
                        if (variable_global_exists("estoque_recursos") && ds_exists(global.estoque_recursos, ds_type_map)) {
                            ds_map_replace(global.estoque_recursos, "População", global.populacao);
                        }
                        show_debug_message("📈 Crescimento limitado: +" + string(_crescimento_limite) + " pessoas");
                    } else {
                        show_debug_message("🚫 Limite populacional atingido! Construa mais casas para crescer.");
                    }
                }
            }
            
            show_debug_message("🍽️ Consumo: " + string(consumo_total) + " Alimento");
            show_debug_message("👥 População total: " + string(global.populacao));
        } else {
            // População mal alimentada - sem crescimento
            show_debug_message("⚠️ População mal alimentada - sem crescimento");
        }
    }
}