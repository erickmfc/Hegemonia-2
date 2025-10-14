/// @description Lógica principal da Lancha Patrulha

// Atualiza timers
if (reload_timer > 0) reload_timer -= 1;

// ✅ SISTEMA DE SELEÇÃO DIRETA (Como no Avião)
if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        selecionado = true;
        show_debug_message("🚢 Lancha selecionada diretamente");
    } else if (!modo_definicao_patrulha) {
        selecionado = false;
        show_debug_message("🚢 Lancha desselecionada");
    }
}

// ✅ CONTROLES DIRETOS NA LANCHA (Como no Avião)
if (selecionado) {
    // Clique direito para mover
    if (mouse_check_button_pressed(mb_right)) {
        var coords = scr_mouse_to_world();
        if (modo_definicao_patrulha) {
            // Finalizar patrulha
            modo_definicao_patrulha = false;
            if (ds_list_size(pontos_patrulha) > 1) {
                func_iniciar_patrulha();
                show_debug_message("🚢 Patrulha iniciada!");
            } else {
                ds_list_clear(pontos_patrulha);
                show_debug_message("🚢 Patrulha cancelada - poucos pontos");
            }
        } else {
            // Movimento normal
            ordem_mover(coords[0], coords[1]);
        }
    }
    
    // Clique esquerdo durante patrulha para adicionar pontos
    if (mouse_check_button_pressed(mb_left) && modo_definicao_patrulha) {
        if (!position_meeting(mouse_x, mouse_y, id)) { // Se não clicou na própria lancha
            var coords = scr_mouse_to_world();
            ds_list_add(pontos_patrulha, [coords[0], coords[1]]);
            show_debug_message("🚢 Ponto adicionado: " + string(ds_list_size(pontos_patrulha)));
        }
    }
    
    // Controles de teclado
    if (keyboard_check_pressed(ord("K"))) {
        modo_definicao_patrulha = !modo_definicao_patrulha;
        if (modo_definicao_patrulha) {
            ds_list_clear(pontos_patrulha);
            show_debug_message("🚢 Modo PATRULHA ativado - clique esquerdo para adicionar pontos");
        } else {
            show_debug_message("🚢 Modo PATRULHA desativado");
        }
    }
    
    if (keyboard_check_pressed(ord("L"))) {
        estado = LanchaState.PARADO;
        modo_definicao_patrulha = false;
        alvo_unidade = noone;
        show_debug_message("🚢 PARAR - todas as ações canceladas");
    }
    
    if (keyboard_check_pressed(ord("O"))) {
        modo_combate = LanchaMode.ATAQUE;
        show_debug_message("🚢 MODO ATAQUE ativado");
    }
    
    if (keyboard_check_pressed(ord("P"))) {
        modo_combate = LanchaMode.PASSIVO;
        show_debug_message("🚢 MODO PASSIVO ativado");
    }
}

// Mudar comportamento por estado
switch (estado) {
    case LanchaState.PARADO:
        // Verificar se modo ATAQUE e detectar inimigos
        if (modo_combate == LanchaMode.ATAQUE) {
            var encontrado = func_procurar_inimigo();
            if (encontrado != noone) {
                alvo_unidade = encontrado;
                estado = LanchaState.ATACANDO;
                show_debug_message("🚢 Alvo detectado! Atacando...");
            }
        }
        break;

    case LanchaState.MOVENDO:
        var _distancia_destino = point_distance(x, y, alvo_x, alvo_y);
        
        if (_distancia_destino > 5) { // Parar quando próximo (como o avião)
            // Movimento suave em direção ao alvo (como o avião)
            var _angulo = point_direction(x, y, alvo_x, alvo_y);
            x += lengthdir_x(velocidade_movimento, _angulo);
            y += lengthdir_y(velocidade_movimento, _angulo);
            image_angle = _angulo; // Rotacionar sprite como o avião
            
            // Debug menos verboso
            if (_distancia_destino mod 30 == 0) { // Debug a cada 30 frames
                show_debug_message("🚢 Navegando... Distância: " + string(round(_distancia_destino)));
            }
        } else {
            // Chegou ao destino
            x = alvo_x;
            y = alvo_y;
            estado = LanchaState.PARADO;
            show_debug_message("🚢 Chegou ao destino!");
        }
        
        // Enquanto se move, verificar inimigos se modo ATAQUE
        if (modo_combate == LanchaMode.ATAQUE) {
            var encontrado2 = func_procurar_inimigo();
            if (encontrado2 != noone) {
                alvo_unidade = encontrado2;
                estado = LanchaState.ATACANDO;
                show_debug_message("🚢 Inimigo detectado durante movimento!");
            }
        }
        break;

    case LanchaState.PATRULHANDO:
        var _distancia_ponto = point_distance(x, y, alvo_x, alvo_y);
        
        if (_distancia_ponto > 5) { // Parar quando próximo ao ponto
            // Movimento suave em direção ao ponto atual
            var _angulo = point_direction(x, y, alvo_x, alvo_y);
            x += lengthdir_x(velocidade_movimento, _angulo);
            y += lengthdir_y(velocidade_movimento, _angulo);
            image_angle = _angulo; // Rotacionar sprite
        } else {
            // Chegou ao ponto de patrulha
            x = alvo_x; 
            y = alvo_y;
            func_proximo_ponto();
            show_debug_message("🚢 Patrulha: Próximo ponto " + string(indice_patrulha_atual + 1) + "/" + string(ds_list_size(pontos_patrulha)));
        }
        
        // Enquanto patrulha, checar inimigos se modo ATAQUE
        if (modo_combate == LanchaMode.ATAQUE) {
            var encontrado3 = func_procurar_inimigo();
            if (encontrado3 != noone) {
                alvo_unidade = encontrado3;
                estado = LanchaState.ATACANDO;
                show_debug_message("🚢 Inimigo detectado durante patrulha!");
            }
        }
        break;

    case LanchaState.ATACANDO:
        if (instance_exists(alvo_unidade)) {
            var _dist_alvo = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
            
            // Se alvo saiu do radar, parar ataque
            if (_dist_alvo > radar_alcance) {
                alvo_unidade = noone;
                estado = LanchaState.PARADO;
                show_debug_message("🚢 Alvo fora de alcance - parando ataque");
            } else {
                func_atacar_alvo();
            }
        } else {
            // Procurar novo alvo se ainda em modo ataque
            if (modo_combate == LanchaMode.ATAQUE) {
                var novo_alvo = func_procurar_inimigo();
                if (novo_alvo != noone) {
                    alvo_unidade = novo_alvo;
                    show_debug_message("🚢 Novo alvo adquirido!");
                } else {
                    estado = LanchaState.PARADO;
                    show_debug_message("🚢 Nenhum alvo disponível - parando");
                }
            } else {
                estado = LanchaState.PARADO;
            }
        }
        break;
}
