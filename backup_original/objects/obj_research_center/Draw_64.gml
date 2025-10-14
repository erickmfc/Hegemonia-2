/// Research Center - Modern UI Design
/// Centro de Pesquisa com Interface Moderna e Organizada

if (!global.menu_pesquisa_aberto) return;

// === CONFIGURAÇÃO DE FONTE ===
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// === BACKGROUND OVERLAY COM EFEITO DE BLUR ===
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(8, 12, 18));
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// === MAIN CONTAINER - DESIGN MODERNO ===
var container_w = display_get_gui_width() * 0.75;
var container_h = display_get_gui_height() * 0.7;
var container_x = (display_get_gui_width() - container_w) / 2;
var container_y = (display_get_gui_height() - container_h) / 2;

// Container principal com gradiente e borda
draw_set_color(make_color_rgb(25, 35, 50));
draw_set_alpha(0.98);
draw_roundrect_ext(container_x, container_y, container_x + container_w, container_y + container_h, 16, 16, false);

// Borda com gradiente
draw_set_color(make_color_rgb(60, 120, 200));
draw_set_alpha(0.8);
draw_roundrect_ext(container_x, container_y, container_x + container_w, container_y + container_h, 16, 16, true);

// Efeito de brilho no topo
draw_set_color(make_color_rgb(100, 160, 255));
draw_set_alpha(0.3);
draw_roundrect_ext(container_x + 2, container_y + 2, container_x + container_w - 2, container_y + 25, 14, 14, false);
draw_set_alpha(1);

// === HEADER MODERNO ===
var header_h = 60;
var header_y = container_y + 10;

// Background do header
draw_set_color(make_color_rgb(35, 45, 65));
draw_set_alpha(0.95);
draw_roundrect_ext(container_x + 10, header_y, container_x + container_w - 10, header_y + header_h, 12, 12, false);

// Título principal
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(240, 245, 255));
draw_text_transformed(container_x + container_w/2, header_y + 20, "CENTRO DE PESQUISA TECNOLÓGICA", 1.2, 1.2, 0);

// Subtítulo
draw_set_color(make_color_rgb(180, 200, 220));
draw_text_transformed(container_x + container_w/2, header_y + 40 + (header_h * 0.07), "Desenvolva novas tecnologias para expandir seu império", 0.85, 0.85, 0);

// === INFO PANEL - LADO DIREITO ===
var info_panel_w = 200;
var info_panel_x = container_x + container_w - info_panel_w - 20;
var info_panel_y = header_y + header_h + 20;
var info_panel_h = 120;

// Background do painel de informações
draw_set_color(make_color_rgb(30, 40, 55));
draw_set_alpha(0.9);
draw_roundrect_ext(info_panel_x, info_panel_y, info_panel_x + info_panel_w, info_panel_y + info_panel_h, 10, 10, false);

// Borda do painel
draw_set_color(make_color_rgb(80, 140, 220));
draw_set_alpha(0.6);
draw_roundrect_ext(info_panel_x, info_panel_y, info_panel_x + info_panel_w, info_panel_y + info_panel_h, 10, 10, true);

// Informações do painel
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(info_panel_x + 15, info_panel_y + 15, "RECURSOS", 0.9, 0.9, 0);

draw_set_color(c_white);
draw_text_transformed(info_panel_x + 15, info_panel_y + 40, "Dinheiro: $" + string(global.dinheiro), 0.8, 0.8, 0);

// Barra de progresso dos slots
var slot_progress = global.slots_pesquisa_usados / global.slots_pesquisa_total;
var slot_bar_x = info_panel_x + 15;
var slot_bar_y = info_panel_y + 65;
var slot_bar_w = info_panel_w - 30;
var slot_bar_h = 8;

draw_set_color(make_color_rgb(40, 50, 70));
draw_roundrect_ext(slot_bar_x, slot_bar_y, slot_bar_x + slot_bar_w, slot_bar_y + slot_bar_h, 4, 4, false);

