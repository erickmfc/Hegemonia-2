// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE VISIBILIDADE DO MENU
// Step Event - obj_menu_construcao
// =========================================================

// Controla a visibilidade baseado no modo de construção global
if (global.modo_construcao) {
    if (!visible) {
        visible = true;
        menu_ativo = true;
    }
} else {
    if (visible) {
        visible = false;
        menu_ativo = false;
    }
}
