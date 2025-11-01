/// Room Creation Code - Room1
/// Inicialização Limpa e Otimizada

if (global.debug_enabled) show_debug_message("Room1 creation code executando...");

// === CONFIGURAÇÃO CRÍTICA DA GUI ===
// Garante que a GUI funcione corretamente para detecção de cliques
display_set_gui_maximise(1, 1, 0, 0);
if (global.debug_enabled) {
    show_debug_message("✅ GUI configurado na Room1 com display_set_gui_maximise");
    show_debug_message("   GUI Width: " + string(display_get_gui_width()) + " | Height: " + string(display_get_gui_height()));
}

// === CRIAÇÃO DE INSTÂNCIAS ESSENCIAIS ===

// Dashboard para exibir recursos
if (object_exists(obj_simple_dashboard)) {
    var _dashboard_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_simple_dashboard);
    if (global.debug_enabled && instance_exists(_dashboard_instance)) {
        show_debug_message("✅ Dashboard criado - ID: " + string(_dashboard_instance));
    }
}

// Centro de pesquisa
if (object_exists(obj_research_center)) {
    var _research_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_research_center);
    if (global.debug_enabled && instance_exists(_research_instance)) {
        show_debug_message("✅ Research Center criado - ID: " + string(_research_instance));
    }
} else if (object_exists(obj_centro_pesquisa)) {
    var _research_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_centro_pesquisa);
    if (global.debug_enabled && instance_exists(_research_instance)) {
        show_debug_message("✅ Centro de Pesquisa criado - ID: " + string(_research_instance));
    }
}

// Menu de construção
if (object_exists(obj_menu_construcao)) {
    var _menu_construcao_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_menu_construcao);
    if (global.debug_enabled && instance_exists(_menu_construcao_instance)) {
        show_debug_message("✅ Menu de Construção criado - ID: " + string(_menu_construcao_instance));
    }
}

// Controlador de construção
try {
    var _controlador_construcao_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_controlador_construcao);
    if (global.debug_enabled && instance_exists(_controlador_construcao_instance)) {
        show_debug_message("✅ Controlador de Construção criado - ID: " + string(_controlador_construcao_instance));
    }
} catch (_error) {
    if (global.debug_enabled) show_debug_message("⚠️ obj_controlador_construcao não registrado");
}

// Menu de ação
try {
    var _menu_acao_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_menu_de_acao);
    if (global.debug_enabled && instance_exists(_menu_acao_instance)) {
        show_debug_message("✅ Menu de Ação criado - ID: " + string(_menu_acao_instance));
    }
} catch (_error) {
    if (global.debug_enabled) show_debug_message("⚠️ obj_menu_de_acao não registrado");
}

// UI Manager
if (object_exists(obj_ui_manager)) {
    var _ui_manager_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_ui_manager);
    if (global.debug_enabled && instance_exists(_ui_manager_instance)) {
        show_debug_message("✅ UI Manager criado - ID: " + string(_ui_manager_instance));
    }
}

// Input Manager (CRÍTICO PARA WASD)
// ✅ CORREÇÃO: obj_input_manager é PERSISTENTE, então só criar se não existir ainda
if (!instance_exists(obj_input_manager)) {
    if (object_exists(obj_input_manager)) {
        var _input_manager_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_input_manager);
        if (global.debug_enabled && instance_exists(_input_manager_instance)) {
            show_debug_message("✅ Input Manager criado na Room1 - ID: " + string(_input_manager_instance));
            show_debug_message("   WASD habilitado para movimentação da câmera");
        } else {
            show_debug_message("❌ ERRO: Falha ao criar Input Manager - WASD não funcionará!");
        }
    } else {
        show_debug_message("❌ ERRO: obj_input_manager não existe - WASD não funcionará!");
    }
} else {
    if (global.debug_enabled) {
        var _existing_instance = instance_find(obj_input_manager, 0);
        show_debug_message("✅ Input Manager já existe (persistente) - ID: " + string(_existing_instance));
    }
}

// === CRIAÇÃO DE INIMIGOS PARA TESTE ===
if (global.debug_enabled) show_debug_message("=== CRIANDO INIMIGOS PARA TESTE ===");

var inimigos_criados = 0;
if (object_exists(obj_inimigo)) {
    for (var i = 0; i < 2; i++) {
        var inimigo = instance_create_layer(400 + (i * 150), 300 + (i * 100), "rm_mapa_principal", obj_inimigo);
        if (instance_exists(inimigo)) {
            inimigos_criados++;
            if (global.debug_enabled) {
                show_debug_message("🎯 Inimigo " + string(inimigos_criados) + " criado - ID: " + string(inimigo));
            }
        }
    }
} else {
    // Fallback: usar obj_infantaria como inimigo
    for (var i = 0; i < 2; i++) {
        var inimigo = instance_create_layer(400 + (i * 150), 300 + (i * 100), "rm_mapa_principal", obj_infantaria);
        if (instance_exists(inimigo)) {
            inimigo.nacao_proprietaria = 2; // 2 = inimigo
            inimigo.hp_atual = 100;
            inimigo.hp_max = 100;
            inimigo.estado = "livre";
            inimigo.comando_atual = "LIVRE";
            inimigos_criados++;
            if (global.debug_enabled) {
                show_debug_message("🎯 Inimigo " + string(inimigos_criados) + " criado (fallback) - ID: " + string(inimigo));
            }
        }
    }
}

// === CRIAÇÃO DA IA PRESIDENTE 1 ===
// Removido temporariamente - adicione obj_presidente_1 manualmente no mapa quando desejar
// if (object_exists(obj_presidente_1)) {
//     var _ia_instance = instance_create_layer(800, 600, "rm_mapa_principal", obj_presidente_1);
//     if (instance_exists(_ia_instance)) {
//         show_debug_message("🤖 IA Presidente 1 criada na posição (800, 600) - ID: " + string(_ia_instance));
//     }
// }

if (global.debug_enabled) {
show_debug_message("🎯 Total de inimigos criados: " + string(inimigos_criados));
    show_debug_message("=== SISTEMA PRONTO PARA JOGO ===");
    show_debug_message("🏠 Sistema de Construção: Ativo");
    show_debug_message("⚔️ Sistema de Combate: Ativo");
    show_debug_message("🎮 Controles: Clique esquerdo para selecionar, direito para mover/atacar");
}