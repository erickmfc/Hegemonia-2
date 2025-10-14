// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO
// Bloco 3, Fase 2: Inicialização
// =========================================================

// Evento Create de obj_menu_construcao
visible = false;
menu_ativo = false;

// Posicionamento fixo na parte inferior da tela
// Usando valores fixos para evitar erros de sprite não encontrado
var _menu_width = 320;
var _menu_height = 80;

x = display_get_gui_width() / 2 - _menu_width / 2;
y = display_get_gui_height() - _menu_height - 20;

// Verificar se o sprite existe
if (sprite_exists(spr_menu_construcao)) {
    show_debug_message("Sprite do menu de construção encontrado: " + sprite_get_name(spr_menu_construcao));
} else {
    show_debug_message("AVISO: Sprite spr_menu_construcao não encontrado!");
}

show_debug_message("Menu de construção inicializado. Posição: " + string(x) + ", " + string(y));