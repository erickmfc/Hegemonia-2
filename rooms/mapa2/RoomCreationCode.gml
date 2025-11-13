/// Room Creation Code - Room1
/// Inicialização Limpa e Otimizada

if (global.debug_enabled) show_debug_message("Room1 creation code executando...");

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

// === CRIAÇÃO DE INIMIGOS PARA TESTE ===
if (global.debug_enabled) show_debug_message("=== CRIANDO INIMIGOS PARA TESTE ===");

// ✅ CORREÇÃO: obj_inimigo removido - não criar mais inimigos
var inimigos_criados = 0;
// if (object_exists(obj_inimigo)) {
//     for (var i = 0; i < 2; i++) {
//         var inimigo = instance_create_layer(400 + (i * 150), 300 + (i * 100), "rm_mapa_principal", obj_inimigo);
//         if (instance_exists(inimigo)) {
//             inimigos_criados++;
//             if (global.debug_enabled) {
//                 show_debug_message("🎯 Inimigo " + string(inimigos_criados) + " criado - ID: " + string(inimigo));
//             }
//         }
//     }
// }

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

// === CRIAÇÃO DA IA PRESIDENTE 1 ===
// ✅ REMOVIDO: obj_presidente_1 não deve aparecer no mapa2
// Garantir que nenhuma instância de obj_presidente_1 exista nesta room
// ✅ FORÇA BRUTA: Destruir TODAS as instâncias, mesmo que já tenham sido criadas
if (object_exists(obj_presidente_1)) {
    var _total_presidentes = instance_number(obj_presidente_1);
    if (_total_presidentes > 0) {
        with (obj_presidente_1) {
            instance_destroy();
        }
        if (global.debug_enabled) {
            show_debug_message("🗑️ Removido " + string(_total_presidentes) + " instância(s) de obj_presidente_1 do mapa2 (RoomCreationCode)");
        }
    }
}

// ✅ VERIFICAÇÃO ADICIONAL: Marcar para verificação contínua
// O obj_presidente_1 agora se auto-destrói no Create e Step se estiver no mapa2
// Esta verificação adicional garante remoção imediata

if (global.debug_enabled) {
show_debug_message("🎯 Total de inimigos criados: " + string(inimigos_criados));
    show_debug_message("=== SISTEMA PRONTO PARA JOGO ===");
    show_debug_message("🏠 Sistema de Construção: Ativo");
    show_debug_message("⚔️ Sistema de Combate: Ativo");
    show_debug_message("🎮 Controles: Clique esquerdo para selecionar, direito para mover/atacar");
}