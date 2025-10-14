// ===============================================
// HEGEMONIA GLOBAL - DIAGNÓSTICO COMPLETO DE NAVIOS
// Script para identificar por que os navios não aparecem
// ===============================================

/// @description Diagnóstico completo do sistema de navios
function scr_diagnostico_navios_completo() {
    show_debug_message("=== DIAGNÓSTICO COMPLETO DE NAVIOS ===");
    
    // === TESTE 1: SISTEMA DE RECURSOS ===
    show_debug_message("=== TESTE 1: SISTEMA DE RECURSOS ===");
    
    if (variable_global_exists("dinheiro")) {
        show_debug_message("✅ global.dinheiro existe: $" + string(global.dinheiro));
    } else {
        show_debug_message("❌ global.dinheiro NÃO existe!");
        global.dinheiro = 10000;
        show_debug_message("✅ global.dinheiro inicializado: $" + string(global.dinheiro));
    }
    
    // === TESTE 2: QUARTÉIS DE MARINHA ===
    show_debug_message("=== TESTE 2: QUARTÉIS DE MARINHA ===");
    
    var _quartel_count = instance_number(obj_quartel_marinha);
    show_debug_message("Quartéis de marinha: " + string(_quartel_count));
    
    if (_quartel_count > 0) {
        with (obj_quartel_marinha) {
            show_debug_message("--- Quartel ID: " + string(id) + " ---");
            show_debug_message("  Posição: (" + string(x) + ", " + string(y) + ")");
            show_debug_message("  Produzindo: " + string(produzindo));
            show_debug_message("  Timer produção: " + string(timer_producao));
            show_debug_message("  Fila tamanho: " + string(ds_queue_size(fila_producao)));
            show_debug_message("  Unidades produzidas: " + string(unidades_produzidas));
            show_debug_message("  Unidades disponíveis: " + string(ds_list_size(unidades_disponiveis)));
            
            if (!ds_queue_empty(fila_producao)) {
                var _proxima = ds_queue_head(fila_producao);
                show_debug_message("  Próxima unidade: " + _proxima.nome);
                show_debug_message("  Tempo restante: " + string(_proxima.tempo_treino) + " frames");
            }
        }
    } else {
        show_debug_message("⚠️ Nenhum quartel encontrado!");
    }
    
    // === TESTE 3: OBJETO DA UNIDADE ===
    show_debug_message("=== TESTE 3: OBJETO DA UNIDADE ===");
    
    if (object_exists(obj_lancha_patrulha)) {
        show_debug_message("✅ obj_lancha_patrulha existe");
        
        // Testar criação direta
        var _test_navio = instance_create_layer(500, 500, "rm_mapa_principal", obj_lancha_patrulha);
        if (instance_exists(_test_navio)) {
            show_debug_message("✅ Navio criado diretamente: " + string(_test_navio));
            show_debug_message("  Posição: (" + string(_test_navio.x) + ", " + string(_test_navio.y) + ")");
            show_debug_message("  HP: " + string(_test_navio.hp_atual) + "/" + string(_test_navio.hp_max));
            
            // Destruir navio de teste
            instance_destroy(_test_navio);
            show_debug_message("✅ Navio de teste destruído");
        } else {
            show_debug_message("❌ Falha ao criar navio diretamente");
        }
    } else {
        show_debug_message("❌ obj_lancha_patrulha NÃO existe!");
    }
    
    // === TESTE 4: NAVIOS EXISTENTES ===
    show_debug_message("=== TESTE 4: NAVIOS EXISTENTES ===");
    
    var _navios_count = instance_number(obj_lancha_patrulha);
    show_debug_message("Navios na sala: " + string(_navios_count));
    
    if (_navios_count > 0) {
        with (obj_lancha_patrulha) {
            show_debug_message("  Navio ID: " + string(id) + " | Posição: (" + string(x) + ", " + string(y) + ")");
        }
    }
    
    // === TESTE 5: MENUS ABERTOS ===
    show_debug_message("=== TESTE 5: MENUS ABERTOS ===");
    
    var _menus_count = instance_number(obj_menu_recrutamento_marinha);
    show_debug_message("Menus abertos: " + string(_menus_count));
    
    if (_menus_count > 0) {
        with (obj_menu_recrutamento_marinha) {
            show_debug_message("  Menu ID: " + string(id) + " | Quartel: " + string(meu_quartel_id));
        }
    }
    
    show_debug_message("=== DIAGNÓSTICO CONCLUÍDO ===");
}

