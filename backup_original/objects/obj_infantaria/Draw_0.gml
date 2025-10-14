/// @description Desenho do soldado com feedback visual

// Desenha o soldado (assumindo que tem sprite)
draw_self();

// Barra de vida
if (vida < vida_max) {
    var bar_width = 30;
    var bar_height = 4;
    var bar_x = x - bar_width/2;
    var bar_y = y - 20;
    
    // Fundo da barra (vermelho)
    draw_set_color(c_red);
    draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
    
    // Vida atual (verde)
    draw_set_color(c_green);
    var vida_width = (vida / vida_max) * bar_width;
    draw_rectangle(bar_x, bar_y, bar_x + vida_width, bar_y + bar_height, false);
}

// Indicador de seleção
if (selecionado) {
    // Círculo de visão de tiro (mais transparente para ver melhor)
    draw_set_color(c_gray);
    draw_set_alpha(0.08);
    draw_circle(x, y, alcance_tiro, false);
    draw_set_alpha(1);
    
    // Linhas verdes ao redor do corpo (seleção)
    draw_set_color(c_lime);
    
    // Linha superior
    draw_line(bbox_left - 5, bbox_top - 5, bbox_right + 5, bbox_top - 5);
    // Linha inferior
    draw_line(bbox_left - 5, bbox_bottom + 5, bbox_right + 5, bbox_bottom + 5);
    // Linha esquerda
    draw_line(bbox_left - 5, bbox_top - 5, bbox_left - 5, bbox_bottom + 5);
    // Linha direita
    draw_line(bbox_right + 5, bbox_top - 5, bbox_right + 5, bbox_bottom + 5);

    // Desenhar rota da patrulha alinhada exatamente ao mouse (coordenadas do mundo)
    if (ds_list_size(patrulha) > 0) {
        draw_set_color(c_yellow);
        // Converter posição atual do mouse para coordenadas do mundo com base na view
        var mxw = camera_get_view_x(view_camera[0]) + mouse_x;
        var myw = camera_get_view_y(view_camera[0]) + mouse_y;
        // desenha segmentos entre pontos já definidos
        for (var i = 0; i < ds_list_size(patrulha)-1; i++) {
            var p1 = patrulha[| i];
            var p2 = patrulha[| i+1];
            draw_line(p1[0], p1[1], p2[0], p2[1]);
        }
        // se estamos no modo patrulha, estende a última aresta até a posição do mouse em mundo
        if (modo_patrulha) {
            var plast = patrulha[| ds_list_size(patrulha)-1];
            draw_line(plast[0], plast[1], mxw, myw);
        }
    }
}

// Indicador de estado (removido - não mostra mais na tela)