/// @description Teste de visibilidade do menu de recrutamento naval
/// @param {instance} quartel_id ID do quartel de marinha

function scr_teste_menu_visibilidade(quartel_id) {
    
    show_debug_message("=== TESTE DE VISIBILIDADE DO MENU ===");
    
    // Verificar se o quartel existe
    if (!instance_exists(quartel_id)) {
        show_debug_message("❌ ERRO: Quartel não existe!");
        return false;
    }
    
    // Verificar se o menu foi criado
    if (quartel_id.menu_recrutamento == noone) {
        show_debug_message("❌ ERRO: Menu não foi criado!");
        return false;
    }
    
    var _menu = quartel_id.menu_recrutamento;
    
    // Verificar se o menu existe
    if (!instance_exists(_menu)) {
        show_debug_message("❌ ERRO: Instância do menu não existe!");
        return false;
    }
    
    // Verificar propriedades do menu
    show_debug_message("✅ Menu criado com sucesso!");
    show_debug_message("Menu ID: " + string(_menu));
    show_debug_message("Menu X: " + string(_menu.x));
    show_debug_message("Menu Y: " + string(_menu.y));
    show_debug_message("Quartel ID vinculado: " + string(_menu.meu_quartel_id));
    
    // Verificar se o menu tem evento Draw
    if (event_exists(_menu, ev_draw)) {
        show_debug_message("✅ Menu tem evento Draw!");
    } else {
        show_debug_message("❌ ERRO: Menu não tem evento Draw!");
    }
    
    // Verificar se o menu tem evento Mouse
    if (event_exists(_menu, ev_mouse)) {
        show_debug_message("✅ Menu tem evento Mouse!");
    } else {
        show_debug_message("❌ ERRO: Menu não tem evento Mouse!");
    }
    
    show_debug_message("=== TESTE CONCLUÍDO ===");
    return true;
}
