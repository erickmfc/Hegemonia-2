// ===============================================
// HEGEMONIA GLOBAL - OBJETO PAI: UNIDADE MILITAR
// Sistema Padronizado P, O, L, K
// ===============================================

// --- 1. RESFRIAMENTO DO ATAQUE ---
if (timer_ataque > 0) timer_ataque--;

// --- 2. CONTROLES DO JOGADOR (QUANDO SELECIONADO) ---
if (selecionado) {
    // Tecla P - MODO PASSIVO
    if (keyboard_check_pressed(ord("P"))) {
        modo_combate = "passivo";
        estado = "parado";
        alvo = noone;
        show_debug_message("🛡️ " + object_get_name(object_index) + " - Modo PASSIVO");
    }
    
    // Tecla O - MODO ATAQUE
    if (keyboard_check_pressed(ord("O"))) {
        modo_combate = "atacando";
        show_debug_message("⚔️ " + object_get_name(object_index) + " - Modo ATAQUE");
    }
    
    // Tecla L - PARAR
    if (keyboard_check_pressed(ord("L"))) {
        estado = "parado";
        modo_definicao_patrulha = false; // Cancela desenho de patrulha
        patrulhando = false;
        alvo = noone;
        show_debug_message("⏹️ " + object_get_name(object_index) + " - PARADO");
    }

    // Tecla K: Entra/Cancela modo de desenho
    if (keyboard_check_pressed(ord("K"))) {
        if (modo_definicao_patrulha) {
            // Cancelar modo de desenho
            modo_definicao_patrulha = false;
            ds_list_clear(pontos_patrulha);
            show_debug_message("❌ " + object_get_name(object_index) + " - Patrulha cancelada");
        } else {
            // Entrar em modo de desenho
            modo_definicao_patrulha = true;
            ds_list_clear(pontos_patrulha);
            show_debug_message("🎯 " + object_get_name(object_index) + " - Modo PATRULHA: Clique esquerdo para adicionar pontos");
        }
    }
    
    // Clique esquerdo: Adicionar ponto de patrulha (quando em modo de desenho)
    if (modo_definicao_patrulha && mouse_check_button_pressed(mb_left)) {
        var world_x = camera_get_view_x(view_camera[0]) + mouse_x;
        var world_y = camera_get_view_y(view_camera[0]) + mouse_y;
        ds_list_add(pontos_patrulha, [world_x, world_y]);
        show_debug_message("📍 Ponto " + string(ds_list_size(pontos_patrulha)) + " adicionado: (" + string(world_x) + ", " + string(world_y) + ")");
    }
    
    // Clique direito: Finalizar patrulha ou mover
    if (mouse_check_button_pressed(mb_right)) {
        if (modo_definicao_patrulha) {
            // Finalizar patrulha
            if (ds_list_size(pontos_patrulha) > 0) {
                modo_definicao_patrulha = false;
                patrulhando = true;
                indice_patrulha = 0;
                estado = "patrulhando";
                show_debug_message("🔄 " + object_get_name(object_index) + " - Patrulha iniciada com " + string(ds_list_size(pontos_patrulha)) + " pontos");
            } else {
                modo_definicao_patrulha = false;
                show_debug_message("❌ " + object_get_name(object_index) + " - Nenhum ponto definido, patrulha cancelada");
            }
        } else {
            // Movimento normal
            var world_x = camera_get_view_x(view_camera[0]) + mouse_x;
            var world_y = camera_get_view_y(view_camera[0]) + mouse_y;
            destino_x = world_x;
            destino_y = world_y;
            estado = "movendo";
            alvo = noone;
            patrulhando = false;
            image_angle = point_direction(x, y, destino_x, destino_y);
            show_debug_message("🚶 " + object_get_name(object_index) + " - Movendo para (" + string(world_x) + ", " + string(world_y) + ")");
        }
    }
}

// --- 3. DETECÇÃO DE INIMIGOS (MODO ATAQUE) ---
if (modo_combate == "atacando" && estado != "movendo") {
    if (alvo == noone || !instance_exists(alvo)) {
        alvo = instance_nearest(x, y, obj_inimigo);
        if (alvo != noone && point_distance(x, y, alvo.x, alvo.y) <= alcance_visao) {
            estado = "atacando";
        }
    }
}

// --- 4. ESTADOS ---
switch (estado) {
    case "parado":
        // Aguarda comandos
    break;
    
    case "movendo":
        if (point_distance(x, y, destino_x, destino_y) > 6) {
            var dir = point_direction(x, y, destino_x, destino_y);
            var dx = lengthdir_x(velocidade, dir);
            var dy = lengthdir_y(velocidade, dir);
            x += dx;
            y += dy;
            image_angle = dir;
        } else {
            estado = "parado";
        }
    break;
    
    case "patrulhando":
        if (ds_list_size(pontos_patrulha) > 0) {
            var ponto = pontos_patrulha[| indice_patrulha];
            var px = ponto[0];
            var py = ponto[1];
            
            if (point_distance(x, y, px, py) > 6) {
                var dir = point_direction(x, y, px, py);
                var dx = lengthdir_x(velocidade, dir);
                var dy = lengthdir_y(velocidade, dir);
                x += dx;
                y += dy;
                image_angle = dir;
            } else {
                indice_patrulha = (indice_patrulha + 1) mod ds_list_size(pontos_patrulha);
            }
        } else {
            estado = "parado";
            patrulhando = false;
        }
    break;
    
    case "atacando":
        if (alvo != noone && instance_exists(alvo)) {
            var dist = point_distance(x, y, alvo.x, alvo.y);
            
            if (dist <= alcance_tiro) {
                // Atirar
                if (timer_ataque <= 0) {
                    var b = instance_create_layer(x, y, layer, projetil_objeto);
                    b.direction = point_direction(x, y, alvo.x, alvo.y);
                    b.speed = 8;
                    b.dano = 25;
                    timer_ataque = intervalo_ataque;
                }
                image_angle = point_direction(x, y, alvo.x, alvo.y);
            } else if (dist <= alcance_visao) {
                // Aproximar do inimigo
                var dir = point_direction(x, y, alvo.x, alvo.y);
                var dx = lengthdir_x(velocidade, dir);
                var dy = lengthdir_y(velocidade, dir);
                x += dx;
                y += dy;
                image_angle = dir;
            } else {
                // Inimigo muito longe
                alvo = noone;
                estado = "parado";
            }
        } else {
            alvo = noone;
            estado = "parado";
        }
    break;
}
