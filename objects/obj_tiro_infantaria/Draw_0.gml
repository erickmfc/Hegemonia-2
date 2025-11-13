// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO INFANTARIA
// Draw Event - Visual do Projétil
// ================================================

// =============================================
// DRAW - Otimizado com verificação de visibilidade
// =============================================

// ✅ NÃO DESENHAR SE ESTÁ DESATIVADO OU INVISÍVEL
if (!visible || image_alpha <= 0 || speed <= 0) {
    exit;
}

// ✅ OTIMIZAÇÃO: Verificar se deve desenhar
if (!scr_should_draw(id)) {
    if (instance_exists(obj_draw_optimizer)) {
        obj_draw_optimizer.objects_skipped++;
    }
    exit;
}

// === DESENHAR O TIRO ===
draw_set_color(c_yellow);
draw_set_alpha(image_alpha);

// Desenhar círculo amarelo como tiro
draw_circle(x, y, 4, false);
draw_circle(x, y, 2, true);

// Desenhar borda
draw_set_color(c_orange);
draw_set_alpha(image_alpha * 0.7);
draw_circle(x, y, 4, true);

// Resetar configurações
draw_set_alpha(1);
draw_set_color(c_white);
/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
