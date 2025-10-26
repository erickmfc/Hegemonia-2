// ===============================================
// HEGEMONIA GLOBAL - WW-HENDRICK
// Draw Event - Indicadores específicos de submarino
// ===============================================

// Chamar o Draw do objeto pai (herda indicadores básicos)
event_inherited();

// === INDICADORES ESPECÍFICOS DO WW-HENDRICK ===
if (selecionado) {
    // Círculo de seleção específico do submarino (Azul Ciano)
    var _cor_azul = make_color_rgb(0, 255, 255); // Cyan RGB
    draw_set_color(_cor_azul);
    draw_set_alpha(0.3);
    draw_circle(x, y, 30, false);
    draw_set_alpha(1.0);
    
    // Indicador de nome
    draw_set_halign(fa_center);
    draw_set_color(_cor_azul);
    draw_text_transformed(x, y - 80, "WW-HENDRICK", 0.9, 0.9, 0);
    
    // Indicador de profundidade
    if (submerso) {
        draw_set_color(c_red);
        draw_text_transformed(x, y - 95, "SUBMERSO", 0.8, 0.8, 0);
    } else {
        draw_set_color(c_green);
        draw_text_transformed(x, y - 95, "SUPERFÍCIE", 0.8, 0.8, 0);
    }
}