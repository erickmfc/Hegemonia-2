/// @description Controlador de seleção e comandos

// === COMANDOS TÁTICOS SIMPLIFICADOS ===
if (keyboard_check_pressed(ord("A"))) {
    // Ataque - todas as unidades selecionadas atacam inimigos próximos
    with (obj_infantaria) {
        if (selecionado) {
            var inimigo = instance_nearest(x, y, obj_inimigo);
            if (inimigo != noone) {
                alvo = inimigo;
                estado = "atacando";
            }
        }
    }
    if (global.debug_enabled) {
        show_debug_message("Comando: ATAQUE - Unidades atacando inimigos próximos");
    }
}

if (keyboard_check_pressed(ord("D"))) {
    // Defesa - todas as unidades param
    with (obj_infantaria) {
        if (selecionado) {
            estado = "parado";
            alvo = noone;
            script_execute(parar_movimento); // Usa script
        }
    }
    if (global.debug_enabled) {
        show_debug_message("Comando: DEFESA - Unidades em posição defensiva");
    }
}

// Selecionar unidade com clique esquerdo
if (mouse_check_button_pressed(mb_left)) {
    // Coordenadas do mundo com suporte a zoom
    var world_x = camera_get_view_x(view_camera[0]) + mouse_x;
    var world_y = camera_get_view_y(view_camera[0]) + mouse_y;

    // Verifica infantaria
    var unidade_clicada = collision_point(world_x, world_y, obj_infantaria, false, true);

    // Verificar se alguma unidade está em modo de desenho de patrulha
    var unidade_desenhando = false;
    with (obj_infantaria) {
        if (selecionado && drawing_patrol) {
            unidade_desenhando = true;
            if (global.debug_enabled) {
                show_debug_message("Unidade " + string(id) + " está em modo de desenho de patrulha");
            }
        }
    }

    if (unidade_desenhando) {
        // Finalizar desenho de patrulha e iniciar patrulha
        with (obj_infantaria) {
            if (selecionado && drawing_patrol) {
                if (ds_list_size(patrol_points) > 0) {
                    // Há pontos definidos - finalizar e iniciar patrulha
                    drawing_patrol = false;
                    patrolling = true;
                    patrol_index = 0;
                    estado = "patrulhando";
                    if (global.debug_enabled) {
                        show_debug_message("Patrulha iniciada com " + string(ds_list_size(patrol_points)) + " pontos");
                        show_debug_message("Estado: " + estado);
                    }
                } else {
                    // Não há pontos definidos - cancelar desenho
                    drawing_patrol = false;
                    if (global.debug_enabled) {
                        show_debug_message("Nenhum ponto definido - desenho de patrulha cancelado");
                    }
                }
            }
        }
    } else {
        // Seleção normal de unidades
        if (unidade_clicada != noone) {
            // Se não estiver segurando Ctrl, desselecionar todas primeiro
            if (!keyboard_check(vk_control)) {
                with (obj_infantaria) { selecionado = false; }
            }
            unidade_clicada.selecionado = true;
            if (global.debug_enabled) {
                show_debug_message("Unidade selecionada!");
            }
        } else {
            // Se clicou em lugar vazio e não está segurando Ctrl, desselecionar todas
            if (!keyboard_check(vk_control)) {
                with (obj_infantaria) { selecionado = false; }
            }
        }
    }
}

// Seleção múltipla com arrastar
if (mouse_check_button(mb_left)) {
    if (!selecionando) {
        selecionando = true;
        inicio_selecao_x = camera_get_view_x(view_camera[0]) + mouse_x;
        inicio_selecao_y = camera_get_view_y(view_camera[0]) + mouse_y;
    }
} else {
    if (selecionando) {
        selecionando = false;
        
        var world_x = camera_get_view_x(view_camera[0]) + mouse_x;
        var world_y = camera_get_view_y(view_camera[0]) + mouse_y;
        
        var min_x = min(inicio_selecao_x, world_x);
        var max_x = max(inicio_selecao_x, world_x);
        var min_y = min(inicio_selecao_y, world_y);
        var max_y = max(inicio_selecao_y, world_y);
        
        with (obj_infantaria) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
    }
}

// === COMANDO DE MOVIMENTO (BOTÃO DIREITO) ===
if (mouse_check_button_pressed(mb_right)) {
    var world_x = camera_get_view_x(view_camera[0]) + mouse_x;
    var world_y = camera_get_view_y(view_camera[0]) + mouse_y;

    // Verificar se alguma unidade está em modo de desenho de patrulha
    var unidade_desenhando = false;
    with (obj_infantaria) {
        if (selecionado && drawing_patrol) {
            unidade_desenhando = true;
            // Adicionar ponto à rota de patrulha
            ds_list_add(patrol_points, [world_x, world_y]);
            if (global.debug_enabled) {
                show_debug_message("Ponto adicionado à patrulha: (" + string(world_x) + ", " + string(world_y) + ")");
                show_debug_message("Total de pontos: " + string(ds_list_size(patrol_points)));
            }
        } else if (selecionado && !drawing_patrol) {
            if (global.debug_enabled) {
                show_debug_message("Unidade " + string(id) + " selecionada mas NÃO está em modo de desenho de patrulha");
                show_debug_message("drawing_patrol: " + string(drawing_patrol));
            }
        }
    }

    // Se não está desenhando patrulha, fazer movimento normal
    if (!unidade_desenhando) {
        // Criar lista de unidades selecionadas
        var lista_selecionadas = ds_list_create();
        with (obj_infantaria) {
            if (selecionado) {
                ds_list_add(lista_selecionadas, id);
            }
        }

        var total_selecionadas = ds_list_size(lista_selecionadas);

        if (total_selecionadas > 0) {
            if (global.debug_enabled) {
                show_debug_message("Controlador: Ordem de movimento para " + string(total_selecionadas) + " unidades.");
            }

            for (var i = 0; i < total_selecionadas; i++) {
                var unidade_id = lista_selecionadas[| i];
                
                with (unidade_id) {
                    var dest_x = world_x;
                    var dest_y = world_y;

                    if (total_selecionadas > 1) {
                        var colunas = floor(sqrt(total_selecionadas));
                        var coluna_atual = i mod colunas;
                        var linha_atual = i div colunas;
                        var espacamento = 48;

                        var offset_x = (coluna_atual - colunas / 2) * espacamento;
                        var offset_y = (linha_atual - colunas / 2) * espacamento;

                        dest_x += offset_x;
                        dest_y += offset_y;
                    }

                    // Usar script para iniciar movimento
                    script_execute(iniciar_movimento, dest_x, dest_y);
                    estado = "movendo";
                    alvo = noone;
                }
            }
        }

        ds_list_destroy(lista_selecionadas);
    }
}
