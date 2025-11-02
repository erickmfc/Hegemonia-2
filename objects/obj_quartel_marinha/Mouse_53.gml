// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Seleção Corrigido para Zoom
// ===============================================

// Evento Left Pressed - Seleção do quartel de marinha
// ✅ REMOVIDO: Debug excessivo removido para melhorar performance

// ✅ CORREÇÃO: Usar função global para coordenadas consistentes
var _coords = scr_mouse_to_world();
var _mouse_world_x = _coords[0];
var _mouse_world_y = _coords[1];

// ✅ CORREÇÃO BUG: Verificar se há unidade SOBRE o edifício (apenas se não for o próprio quartel)
// Primeiro verificar se há uma UNIDADE sobre o edifício (não o próprio edifício)
var _tem_unidade_sobre = false;
var _tipos_unidades = [
    obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo,
    obj_caca_f5, obj_helicoptero_militar, obj_f15, obj_f6, obj_c100
];

for (var i = 0; i < array_length(_tipos_unidades); i++) {
    var _inst = instance_position(_mouse_world_x, _mouse_world_y, _tipos_unidades[i]);
    if (_inst != noone && instance_exists(_inst)) {
        _tem_unidade_sobre = true;
        // ✅ REMOVIDO: Debug removido para performance
        break;
    }
}

// Se há unidade sobre o edifício, ignorar o clique no edifício
if (_tem_unidade_sobre) {
    exit; // Sair sem processar clique no edifício
}

// ✅ CORREÇÃO: Verificar se o clique está dentro do sprite do quartel
var _click_detected = false;
if (mouse_check_button_pressed(mb_left)) {
    // Verificar se o clique está dentro da área do quartel
    var _sprite_w = sprite_get_width(sprite_index);
    var _sprite_h = sprite_get_height(sprite_index);
    var _left = x - _sprite_w/2;
    var _right = x + _sprite_w/2;
    var _top = y - _sprite_h/2;
    var _bottom = y + _sprite_h/2;
    
    if (_mouse_world_x >= _left && _mouse_world_x <= _right && 
        _mouse_world_y >= _top && _mouse_world_y <= _bottom) {
        _click_detected = true;
    }
}

if (_click_detected) {
    // ✅ REDUZIDO: Debug apenas se debug_enabled
    if (global.debug_enabled) show_debug_message("✅ CLIQUE NO QUARTEL MARINHA!");
    
    // === CORREÇÃO: FECHAR APENAS O MENU DESTE QUARTEL (se existir) ===
    // Permite múltiplos menus abertos simultaneamente - cada um operando independentemente
    if (menu_recrutamento != noone && instance_exists(menu_recrutamento)) {
        instance_destroy(menu_recrutamento);
        menu_recrutamento = noone;
    }
    
    // Marcar este quartel de marinha
    selecionado = true;
    
    // === CORREÇÃO: CRIAR MENU COM SISTEMA ROBUSTO ===
    // Verificar se objeto do menu existe
    if (!object_exists(obj_menu_recrutamento_marinha)) {
        if (global.debug_enabled) show_debug_message("❌ ERRO: obj_menu_recrutamento_marinha não existe!");
        return;
    }
    
    // Tentar criar menu na layer "Instances" (mais segura)
    var _menu_criado = false;
    
    // Primeira tentativa: layer "Instances"
    if (layer_exists("Instances")) {
        menu_recrutamento = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
        if (instance_exists(menu_recrutamento)) {
            _menu_criado = true;
        }
    }
    
    // Segunda tentativa: layer "GUI" (se existir)
    if (!_menu_criado && layer_exists("GUI")) {
        menu_recrutamento = instance_create_layer(0, 0, "GUI", obj_menu_recrutamento_marinha);
        if (instance_exists(menu_recrutamento)) {
            _menu_criado = true;
        }
    }
    
    // Terceira tentativa: criar layer GUI e tentar novamente
    if (!_menu_criado) {
        layer_create(-100, "GUI");
        menu_recrutamento = instance_create_layer(0, 0, "GUI", obj_menu_recrutamento_marinha);
        if (instance_exists(menu_recrutamento)) {
            _menu_criado = true;
        }
    }
    
    // Configurar menu se foi criado com sucesso
    if (_menu_criado && instance_exists(menu_recrutamento)) {
        // Configurar menu
        menu_recrutamento.meu_quartel_id = id;
        global.menu_recrutamento_aberto = true;
        
        // Garantir que menu é visível
        menu_recrutamento.visible = true;
        menu_recrutamento.image_alpha = 1.0;
        menu_recrutamento.depth = -1000; // Depth alto para ficar na frente
        
        // ✅ REDUZIDO: Debug apenas se debug_enabled
        if (global.debug_enabled) {
            show_debug_message("✅ Menu de recrutamento naval aberto - ID: " + string(id));
        }
        
        // Verificar se Create event executou
        if (!variable_instance_exists(menu_recrutamento, "meu_quartel_id")) {
            menu_recrutamento.meu_quartel_id = id;
        }
        
    } else if (global.debug_enabled) {
        show_debug_message("❌ Falha ao criar menu de recrutamento");
    }
}