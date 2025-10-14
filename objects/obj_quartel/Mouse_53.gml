// ===============================================
// HEGEMONIA GLOBAL - QUARTEL: MENU DE RECRUTAMENTO
// Sistema Original com Menu
// ===============================================

// Evento Left Pressed de obj_quartel
// CORREÇÃO: Usar a função global scr_mouse_to_world para coordenadas consistentes
var _coords = global.scr_mouse_to_world();
var _world_mouse_x = _coords[0];
var _world_mouse_y = _coords[1];

// Debug: Mostrar informações do clique
show_debug_message("=== DEBUG QUARTEL CLIQUE ===");
show_debug_message("Mouse Mundo: (" + string(_world_mouse_x) + ", " + string(_world_mouse_y) + ")");
show_debug_message("Quartel Pos: (" + string(x) + ", " + string(y) + ")");
show_debug_message("Clique detectado: " + string(mouse_check_button_pressed(mb_left)));
show_debug_message("Position meeting: " + string(position_meeting(_world_mouse_x, _world_mouse_y, id)));

// Verificar se o clique foi realmente no sprite do quartel
// Usar collision_point como método alternativo mais confiável
var _clique_detectado = false;

// Método 1: position_meeting com coordenadas corrigidas
if (position_meeting(_world_mouse_x, _world_mouse_y, id)) {
    _clique_detectado = true;
    show_debug_message("✅ Clique detectado via position_meeting");
}

// Método 2: collision_point como fallback
if (!_clique_detectado) {
    var _colisao = collision_point(_world_mouse_x, _world_mouse_y, obj_quartel, false, true);
    if (_colisao == id) {
        _clique_detectado = true;
        show_debug_message("✅ Clique detectado via collision_point");
    }
}

if (mouse_check_button_pressed(mb_left) && _clique_detectado) {
    show_debug_message("✅ CLIQUE NO QUARTEL DETECTADO!");
    
    // === CORREÇÃO: FECHAR MENUS EXISTENTES PRIMEIRO ===
    // Garantir que não há menus órfãos antes de criar um novo
    if (global.menu_recrutamento_aberto) {
        show_debug_message("🔄 Fechando menus existentes antes de abrir novo...");
        scr_limpar_menus_recrutamento();
    }
    
    // === VERIFICAÇÃO DE CONDIÇÕES ===
    if (!global.modo_construcao && global.construindo_agora == noone) {
        // Verificar se o quartel está completamente construído antes de abrir o menu
        // Como o quartel já foi criado como instância, ele está completo
        var menu = instance_create_layer(x, y + 64, "Instances", obj_menu_recrutamento);
        menu.id_do_quartel = id; // Informa ao menu qual quartel o criou
        global.menu_recrutamento_aberto = true;
        
        show_debug_message("=== MENU DE RECRUTAMENTO CRIADO ===");
        show_debug_message("Menu ID: " + string(menu));
        show_debug_message("Quartel ID: " + string(id));
        show_debug_message("Posição do menu: (" + string(menu.x) + ", " + string(menu.y) + ")");
        show_debug_message("Estado global: " + string(global.menu_recrutamento_aberto));
    } else {
        show_debug_message("❌ NÃO FOI POSSÍVEL ABRIR MENU:");
        if (global.modo_construcao) {
            show_debug_message("- Modo construção ativo: " + string(global.modo_construcao));
        } else if (global.construindo_agora != noone) {
            show_debug_message("- Construindo agora: " + string(global.construindo_agora));
        } else {
            show_debug_message("- Razão desconhecida!");
        }
    }
} else {
    show_debug_message("❌ Clique não detectado no quartel");
}
