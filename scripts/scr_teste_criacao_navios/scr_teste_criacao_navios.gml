// ===============================================
// HEGEMONIA GLOBAL - TESTE DE CRIAÇÃO DE NAVIOS
// Script para testar o sistema completo de compra e criação
// ===============================================

/// @description Teste completo do sistema de criação de navios
function scr_teste_criacao_navios() {
    show_debug_message("=== TESTE DE CRIAÇÃO DE NAVIOS ===");
    
    // === TESTE 1: VERIFICAR QUARTEL DE MARINHA ===
    show_debug_message("=== TESTE 1: VERIFICAÇÃO DO QUARTEL ===");
    
    var _quartel_count = instance_number(obj_quartel_marinha);
    show_debug_message("Quartéis de marinha: " + string(_quartel_count));
    
    if (_quartel_count == 0) {
        show_debug_message("⚠️ Nenhum quartel encontrado - criando quartel de teste...");
        var _test_quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
        if (instance_exists(_test_quartel)) {
            show_debug_message("✅ Quartel de teste criado: " + string(_test_quartel));
        }
    }
    
    // === TESTE 2: VERIFICAR UNIDADES DISPONÍVEIS ===
    show_debug_message("=== TESTE 2: UNIDADES DISPONÍVEIS ===");
    
    with (obj_quartel_marinha) {
        if (variable_instance_exists(id, "unidades_disponiveis")) {
            var _unidades_count = ds_list_size(unidades_disponiveis);
            show_debug_message("Unidades disponíveis: " + string(_unidades_count));
            
            for (var i = 0; i < _unidades_count; i++) {
                var _unidade = unidades_disponiveis[| i];
                show_debug_message("  " + string(i+1) + ". " + _unidade.nome + " - $" + string(_unidade.custo_dinheiro));
            }
        } else {
            show_debug_message("❌ Lista de unidades não existe");
        }
    }
    
    // === TESTE 3: VERIFICAR SISTEMA DE RECURSOS ===
    show_debug_message("=== TESTE 3: SISTEMA DE RECURSOS ===");
    
    if (!variable_global_exists("nacao_recursos")) {
        global.nacao_recursos = ds_map_create();
        global.nacao_recursos[? "Dinheiro"] = 10000;
        show_debug_message("✅ Sistema de recursos inicializado");
    }
    
    show_debug_message("Dinheiro atual: $" + string(global.nacao_recursos[? "Dinheiro"]));
    
    // === TESTE 4: VERIFICAR OBJETO DA UNIDADE ===
    show_debug_message("=== TESTE 4: OBJETO DA UNIDADE ===");
    
    if (object_exists(obj_lancha_patrulha)) {
        show_debug_message("✅ obj_lancha_patrulha existe");
    } else {
        show_debug_message("❌ obj_lancha_patrulha NÃO existe");
    }
    
    // === TESTE 5: TESTAR CRIAÇÃO DIRETA ===
    show_debug_message("=== TESTE 5: CRIAÇÃO DIRETA ===");
    
    var _test_navio = instance_create_layer(300, 300, "rm_mapa_principal", obj_lancha_patrulha);
    if (instance_exists(_test_navio)) {
        show_debug_message("✅ Navio criado diretamente: " + string(_test_navio));
        show_debug_message("Posição: (" + string(_test_navio.x) + ", " + string(_test_navio.y) + ")");
        
        // Destruir navio de teste
        instance_destroy(_test_navio);
        show_debug_message("✅ Navio de teste destruído");
    } else {
        show_debug_message("❌ Falha ao criar navio diretamente");
    }
    
    show_debug_message("=== TESTE CONCLUÍDO ===");
    show_debug_message("💡 AGORA TESTE COMPRANDO UM NAVIO NO MENU!");
}

/// @description Teste de compra automática
function scr_teste_compra_automatica() {
    show_debug_message("=== TESTE DE COMPRA AUTOMÁTICA ===");
    
    // Encontrar quartel de marinha
    var _quartel = instance_position(200, 200, obj_quartel_marinha);
    if (_quartel == noone) {
        _quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    }
    
    if (instance_exists(_quartel)) {
        show_debug_message("✅ Quartel encontrado: " + string(_quartel));
        
        // Inicializar recursos
        if (!variable_global_exists("nacao_recursos")) {
            global.nacao_recursos = ds_map_create();
            global.nacao_recursos[? "Dinheiro"] = 10000;
        }
        
        // Simular compra da primeira unidade
        if (ds_list_size(_quartel.unidades_disponiveis) > 0) {
            var _unidade_data = _quartel.unidades_disponiveis[| 0];
            var _custo = _unidade_data.custo_dinheiro;
            var _dinheiro = global.nacao_recursos[? "Dinheiro"];
            
            show_debug_message("Tentando comprar: " + _unidade_data.nome);
            show_debug_message("Custo: $" + string(_custo) + " | Dinheiro: $" + string(_dinheiro));
            
            if (_dinheiro >= _custo) {
                // Deduzir dinheiro
                global.nacao_recursos[? "Dinheiro"] -= _custo;
                
                // Adicionar à fila
                ds_queue_enqueue(_quartel.fila_producao, _unidade_data);
                
                // Iniciar produção
                if (!_quartel.produzindo) {
                    _quartel.produzindo = true;
                    var _proxima = ds_queue_head(_quartel.fila_producao);
                    _quartel.timer_producao = _proxima.tempo_treino;
                }
                
                show_debug_message("✅ Compra realizada com sucesso!");
                show_debug_message("Dinheiro restante: $" + string(global.nacao_recursos[? "Dinheiro"]));
                show_debug_message("Tempo de produção: " + string(_unidade_data.tempo_treino) + " frames");
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

/// @description Verificar status da produção
function scr_verificar_producao() {
    show_debug_message("=== STATUS DA PRODUÇÃO ===");
    
    with (obj_quartel_marinha) {
        show_debug_message("Quartel ID: " + string(id));
        show_debug_message("Produzindo: " + string(produzindo));
        show_debug_message("Timer produção: " + string(timer_producao));
        show_debug_message("Fila tamanho: " + string(ds_queue_size(fila_producao)));
        show_debug_message("Unidades produzidas: " + string(unidades_produzidas));
        
        if (!ds_queue_empty(fila_producao)) {
            var _proxima = ds_queue_head(fila_producao);
            show_debug_message("Próxima unidade: " + _proxima.nome);
        }
    }
    
    show_debug_message("Navios na sala: " + string(instance_number(obj_lancha_patrulha)));
}
