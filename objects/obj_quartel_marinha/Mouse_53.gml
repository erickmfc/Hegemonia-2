// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Seleção Corrigido para Zoom
// ===============================================

// Evento Left Pressed - Seleção do quartel de marinha
show_debug_message("=== MOUSE_53 EXECUTADO ===");
show_debug_message("Mouse X: " + string(mouse_x) + " | Mouse Y: " + string(mouse_y));
show_debug_message("Quartel X: " + string(x) + " | Quartel Y: " + string(y));

// ✅ CORREÇÃO: Usar função global para coordenadas consistentes
var _coords = global.scr_mouse_to_world();
var _mouse_world_x = _coords[0];
var _mouse_world_y = _coords[1];
show_debug_message("Mouse Mundo: (" + string(_mouse_world_x) + ", " + string(_mouse_world_y) + ")");

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
        show_debug_message("✅ CLIQUE DETECTADO NO QUARTEL (área do sprite)!");
    } else {
        show_debug_message("❌ Clique fora da área do quartel");
        show_debug_message("   Área quartel: (" + string(_left) + "," + string(_top) + ") a (" + string(_right) + "," + string(_bottom) + ")");
    }
}

if (_click_detected) {
    show_debug_message("✅ CLIQUE DETECTADO NO QUARTEL!");
    
    // === CORREÇÃO: FECHAR MENUS EXISTENTES ===
    // Garantir que não há menus órfãos antes de criar um novo
    if (global.menu_recrutamento_aberto) {
        show_debug_message("🔄 Fechando menus existentes antes de abrir novo...");
        scr_limpar_menus_recrutamento();
    }
    
    // Fechar menu deste quartel se existir
    if (menu_recrutamento != noone) {
        show_debug_message("Fechando menu existente: " + string(menu_recrutamento));
        instance_destroy(menu_recrutamento);
        menu_recrutamento = noone;
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
    
    // === CORREÇÃO: CRIAR MENU NA LAYER CORRETA ===
    show_debug_message("Criando menu de recrutamento...");
    
    // Verificar se layer GUI existe, se não, criar
    if (!layer_exists("GUI")) {
        show_debug_message("Criando layer GUI...");
        layer_create(-100, "GUI");
    }
    
    if (object_exists(obj_menu_recrutamento_marinha)) {
        // Criar menu na layer GUI com prioridade alta
        menu_recrutamento = instance_create_layer(0, 0, "GUI", obj_menu_recrutamento_marinha);
        
        if (instance_exists(menu_recrutamento)) {
            menu_recrutamento.meu_quartel_id = id;
            global.menu_recrutamento_aberto = true;
            
            show_debug_message("=== MENU DE RECRUTAMENTO NAVAL ABERTO ===");
            show_debug_message("Quartel de Marinha ID: " + string(id));
            show_debug_message("Menu ID: " + string(menu_recrutamento));
            show_debug_message("Layer: GUI");
            show_debug_message("Posição: (" + string(menu_recrutamento.x) + ", " + string(menu_recrutamento.y) + ")");
        } else {
            show_debug_message("❌ Falha ao criar menu na layer GUI");
        }
    } else {
        show_debug_message("ERRO: obj_menu_recrutamento_marinha não existe!");
    }
} else {
    show_debug_message("❌ Clique não detectado ou fora do quartel");
}