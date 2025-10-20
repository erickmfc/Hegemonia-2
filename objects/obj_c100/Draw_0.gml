// ===============================================
// HEGEMONIA GLOBAL - C-100 Draw (Visual)
// ===============================================

// Herdar desenho do F-5
event_inherited();

// Feedback visual de embarque quando modo ativo e unidade próxima
if (modo_receber_carga && global.unidade_selecionada != noone && global.unidade_selecionada != id) {
    var _unidade_sel = global.unidade_selecionada;
    if (point_distance(x, y, _unidade_sel.x, _unidade_sel.y) <= 50) {
        // Círculo pulsante para indicar que pode embarcar
        var _alpha = 0.5 + 0.3 * sin(current_time * 0.01);
        var _radius = 35 + 5 * sin(current_time * 0.02);
        
        draw_set_alpha(_alpha);
        draw_set_color(c_lime);
        draw_circle(x, y, _radius, false);
        
        draw_set_color(c_yellow);
        draw_circle(x, y, _radius * 0.7, false);
        
        // Texto indicativo
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(x, y - 10, "EMBARQUE");
        draw_text(x, y + 10, "DISPONÍVEL");
        
        // Restaurar configurações
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}