// ===============================================
// HEGEMONIA GLOBAL - DIAGNÓSTICO QUARTEL MARINHA
// Script para testar e diagnosticar problemas do menu
// ===============================================

/// @description Diagnóstico completo do quartel de marinha
function scr_diagnostico_quartel_marinha() {
    show_debug_message("=== DIAGNÓSTICO QUARTEL DE MARINHA ===");
    
    // === TESTE 1: VERIFICAR OBJETOS ===
    show_debug_message("=== TESTE 1: VERIFICAÇÃO DE OBJETOS ===");
    
    if (object_exists(obj_quartel_marinha)) {
        show_debug_message("✅ obj_quartel_marinha existe");
    } else {
        show_debug_message("❌ obj_quartel_marinha NÃO existe");
        return;
    }
    
    if (object_exists(obj_menu_recrutamento_marinha)) {
        show_debug_message("✅ obj_menu_recrutamento_marinha existe");
    } else {
        show_debug_message("❌ obj_menu_recrutamento_marinha NÃO existe");
        return;
    }
    
    // === TESTE 2: VERIFICAR LAYERS ===
    show_debug_message("=== TESTE 2: VERIFICAÇÃO DE LAYERS ===");
    
    var _room = room_get_name(room);
    show_debug_message("Sala atual: " + _room);
    
    // Verificar se a layer Instances existe
    var _layer_exists = layer_exists("Instances");
    if (_layer_exists) {
        show_debug_message("✅ Layer 'Instances' existe");
    } else {
        show_debug_message("❌ Layer 'Instances' NÃO existe");
        show_debug_message("   Tentando criar layer 'Instances'...");
        
        // Tentar criar a layer
        var _layer_id = layer_create(0, "Instances");
        if (_layer_id != -1) {
            show_debug_message("✅ Layer 'Instances' criada com sucesso");
        } else {
            show_debug_message("❌ Falha ao criar layer 'Instances'");
        }
    }
    
    // === TESTE 3: VERIFICAR QUARTÉIS EXISTENTES ===
    show_debug_message("=== TESTE 3: QUARTÉIS EXISTENTES ===");
    
    var _quartel_count = instance_number(obj_quartel_marinha);
    show_debug_message("Quartéis de marinha na sala: " + string(_quartel_count));
    
    if (_quartel_count > 0) {
        with (obj_quartel_marinha) {
            show_debug_message("Quartel ID: " + string(id) + " | Posição: (" + string(x) + ", " + string(y) + ")");
            show_debug_message("  Selecionado: " + string(selecionado));
            show_debug_message("  Menu recrutamento: " + string(menu_recrutamento));
        }
    } else {
        show_debug_message("⚠️ Nenhum quartel de marinha encontrado na sala");
        show_debug_message("   Criando quartel de teste...");
        
        var _test_quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
        if (instance_exists(_test_quartel)) {
            show_debug_message("✅ Quartel de teste criado: " + string(_test_quartel));
        } else {
            show_debug_message("❌ Falha ao criar quartel de teste");
        }
    }
    
    // === TESTE 4: VERIFICAR SISTEMA DE CLIQUE ===
    show_debug_message("=== TESTE 4: SISTEMA DE CLIQUE ===");
    
    var _mouse_x = mouse_x;
    var _mouse_y = mouse_y;
    show_debug_message("Posição do mouse: (" + string(_mouse_x) + ", " + string(_mouse_y) + ")");
    
    // Verificar se há quartel na posição do mouse
    var _quartel_sob_mouse = instance_position(_mouse_x, _mouse_y, obj_quartel_marinha);
    if (_quartel_sob_mouse != noone) {
        show_debug_message("✅ Quartel encontrado sob o mouse: " + string(_quartel_sob_mouse));
    } else {
        show_debug_message("⚠️ Nenhum quartel encontrado sob o mouse");
    }
    
    // === TESTE 5: TESTAR CRIAÇÃO DO MENU ===
    show_debug_message("=== TESTE 5: CRIAÇÃO DO MENU ===");
    
    var _test_menu = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
    if (instance_exists(_test_menu)) {
        show_debug_message("✅ Menu de teste criado com sucesso: " + string(_test_menu));
        show_debug_message("   Posição do menu: (" + string(_test_menu.x) + ", " + string(_test_menu.y) + ")");
        
        // Destruir menu de teste
        instance_destroy(_test_menu);
        show_debug_message("✅ Menu de teste destruído");
    } else {
        show_debug_message("❌ Falha ao criar menu de teste");
    }
    
    // === TESTE 6: VERIFICAR CONFLITOS ===
    show_debug_message("=== TESTE 6: VERIFICAÇÃO DE CONFLITOS ===");
    
    // Verificar se há outros objetos interceptando cliques
    var _all_objects = instance_position(_mouse_x, _mouse_y, all);
    if (_all_objects != noone) {
        show_debug_message("Objetos na posição do mouse:");
        with (_all_objects) {
            show_debug_message("  - " + object_get_name(object_index) + " (ID: " + string(id) + ")");
        }
    } else {
        show_debug_message("Nenhum objeto na posição do mouse");
    }
    
    show_debug_message("=== DIAGNÓSTICO CONCLUÍDO ===");
    show_debug_message("💡 DICAS:");
    show_debug_message("1. Clique no quartel de marinha e observe o console");
    show_debug_message("2. Verifique se aparecem mensagens de debug");
    show_debug_message("3. Se não aparecer nada, há problema no sistema de clique");
    show_debug_message("4. Se aparecer mensagens mas não menu, há problema na criação");
}

