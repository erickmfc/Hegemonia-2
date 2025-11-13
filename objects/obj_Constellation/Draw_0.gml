/// @description Draw Event da Constellation

// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION (HERDA DE NAVIO_BASE)
// Draw Event - Indicadores específicos
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

// Chamar o Draw do objeto pai (herda indicadores básicos)
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === INDICADORES ESPECÍFICOS DO CONSTELLATION ===
if (selecionado) {
    // Círculo de seleção específico do Constellation
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_circle(x, y, 35, false);
    draw_set_alpha(1.0);
    
    // Círculo de alcance dos mísseis (800px) - 50% mais transparente
    draw_set_color(c_red);
    draw_set_alpha(0.06);
    draw_circle(x, y, 800, false);
    draw_set_alpha(1.0);
    
    // Círculo de alcance do radar (1000px)
    draw_set_color(c_blue);
    draw_set_alpha(0.08);
    draw_circle(x, y, 1000, false);
    draw_set_alpha(1.0);
    
    // Linha para o destino e marcador visual
    if (variable_instance_exists(id, "estado") && estado != LanchaState.PARADO) {
        if (variable_instance_exists(id, "destino_x") && variable_instance_exists(id, "destino_y")) {
            if (estado == LanchaState.ATACANDO) {
                draw_set_color(c_red); // Linha vermelha quando atacando
                draw_set_alpha(0.7);
            } else {
                draw_set_color(c_yellow); // Linha amarela para movimento normal
                draw_set_alpha(0.5);
            }
            // Desenhar linha do navio até o destino
            draw_line_width(x, y, destino_x, destino_y, 2);
            
            // Desenhar círculo marcador no destino
            draw_set_alpha(0.8);
            draw_circle(destino_x, destino_y, 15, false);
            draw_circle(destino_x, destino_y, 8, true);
        }
    }
    
    // Indicador de nome específico
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text_transformed(x, y - 100, "CONSTELLATION", 0.9, 0.9, 0);
}