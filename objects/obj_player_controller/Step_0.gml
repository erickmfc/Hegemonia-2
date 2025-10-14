/// @description obj_player_controller - Step

// Seleção (clique esquerdo) e ordens (clique direito)
// Usa scr_mouse_to_world para coordenadas corretas

// --- Clique esquerdo: selecionar unidade (lancha) ---
if (mouse_check_button_pressed(mb_left)) {
    var coords = scr_mouse_to_world();
    var wx = coords[0], wy = coords[1];

    // Tenta encontrar uma lancha (ou outra unidade) na posição do mouse
    var inst = instance_position(wx, wy, obj_lancha_patrulha);
    if (inst != noone) {
        // Seleciona esta instância e desmarca a anterior
        if (instance_exists(selected_unit)) {
            // desmarcar anterior
            selected_unit.selecionado = false;
            if (variable_instance_exists(selected_unit, "on_deselect")) {
                selected_unit.on_deselect();
            }
        }
        selected_unit = inst;
        selected_unit.selecionado = true;
        if (variable_instance_exists(selected_unit, "on_select")) {
            selected_unit.on_select();
        }
        show_debug_message("Controller: Lancha selecionada (id=" + string(selected_unit) + ")");
    } else {
        // clicou no chão -> deselecionar
        if (instance_exists(selected_unit)) {
            selected_unit.selecionado = false;
            if (variable_instance_exists(selected_unit, "on_deselect")) {
                selected_unit.on_deselect();
            }
            selected_unit = noone;
            show_debug_message("Controller: Deselecionado");
        }
    }
}

// --- Clique direito: ordem de mover ou confirmar patrulha ---
if (mouse_check_button_pressed(mb_right)) {
    var coords = scr_mouse_to_world();
    var wx = coords[0], wy = coords[1];

    if (instance_exists(selected_unit)) {
        // se a lancha está em modo_definicao_patrulha, o clique direito confirma e inicia a patrulha
        if (selected_unit.modo_definicao_patrulha) {
            selected_unit.modo_definicao_patrulha = false;
            if (ds_list_size(selected_unit.pontos_patrulha) > 1) {
                selected_unit.indice_patrulha_atual = 0;
                selected_unit.estado = LanchaState.PATRULHANDO;
                show_debug_message("Controller: Patrulha confirmada para lancha (pontos=" + string(ds_list_size(selected_unit.pontos_patrulha)) + ")");
            } else {
                // se só tinha 0/1 ponto, cancelar
                ds_list_clear(selected_unit.pontos_patrulha);
                selected_unit.estado = LanchaState.PARADO;
                show_debug_message("Controller: Patrulha cancelada (pontos insuficientes)");
            }
        } else {
            // Ordem de mover normal
            if (variable_instance_exists(selected_unit, "ordem_mover")) {
                selected_unit.ordem_mover(wx, wy);
                show_debug_message("Controller: Ordem de mover enviada -> (" + string(wx) + "," + string(wy) + ")");
            } else {
                // fallback simples
                selected_unit.alvo_x = wx;
                selected_unit.alvo_y = wy;
                selected_unit.estado = LanchaState.MOVENDO;
                show_debug_message("Controller: Movimento fallback -> (" + string(wx) + "," + string(wy) + ")");
            }
        }
    }
}

// --- Durante definição de patrulha: clique esquerdo adiciona ponto ---
if (mouse_check_button_pressed(mb_left)) {
    if (instance_exists(selected_unit) && selected_unit.modo_definicao_patrulha) {
        var coords = scr_mouse_to_world();
        var wx = coords[0], wy = coords[1];
        ds_list_add(selected_unit.pontos_patrulha, [wx, wy]);
        show_debug_message("Controller: Ponto de patrulha adicionado (" + string(wx) + "," + string(wy) + ")");
    }
}

// --- Teclas de controle globais (O/P/K/L) aplicam-se à unidade selecionada ---
if (keyboard_check_pressed(ord("O")) && instance_exists(selected_unit)) {
    selected_unit.modo_combate = LanchaMode.ATAQUE;
    show_debug_message("Controller: Modo ATAQUE ativado (lancha)");
}
if (keyboard_check_pressed(ord("P")) && instance_exists(selected_unit)) {
    selected_unit.modo_combate = LanchaMode.PASSIVO;
    show_debug_message("Controller: Modo PASSIVO ativado (lancha)");
}
if (keyboard_check_pressed(ord("L")) && instance_exists(selected_unit)) {
    selected_unit.estado = LanchaState.PARADO;
    selected_unit.alvo_unidade = noone;
    selected_unit.modo_definicao_patrulha = false;
    show_debug_message("Controller: Ordem STOP enviada (lancha)");
}
if (keyboard_check_pressed(ord("K")) && instance_exists(selected_unit)) {
    selected_unit.modo_definicao_patrulha = !selected_unit.modo_definicao_patrulha;
    if (selected_unit.modo_definicao_patrulha) {
        ds_list_clear(selected_unit.pontos_patrulha);
        show_debug_message("Controller: Entrou em modo DEFINIÇÃO PATRULHA (lancha)");
    } else {
        show_debug_message("Controller: Saiu do modo DEFINIÇÃO PATRULHA (lancha)");
    }
}