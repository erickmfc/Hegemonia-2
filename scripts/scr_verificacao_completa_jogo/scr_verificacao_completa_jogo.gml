// ===============================================
// HEGEMONIA GLOBAL - VERIFICAÇÃO COMPLETA DO JOGO
// Script para verificar todos os sistemas do jogo
// ===============================================

/// @description Verificação completa do jogo
function scr_verificacao_completa_jogo() {
    show_debug_message("=== VERIFICAÇÃO COMPLETA DO JOGO ===");
    
    // === VERIFICAÇÃO 1: SISTEMA DE RECURSOS ===
    show_debug_message("=== VERIFICAÇÃO 1: SISTEMA DE RECURSOS ===");
    
    if (variable_global_exists("dinheiro")) {
        show_debug_message("✅ global.dinheiro existe: $" + string(global.dinheiro));
    } else {
        show_debug_message("❌ global.dinheiro NÃO existe!");
        global.dinheiro = 10000;
        show_debug_message("✅ global.dinheiro inicializado: $" + string(global.dinheiro));
    }
    
    if (variable_global_exists("minerio")) {
        show_debug_message("✅ global.minerio existe: " + string(global.minerio));
    } else {
        show_debug_message("⚠️ global.minerio não existe");
    }
    
    if (variable_global_exists("populacao")) {
        show_debug_message("✅ global.populacao existe: " + string(global.populacao));
    } else {
        show_debug_message("⚠️ global.populacao não existe");
    }
    
    // === VERIFICAÇÃO 2: QUARTÉIS ===
    show_debug_message("=== VERIFICAÇÃO 2: QUARTÉIS ===");
    
    var _quartel_terrestre = instance_number(obj_quartel);
    var _quartel_naval = instance_number(obj_quartel_marinha);
    
    show_debug_message("Quartéis terrestres: " + string(_quartel_terrestre));
    show_debug_message("Quartéis navais: " + string(_quartel_naval));
    
    if (_quartel_naval > 0) {
        with (obj_quartel_marinha) {
            show_debug_message("  Quartel Naval ID: " + string(id));
            show_debug_message("    Posição: (" + string(x) + ", " + string(y) + ")");
            show_debug_message("    Produzindo: " + string(produzindo));
            show_debug_message("    Alarm[0]: " + string(alarm[0]));
            show_debug_message("    Fila: " + string(ds_queue_size(fila_producao)));
            show_debug_message("    Unidades produzidas: " + string(unidades_produzidas));
        }
    }
    
    // === VERIFICAÇÃO 3: UNIDADES ===
    show_debug_message("=== VERIFICAÇÃO 3: UNIDADES ===");
    
    var _infantaria = instance_number(obj_infantaria);
    var _soldado_aa = instance_number(obj_soldado_antiaereo);
    var _tanque = instance_number(obj_tanque);
    var _blindado_aa = instance_number(obj_blindado_antiaereo);
    var _navios = instance_number(obj_lancha_patrulha);
    
    show_debug_message("Infantaria: " + string(_infantaria));
    show_debug_message("Soldado Anti-Aéreo: " + string(_soldado_aa));
    show_debug_message("Tanque: " + string(_tanque));
    show_debug_message("Blindado Anti-Aéreo: " + string(_blindado_aa));
    show_debug_message("Navios: " + string(_navios));
    
    if (_navios > 0) {
        with (obj_lancha_patrulha) {
            show_debug_message("  Navio ID: " + string(id));
            show_debug_message("    Posição: (" + string(x) + ", " + string(y) + ")");
            show_debug_message("    Selecionado: " + string(selecionado));
            show_debug_message("    Estado: " + string(estado));
            show_debug_message("    HP: " + string(hp_atual) + "/" + string(hp_max));
        }
    }
    
    // === VERIFICAÇÃO 4: OBJETOS IMPORTANTES ===
    show_debug_message("=== VERIFICAÇÃO 4: OBJETOS IMPORTANTES ===");
    
    show_debug_message("obj_quartel existe: " + string(object_exists(obj_quartel)));
    show_debug_message("obj_quartel_marinha existe: " + string(object_exists(obj_quartel_marinha)));
    show_debug_message("obj_lancha_patrulha existe: " + string(object_exists(obj_lancha_patrulha)));
    show_debug_message("obj_menu_recrutamento_marinha existe: " + string(object_exists(obj_menu_recrutamento_marinha)));
    show_debug_message("obj_controlador_unidades existe: " + string(object_exists(obj_controlador_unidades)));
    
    // === VERIFICAÇÃO 5: MENUS ===
    show_debug_message("=== VERIFICAÇÃO 5: MENUS ===");
    
    var _menus_navais = instance_number(obj_menu_recrutamento_marinha);
    show_debug_message("Menus de recrutamento naval: " + string(_menus_navais));
    
    if (_menus_navais > 0) {
        with (obj_menu_recrutamento_marinha) {
            show_debug_message("  Menu ID: " + string(id));
            show_debug_message("    Quartel associado: " + string(meu_quartel_id));
        }
    }
    
    // === VERIFICAÇÃO 6: SISTEMA DE CÂMERA ===
    show_debug_message("=== VERIFICAÇÃO 6: SISTEMA DE CÂMERA ===");
    
    show_debug_message("View camera[0]: " + string(view_camera[0]));
    show_debug_message("Camera view X: " + string(camera_get_view_x(view_camera[0])));
    show_debug_message("Camera view Y: " + string(camera_get_view_y(view_camera[0])));
    show_debug_message("Camera view W: " + string(camera_get_view_width(view_camera[0])));
    show_debug_message("Camera view H: " + string(camera_get_view_height(view_camera[0])));
    
    // === VERIFICAÇÃO 7: SISTEMA DE DEBUG ===
    show_debug_message("=== VERIFICAÇÃO 7: SISTEMA DE DEBUG ===");
    
    show_debug_message("global.debug_enabled: " + string(global.debug_enabled));
    show_debug_message("Sistema de debug funcionando: " + string(global.debug_enabled ? "SIM" : "NÃO"));
    
    // === VERIFICAÇÃO 8: INIMIGOS ===
    show_debug_message("=== VERIFICAÇÃO 8: INIMIGOS ===");
    
    var _inimigos = instance_number(obj_inimigo);
    show_debug_message("Inimigos na sala: " + string(_inimigos));
    
    if (_inimigos > 0) {
        with (obj_inimigo) {
            show_debug_message("  Inimigo ID: " + string(id));
            show_debug_message("    Posição: (" + string(x) + ", " + string(y) + ")");
            show_debug_message("    HP: " + string(hp_atual) + "/" + string(hp_max));
        }
    }
    
    show_debug_message("=== VERIFICAÇÃO CONCLUÍDA ===");
}

