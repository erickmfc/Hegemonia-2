// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO MELHORADO
// Inicialização com posicionamento centralizado
// =========================================================

// Evento Create de obj_menu_construcao
visible = false;
menu_ativo = false;

// === POSICIONAMENTO CENTRALIZADO ===
// Menu agora aparece no centro da tela
var _menu_width = 400;
var _menu_height = 200;

x = display_get_gui_width() / 2 - _menu_width / 2;
y = display_get_gui_height() / 2 - _menu_height / 2;

// === VERIFICAÇÃO DE FONTE ===
if (font_exists(fnt_ui_main)) {
    show_debug_message("✅ Fonte fnt_ui_main encontrada e configurada");
} else {
    show_debug_message("❌ ERRO: Fonte fnt_ui_main não encontrada!");
}

show_debug_message("Menu de construção centralizado inicializado. Posição: " + string(x) + ", " + string(y));
