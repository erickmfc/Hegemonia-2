/// @description Calcular layout da UI do Centro de Pesquisa
// Este evento roda uma vez por frame, antes do Draw e do Step.
// Centralizar os cálculos aqui evita duplicação de código e bugs.

if (!global.menu_pesquisa_aberto) {
    // Limpa o layout se o menu estiver fechado para não guardar dados antigos
    ui_layout = {};
    exit;
}

// Container principal
ui_layout.container_w = display_get_gui_width() * 0.6;
ui_layout.container_h = display_get_gui_height() * 0.6;
ui_layout.container_x = (display_get_gui_width() - ui_layout.container_w) / 2;
ui_layout.container_y = (display_get_gui_height() - ui_layout.container_h) / 2;

// Header
ui_layout.header_h = 60;
ui_layout.header_y = ui_layout.container_y + 10;

// Footer
ui_layout.footer_y = ui_layout.container_y + ui_layout.container_h - 80;

// Botão de fechar
ui_layout.close_btn_w = 80;
ui_layout.close_btn_h = 35;
ui_layout.close_btn_x = ui_layout.container_x + ui_layout.container_w - 120;
ui_layout.close_btn_y = ui_layout.footer_y + 15;

// Botão de slot extra
ui_layout.slot_btn_w = 200 + (200 * 0.20);
ui_layout.slot_btn_h = 35;
ui_layout.slot_btn_x = ui_layout.container_x + 30 + (ui_layout.container_w * 0.10);
ui_layout.slot_btn_y = ui_layout.container_y + ui_layout.container_h - 80;

// Grid de pesquisa
var info_panel_w = 200;
ui_layout.grid_start_x = ui_layout.container_x + 30;
ui_layout.grid_start_y = ui_layout.header_y + ui_layout.header_h + 30;
var grid_w = ui_layout.container_w - info_panel_w - 60;
var grid_h = ui_layout.container_h - ui_layout.header_h - 140;

var grid_cols = 4;
var grid_rows = 3;
ui_layout.card_w = (grid_w - (grid_cols - 1) * 25) / grid_cols * 0.9;
ui_layout.card_h = (grid_h - (grid_rows - 1) * 20) / grid_rows * 0.9;
ui_layout.grid_cols = grid_cols;