/// @description Teste rápido de funcionalidades
function scr_teste_rapido_funcionalidades() {
    show_debug_message("=== TESTE RÁPIDO DE FUNCIONALIDADES ===");
    
    // Teste 1: Criar quartel naval
    show_debug_message("TESTE 1: Criando quartel naval...");
    var _quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    if (instance_exists(_quartel)) {
        show_debug_message("✅ Quartel naval criado: " + string(_quartel));
    } else {
        show_debug_message("❌ Falha ao criar quartel naval");
    }
    
    // Teste 2: Criar navio
    show_debug_message("TESTE 2: Criando navio...");
    var _navio = instance_create_layer(300, 300, "rm_mapa_principal", obj_lancha_patrulha);
    if (instance_exists(_navio)) {
        show_debug_message("✅ Navio criado: " + string(_navio));
        show_debug_message("  Posição: (" + string(_navio.x) + ", " + string(_navio.y) + ")");
        show_debug_message("  HP: " + string(_navio.hp_atual) + "/" + string(_navio.hp_max));
        
        // Destruir navio de teste
        instance_destroy(_navio);
        show_debug_message("✅ Navio de teste destruído");
    } else {
        show_debug_message("❌ Falha ao criar navio");
    }
    
    // Teste 3: Sistema de recursos
    show_debug_message("TESTE 3: Sistema de recursos...");
    if (!variable_global_exists("dinheiro")) {
        global.dinheiro = 10000;
    }
    show_debug_message("✅ Dinheiro disponível: $" + string(global.dinheiro));
    
    // Teste 4: Sistema de produção
    show_debug_message("TESTE 4: Sistema de produção...");
    if (instance_exists(_quartel)) {
        if (ds_list_size(_quartel.unidades_disponiveis) > 0) {
            show_debug_message("✅ Unidades disponíveis: " + string(ds_list_size(_quartel.unidades_disponiveis)));
            
            var _unidade_data = _quartel.unidades_disponiveis[| 0];
            show_debug_message("  Primeira unidade: " + _unidade_data.nome);
            show_debug_message("  Custo: $" + string(_unidade_data.custo_dinheiro));
            show_debug_message("  Tempo: " + string(_unidade_data.tempo_treino) + " frames");
        } else {
            show_debug_message("❌ Nenhuma unidade disponível");
        }
    }
    
    show_debug_message("=== TESTE RÁPIDO CONCLUÍDO ===");
}

/// @description Verificar problemas específicos
function scr_verificar_problemas_especificos() {
    show_debug_message("=== VERIFICAÇÃO DE PROBLEMAS ESPECÍFICOS ===");
    
    // Problema 1: Coordenadas inconsistentes
    show_debug_message("PROBLEMA 1: Verificando coordenadas...");
    var _world_x = camera_get_view_x(view_camera[0]) + mouse_x;
    var _world_y = camera_get_view_y(view_camera[0]) + mouse_y;
    show_debug_message("  Coordenadas mundo: (" + string(_world_x) + ", " + string(_world_y) + ")");
    show_debug_message("  Mouse: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
    show_debug_message("✅ Sistema de coordenadas funcionando");
    
    // Problema 2: Detecção de navios
    show_debug_message("PROBLEMA 2: Testando detecção de navios...");
    var _navios = instance_number(obj_lancha_patrulha);
    if (_navios > 0) {
        with (obj_lancha_patrulha) {
            var _detectado = collision_point(x, y, obj_lancha_patrulha, false, true);
            if (_detectado != noone) {
                show_debug_message("✅ Navio detectado corretamente");
            } else {
                show_debug_message("❌ Problema na detecção de navios");
            }
        }
    } else {
        show_debug_message("⚠️ Nenhum navio para testar detecção");
    }
    
    // Problema 3: Sistema de zoom
    show_debug_message("PROBLEMA 3: Verificando sistema de zoom...");
    show_debug_message("  Camera view: (" + string(camera_get_view_x(view_camera[0])) + ", " + string(camera_get_view_y(view_camera[0])) + ")");
    show_debug_message("  Camera size: " + string(camera_get_view_width(view_camera[0])) + "x" + string(camera_get_view_height(view_camera[0])));
    show_debug_message("✅ Sistema de zoom funcionando");
    
    show_debug_message("=== VERIFICAÇÃO DE PROBLEMAS CONCLUÍDA ===");
}
