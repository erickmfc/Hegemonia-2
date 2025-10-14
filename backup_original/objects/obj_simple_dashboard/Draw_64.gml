/// Strategic Dashboard - Draw GUI Event - REDESIGNED
/// Dashboard visual completamente redesenhado para melhor legibilidade

// Set font with 23% size reduction (20% + 3% additional)
var font_scale = 0.77; // 23% reduction - Definido no escopo global
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// === MAIN CONTAINER - CLEANER DESIGN ===
draw_set_color(make_color_rgb(30, 45, 65)); // Cor mais suave e azulada
draw_set_alpha(0.75); // Mais transparente (era 0.92)
draw_roundrect_ext(dashboard_x, dashboard_y, dashboard_x + dashboard_width, dashboard_y + dashboard_height, 12, 12, false);

// Clean border
draw_set_color(make_color_rgb(100, 160, 240)); // Azul mais vibrante
draw_set_alpha(0.65); // Mais transparente (era 0.9)
draw_roundrect_ext(dashboard_x, dashboard_y, dashboard_x + dashboard_width, dashboard_y + dashboard_height, 12, 12, true);
draw_set_alpha(1);

// === HEADER ===
var header_height = 45;
draw_set_color(make_color_rgb(40, 65, 95)); // Cor mais suave
draw_set_alpha(0.8); // Mais transparente
draw_roundrect_ext(dashboard_x + 6, dashboard_y + 6, dashboard_x + dashboard_width - 6, dashboard_y + header_height, 8, 8, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
// Apply font scaling for 20% size reduction
var header_text = "CENTRO DE COMANDO NACIONAL";
var header_x = dashboard_x + dashboard_width/2;
var header_y = dashboard_y + header_height/2;
draw_text_transformed(header_x, header_y, header_text, font_scale, font_scale, 0);

// === LAYOUT VARIABLES - IMPROVED SPACING ===
var margin = 18;      // Increased from 15 for better spacing
var spacing = 15;     // Increased from 12 for better card separation
var start_y = dashboard_y + header_height + margin;
var card_w = (dashboard_width - (margin * 2) - spacing) / 2;
var card_h = 95;      // Slightly increased card height for better proportions
var left_x = dashboard_x + margin;
var right_x = dashboard_x + margin + card_w + spacing;
var card_y = start_y;

// === ECONOMIA CARD ===
draw_set_color(make_color_rgb(35, 70, 35));
draw_set_alpha(0.7); // Mais transparente (era 0.85)
draw_roundrect_ext(left_x, card_y, left_x + card_w, card_y + card_h, 6, 6, false);
draw_set_color(make_color_rgb(120, 220, 120));
draw_set_alpha(0.6); // Mais transparente (era 0.8)
draw_roundrect_ext(left_x, card_y, left_x + card_w, card_y + card_h, 6, 6, true);
draw_set_alpha(1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(150, 255, 150));
draw_text_transformed(left_x + 12, card_y + 10, "ECONOMIA", font_scale, font_scale, 0);
draw_set_color(c_white);
draw_text_transformed(left_x + 12, card_y + 35, "Dinheiro: $" + string(current_money), font_scale, font_scale, 0);
draw_text_transformed(left_x + 12, card_y + 55, "Renda/Dia: $" + string(daily_income), font_scale, font_scale, 0);

// Status indicator
var status_col = (current_money > 1000) ? make_color_rgb(100, 255, 100) : make_color_rgb(255, 200, 100);
draw_set_color(status_col);
draw_circle(left_x + card_w - 15, card_y + 15, 5, false);

card_y += card_h + spacing;

// === POPULAÇÃO CARD ===
draw_set_color(make_color_rgb(35, 50, 70));
draw_set_alpha(0.7); // Mais transparente (era 0.85)
draw_roundrect_ext(left_x, card_y, left_x + card_w, card_y + card_h, 6, 6, false);
draw_set_color(make_color_rgb(130, 160, 255));
draw_set_alpha(0.6); // Mais transparente (era 0.8)
draw_roundrect_ext(left_x, card_y, left_x + card_w, card_y + card_h, 6, 6, true);
draw_set_alpha(1);

draw_set_color(make_color_rgb(160, 180, 255));
draw_text_transformed(left_x + 12, card_y + 10, "POPULACAO", font_scale, font_scale, 0);
draw_set_color(c_white);
draw_text_transformed(left_x + 12, card_y + 35, "Civil: " + string(current_population), font_scale, font_scale, 0);
draw_text_transformed(left_x + 12, card_y + 55, "Turistas: " + string(current_tourists), font_scale, font_scale, 0);
draw_text_transformed(left_x + 12, card_y + 75, "Militar: " + string(current_military) + " | Rank: #" + string(current_ranking), font_scale, font_scale, 0);

card_y += card_h + spacing;

// === INFRAESTRUTURA CARD ===
draw_set_color(make_color_rgb(70, 50, 30));
draw_set_alpha(0.7); // Mais transparente (era 0.85)
draw_roundrect_ext(left_x, card_y, left_x + card_w, card_y + card_h, 6, 6, false);
draw_set_color(make_color_rgb(255, 180, 100));
draw_set_alpha(0.6); // Mais transparente (era 0.8)
draw_roundrect_ext(left_x, card_y, left_x + card_w, card_y + card_h, 6, 6, true);
draw_set_alpha(1);

draw_set_color(make_color_rgb(255, 200, 120));
draw_text_transformed(left_x + 12, card_y + 10, "INFRAESTRUTURA", font_scale, font_scale, 0);
draw_set_color(c_white);
draw_text_transformed(left_x + 12, card_y + 35, "Edifícios: " + string(total_buildings), font_scale, font_scale, 0);
draw_text_transformed(left_x + 12, card_y + 55, "Status: " + ((total_buildings > 0) ? "Operacional" : "Inicial"), font_scale, font_scale, 0);

// Progress bar
var bar_x = left_x + 160;  // Adjusted for better spacing
var bar_y = card_y + 43;   // Adjusted for improved vertical alignment
var bar_w = 85;            // Slightly wider
var bar_h = 12;            // Slightly taller
var prog = min(total_buildings / 20, 1);

draw_set_color(make_color_rgb(60, 60, 60));
draw_roundrect_ext(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, 2, 2, false);
draw_set_color(make_color_rgb(255, 180, 100));
draw_roundrect_ext(bar_x, bar_y, bar_x + (bar_w * prog), bar_y + bar_h, 2, 2, false);

// === RIGHT COLUMN - RECURSOS CARD (LARGE) ===
card_y = start_y;
var res_card_h = (card_h * 2) + spacing;

draw_set_color(make_color_rgb(50, 50, 30));
draw_set_alpha(0.7); // Mais transparente (era 0.85)
draw_roundrect_ext(right_x, card_y, right_x + card_w, card_y + res_card_h, 6, 6, false);
draw_set_color(make_color_rgb(255, 220, 120));
draw_set_alpha(0.6); // Mais transparente (era 0.8)
draw_roundrect_ext(right_x, card_y, right_x + card_w, card_y + res_card_h, 6, 6, true);
draw_set_alpha(1);

draw_set_color(make_color_rgb(255, 230, 150));
draw_text_transformed(right_x + 12, card_y + 10, "RECURSOS", font_scale, font_scale, 0);

// Resource list with improved spacing
var res_start_x = right_x + 12;  // Increased margin
var res_start_y = card_y + 38;   // Better vertical spacing
var res_col_w = (card_w - 24) / 2;
var res_row_h = 24;              // Increased row height for better spacing

var resources = [
    ["Ouro", make_color_rgb(255, 215, 0)],
    ["Minério", make_color_rgb(200, 200, 200)],
    ["Cobre", make_color_rgb(184, 115, 51)],
    ["Urânio", make_color_rgb(100, 255, 150)],
    ["Titânio", make_color_rgb(135, 206, 235)],
    ["Lítio", make_color_rgb(180, 130, 255)],
    ["Alumínio", make_color_rgb(180, 180, 180)],
    ["Petróleo", make_color_rgb(100, 100, 100)]
];

for (var i = 0; i < array_length(resources); i++) {
    var col = i mod 2;
    var row = i div 2;
    var res_name = resources[i][0];
    var res_color = resources[i][1];
    var res_amount = ds_map_exists(current_resources, res_name) ? current_resources[? res_name] : 0;
    
    var res_x = res_start_x + (col * res_col_w);
    var res_y = res_start_y + (row * res_row_h);
    
    draw_set_color(res_color);
    draw_circle(res_x + 8, res_y + 8, 4, false);
    draw_set_color(c_white);
    draw_text_transformed(res_x + 18, res_y, res_name + ": " + string(res_amount), font_scale, font_scale, 0);
}

card_y += res_card_h + spacing;

// === PESQUISA CARD - IMPROVED SPACING ===
draw_set_color(make_color_rgb(50, 30, 70));
draw_set_alpha(0.7); // Mais transparente (era 0.85)
draw_roundrect_ext(right_x, card_y, right_x + card_w, card_y + card_h, 6, 6, false);
draw_set_color(make_color_rgb(200, 150, 255));
draw_set_alpha(0.6); // Mais transparente (era 0.8)
draw_roundrect_ext(right_x, card_y, right_x + card_w, card_y + card_h, 6, 6, true);
draw_set_alpha(1); // Resetar alpha para 1.0

// Garantir que a fonte está definida
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

draw_set_color(make_color_rgb(220, 170, 255));
draw_text_transformed(right_x + 12, card_y + 10, "CENTRO DE PESQUISA", font_scale, font_scale, 0);

// DEBUG: Garantir que as variáveis têm valores válidos
if (is_undefined(research_completed_count) || research_completed_count < 0) {
    research_completed_count = 0;
}
if (is_undefined(research_active_count) || research_active_count < 0) {
    research_active_count = 0;
}

// Forçar configurações de desenho para garantir visibilidade
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Criar strings explicitamente
var completed_text = "Concluidas: " + string(research_completed_count) + "/12";
var active_text = "Ativas: " + string(research_active_count);

// Desenhar com background para garantir contraste (ANTES do texto)
draw_set_color(c_black);
draw_set_alpha(0.3);
draw_rectangle(right_x + 10, card_y + 33, right_x + 200, card_y + 37, false);
draw_rectangle(right_x + 10, card_y + 53, right_x + 150, card_y + 57, false);

// Desenhar texto principal (DEPOIS do background)
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_text_transformed(right_x + 12, card_y + 35, completed_text, font_scale, font_scale, 0);
draw_text_transformed(right_x + 12, card_y + 55, active_text, font_scale, font_scale, 0);

// Progress bar with improved spacing
var research_bar_x = right_x + 160;  // Better positioning
var research_bar_y = card_y + 43;    // Improved vertical alignment
var research_bar_w = 85;             // Slightly wider
var research_bar_h = 12;             // Slightly taller
var research_prog = research_completed_count / 12;

draw_set_color(make_color_rgb(60, 60, 60));
draw_roundrect_ext(research_bar_x, research_bar_y, research_bar_x + research_bar_w, research_bar_y + research_bar_h, 2, 2, false);
draw_set_color(make_color_rgb(200, 150, 255));
draw_roundrect_ext(research_bar_x, research_bar_y, research_bar_x + (research_bar_w * research_prog), research_bar_y + research_bar_h, 2, 2, false);

// Research progress only - no key hints

// Clean footer without status text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(200, 200, 200));
// Footer removed as requested

// Reset settings
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_alpha(1);