/// @description Teste de compra e produção automática
function scr_teste_producao_automatica() {
    show_debug_message("=== TESTE DE PRODUÇÃO AUTOMÁTICA ===");
    
    // Encontrar ou criar quartel
    var _quartel = instance_position(200, 200, obj_quartel_marinha);
    if (_quartel == noone) {
        _quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
        show_debug_message("✅ Quartel criado: " + string(_quartel));
    } else {
        show_debug_message("✅ Quartel encontrado: " + string(_quartel));
    }
    
    if (instance_exists(_quartel)) {
        // Inicializar recursos
        if (!variable_global_exists("dinheiro")) {
            global.dinheiro = 10000;
        }
        
        // Verificar unidades disponíveis
        if (ds_list_size(_quartel.unidades_disponiveis) > 0) {
            var _unidade_data = _quartel.unidades_disponiveis[| 0];
            var _custo = _unidade_data.custo_dinheiro;
            var _dinheiro = global.dinheiro;
            
            show_debug_message("Comprando: " + _unidade_data.nome);
            show_debug_message("Custo: $" + string(_custo) + " | Dinheiro: $" + string(_dinheiro));
            
            if (_dinheiro >= _custo) {
                // Realizar compra
                global.dinheiro -= _custo;
                ds_queue_enqueue(_quartel.fila_producao, _unidade_data);
                
                // Iniciar produção
                if (!_quartel.produzindo) {
                    _quartel.produzindo = true;
                    var _proxima = ds_queue_head(_quartel.fila_producao);
                    _quartel.timer_producao = _proxima.tempo_treino;
                    show_debug_message("🚀 Produção iniciada!");
                    show_debug_message("⏱️ Tempo: " + string(_proxima.tempo_treino) + " frames (" + string(_proxima.tempo_treino / 60) + " segundos)");
                }
                
                show_debug_message("✅ Compra realizada!");
                show_debug_message("💵 Dinheiro restante: $" + string(global.dinheiro));
                show_debug_message("📦 Fila: " + string(ds_queue_size(_quartel.fila_producao)) + " unidades");
                
                // Aguardar produção
                show_debug_message("⏳ Aguardando produção...");
                
            } else {
                show_debug_message("❌ Dinheiro insuficiente!");
            }
        } else {
            show_debug_message("❌ Nenhuma unidade disponível!");
        }
    } else {
        show_debug_message("❌ Falha ao encontrar/criar quartel!");
    }
}

/// @description Monitorar produção em tempo real
function scr_monitorar_producao() {
    show_debug_message("=== MONITOR DE PRODUÇÃO ===");
    
    with (obj_quartel_marinha) {
        if (produzindo) {
            show_debug_message("🏭 Quartel " + string(id) + " produzindo...");
            show_debug_message("  Timer: " + string(timer_producao) + " frames");
            show_debug_message("  Tempo restante: " + string(ceil(timer_producao / 60)) + " segundos");
            
            if (timer_producao <= 0) {
                show_debug_message("🎯 PRODUÇÃO CONCLUÍDA!");
            }
        } else {
            show_debug_message("😴 Quartel " + string(id) + " ocioso");
        }
    }
    
    var _navios = instance_number(obj_lancha_patrulha);
    show_debug_message("Navios na sala: " + string(_navios));
}

/// @description Forçar criação de navio
function scr_forcar_criacao_navio() {
    show_debug_message("=== FORÇAR CRIAÇÃO DE NAVIO ===");
    
    // Encontrar quartel
    var _quartel = instance_position(200, 200, obj_quartel_marinha);
    if (_quartel == noone) {
        _quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    }
    
    if (instance_exists(_quartel)) {
        // Criar navio diretamente
        var _spawn_x = _quartel.x + 50;
        var _spawn_y = _quartel.y + 50;
        
        var _navio = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
        
        if (instance_exists(_navio)) {
            show_debug_message("✅ Navio criado forçadamente!");
            show_debug_message("  ID: " + string(_navio));
            show_debug_message("  Posição: (" + string(_navio.x) + ", " + string(_navio.y) + ")");
            show_debug_message("  Quartel: " + string(_quartel));
        } else {
            show_debug_message("❌ Falha ao criar navio!");
        }
    }
}
