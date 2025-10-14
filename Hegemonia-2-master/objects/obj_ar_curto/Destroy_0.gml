// ================================================
// HEGEMONIA GLOBAL - OBJETO: AR-CURTO (Míssil Ar-Ar)
// Destroy Event - Limpeza e Efeitos Finais
// ================================================

// === EFEITO DE DESTRUIÇÃO ===
if (object_exists(obj_explosao_aquatica)) {
    var _explosao = instance_create_depth(x, y, 0, obj_explosao_aquatica);
    if (instance_exists(_explosao)) {
        _explosao.image_blend = make_color_rgb(200, 200, 200); // Cinza para explosão de destruição
        _explosao.image_xscale = 1.5;
        _explosao.image_yscale = 1.5;
        _explosao.image_angle = random(360);
    }
}

show_debug_message("💥 Míssil AR-CURTO destruído!");