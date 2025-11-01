// ================================================
// HEGEMONIA GLOBAL - OBJETO: INIMIGO TESTE NOVO
// Draw Event - OBJETO COMPLETAMENTE NOVO
// ================================================

// === VERIFICAÇÃO DE FUNCIONAMENTO ===
if (timer_draw == 0) {
    timer_draw = 1;
    // ✅ REMOVIDO: Debug removido para melhorar performance
}

// === DESENHAR O SPRITE BASE ===
if (sprite_index != noone) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    // ✅ REMOVIDO: Debug removido para melhorar performance
} else {
    // Fallback: círculo vermelho
    draw_set_color(make_color_rgb(255, 0, 0));
    draw_circle(x, y, 20, true);
    // ✅ REMOVIDO: Debug removido para melhorar performance
}

// === DESENHAR BARRA DE HP ===
var barra_w = 40;
var barra_h = 6;
var barra_x = x - barra_w/2;
var barra_y = y - 35;

// Background
draw_set_color(make_color_rgb(128, 128, 128));
draw_rectangle(barra_x, barra_y, barra_x + barra_w, barra_y + barra_h, false);

// HP
var hp_percent = hp_atual / hp_max;
draw_set_color(make_color_rgb(0, 255, 0));
draw_rectangle(barra_x, barra_y, barra_x + (barra_w * hp_percent), barra_y + barra_h, false);

// Borda
draw_set_color(make_color_rgb(0, 0, 0));
draw_rectangle(barra_x, barra_y, barra_x + barra_w, barra_y + barra_h, true);

// === DESENHAR TEXTO ===
draw_set_color(make_color_rgb(255, 255, 255));
draw_set_font(font_get_name(0));
draw_text(x, y - 45, string(hp_atual) + "/" + string(hp_max));

// === INDICADOR DE SELEÇÃO ===
if (selecionado) {
    draw_set_color(make_color_rgb(255, 255, 0));
    draw_set_alpha(0.7);
    draw_circle(x, y, 25, false);
    draw_set_alpha(1);
    
    draw_set_color(make_color_rgb(255, 255, 0));
    draw_text(x, y + 30, "ARRESTANDO");
}

// === INDICADOR DE TESTE ===
draw_set_color(make_color_rgb(255, 165, 0));
draw_text(x, y + 45, "OBJETO NOVO TESTE");

// Reset
draw_set_color(make_color_rgb(255, 255, 255));
