// ===============================================
// HEGEMONIA GLOBAL - SELEÇÃO DE QUARTÉIS
// Script para Seleção Unificada de Quartéis
// ===============================================

/// @description Selecionar quartel e abrir menu
/// @param {real} quartel_id ID do quartel
/// @param {real} menu_obj Objeto do menu de recrutamento
function scr_selecionar_quartel(quartel_id, menu_obj) {
    // Verificar se o quartel existe
    if (!instance_exists(quartel_id)) {
        return false;
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
        if (variable_instance_exists(id, "menu_recrutamento") && menu_recrutamento != noone) {
            instance_destroy(menu_recrutamento);
            menu_recrutamento = noone;
        }
    }
    
    // Marcar este quartel
    quartel_id.selecionado = true;
    
    // Criar menu de recrutamento
    if (quartel_id.menu_recrutamento == noone) {
        quartel_id.menu_recrutamento = instance_create_layer(0, 0, "Instances", menu_obj);
        quartel_id.menu_recrutamento.meu_quartel_id = quartel_id;
        
        show_debug_message("=== MENU DE RECRUTAMENTO ABERTO ===");
        show_debug_message("Quartel ID: " + string(quartel_id));
        show_debug_message("Menu ID: " + string(quartel_id.menu_recrutamento));
    }
    
    return true;
}
