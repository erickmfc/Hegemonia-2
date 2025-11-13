// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO METRALHADORA
// Draw Event - Visual do Projétil de Metralhadora
// ================================================

// =============================================
// DRAW - Otimizado com verificação de visibilidade
// =============================================

// ✅ NÃO DESENHAR SE ESTÁ DESATIVADO OU INVISÍVEL
if (!visible || image_alpha <= 0) {
    exit;
}

// ✅ OTIMIZAÇÃO: Verificar se deve desenhar (se o script existir)
if (script_exists(scr_should_draw)) {
    if (!scr_should_draw(id)) {
        if (instance_exists(obj_draw_optimizer)) {
            obj_draw_optimizer.objects_skipped++;
        }
        exit;
    }
}

// === DESENHAR SPRITE DO TIRO DE METRALHADORA ===
if (sprite_exists(sprite_index)) {
    // Desenhar sprite com configurações visuais
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
} else {
    // Fallback: desenhar círculo se sprite não existir (debug)
    draw_set_color(c_yellow);
    draw_set_alpha(image_alpha);
    draw_circle(x, y, 4, false);
    draw_circle(x, y, 2, true);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
