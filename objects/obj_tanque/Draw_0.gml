/// @description Desenho do tanque com otimização

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

draw_self();

// Seleção (estilo da infantaria)
if (selecionado) {
    // Círculo de alcance de tiro (cinza translúcido)
    draw_set_color(c_gray);
    draw_set_alpha(0.05);
    draw_circle(x, y, alcance_tiro, false);
    draw_set_alpha(1);

    // Cantoneiras verdes em volta da caixa de colisão
    draw_set_color(c_lime);
    // Linha superior
    draw_line(bbox_left - 5, bbox_top - 5, bbox_right + 5, bbox_top - 5);
    // Linha inferior
    draw_line(bbox_left - 5, bbox_bottom + 5, bbox_right + 5, bbox_bottom + 5);
    // Linha esquerda
    draw_line(bbox_left - 5, bbox_top - 5, bbox_left - 5, bbox_bottom + 5);
    // Linha direita
    draw_line(bbox_right + 5, bbox_top - 5, bbox_right + 5, bbox_bottom + 5);

    // Linha da patrulha (com mouse em mundo)
    if (ds_list_size(patrulha) > 0) {
        draw_set_color(c_yellow);
        // Converter posição do mouse em mundo (igual infantaria)
        var mxw = camera_get_view_x(view_camera[0]) + mouse_x;
        var myw = camera_get_view_y(view_camera[0]) + mouse_y;
        for (var i = 0; i < ds_list_size(patrulha)-1; i++) {
            var p1 = ds_list_find_value(patrulha, i);
            var p2 = ds_list_find_value(patrulha, i+1);
            if (is_array(p1) && is_array(p2) && array_length(p1) >= 2 && array_length(p2) >= 2) {
                draw_line(p1[0], p1[1], p2[0], p2[1]);
            }
        }
        if (modo_patrulha) {
            var plast = ds_list_find_value(patrulha, ds_list_size(patrulha)-1);
            if (is_array(plast) && array_length(plast) >= 2) {
                draw_line(plast[0], plast[1], mxw, myw);
            }
        }
    }

    // Reset de desenho
    draw_set_alpha(1);
    draw_set_color(c_white);
}
