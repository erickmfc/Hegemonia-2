/// @description Controlador de seleção e comandos

// =========================================================================
// EVENTO DESATIVADO PARA EVITAR CONFLITOS
// Toda a lógica de seleção e comandos foi centralizada no Step_0.gml
exit;
// === COMANDOS AVANÇADOS PARA UNIDADES AÉREAS (REMOVIDOS - DUPLICADOS) ===
// Comandos E e Q já estão centralizados no obj_input_manager
// Este código foi removido para evitar duplicação

// === COMANDOS TÁTICOS SIMPLIFICADOS ===
if (keyboard_check_pressed(ord("P"))) {
    // Modo Passivo - todas as unidades param de atacar
    with (obj_infantaria) {
        if (selecionado) {
            estado = "passivo";
            alvo = noone;
            if (variable_instance_exists(id, "modo_combate")) {
                modo_combate = "passivo";
            }
        }
    }
    with (obj_blindado_antiaereo) {
        if (selecionado) {
            estado = "passivo";
            alvo = noone;
            if (variable_instance_exists(id, "modo_combate")) {
                modo_combate = "passivo";
            }
        }
    }
    with (obj_lancha_patrulha) {
        if (selecionado) {
            estado = "passivo";
            alvo = noone;
            if (variable_instance_exists(id, "modo_combate")) {
                modo_combate = "passivo";
            }
        }
    }
    with (obj_Constellation) {
        if (selecionado) {
            estado = "passivo";
            alvo = noone;
            if (variable_instance_exists(id, "modo_combate")) {
                modo_combate = "passivo";
            }
        }
    }
    if (global.debug_enabled) {
        show_debug_message("Comando: MODO PASSIVO - Unidades em modo defensivo");
    }
}

if (keyboard_check_pressed(ord("O"))) {
    // Modo Ataque - todas as unidades atacam inimigos próximos
    with (obj_infantaria) {
        if (selecionado) {
            var inimigo = instance_nearest(x, y, obj_inimigo);
            if (inimigo != noone) {
                alvo = inimigo;
                estado = "atacando";
                if (variable_instance_exists(id, "modo_combate")) {
                    modo_combate = "atacando";
                }
            }
        }
    }
    with (obj_blindado_antiaereo) {
        if (selecionado) {
            var inimigo = instance_nearest(x, y, obj_inimigo);
            if (inimigo != noone) {
                alvo = inimigo;
                estado = "atacando";
                if (variable_instance_exists(id, "modo_combate")) {
                    modo_combate = "atacando";
                }
            }
        }
    }
    with (obj_lancha_patrulha) {
        if (selecionado) {
            var inimigo = instance_nearest(x, y, obj_inimigo);
            if (inimigo != noone) {
                alvo = inimigo;
                estado = "atacando";
                if (variable_instance_exists(id, "modo_combate")) {
                    modo_combate = "atacando";
                }
            }
        }
    }
    with (obj_Constellation) {
        if (selecionado) {
            var inimigo = instance_nearest(x, y, obj_inimigo);
            if (inimigo != noone) {
                alvo = inimigo;
                estado = "atacando";
                if (variable_instance_exists(id, "modo_combate")) {
                    modo_combate = "atacando";
                }
            }
        }
    }
    if (global.debug_enabled) {
        show_debug_message("Comando: MODO ATAQUE - Unidades atacando inimigos próximos");
    }
}

// === COMANDO DE TESTE PARA LANCHA ===
if (keyboard_check_pressed(ord("T"))) {
    // Teste de ataque da lancha - criar inimigos próximos
    with (obj_lancha_patrulha) {
        if (selecionado) {
            show_debug_message("🧪 TESTE: Criando inimigos próximos à lancha...");
            scr_teste_lancha_ataque(x, y);
        }
    }
    show_debug_message("🧪 Comando T: Teste de ataque da lancha ativado");
}

// === COMANDO D REMOVIDO - CONFLITO COM COMANDOS P E O ===
// O comando D estava causando conflito com os novos comandos simplificados
// Use P para modo passivo e O para modo ataque

