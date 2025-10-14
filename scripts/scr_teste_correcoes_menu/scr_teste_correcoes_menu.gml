// ===============================================
// HEGEMONIA GLOBAL - TESTE DE CORREÇÃO DO MENU
// Script para testar se as correções funcionaram
// ===============================================

/// @description Teste completo das correções do menu
function scr_teste_correcoes_menu() {
    show_debug_message("=== TESTE DE CORREÇÕES DO MENU ===");
    
    // === TESTE 1: VERIFICAR LAYER GUI ===
    show_debug_message("=== TESTE 1: VERIFICAÇÃO DA LAYER GUI ===");
    
    if (layer_exists("GUI")) {
        show_debug_message("✅ Layer GUI existe");
    } else {
        show_debug_message("❌ Layer GUI não existe - criando...");
        layer_create(-100, "GUI");
        if (layer_exists("GUI")) {
            show_debug_message("✅ Layer GUI criada com sucesso");
        } else {
            show_debug_message("❌ Falha ao criar layer GUI");
        }
    }
    
    // === TESTE 2: VERIFICAR SISTEMA DE RECURSOS ===
    show_debug_message("=== TESTE 2: SISTEMA DE RECURSOS ===");
    
    if (!variable_global_exists("nacao_recursos")) {
        global.nacao_recursos = ds_map_create();
        global.nacao_recursos[? "Dinheiro"] = 10000;
        show_debug_message("✅ Sistema de recursos inicializado");
    } else {
        show_debug_message("✅ Sistema de recursos já existe");
    }
    
    show_debug_message("Dinheiro atual: $" + string(global.nacao_recursos[? "Dinheiro"]));
    
    // === TESTE 3: LIMPAR MENUS EXISTENTES ===
    show_debug_message("=== TESTE 3: LIMPEZA DE MENUS ===");
    
    var _menus_antes = instance_number(obj_menu_recrutamento_marinha);
    show_debug_message("Menus existentes antes: " + string(_menus_antes));
    
    // Limpar todos os menus
    with (obj_menu_recrutamento_marinha) {
        instance_destroy();
    }
    global.menu_recrutamento_aberto = false;
    
    var _menus_depois = instance_number(obj_menu_recrutamento_marinha);
    show_debug_message("Menus existentes depois: " + string(_menus_depois));
    
    // === TESTE 4: TESTAR CRIAÇÃO DO MENU ===
    show_debug_message("=== TESTE 4: CRIAÇÃO DO MENU ===");
    
    var _test_menu = instance_create_layer(0, 0, "GUI", obj_menu_recrutamento_marinha);
    if (instance_exists(_test_menu)) {
        show_debug_message("✅ Menu criado com sucesso na layer GUI");
        show_debug_message("Menu ID: " + string(_test_menu));
        show_debug_message("Posição: (" + string(_test_menu.x) + ", " + string(_test_menu.y) + ")");
        
        // Aguardar alguns frames para o Draw executar
        show_debug_message("Aguardando Draw event executar...");
        
        // Destruir menu de teste após alguns frames
        instance_destroy(_test_menu);
        show_debug_message("✅ Menu de teste destruído");
        
    } else {
        show_debug_message("❌ Falha ao criar menu na layer GUI");
    }
    
    // === TESTE 5: VERIFICAR QUARTÉIS ===
    show_debug_message("=== TESTE 5: VERIFICAÇÃO DE QUARTÉIS ===");
    
    var _quartel_count = instance_number(obj_quartel_marinha);
    show_debug_message("Quartéis de marinha: " + string(_quartel_count));
    
    if (_quartel_count > 0) {
        with (obj_quartel_marinha) {
            show_debug_message("Quartel ID: " + string(id) + " | Selecionado: " + string(selecionado));
        }
    } else {
        show_debug_message("⚠️ Nenhum quartel encontrado - criando quartel de teste...");
        
        var _test_quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
        if (instance_exists(_test_quartel)) {
            show_debug_message("✅ Quartel de teste criado: " + string(_test_quartel));
        }
    }
    
    show_debug_message("=== TESTE CONCLUÍDO ===");
    show_debug_message("💡 AGORA TESTE CLICANDO NO QUARTEL!");
    show_debug_message("💡 O MENU DEVE APARECER VISUALMENTE!");
}

/// @description Teste rápido de criação do menu
function scr_teste_criacao_menu() {
    show_debug_message("=== TESTE RÁPIDO DE CRIAÇÃO ===");
    
    // Limpar menus existentes
    with (obj_menu_recrutamento_marinha) {
        instance_destroy();
    }
    
    // Criar menu na layer GUI
    var _menu = instance_create_layer(0, 0, "GUI", obj_menu_recrutamento_marinha);
    
    if (instance_exists(_menu)) {
        show_debug_message("✅ Menu criado: " + string(_menu));
        show_debug_message("💡 Verifique se o menu aparece na tela!");
        
        // Destruir após 3 segundos
        _menu.alarm[0] = 180; // 3 segundos
    } else {
        show_debug_message("❌ Falha ao criar menu");
    }
}

/// @description Verificar status atual do sistema
function scr_verificar_status_sistema() {
    show_debug_message("=== STATUS ATUAL DO SISTEMA ===");
    
    show_debug_message("Layer GUI existe: " + string(layer_exists("GUI")));
    show_debug_message("Sistema de recursos existe: " + string(variable_global_exists("nacao_recursos")));
    show_debug_message("Quartéis de marinha: " + string(instance_number(obj_quartel_marinha)));
    show_debug_message("Menus abertos: " + string(instance_number(obj_menu_recrutamento_marinha)));
    show_debug_message("Menu global aberto: " + string(global.menu_recrutamento_aberto));
    
    if (variable_global_exists("nacao_recursos")) {
        show_debug_message("Dinheiro: $" + string(global.nacao_recursos[? "Dinheiro"]));
    }
}
