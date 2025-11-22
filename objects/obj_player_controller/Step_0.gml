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
        // Ordem de mover simples
        if (variable_instance_exists(selected_unit, "ordem_mover")) {
            selected_unit.ordem_mover(wx, wy);
            show_debug_message("Controller: Lancha movendo para (" + string(wx) + "," + string(wy) + ")");
        }
    }
}

// --- Patrulha removida - código comentado ---
// if (mouse_check_button_pressed(mb_left)) {
//     if (instance_exists(selected_unit) && variable_instance_exists(selected_unit, "modo_definicao_patrulha") && selected_unit.modo_definicao_patrulha) {
//         var coords = scr_mouse_to_world();
//         var wx = coords[0], wy = coords[1];
//         if (variable_instance_exists(selected_unit, "pontos_patrulha") && ds_exists(selected_unit.pontos_patrulha, ds_type_list)) {
//             ds_list_add(selected_unit.pontos_patrulha, [wx, wy]);
//             show_debug_message("Controller: Ponto de patrulha adicionado (" + string(wx) + "," + string(wy) + ")");
//         }
//     }
// }

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
    if (variable_instance_exists(selected_unit, "estado")) {
        selected_unit.estado = LanchaState.PARADO;
    }
    if (variable_instance_exists(selected_unit, "estado_string")) {
        selected_unit.estado_string = "parado";
    }
    if (variable_instance_exists(selected_unit, "alvo_unidade")) {
        selected_unit.alvo_unidade = noone;
    }
    if (variable_instance_exists(selected_unit, "speed")) {
        selected_unit.speed = 0;
    }
    show_debug_message("Controller: Ordem STOP enviada (lancha)");
}
// Tecla K (patrulha) removida - sistema de patrulha não está mais disponível para lancha
// if (keyboard_check_pressed(ord("K")) && instance_exists(selected_unit)) {
//     if (variable_instance_exists(selected_unit, "modo_definicao_patrulha")) {
//         selected_unit.modo_definicao_patrulha = !selected_unit.modo_definicao_patrulha;
//         if (selected_unit.modo_definicao_patrulha) {
//             if (variable_instance_exists(selected_unit, "pontos_patrulha") && ds_exists(selected_unit.pontos_patrulha, ds_type_list)) {
//                 ds_list_clear(selected_unit.pontos_patrulha);
//             }
//             show_debug_message("Controller: Entrou em modo DEFINIÇÃO PATRULHA (lancha)");
//         } else {
//             show_debug_message("Controller: Saiu do modo DEFINIÇÃO PATRULHA (lancha)");
//         }
//     }
// }