var slot_color = (global.slots_pesquisa_usados < global.slots_pesquisa_total) ? 
    make_color_rgb(100, 200, 100) : make_color_rgb(200, 100, 100);
draw_set_color(slot_color);
draw_roundrect_ext(slot_bar_x, slot_bar_y, slot_bar_x + (slot_bar_w * slot_progress), slot_bar_y + slot_bar_h, 4, 4, false);

draw_set_color(c_white);
draw_text_transformed(info_panel_x + 15, slot_bar_y + 15, "Slots: " + string(global.slots_pesquisa_usados) + "/" + string(global.slots_pesquisa_total), 0.75, 0.75, 0);

// === RESEARCH GRID - LAYOUT MODERNO ===
var grid_start_x = container_x + 30;
var grid_start_y = header_y + header_h + 30;
var grid_w = container_w - info_panel_w - 60;
var grid_h = container_h - header_h - 140;

var grid_cols = 4;
var grid_rows = 3;
var card_w = (grid_w - (grid_cols - 1) * 25) / grid_cols;
var card_h = (grid_h - (grid_rows - 1) * 20) / grid_rows;

// === DESENHO DOS CARDS DE PESQUISA ===
for (var i = 0; i < array_length(research_names); i++) {
    var col = i mod grid_cols;
    var row = i div grid_cols;
    
    var card_x = grid_start_x + col * (card_w + 25);
    var card_y = grid_start_y + row * (card_h + 20);
    
    var research_name = research_names[i];
    var research_sprite = research_sprites[i];
    var status = global.nacao_recursos[? research_name];
    
    // === CARD BACKGROUND - DESIGN MODERNO ===
    var card_bg_color = make_color_rgb(40, 55, 75);
    var card_border_color = make_color_rgb(70, 90, 120);
    
    // Determinar cor baseada no status
    switch(status) {
        case RESOURCE_STATUS.AVAILABLE:
            if (global.slots_pesquisa_usados < global.slots_pesquisa_total) {
                card_bg_color = make_color_rgb(45, 65, 85);
                card_border_color = make_color_rgb(80, 160, 255);
            } else {
                card_bg_color = make_color_rgb(50, 50, 60);
                card_border_color = make_color_rgb(100, 100, 120);
            }
            break;
        case RESOURCE_STATUS.RESEARCHING:
            card_bg_color = make_color_rgb(60, 45, 30);
            card_border_color = make_color_rgb(255, 180, 80);
            break;
        case RESOURCE_STATUS.RESEARCHED:
            card_bg_color = make_color_rgb(35, 65, 45);
            card_border_color = make_color_rgb(120, 255, 150);
            break;
    }
    
    // Background do card
    draw_set_color(card_bg_color);
    draw_set_alpha(0.95);
    draw_roundrect_ext(card_x, card_y, card_x + card_w, card_y + card_h, 12, 12, false);
    
    // Borda do card
    draw_set_color(card_border_color);
    draw_set_alpha(0.8);
    draw_roundrect_ext(card_x, card_y, card_x + card_w, card_y + card_h, 12, 12, true);
    
    // Efeito de brilho no topo do card
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_alpha(0.1);
    draw_roundrect_ext(card_x + 2, card_y + 2, card_x + card_w - 2, card_y + 15, 10, 10, false);
    draw_set_alpha(1);
    
    // === ÍCONE DA PESQUISA ===
    if (sprite_exists(research_sprite)) {
        var icon_x = card_x + card_w/2 + (card_w * 0.10); // Mover 10% para direita
        var icon_y = card_y + 25 + (card_h * 0.40); // Mover 40% para baixo
        var icon_scale = 1.5;
        
        // Background do ícone
        draw_set_color(make_color_rgb(20, 30, 45));
        draw_set_alpha(0.7);
        draw_circle(icon_x, icon_y, 20, false);
        
        // Ícone
        draw_set_alpha(1);
        draw_sprite_ext(research_sprite, 0, icon_x, icon_y, icon_scale, icon_scale, 0, c_white, 1);
    }
    
    // === NOME DA PESQUISA ===
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    
    var display_name = research_name;
    switch(research_name) {
        case "Borracha": display_name = "BORRACHA"; break;
        case "Petroleo": display_name = "PETRÓLEO"; break;
        case "Silicio": display_name = "SILÍCIO"; break;
        case "Mina": display_name = "MINERAÇÃO"; break;
        case "Aluminio": display_name = "ALUMÍNIO"; break;
        case "Centro": display_name = "CENTRO IND."; break;
        case "Ouro": display_name = "OURO"; break;
        case "Serraria": display_name = "SERRARIA"; break;
        case "Cobre": display_name = "COBRE"; break;
        case "Uranio": display_name = "URÂNIO"; break;
        case "Litio": display_name = "LÍTIO"; break;
        case "Titanio": display_name = "TITÂNIO"; break;
        default: display_name = string_upper(research_name); break;
    }
    
    draw_text_transformed(card_x + card_w/2, card_y + 50, display_name, 0.8, 0.8, 0);
    
    // === CUSTO E TEMPO ===
    var cost_text = "";
    var time_text = "";
    
    switch(research_name) {
        case "Borracha": cost_text = "$2.400"; time_text = "40s"; break;
        case "Petroleo": cost_text = "$3.000"; time_text = "45s"; break;
        case "Silicio": cost_text = "$3.200"; time_text = "60s"; break;
        case "Mina": cost_text = "$2.000"; time_text = "30s"; break;
        case "Aluminio": cost_text = "$3.600"; time_text = "50s"; break;
        case "Centro": cost_text = "$4.000"; time_text = "70s"; break;
        case "Ouro": cost_text = "$6.000"; time_text = "80s"; break;
        case "Serraria": cost_text = "$1.600"; time_text = "25s"; break;
        case "Cobre": cost_text = "$2.800"; time_text = "35s"; break;
        case "Uranio": cost_text = "$10.000"; time_text = "120s"; break;
        case "Litio": cost_text = "$4.800"; time_text = "90s"; break;
        case "Titanio": cost_text = "$7.200"; time_text = "100s"; break;
        default: cost_text = "$2.000"; time_text = "30s"; break;
    }
    
    // Custo
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text_transformed(card_x + card_w/2, card_y + 70 + (card_h * 0.20), cost_text, 0.75, 0.75, 0);
    
    // Tempo
    draw_set_color(make_color_rgb(180, 200, 220));
    draw_text_transformed(card_x + card_w/2, card_y + 85 + (card_h * 0.20), time_text, 0.7, 0.7, 0);
    
    // === STATUS INDICATOR ===
    var status_y = card_y + card_h - 25;
    var status_text = "";
    var status_color = c_white;
    
    switch(status) {
        case RESOURCE_STATUS.AVAILABLE:
            if (global.slots_pesquisa_usados < global.slots_pesquisa_total) {
                status_text = "DISPONÍVEL";
                status_color = make_color_rgb(100, 200, 255);
            } else {
                status_text = "SEM SLOT";
                status_color = make_color_rgb(150, 150, 150);
            }
            break;
        case RESOURCE_STATUS.RESEARCHING:
            status_text = "EM ANDAMENTO";
            status_color = make_color_rgb(255, 180, 80);
            break;
        case RESOURCE_STATUS.RESEARCHED:
            status_text = "COMPLETO";
            status_color = make_color_rgb(120, 255, 150);
            break;
        default:
            status_text = "BLOQUEADO";
            status_color = make_color_rgb(255, 100, 100);
            break;
    }
    
    // Background do status
    draw_set_color(make_color_rgb(20, 25, 35));
    draw_set_alpha(0.8);
    draw_roundrect_ext(card_x + 5, status_y - 5, card_x + card_w - 5, status_y + 15, 6, 6, false);
    
    // Texto do status
    draw_set_color(status_color);
    draw_set_alpha(1);
    draw_text_transformed(card_x + card_w/2, status_y + 5, status_text, 0.65, 0.65, 0);
}

