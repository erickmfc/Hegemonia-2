/// @description Desenhar área de seleção e pontos de patrulha
if (selecionando) {
    // Usar mouse_x/mouse_y que já estão no espaço da view atual
    var world_x = mouse_x;
    var world_y = mouse_y;
    
    draw_set_color(c_white);
    draw_set_alpha(0.3);
    draw_rectangle(inicio_selecao_x, inicio_selecao_y, world_x, world_y, false);
    draw_set_alpha(1);
}

// Desenhar pontos de patrulha para F-5
if (instance_exists(global.definindo_patrulha) && global.definindo_patrulha.object_index == obj_caca_f5) {
    var _f5 = global.definindo_patrulha;
    
    // Desenhar pontos existentes
    if (ds_list_size(_f5.pontos_patrulha) > 0) {
        draw_set_color(c_blue);
        draw_set_alpha(0.8);
        
        // Desenhar círculos nos pontos
        for (var i = 0; i < ds_list_size(_f5.pontos_patrulha); i++) {
            var _ponto = _f5.pontos_patrulha[| i];
            draw_circle(_ponto[0], _ponto[1], 8, false);
            draw_circle(_ponto[0], _ponto[1], 8, true);
        }
        
        // Desenhar linhas conectando os pontos
        if (ds_list_size(_f5.pontos_patrulha) > 1) {
            for (var i = 0; i < ds_list_size(_f5.pontos_patrulha) - 1; i++) {
                var _ponto1 = _f5.pontos_patrulha[| i];
                var _ponto2 = _f5.pontos_patrulha[| i + 1];
                draw_line(_ponto1[0], _ponto1[1], _ponto2[0], _ponto2[1]);
            }
        }
        
        draw_set_alpha(1);
    }
    
    // Desenhar linha do último ponto até o mouse
    if (ds_list_size(_f5.pontos_patrulha) > 0) {
        var _ultimo_ponto = _f5.pontos_patrulha[| ds_list_size(_f5.pontos_patrulha) - 1];
        var _mouse_coords = global.scr_mouse_to_world();
        
        draw_set_color(c_yellow);
        draw_set_alpha(0.6);
        draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _mouse_coords[0], _mouse_coords[1]);
        draw_set_alpha(1);
    }
}
