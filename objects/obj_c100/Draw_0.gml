// ===============================================
// HEGEMONIA GLOBAL - C-100 Draw (Visual)
// ===============================================

// Herdar desenho do F-5
event_inherited();

// ✅ CORREÇÃO: Círculo de área de embarque sempre visível quando modo ativo (maior e mais transparente)
if (modo_receber_carga && altura_voo == 0 && estado == "pousado") {
    // ✅ AUMENTADO 30%: Círculo muito maior para pegar múltiplas unidades facilmente
    var _radius = 156; // ✅ AUMENTADO 30%: era 120, agora 156 (120 * 1.3 = 156)
    
    // Círculo externo (muito transparente)
    draw_set_alpha(0.1); // ✅ MUITO TRANSPARENTE: era 0.15, agora 0.1
    draw_set_color(c_lime);
    draw_circle(x, y, _radius, false);
    
    // Círculo interno (um pouco mais visível, mas ainda transparente)
    draw_set_alpha(0.15); // ✅ TRANSPARENTE: era 0.25, agora 0.15
    draw_set_color(c_yellow);
    draw_circle(x, y, _radius * 0.7, false);
    
    // Restaurar configurações
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}