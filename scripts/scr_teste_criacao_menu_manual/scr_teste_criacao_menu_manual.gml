/// @description Teste manual de criação do menu de recrutamento naval
/// @param {instance} quartel_id ID do quartel de marinha

function scr_teste_criacao_menu_manual(quartel_id) {
    
    show_debug_message("=== TESTE MANUAL DE CRIAÇÃO DO MENU ===");
    
    // Verificar se o quartel existe
    if (!instance_exists(quartel_id)) {
        show_debug_message("❌ ERRO: Quartel não existe!");
        return false;
    }
    
    // Verificar se o objeto menu existe
    if (!object_exists(obj_menu_recrutamento_marinha)) {
        show_debug_message("❌ ERRO: Objeto obj_menu_recrutamento_marinha não existe!");
        return false;
    }
    
    show_debug_message("✅ Objeto menu existe!");
    
    // Tentar criar menu diretamente
    var _menu = instance_create(100, 100, obj_menu_recrutamento_marinha);
    
    if (_menu == noone) {
        show_debug_message("❌ ERRO: Falha ao criar menu com instance_create!");
        return false;
    }
    
    show_debug_message("✅ Menu criado com instance_create!");
    show_debug_message("Menu ID: " + string(_menu));
    show_debug_message("Menu X: " + string(_menu.x));
    show_debug_message("Menu Y: " + string(_menu.y));
    
    // Vincular ao quartel
    _menu.meu_quartel_id = quartel_id;
    
    // Verificar se o menu tem os eventos necessários
    if (event_exists(_menu, ev_create)) {
        show_debug_message("✅ Menu tem evento Create!");
    } else {
        show_debug_message("❌ ERRO: Menu não tem evento Create!");
    }
    
    if (event_exists(_menu, ev_draw)) {
        show_debug_message("✅ Menu tem evento Draw!");
    } else {
        show_debug_message("❌ ERRO: Menu não tem evento Draw!");
    }
    
    show_debug_message("=== TESTE CONCLUÍDO ===");
    return true;
}
