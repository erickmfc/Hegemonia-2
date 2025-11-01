// ================================================
// HEGEMONIA GLOBAL - EXPLOSÃO PEQUENA
// Draw Event - Efeito Visual Simples
// ================================================

// === DESENHAR O SPRITE BASE ===
draw_self();

// === EFEITOS ADICIONAIS ===
// ✅ OTIMIZAÇÃO: Reduzir efeitos visuais em zoom out
var _lod_level = scr_get_lod_level();
if (_lod_level >= 2) {
    // Apenas em zoom próximo - mostrar efeitos extras
    if (variable_instance_exists(id, "brilho")) {
        draw_set_color(c_yellow);
        draw_circle(x, y, 10, false);
        draw_set_color(c_white);
    }
}
