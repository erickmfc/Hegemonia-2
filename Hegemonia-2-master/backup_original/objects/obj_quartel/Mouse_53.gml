// ===============================================
// HEGEMONIA GLOBAL - QUARTEL: MENU DE RECRUTAMENTO
// Bloco 4, Fase 3: Interface de Recrutamento (ATUALIZADA)
// ===============================================

// Evento Left Pressed de obj_quartel
// Verificar se o clique foi realmente no sprite do quartel
if (mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
    if (!global.menu_recrutamento_aberto && !global.modo_construcao && global.construindo_agora == noone) {
        // Verificar se o quartel está completamente construído antes de abrir o menu
        // Como o quartel já foi criado como instância, ele está completo
        var menu = instance_create_layer(x, y + 64, "Instances", obj_menu_recrutamento);
        menu.id_do_quartel = id; // Informa ao menu qual quartel o criou
        global.menu_recrutamento_aberto = true;
        
        show_debug_message("=== MENU DE RECRUTAMENTO CRIADO ===");
        show_debug_message("Menu ID: " + string(menu));
        show_debug_message("Quartel ID: " + string(id));
        show_debug_message("Posição do menu: (" + string(menu.x) + ", " + string(menu.y) + ")");
    } else {
        if (global.menu_recrutamento_aberto) {
            show_debug_message("Menu de recrutamento já está aberto.");
        } else if (global.modo_construcao) {
            show_debug_message("Não é possível abrir menu durante construção.");
        } else if (global.construindo_agora != noone) {
            show_debug_message("Não é possível abrir menu enquanto outra construção está em andamento.");
        }
    }
}