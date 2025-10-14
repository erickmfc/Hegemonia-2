/// @description Desenhar área de seleção
if (selecionando) {
    // Usar mouse_x/mouse_y que já estão no espaço da view atual
    var world_x = mouse_x;
    var world_y = mouse_y;
    
    draw_set_color(c_white);
    draw_set_alpha(0.3);
    draw_rectangle(inicio_selecao_x, inicio_selecao_y, world_x, world_y, false);
    draw_set_alpha(1);
}