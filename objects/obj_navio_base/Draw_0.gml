// ===============================================
// HEGEMONIA GLOBAL - NAVIO BASE
// Draw Event - Otimizado
// ===============================================

// =============================================
// DRAW - Otimizado com verificação de visibilidade
// =============================================

// ✅ OTIMIZAÇÃO: Verificar se deve desenhar
if (!scr_should_draw(id)) {
    if (instance_exists(obj_draw_optimizer)) {
        obj_draw_optimizer.objects_skipped++;
    }
    exit;
}

// Desenhar sprite do navio
draw_self();

// Indicadores visuais se selecionado (herdado pelos filhos)
if (variable_instance_exists(id, "selecionado") && selecionado) {
    // Círculo de seleção básico
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_circle(x, y, 50, true);
    draw_set_alpha(1.0);
}