// === SISTEMA DE CLIQUE REMOVIDO - USAR APENAS STEP_0 ===
// Selecionar unidade com clique esquerdo (DESABILITADO - usar Step_0)
if (false && mouse_check_button_pressed(mb_left)) {
    // Coordenadas do mundo com suporte a zoom
    var world_x = camera_get_view_x(view_camera[0]) + mouse_x;
    var world_y = camera_get_view_y(view_camera[0]) + mouse_y;

    // Verifica infantaria primeiro, depois soldado anti-aéreo, depois tanque, depois blindado anti-aéreo, depois navios
    var unidade_clicada = collision_point(world_x, world_y, obj_infantaria, false, true);
    if (unidade_clicada == noone) {
        unidade_clicada = collision_point(world_x, world_y, obj_soldado_antiaereo, false, true);
    }
    if (unidade_clicada == noone) {
        unidade_clicada = collision_point(world_x, world_y, obj_tanque, false, true);
    }
    if (unidade_clicada == noone) {
        unidade_clicada = collision_point(world_x, world_y, obj_blindado_antiaereo, false, true);
    }
    if (unidade_clicada == noone) {
        unidade_clicada = collision_point(world_x, world_y, obj_lancha_patrulha, false, true);
    }
    if (unidade_clicada == noone) {
        unidade_clicada = collision_point(world_x, world_y, obj_Constellation, false, true);
    }
    if (unidade_clicada == noone) {
        unidade_clicada = collision_point(world_x, world_y, obj_nav122, false, true);
    }
    if (unidade_clicada == noone) {
        unidade_clicada = collision_point(world_x, world_y, obj_porta_avioes, false, true);
    }

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
    with (obj_soldado_antiaereo) {
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
        with (obj_soldado_antiaereo) {
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
        with (obj_lancha_patrulha) {
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
        with (obj_Constellation) {
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
                with (obj_soldado_antiaereo) { selecionado = false; }
                with (obj_tanque) { selecionado = false; }
                with (obj_blindado_antiaereo) { selecionado = false; }
                with (obj_lancha_patrulha) { selecionado = false; }
                with (obj_Constellation) { selecionado = false; }
                with (obj_nav122) { selecionado = false; }
                with (obj_porta_avioes) { selecionado = false; }
            }
            unidade_clicada.selecionado = true;
            if (global.debug_enabled) {
                show_debug_message("Unidade selecionada!");
            }
        } else {
            // Se clicou em lugar vazio e não está segurando Ctrl, desselecionar todas
            if (!keyboard_check(vk_control)) {
                with (obj_infantaria) { selecionado = false; }
                with (obj_soldado_antiaereo) { selecionado = false; }
                with (obj_tanque) { selecionado = false; }
                with (obj_blindado_antiaereo) { selecionado = false; }
                with (obj_lancha_patrulha) { selecionado = false; }
                with (obj_Constellation) { selecionado = false; }
                with (obj_nav122) { selecionado = false; }
                with (obj_porta_avioes) { selecionado = false; }
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
        with (obj_soldado_antiaereo) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_blindado_antiaereo) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_lancha_patrulha) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_Constellation) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_nav122) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_porta_avioes) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
    }
}

// === COMANDO DE MOVIMENTO (BOTÃO DIREITO) ===
if (mouse_check_button_pressed(mb_right)) {
    // ADICIONAR CONDIÇÃO: Se já tivermos uma unidade selecionada, este controlador não deve fazer nada.
    // A própria unidade cuidará do comando de movimento.
    if (instance_exists(global.unidade_selecionada)) {
        show_debug_message("🎯 CONTROLADOR: Unidade selecionada detectada - deixando comando para a unidade");
        show_debug_message("🎯 CONTROLADOR: Unidade: " + object_get_name(global.unidade_selecionada.object_index));
        exit; // Sai do script para não interferir
    }
    
    show_debug_message("🎯 CONTROLADOR: Processando clique direito (nenhuma unidade selecionada)");
    // ✅ CORREÇÃO CRÍTICA: Usar sistema de coordenadas do input_manager para zoom
    var _input_manager = instance_find(obj_input_manager, 0);
    var world_x, world_y;
    
    if (instance_exists(_input_manager)) {
        // Usar sistema de coordenadas correto com zoom
        var _cam_x = _input_manager.camera_x - (room_width * _input_manager.zoom_level) / 2;
        var _cam_y = _input_manager.camera_y - (room_height * _input_manager.zoom_level) / 2;
        
        world_x = _cam_x + (mouse_x * _input_manager.zoom_level);
        world_y = _cam_y + (mouse_y * _input_manager.zoom_level);
        
        show_debug_message("🎯 STEP_1 COORDENADAS COM ZOOM - Mouse: (" + string(mouse_x) + ", " + string(mouse_y) + ") | Mundo: (" + string(world_x) + ", " + string(world_y) + ") | Zoom: " + string(_input_manager.zoom_level));
    } else {
        // Fallback: usar sistema padrão
        world_x = camera_get_view_x(view_camera[0]) + mouse_x;
        world_y = camera_get_view_y(view_camera[0]) + mouse_y;
        show_debug_message("⚠️ Input manager não encontrado - usando coordenadas padrão");
    }

    // ✅ CORREÇÃO: Verificar se há navio selecionado primeiro
    var navio_selecionado = false;
    with (obj_lancha_patrulha) {
        if (selecionado) {
            navio_selecionado = true;
            show_debug_message("🚢 NAVIO SELECIONADO - Sistema de patrulha ignorado");
        }
    }
    with (obj_Constellation) {
        if (selecionado) {
            navio_selecionado = true;
            show_debug_message("🚢 CONSTELLATION SELECIONADO - Sistema de patrulha ignorado");
        }
    }
    
    // Se navio está selecionado, não processar sistema de patrulha
    if (navio_selecionado) {
        show_debug_message("🚢 Sistema de patrulha ignorado para navio");
        exit; // Sair do evento para não interferir
    }

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
    with (obj_soldado_antiaereo) {
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
        with (obj_soldado_antiaereo) {
            if (selecionado) {
                ds_list_add(lista_selecionadas, id);
            }
        }
        with (obj_blindado_antiaereo) {
            if (selecionado) {
                ds_list_add(lista_selecionadas, id);
            }
        }
        with (obj_lancha_patrulha) {
            if (selecionado) {
                ds_list_add(lista_selecionadas, id);
            }
        }
        with (obj_Constellation) {
            if (selecionado) {
                ds_list_add(lista_selecionadas, id);
            }
        }
        with (obj_nav122) {
            if (selecionado) {
                ds_list_add(lista_selecionadas, id);
            }
        }
        with (obj_porta_avioes) {
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