/// @description Teste rápido do sistema de clique
function scr_teste_clique_quartel() {
    show_debug_message("=== TESTE RÁPIDO DE CLIQUE ===");
    
    var _mouse_x = mouse_x;
    var _mouse_y = mouse_y;
    
    show_debug_message("Mouse X: " + string(_mouse_x) + " | Mouse Y: " + string(_mouse_y));
    
    // Verificar se há quartel na posição
    var _quartel = instance_position(_mouse_x, _mouse_y, obj_quartel_marinha);
    if (_quartel != noone) {
        show_debug_message("✅ Quartel encontrado: " + string(_quartel));
        
        // Simular clique
        show_debug_message("Simulando clique no quartel...");
        
        // Verificar se o quartel tem evento Mouse_53
        if (event_exists(ev_mouse, ev_mouse_left)) {
            show_debug_message("✅ Evento Mouse_53 existe no quartel");
        } else {
            show_debug_message("❌ Evento Mouse_53 NÃO existe no quartel");
        }
        
    } else {
        show_debug_message("❌ Nenhum quartel encontrado na posição do mouse");
    }
}

/// @description Diagnóstico avançado de problemas específicos
function scr_diagnostico_problemas_especificos() {
    show_debug_message("=== DIAGNÓSTICO DE PROBLEMAS ESPECÍFICOS ===");
    
    // === PROBLEMA 1: MENU VAZIO ===
    show_debug_message("=== TESTE: MENU VAZIO ===");
    
    var _quartel = instance_position(mouse_x, mouse_y, obj_quartel_marinha);
    if (_quartel != noone) {
        if (variable_instance_exists(_quartel, "unidades_disponiveis")) {
            var _unidades_count = ds_list_size(_quartel.unidades_disponiveis);
            show_debug_message("Unidades disponíveis: " + string(_unidades_count));
            
            if (_unidades_count == 0) {
                show_debug_message("❌ PROBLEMA 1: Menu vazio - nenhuma unidade configurada");
                show_debug_message("   Solução: Verificar Create event do quartel");
            } else {
                show_debug_message("✅ Unidades configuradas corretamente");
            }
        } else {
            show_debug_message("❌ PROBLEMA 1: Menu vazio - lista de unidades não existe");
            show_debug_message("   Solução: Criar unidades_disponiveis no Create event");
        }
    }
    
    // === PROBLEMA 2: BOTÕES NÃO FUNCIONAM ===
    show_debug_message("=== TESTE: BOTÕES NÃO FUNCIONAM ===");
    
    if (object_exists(obj_menu_recrutamento_marinha)) {
        // Verificar se tem evento Mouse_56
        show_debug_message("✅ Objeto do menu existe");
        show_debug_message("   Verificar manualmente se evento Mouse_56 está implementado");
    } else {
        show_debug_message("❌ PROBLEMA 2: Objeto do menu não existe");
    }
    
    // === PROBLEMA 3: RECURSOS NÃO DEDUZEM ===
    show_debug_message("=== TESTE: RECURSOS NÃO DEDUZEM ===");
    
    if (variable_global_exists("nacao_recursos")) {
        show_debug_message("✅ Sistema de recursos existe");
        show_debug_message("   Dinheiro atual: $" + string(global.nacao_recursos[? "Dinheiro"]));
    } else {
        show_debug_message("❌ PROBLEMA 3: Sistema de recursos não existe");
        show_debug_message("   Solução: Inicializar global.nacao_recursos");
        
        // Tentar inicializar automaticamente
        global.nacao_recursos = ds_map_create();
        global.nacao_recursos[? "Dinheiro"] = 10000;
        show_debug_message("✅ Sistema de recursos inicializado automaticamente");
    }
    
    // === PROBLEMA 4: UNIDADES NÃO APARECEM ===
    show_debug_message("=== TESTE: UNIDADES NÃO APARECEM ===");
    
    if (object_exists(obj_lancha_patrulha)) {
        show_debug_message("✅ Objeto obj_lancha_patrulha existe");
    } else {
        show_debug_message("❌ PROBLEMA 4: Objeto obj_lancha_patrulha não existe");
        show_debug_message("   Solução: Criar objeto da unidade naval");
    }
    
    // === PROBLEMA 5: MENU SEM VISUAL ===
    show_debug_message("=== TESTE: MENU SEM VISUAL ===");
    
    var _test_menu = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
    if (instance_exists(_test_menu)) {
        show_debug_message("✅ Menu pode ser criado");
        show_debug_message("   Verificar manualmente se evento Draw está implementado");
        instance_destroy(_test_menu);
    } else {
        show_debug_message("❌ PROBLEMA 5: Menu não pode ser criado");
    }
    
    // === PROBLEMA 6: MENU TRAVADO ===
    show_debug_message("=== TESTE: MENU TRAVADO ===");
    show_debug_message("   Verificar manualmente se botão fechar funciona");
    
    // === PROBLEMA 7: MENU FORA DA TELA ===
    show_debug_message("=== TESTE: MENU FORA DA TELA ===");
    
    var _test_menu2 = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
    if (instance_exists(_test_menu2)) {
        show_debug_message("Menu criado em posição: (" + string(_test_menu2.x) + ", " + string(_test_menu2.y) + ")");
        
        if (_test_menu2.x == 0 && _test_menu2.y == 0) {
            show_debug_message("⚠️ PROBLEMA 7: Menu criado em (0,0) - pode estar fora da tela");
            show_debug_message("   Solução: Ajustar posição do menu");
        } else {
            show_debug_message("✅ Posição do menu parece correta");
        }
        
        instance_destroy(_test_menu2);
    }
    
    // === PROBLEMA 8: CONFLITO COM OUTROS QUARTÉIS ===
    show_debug_message("=== TESTE: CONFLITO COM OUTROS QUARTÉIS ===");
    
    var _quartel_terrestre_count = instance_number(obj_quartel);
    var _quartel_naval_count = instance_number(obj_quartel_marinha);
    
    show_debug_message("Quartéis terrestres: " + string(_quartel_terrestre_count));
    show_debug_message("Quartéis navais: " + string(_quartel_naval_count));
    
    if (_quartel_terrestre_count > 0 && _quartel_naval_count > 0) {
        show_debug_message("⚠️ Possível conflito: ambos os tipos de quartel existem");
        show_debug_message("   Verificar se sistema de seleção está funcionando");
    }
    
    // === PROBLEMA 9: MENU SEM COR ===
    show_debug_message("=== TESTE: MENU SEM COR ===");
    show_debug_message("   Verificar manualmente se Draw event tem cores definidas");
    
    // === PROBLEMA 10: INFORMAÇÕES ERRADAS ===
    show_debug_message("=== TESTE: INFORMAÇÕES ERRADAS ===");
    
    var _test_menu3 = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
    if (instance_exists(_test_menu3)) {
        if (variable_instance_exists(_test_menu3, "meu_quartel_id")) {
            show_debug_message("✅ Variável meu_quartel_id existe");
            show_debug_message("   Valor: " + string(_test_menu3.meu_quartel_id));
        } else {
            show_debug_message("❌ PROBLEMA 10: Variável meu_quartel_id não existe");
        }
        instance_destroy(_test_menu3);
    }
    
    show_debug_message("=== DIAGNÓSTICO ESPECÍFICO CONCLUÍDO ===");
}

