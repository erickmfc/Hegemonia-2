/// @description Controle de seleção de unidades

// Selecionar unidade com clique esquerdo
if (mouse_check_button_pressed(mb_left)) {
    // Coordenadas do mundo com suporte a zoom (via obj_input_manager)
    var world_x = mouse_x;
    var world_y = mouse_y;

    // Verifica infantaria primeiro, depois tanque
    // Checagem precisa: usa collision_point (pega bbox do sprite/objeto)
    var unidade_clicada = noone;
    var hit_inf = collision_point(world_x, world_y, obj_infantaria, false, true);
    if (hit_inf != noone) unidade_clicada = hit_inf;
    if (unidade_clicada == noone) {
        var hit_tk = collision_point(world_x, world_y, obj_tanque, false, true);
        if (hit_tk != noone) unidade_clicada = hit_tk;
    }

    if (unidade_clicada != noone) {
        // Se não estiver segurando Ctrl, desselecionar todas primeiro
        if (!keyboard_check(vk_control)) {
            with (obj_infantaria) { selecionado = false; }
            with (obj_tanque) { selecionado = false; }
        }
        unidade_clicada.selecionado = true;
        show_debug_message("Unidade selecionada!");
    } else {
        // Se clicou em lugar vazio e não está segurando Ctrl, desselecionar todas
        if (!keyboard_check(vk_control)) {
            with (obj_infantaria) { selecionado = false; }
            with (obj_tanque) { selecionado = false; }
        }
    }
}

// Seleção múltipla com arrastar (opcional)
if (mouse_check_button(mb_left)) {
    if (!selecionando) {
        selecionando = true;
        // Coordenadas do mundo (usar mouse_x/mouse_y mapeados pelo engine)
        inicio_selecao_x = mouse_x;
        inicio_selecao_y = mouse_y;
    }
} else {
    if (selecionando) {
        // Finalizar seleção múltipla
        selecionando = false;
        
        // Coordenadas do mundo finais
        var world_x = mouse_x;
        var world_y = mouse_y;
        
        // Selecionar unidades dentro da área
        var min_x = min(inicio_selecao_x, world_x);
        var max_x = max(inicio_selecao_x, world_x);
        var min_y = min(inicio_selecao_y, world_y);
        var max_y = max(inicio_selecao_y, world_y);
        
        with (obj_infantaria) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_tanque) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
    }
}