// === FOOTER MODERNO ===
var footer_y = container_y + container_h - 80;
var footer_h = 60;

// Background do footer
draw_set_color(make_color_rgb(30, 40, 55));
draw_set_alpha(0.9);
draw_roundrect_ext(container_x + 10, footer_y, container_x + container_w - 10, footer_y + footer_h, 12, 12, false);

// === BOTÃO DE SLOT EXTRA ===
if (global.slots_pesquisa_total == 3) {
    var slot_btn_x = container_x + 30 + (container_w * 0.10); // Mover 10% para direita
    var slot_btn_y = footer_y + 15;
    var slot_btn_w = 200 + (200 * 0.20); // Aumentar largura em 20%
    var slot_btn_h = 35;
    var can_afford = global.dinheiro >= global.custo_slot_extra;
    
    // Background do botão
    var btn_bg_color = can_afford ? make_color_rgb(60, 100, 60) : make_color_rgb(80, 60, 60);
    draw_set_color(btn_bg_color);
    draw_set_alpha(0.9);
    draw_roundrect_ext(slot_btn_x, slot_btn_y, slot_btn_x + slot_btn_w, slot_btn_y + slot_btn_h, 8, 8, false);
    
    // Borda do botão
    var btn_border_color = can_afford ? make_color_rgb(120, 200, 120) : make_color_rgb(200, 120, 120);
    draw_set_color(btn_border_color);
    draw_set_alpha(0.7);
    draw_roundrect_ext(slot_btn_x, slot_btn_y, slot_btn_x + slot_btn_w, slot_btn_y + slot_btn_h, 8, 8, true);
    
    // Texto do botão
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var btn_text_color = can_afford ? make_color_rgb(255, 255, 200) : make_color_rgb(200, 200, 200);
    draw_set_color(btn_text_color);
    draw_set_alpha(1);
    draw_text_transformed(slot_btn_x + slot_btn_w/2, slot_btn_y + slot_btn_h/2, "SLOT EXTRA ($" + string(global.custo_slot_extra) + ")", 0.85, 0.85, 0);
}