/// @description Correção automática de problemas comuns
function scr_corrigir_problemas_automaticamente() {
    show_debug_message("=== CORREÇÃO AUTOMÁTICA DE PROBLEMAS ===");
    
    // === CORREÇÃO 1: INICIALIZAR SISTEMA DE RECURSOS ===
    if (!variable_global_exists("nacao_recursos")) {
        global.nacao_recursos = ds_map_create();
        global.nacao_recursos[? "Dinheiro"] = 10000;
        global.nacao_recursos[? "Minério"] = 5000;
        global.nacao_recursos[? "Petróleo"] = 3000;
        show_debug_message("✅ Sistema de recursos inicializado");
    }
    
    // === CORREÇÃO 2: CRIAR LAYER SE NÃO EXISTIR ===
    if (!layer_exists("Instances")) {
        var _layer_id = layer_create(0, "Instances");
        if (_layer_id != -1) {
            show_debug_message("✅ Layer 'Instances' criada");
        }
    }
    
    // === CORREÇÃO 3: VERIFICAR QUARTÉIS ===
    with (obj_quartel_marinha) {
        if (!variable_instance_exists(id, "unidades_disponiveis")) {
            unidades_disponiveis = ds_list_create();
            
            // Adicionar unidades básicas
            var _lancha = {
                nome: "Lancha Patrulha",
                objeto: obj_lancha_patrulha,
                custo_dinheiro: 300,
                custo_populacao: 2,
                tempo_treino: 300
            };
            ds_list_add(unidades_disponiveis, _lancha);
            
            show_debug_message("✅ Lista de unidades criada para quartel " + string(id));
        }
    }
    
    show_debug_message("=== CORREÇÕES APLICADAS ===");
    show_debug_message("💡 Agora teste o quartel novamente!");
}
