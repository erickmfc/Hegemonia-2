// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema Unificado de Clique - IMPLEMENTAÇÃO INLINE
// ===============================================

// === PASSO 1: DESSELECIONAR UNIDADES ===
// Desselecionar todas as unidades quando clica em qualquer edifício
with (obj_infantaria) { selecionado = false; }
with (obj_soldado_antiaereo) { selecionado = false; }
with (obj_tanque) { selecionado = false; }
with (obj_blindado_antiaereo) { selecionado = false; }
with (obj_lancha_patrulha) { selecionado = false; }
with (obj_caca_f5) { selecionado = false; }
with (obj_helicoptero_militar) { selecionado = false; }

// Limpar unidade selecionada global
global.unidade_selecionada = noone;

show_debug_message("🔄 Unidades desselecionadas por clique em edifício");

// === PASSO 2: DETECÇÃO DE CLIQUE ===
// Usar função global para coordenadas consistentes
var _coords = global.scr_mouse_to_world();
var _world_mouse_x = _coords[0];
var _world_mouse_y = _coords[1];

// Debug: Mostrar informações do clique
show_debug_message("=== DEBUG EDIFÍCIO CLIQUE ===");
show_debug_message("Mouse Mundo: (" + string(_world_mouse_x) + ", " + string(_world_mouse_y) + ")");
show_debug_message("Edifício Pos: (" + string(x) + ", " + string(y) + ")");
show_debug_message("Clique detectado: " + string(mouse_check_button_pressed(mb_left)));
show_debug_message("Position meeting: " + string(position_meeting(_world_mouse_x, _world_mouse_y, id)));

// === PASSO 3: VERIFICAÇÃO DE CLIQUE ===
// Usar múltiplos métodos para detecção mais robusta
var _clique_detectado = false;

// Método 1: position_meeting com coordenadas corrigidas
if (position_meeting(_world_mouse_x, _world_mouse_y, id)) {
    _clique_detectado = true;
    show_debug_message("✅ Clique detectado via position_meeting");
}

// Método 2: collision_point como fallback
if (!_clique_detectado) {
    var _colisao = collision_point(_world_mouse_x, _world_mouse_y, object_index, false, true);
    if (_colisao == id) {
        _clique_detectado = true;
        show_debug_message("✅ Clique detectado via collision_point");
    }
}

// Método 3: Verificação manual com dimensões do sprite
if (!_clique_detectado) {
    var _sprite_w = sprite_get_width(sprite_index);
    var _sprite_h = sprite_get_height(sprite_index);
    var _origin_x = sprite_get_xoffset(sprite_index);
    var _origin_y = sprite_get_yoffset(sprite_index);
    
    var _left = x - _origin_x;
    var _right = x + (_sprite_w - _origin_x);
    var _top = y - _origin_y;
    var _bottom = y + (_sprite_h - _origin_y);
    
    show_debug_message("Área de clique: (" + string(_left) + ", " + string(_top) + ") a (" + string(_right) + ", " + string(_bottom) + ")");
    
    if (_world_mouse_x >= _left && _world_mouse_x <= _right && 
        _world_mouse_y >= _top && _world_mouse_y <= _bottom) {
        _clique_detectado = true;
        show_debug_message("✅ Clique detectado via verificação manual");
    }
}

// === PASSO 4: LÓGICA ESPECÍFICA DO EDIFÍCIO ===
if (mouse_check_button_pressed(mb_left) && _clique_detectado) {
    show_debug_message("✅ CLIQUE NO QUARTEL DE MARINHA DETECTADO!");
    
    // === FECHAR MENUS EXISTENTES ===
    // Fechar menu deste quartel se existir
    if (menu_recrutamento != noone) {
        show_debug_message("Fechando menu existente: " + string(menu_recrutamento));
        instance_destroy(menu_recrutamento);
        menu_recrutamento = noone;
    }
    
    // Fechar todos os menus globais
    if (global.menu_recrutamento_aberto) {
        show_debug_message("Fechando todos os menus globais...");
        with (obj_menu_recrutamento_marinha) {
            instance_destroy();
        }
        with (obj_menu_recrutamento) {
            instance_destroy();
        }
        global.menu_recrutamento_aberto = false;
    }
    
    // Desmarcar outros quartéis
    with (obj_quartel) { 
        selecionado = false;
        if (variable_instance_exists(id, "menu_recrutamento") && menu_recrutamento != noone) {
            instance_destroy(menu_recrutamento);
            menu_recrutamento = noone;
        }
    }
    
    with (obj_quartel_marinha) { 
        selecionado = false;
        if (menu_recrutamento != noone) {
            instance_destroy(menu_recrutamento);
            menu_recrutamento = noone;
        }
    }
    
    // Marcar este quartel de marinha
    selecionado = true;
    show_debug_message("✅ Quartel selecionado!");
    
    // === CRIAR MENU DE RECRUTAMENTO NAVAL ===
    show_debug_message("Criando menu de recrutamento...");
    
    if (object_exists(obj_menu_recrutamento_marinha)) {
        show_debug_message("✅ Objeto obj_menu_recrutamento_marinha existe!");
        
        // Tentar diferentes métodos de criação
        menu_recrutamento = noone;
        
        // Método 1: Tentar com layer "Instances"
        if (layer_exists("Instances")) {
            menu_recrutamento = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
            show_debug_message("✅ Método 1: Criado na layer 'Instances'");
        }
        
        // Método 2: Tentar com layer "rm_mapa_principal"
        if (!instance_exists(menu_recrutamento) && layer_exists("rm_mapa_principal")) {
            menu_recrutamento = instance_create_layer(0, 0, "rm_mapa_principal", obj_menu_recrutamento_marinha);
            show_debug_message("✅ Método 2: Criado na layer 'rm_mapa_principal'");
        }
        
        // Método 3: Fallback - tentar criar sem layer específica
        if (!instance_exists(menu_recrutamento)) {
            show_debug_message("⚠️ Tentando método de fallback...");
            var _temp_x = x;
            var _temp_y = y;
            menu_recrutamento = instance_create_layer(_temp_x, _temp_y, "Instances", obj_menu_recrutamento_marinha);
            show_debug_message("✅ Método 3: Fallback executado");
        }
        
        if (instance_exists(menu_recrutamento)) {
            menu_recrutamento.meu_quartel_id = id;
            global.menu_recrutamento_aberto = true;
            
            show_debug_message("=== MENU DE RECRUTAMENTO NAVAL ABERTO ===");
            show_debug_message("Quartel de Marinha ID: " + string(id));
            show_debug_message("Menu ID: " + string(menu_recrutamento));
            show_debug_message("Posição: (" + string(menu_recrutamento.x) + ", " + string(menu_recrutamento.y) + ")");
            show_debug_message("✅ Menu criado com sucesso!");
        } else {
            show_debug_message("❌ Falha ao criar instância do menu");
        }
    } else {
        show_debug_message("❌ ERRO: obj_menu_recrutamento_marinha não existe!");
    }
}