// === BOTÃO FECHAR ===
var close_btn_x = container_x + container_w - 120;
var close_btn_y = footer_y + 15;
var close_btn_w = 80;
var close_btn_h = 35;

// Background do botão fechar (vermelho aumentado em 10%)
draw_set_color(make_color_rgb(132, 66, 66)); // 120 + 10% = 132, 60 + 10% = 66
draw_set_alpha(0.9);
draw_roundrect_ext(close_btn_x, close_btn_y, close_btn_x + close_btn_w, close_btn_y + close_btn_h, 8, 8, false);

// Borda do botão fechar (vermelho aumentado em 10%)
draw_set_color(make_color_rgb(220, 110, 110)); // 200 + 10% = 220, 100 + 10% = 110
draw_set_alpha(0.7);
draw_roundrect_ext(close_btn_x, close_btn_y, close_btn_x + close_btn_w, close_btn_y + close_btn_h, 8, 8, true);

// Texto do botão fechar
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_alpha(1);
draw_text_transformed(close_btn_x + close_btn_w/2, close_btn_y + close_btn_h/2, "FECHAR", 0.85, 0.85, 0);

// === INSTRUÇÕES ===
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(200, 220, 255));
draw_text_transformed(container_x + container_w/2, footer_y + 45, "Clique nos recursos para iniciar a pesquisa • Máximo " + string(global.slots_pesquisa_total) + " pesquisas simultâneas", 0.75, 0.75, 0);

// === RESET DAS CONFIGURAÇÕES ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_font(-1);