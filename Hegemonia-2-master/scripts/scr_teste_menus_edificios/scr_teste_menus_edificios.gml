/// @function scr_teste_menus_edificios()
/// @description Testa se os menus dos edifícios estão funcionando corretamente
/// @return {Boolean} true se todos os menus funcionam

function scr_teste_menus_edificios() {
    show_debug_message("=== 🧪 TESTE DE MENUS DE EDIFÍCIOS ===");
    
    var _testes_passaram = true;
    
    // === TESTE 1: QUARTEL ===
    show_debug_message("🧪 TESTE 1: Menu do Quartel");
    var _quartel = instance_find(obj_quartel, 0);
    if (instance_exists(_quartel)) {
        show_debug_message("✅ Quartel encontrado: ID " + string(_quartel));
        
        // Simular clique no quartel
        if (object_exists(obj_menu_recrutamento)) {
            show_debug_message("✅ Objeto obj_menu_recrutamento existe");
            
            // Testar criação do menu
            var _menu_teste = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento);
            if (instance_exists(_menu_teste)) {
                show_debug_message("✅ Menu de recrutamento criado com sucesso: ID " + string(_menu_teste));
                instance_destroy(_menu_teste);
                show_debug_message("✅ Menu de teste destruído");
            } else {
                show_debug_message("❌ FALHA: Não foi possível criar menu de recrutamento");
                _testes_passaram = false;
            }
        } else {
            show_debug_message("❌ FALHA: Objeto obj_menu_recrutamento não existe");
            _testes_passaram = false;
        }
    } else {
        show_debug_message("⚠️ AVISO: Nenhum quartel encontrado no mapa");
    }
    
    // === TESTE 2: QUARTEL DE MARINHA ===
    show_debug_message("🧪 TESTE 2: Menu do Quartel de Marinha");
    var _quartel_marinha = instance_find(obj_quartel_marinha, 0);
    if (instance_exists(_quartel_marinha)) {
        show_debug_message("✅ Quartel de Marinha encontrado: ID " + string(_quartel_marinha));
        
        if (object_exists(obj_menu_recrutamento_marinha)) {
            show_debug_message("✅ Objeto obj_menu_recrutamento_marinha existe");
            
            // Testar criação do menu
            var _menu_teste = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
            if (instance_exists(_menu_teste)) {
                show_debug_message("✅ Menu de recrutamento naval criado com sucesso: ID " + string(_menu_teste));
                instance_destroy(_menu_teste);
                show_debug_message("✅ Menu de teste destruído");
            } else {
                show_debug_message("❌ FALHA: Não foi possível criar menu de recrutamento naval");
                _testes_passaram = false;
            }
        } else {
            show_debug_message("❌ FALHA: Objeto obj_menu_recrutamento_marinha não existe");
            _testes_passaram = false;
        }
    } else {
        show_debug_message("⚠️ AVISO: Nenhum quartel de marinha encontrado no mapa");
    }
    
    // === TESTE 3: AEROPORTO ===
    show_debug_message("🧪 TESTE 3: Menu do Aeroporto");
    var _aeroporto = instance_find(obj_aeroporto_militar, 0);
    if (instance_exists(_aeroporto)) {
        show_debug_message("✅ Aeroporto encontrado: ID " + string(_aeroporto));
        
        if (object_exists(obj_menu_recrutamento_aereo)) {
            show_debug_message("✅ Objeto obj_menu_recrutamento_aereo existe");
            
            // Testar criação do menu
            var _menu_teste = instance_create_layer(0, 0, "rm_mapa_principal", obj_menu_recrutamento_aereo);
            if (instance_exists(_menu_teste)) {
                show_debug_message("✅ Menu de recrutamento aéreo criado com sucesso: ID " + string(_menu_teste));
                instance_destroy(_menu_teste);
                show_debug_message("✅ Menu de teste destruído");
            } else {
                show_debug_message("❌ FALHA: Não foi possível criar menu de recrutamento aéreo");
                _testes_passaram = false;
            }
        } else {
            show_debug_message("❌ FALHA: Objeto obj_menu_recrutamento_aereo não existe");
            _testes_passaram = false;
        }
    } else {
        show_debug_message("⚠️ AVISO: Nenhum aeroporto encontrado no mapa");
    }
    
    // === TESTE 4: LAYERS ===
    show_debug_message("🧪 TESTE 4: Layers disponíveis");
    var _layers = ["Instances", "rm_mapa_principal"];
    for (var i = 0; i < array_length(_layers); i++) {
        var _layer = _layers[i];
        if (layer_exists(_layer)) {
            show_debug_message("✅ Layer '" + _layer + "' existe");
        } else {
            show_debug_message("❌ FALHA: Layer '" + _layer + "' não existe");
            _testes_passaram = false;
        }
    }
    
    // === RESULTADO FINAL ===
    show_debug_message("=== 📊 RESULTADO FINAL ===");
    if (_testes_passaram) {
        show_debug_message("✅ TODOS OS TESTES DE MENUS PASSARAM!");
        show_debug_message("🎯 Sistema de menus está funcionando corretamente");
    } else {
        show_debug_message("❌ ALGUNS TESTES DE MENUS FALHARAM!");
        show_debug_message("🔧 Verifique os problemas listados acima");
    }
    
    return _testes_passaram;
}
