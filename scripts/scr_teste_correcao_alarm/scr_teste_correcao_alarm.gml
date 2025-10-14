// ===============================================
// HEGEMONIA GLOBAL - TESTE DE CORREÇÃO DO ALARM EVENT
// Script para testar se as correções do Alarm event funcionaram
// ===============================================

/// @description Teste de correção do Alarm event
function scr_teste_correcao_alarm() {
    show_debug_message("=== TESTE DE CORREÇÃO DO ALARM EVENT ===");
    
    // === TESTE 1: VERIFICAR QUARTEL ===
    show_debug_message("=== TESTE 1: VERIFICAÇÃO DO QUARTEL ===");
    
    var _quartel_count = instance_number(obj_quartel_marinha);
    show_debug_message("Quartéis de marinha: " + string(_quartel_count));
    
    if (_quartel_count > 0) {
        with (obj_quartel_marinha) {
            show_debug_message("Quartel ID: " + string(id));
            show_debug_message("  Posição: (" + string(x) + ", " + string(y) + ")");
            show_debug_message("  Produzindo: " + string(produzindo));
            show_debug_message("  Alarm[0]: " + string(alarm[0]));
            show_debug_message("  Fila tamanho: " + string(ds_queue_size(fila_producao)));
            show_debug_message("  Unidades produzidas: " + string(unidades_produzidas));
        }
    } else {
        show_debug_message("⚠️ Nenhum quartel encontrado!");
    }
    
    // === TESTE 2: VERIFICAR OBJETO DA UNIDADE ===
    show_debug_message("=== TESTE 2: OBJETO DA UNIDADE ===");
    
    if (object_exists(obj_lancha_patrulha)) {
        show_debug_message("✅ obj_lancha_patrulha existe");
        
        // Testar criação direta com instance_create_layer
        var _test_navio = instance_create_layer(500, 500, "rm_mapa_principal", obj_lancha_patrulha);
        if (instance_exists(_test_navio)) {
            show_debug_message("✅ Navio criado com instance_create_layer: " + string(_test_navio));
            show_debug_message("  Posição: (" + string(_test_navio.x) + ", " + string(_test_navio.y) + ")");
            show_debug_message("  HP: " + string(_test_navio.hp_atual) + "/" + string(_test_navio.hp_max));
            
            // Destruir navio de teste
            instance_destroy(_test_navio);
            show_debug_message("✅ Navio de teste destruído");
        } else {
            show_debug_message("❌ Falha ao criar navio com instance_create_layer");
        }
    } else {
        show_debug_message("❌ obj_lancha_patrulha NÃO existe!");
    }
    
    // === TESTE 3: VERIFICAR NAVIOS EXISTENTES ===
    show_debug_message("=== TESTE 3: NAVIOS EXISTENTES ===");
    
    var _navios_count = instance_number(obj_lancha_patrulha);
    show_debug_message("Navios na sala: " + string(_navios_count));
    
    if (_navios_count > 0) {
        with (obj_lancha_patrulha) {
            show_debug_message("  Navio ID: " + string(id) + " | Posição: (" + string(x) + ", " + string(y) + ")");
        }
    }
    
    show_debug_message("=== TESTE CONCLUÍDO ===");
}

/// @description Teste de produção com Alarm event
function scr_teste_producao_alarm() {
    show_debug_message("=== TESTE DE PRODUÇÃO COM ALARM EVENT ===");
    
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
                
                // Configurar Alarm event
                _quartel.produzindo = true;
                _quartel.alarm[0] = _unidade_data.tempo_treino;
                
                show_debug_message("✅ Compra realizada!");
                show_debug_message("💵 Dinheiro restante: $" + string(global.dinheiro));
                show_debug_message("📦 Fila: " + string(ds_queue_size(_quartel.fila_producao)) + " unidades");
                show_debug_message("⏰ Alarm[0] configurado para: " + string(_quartel.alarm[0]) + " frames");
                show_debug_message("💡 Aguarde " + string(_unidade_data.tempo_treino / 60) + " segundos para o navio aparecer!");
                
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

/// @description Monitorar Alarm event em tempo real
function scr_monitorar_alarm() {
    show_debug_message("=== MONITOR DE ALARM EVENT ===");
    
    with (obj_quartel_marinha) {
        if (produzindo) {
            show_debug_message("🏭 Quartel " + string(id) + " produzindo...");
            show_debug_message("  Alarm[0]: " + string(alarm[0]) + " frames");
            show_debug_message("  Tempo restante: " + string(ceil(alarm[0] / 60)) + " segundos");
            show_debug_message("  Fila: " + string(ds_queue_size(fila_producao)) + " unidades");
            
            if (alarm[0] <= 0) {
                show_debug_message("🎯 ALARM EVENT DEVE EXECUTAR AGORA!");
            }
        } else {
            show_debug_message("😴 Quartel " + string(id) + " ocioso");
        }
    }
    
    var _navios = instance_number(obj_lancha_patrulha);
    show_debug_message("Navios na sala: " + string(_navios));
}

/// @description Forçar execução do Alarm event
function scr_forcar_alarm_event() {
    show_debug_message("=== FORÇAR EXECUÇÃO DO ALARM EVENT ===");
    
    // Encontrar quartel
    var _quartel = instance_position(200, 200, obj_quartel_marinha);
    if (_quartel == noone) {
        _quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    }
    
    if (instance_exists(_quartel)) {
        // Adicionar unidade à fila
        if (ds_list_size(_quartel.unidades_disponiveis) > 0) {
            var _unidade_data = _quartel.unidades_disponiveis[| 0];
            ds_queue_enqueue(_quartel.fila_producao, _unidade_data);
            
            // Forçar execução do Alarm event
            _quartel.produzindo = true;
            _quartel.alarm[0] = 1; // Executar no próximo frame
            
            show_debug_message("✅ Alarm event forçado!");
            show_debug_message("  Unidade: " + _unidade_data.nome);
            show_debug_message("  Alarm[0]: " + string(_quartel.alarm[0]));
            show_debug_message("💡 O Alarm event deve executar no próximo frame!");
        }
    }
}

