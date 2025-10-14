// ===============================================
// HEGEMONIA GLOBAL - OBJETO PAI: UNIDADE MILITAR
// Sistema Padronizado P, O, L, K
// ===============================================

// Desenhar a unidade
draw_self();

// Indicadores visuais quando selecionado
if (selecionado) {
    // Círculo de alcance de tiro
    draw_set_color(c_gray);
    draw_set_alpha(0.1);
    draw_circle(x, y, alcance_tiro, false);
    draw_set_alpha(1);
    
    // Cantoneiras de seleção
    draw_set_color(c_lime);
    draw_line(bbox_left - 5, bbox_top - 5, bbox_right + 5, bbox_top - 5);
    draw_line(bbox_left - 5, bbox_bottom + 5, bbox_right + 5, bbox_bottom + 5);
    draw_line(bbox_left - 5, bbox_top - 5, bbox_left - 5, bbox_bottom + 5);
    draw_line(bbox_right + 5, bbox_top - 5, bbox_right + 5, bbox_bottom + 5);
    
    // Linhas de patrulha
    if (ds_list_size(pontos_patrulha) > 0) {
        draw_set_color(c_yellow);
        for (var i = 0; i < ds_list_size(pontos_patrulha) - 1; i++) {
            var p1 = pontos_patrulha[| i];
            var p2 = pontos_patrulha[| i + 1];
            draw_line(p1[0], p1[1], p2[0], p2[1]);
        }
        
        // Linha do último ponto ao mouse (quando em modo de desenho)
        if (modo_definicao_patrulha) {
            var mxw = camera_get_view_x(view_camera[0]) + mouse_x;
            var myw = camera_get_view_y(view_camera[0]) + mouse_y;
            var plast = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
            draw_line(plast[0], plast[1], mxw, myw);
        }
    }
    
    // Indicador de modo de combate
    draw_set_color(c_white);
    var modo_texto = "";
    var modo_cor = c_white;
    
    if (modo_combate == "passivo") {
        modo_texto = "PASSIVO";
        modo_cor = c_green;
    } else if (modo_combate == "atacando") {
        modo_texto = "ATACANDO";
        modo_cor = c_red;
    }
    
    if (modo_texto != "") {
        draw_set_color(modo_cor);
        draw_text(x, y - 30, modo_texto);
    }
    
    // Reset
    draw_set_color(c_white);
}
