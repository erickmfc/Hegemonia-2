// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE VISIBILIDADE DO MENU
// Step Event - obj_menu_construcao
// =========================================================

// Controla a visibilidade baseado no modo de construção global
if (global.modo_construcao) {
    if (!visible) {
        visible = true;
        menu_ativo = true;
        show_debug_message("[MENU] Menu de construção MOSTRADO");
    }
} else {
    if (visible) {
        visible = false;
        menu_ativo = false;
        show_debug_message("[MENU] Menu de construção OCULTADO");
    }
}

// Debug: Mostra status do menu a cada 3 segundos
if (current_time mod 3000 < 17) {
    show_debug_message("[MENU STATUS] Visível: " + string(visible) + " | Modo construção: " + string(global.modo_construcao));
}
