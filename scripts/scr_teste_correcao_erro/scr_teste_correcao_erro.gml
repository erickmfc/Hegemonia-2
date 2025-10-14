// ===============================================
// HEGEMONIA GLOBAL - TESTE DE CORREÇÃO DE ERRO
// Script para testar se o erro foi corrigido
// ===============================================

/// @description Teste de correção do erro de sintaxe
function scr_teste_correcao_erro() {
    show_debug_message("=== TESTE DE CORREÇÃO DE ERRO ===");
    
    // === TESTE 1: VERIFICAR SISTEMA DE RECURSOS ===
    show_debug_message("=== TESTE 1: SISTEMA DE RECURSOS ===");
    
    if (!variable_global_exists("nacao_recursos")) {
        global.nacao_recursos = ds_map_create();
        global.nacao_recursos[? "Dinheiro"] = 10000;
        show_debug_message("✅ Sistema de recursos inicializado");
    } else {
        show_debug_message("✅ Sistema de recursos já existe");
    }
    
    show_debug_message("Dinheiro atual: $" + string(global.nacao_recursos[? "Dinheiro"]));
    
    // === TESTE 2: VERIFICAR QUARTEL ===
    show_debug_message("=== TESTE 2: VERIFICAÇÃO DO QUARTEL ===");
    
    var _quartel_count = instance_number(obj_quartel_marinha);
    show_debug_message("Quartéis de marinha: " + string(_quartel_count));
    
    if (_quartel_count > 0) {
        with (obj_quartel_marinha) {
            show_debug_message("Quartel ID: " + string(id));
            show_debug_message("Unidades disponíveis: " + string(ds_list_size(unidades_disponiveis)));
            show_debug_message("Fila de produção: " + string(ds_queue_size(fila_producao)));
            show_debug_message("Produzindo: " + string(produzindo));
        }
    } else {
        show_debug_message("⚠️ Nenhum quartel encontrado");
    }
    
    // === TESTE 3: VERIFICAR OBJETO DO MENU ===
    show_debug_message("=== TESTE 3: OBJETO DO MENU ===");
    
    if (object_exists(obj_menu_recrutamento_marinha)) {
        show_debug_message("✅ obj_menu_recrutamento_marinha existe");
    } else {
        show_debug_message("❌ obj_menu_recrutamento_marinha NÃO existe");
    }
    
    // === TESTE 4: VERIFICAR OBJETO DA UNIDADE ===
    show_debug_message("=== TESTE 4: OBJETO DA UNIDADE ===");
    
    if (object_exists(obj_lancha_patrulha)) {
        show_debug_message("✅ obj_lancha_patrulha existe");
    } else {
        show_debug_message("❌ obj_lancha_patrulha NÃO existe");
    }
    
    show_debug_message("=== TESTE CONCLUÍDO ===");
    show_debug_message("💡 AGORA TESTE CLICANDO NO QUARTEL!");
    show_debug_message("💡 O MENU DEVE ABRIR SEM ERROS!");
}

/// @description Teste rápido de compra
function scr_teste_compra_rapida() {
    show_debug_message("=== TESTE RÁPIDO DE COMPRA ===");
    
    // Encontrar quartel
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
        
        // Simular compra
        if (ds_list_size(_quartel.unidades_disponiveis) > 0) {
            var _unidade_data = _quartel.unidades_disponiveis[| 0];
            var _custo = _unidade_data.custo_dinheiro;
            var _dinheiro = global.nacao_recursos[? "Dinheiro"];
            
            show_debug_message("Comprando: " + _unidade_data.nome);
            show_debug_message("Custo: $" + string(_custo));
            show_debug_message("Dinheiro: $" + string(_dinheiro));
            
            if (_dinheiro >= _custo) {
                global.nacao_recursos[? "Dinheiro"] -= _custo;
                ds_queue_enqueue(_quartel.fila_producao, _unidade_data);
                
                if (!_quartel.produzindo) {
                    _quartel.produzindo = true;
                    var _proxima = ds_queue_head(_quartel.fila_producao);
                    _quartel.timer_producao = _proxima.tempo_treino;
                }
                
                show_debug_message("✅ Compra realizada!");
                show_debug_message("Dinheiro restante: $" + string(global.nacao_recursos[? "Dinheiro"]));
                show_debug_message("Aguarde " + string(_unidade_data.tempo_treino / 60) + " segundos para o navio aparecer!");
            }
        }
    }
}
