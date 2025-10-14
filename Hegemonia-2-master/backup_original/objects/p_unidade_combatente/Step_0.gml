// ===============================================
// HEGEMONIA GLOBAL - OBJETO PAI: UNIDADE COMBATENTE
// Step Event - Lógica Comum de Combate e Movimento
// ===============================================

// Verificação de vida
if (vida_atual <= 0) {
    instance_destroy();
    exit;
}

// =======================
// RESFRIAMENTO DO TIRO
// =======================
if (atq_cooldown > 0) atq_cooldown--;

// =======================
// DETECÇÃO DE INIMIGOS
// =======================
// Só procura novo alvo se não estiver atacando
if (estado != "atacando" || alvo_inimigo == noone || !instance_exists(alvo_inimigo)) {
    alvo_inimigo = instance_nearest(x, y, obj_inimigo);
    if (alvo_inimigo != noone && point_distance(x, y, alvo_inimigo.x, alvo_inimigo.y) <= raio_de_visao) {
        estado = "atacando";
    }
}

// ======================
// CONTROLE POR TECLAS
// ======================
if (selecionado) {
    
    // ENTRAR/SAIR DO MODO PATRULHA (Q)
    if (keyboard_check_pressed(ord("Q"))) {
        if (!modo_patrulha) {
            // Entrar no modo patrulha
            modo_patrulha = true;
            ds_list_clear(rota_de_patrulha); // limpa patrulha anterior
            ponto_da_patrulha_atual = 0;
            show_debug_message("Modo patrulha ativado - clique direito nos pontos");
        } else {
            // Sair do modo patrulha
            modo_patrulha = false;
            if (ds_list_size(rota_de_patrulha) > 0) {
                estado = "patrulhando";
                show_debug_message("Patrulha iniciada com " + string(ds_list_size(rota_de_patrulha)) + " pontos");
            } else {
                show_debug_message("Modo patrulha desativado - nenhum ponto definido");
            }
        }
    }
    
    // SAIR DO MODO PATRULHA (clique esquerdo)
    if (modo_patrulha && mouse_check_button_pressed(mb_left)) {
        modo_patrulha = false;
        if (ds_list_size(rota_de_patrulha) > 0) {
            estado = "patrulhando";
            show_debug_message("Patrulha iniciada com " + string(ds_list_size(rota_de_patrulha)) + " pontos");
        } else {
            show_debug_message("Modo patrulha desativado - nenhum ponto definido");
        }
    }
    
    // ADICIONAR PONTO DE PATRULHA (botão direito no modo patrulha)
    if (modo_patrulha && mouse_check_button_pressed(mb_right)) {
        // Usar coordenadas do mundo (considerando zoom e câmera)
        var world_x = camera_get_view_x(view_camera[0]) + mouse_x / camera_get_view_width(view_camera[0]) * camera_get_view_width(view_camera[0]);
        var world_y = camera_get_view_y(view_camera[0]) + mouse_y / camera_get_view_height(view_camera[0]) * camera_get_view_height(view_camera[0]);
        var pos = [world_x, world_y];
        ds_list_add(rota_de_patrulha, pos);
        show_debug_message("Ponto de patrulha adicionado: " + string(world_x) + ", " + string(world_y));
    }
    
    // ANDAR (botão direito - só se não estiver no modo patrulha)
    if (!modo_patrulha && mouse_check_button_pressed(mb_right)) {
        // Usar coordenadas do mundo (considerando zoom e câmera)
        var world_x = camera_get_view_x(view_camera[0]) + mouse_x / camera_get_view_width(view_camera[0]) * camera_get_view_width(view_camera[0]);
        var world_y = camera_get_view_y(view_camera[0]) + mouse_y / camera_get_view_height(view_camera[0]) * camera_get_view_height(view_camera[0]);
        
        // Se há múltiplas unidades selecionadas, formar formação
        var unidades_selecionadas = 0;
        with (p_unidade_combatente) {
            if (selecionado) unidades_selecionadas++;
        }
        
        if (unidades_selecionadas > 1) {
            // Formação em linha
            var offset_x = 0;
            var offset_y = 0;
            var index = 0;
            
            with (p_unidade_combatente) {
                if (selecionado) {
                    offset_x = (index - (unidades_selecionadas-1)/2) * 30;
                    offset_y = (index - (unidades_selecionadas-1)/2) * 10;
                    
                    destino_x = world_x + offset_x;
                    destino_y = world_y + offset_y;
                    estado = "movendo";
                    alvo_inimigo = noone;
                    index++;
                }
            }
        } else {
            // Movimento individual
            destino_x = world_x;
            destino_y = world_y;
            estado = "movendo";
            alvo_inimigo = noone;
        }
    }
    
    // SEGUIR (E)
    if (keyboard_check_pressed(ord("E"))) {
        // Usar coordenadas do mundo (considerando zoom e câmera)
        var world_x = camera_get_view_x(view_camera[0]) + mouse_x / camera_get_view_width(view_camera[0]) * camera_get_view_width(view_camera[0]);
        var world_y = camera_get_view_y(view_camera[0]) + mouse_y / camera_get_view_height(view_camera[0]) * camera_get_view_height(view_camera[0]);
        var alvo_seg = instance_position(world_x, world_y, p_unidade_combatente);
        if (alvo_seg != noone && alvo_seg != id) {
            seguir_alvo = alvo_seg;
            estado = "seguindo";
            show_debug_message("Seguindo unidade alvo");
        } else {
            show_debug_message("Nenhuma unidade encontrada para seguir");
        }
    }
    
    // PARAR (S)
    if (keyboard_check_pressed(ord("S"))) {
        estado = "parado";
        alvo_inimigo = noone;
        seguir_alvo = noone;
        modo_patrulha = false;
        show_debug_message("Unidade parada");
    }
    
    // CANCELAR SEGUIR (X)
    if (keyboard_check_pressed(ord("X"))) {
        seguir_alvo = noone;
        if (estado == "seguindo") {
            estado = "parado";
        }
        show_debug_message("Comando de seguir cancelado");
    }
    
    // LIMPAR PATRULHA (R)
    if (keyboard_check_pressed(ord("R"))) {
        ds_list_clear(rota_de_patrulha);
        ponto_da_patrulha_atual = 0;
        modo_patrulha = false;
        estado = "parado";
        show_debug_message("Patrulha limpa");
    }
}

// ========================
// LÓGICA DE ESTADOS
// ========================
switch (estado) {
    
    case "parado":
        // só espera
    break;
    
    case "movendo":
        var dist = point_distance(x, y, destino_x, destino_y);
        if (dist > velocidade) {
            // Move na direção do destino
            var dir_x = destino_x - x;
            var dir_y = destino_y - y;
            var dist_norm = point_distance(0, 0, dir_x, dir_y);
            if (dist_norm > 0) {
                x += (dir_x / dist_norm) * velocidade;
                y += (dir_y / dist_norm) * velocidade;
            }
        } else {
            // Para exatamente no destino
            x = destino_x;
            y = destino_y;
            estado = "parado";
        }
    break;
    
    case "patrulhando":
        if (ds_list_size(rota_de_patrulha) > 0) {
            var pt = rota_de_patrulha[| ponto_da_patrulha_atual];
            var px = pt[0];
            var py = pt[1];
            
            var dist = point_distance(x, y, px, py);
            if (dist > velocidade) {
                // Move na direção do ponto
                var dir_x = px - x;
                var dir_y = py - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    x += (dir_x / dist_norm) * velocidade;
                    y += (dir_y / dist_norm) * velocidade;
                }
            } else {
                // Para exatamente no ponto
                x = px;
                y = py;
                // próximo ponto
                ponto_da_patrulha_atual = (ponto_da_patrulha_atual + 1) mod ds_list_size(rota_de_patrulha);
            }
        }
    break;
    
    case "atacando":
        if (alvo_inimigo != noone && !instance_exists(alvo_inimigo)) {
            // Inimigo eliminado, volta para patrulha
            alvo_inimigo = noone;
            estado = "patrulhando";
        } else if (alvo_inimigo != noone && instance_exists(alvo_inimigo)) {
            var dist = point_distance(x, y, alvo_inimigo.x, alvo_inimigo.y);
            
            // Verificar se o inimigo está se movendo
            var inimigo_movendo = false;
            if (variable_instance_exists(alvo_inimigo, "velocidade") && alvo_inimigo.velocidade > 0) {
                inimigo_movendo = true;
            } else if (variable_instance_exists(alvo_inimigo, "speed") && alvo_inimigo.speed > 0) {
                inimigo_movendo = true;
            } else if (variable_instance_exists(alvo_inimigo, "estado") && alvo_inimigo.estado == "movendo") {
                inimigo_movendo = true;
            }
            
            if (dist <= alcance_em_pixels) {
                // Atira se estiver no alcance
                if (atq_cooldown <= 0) {
                    var b = instance_create_layer(x, y, layer, obj_tiro_infantaria);
                    b.direction = point_direction(x, y, alvo_inimigo.x, alvo_inimigo.y);
                    b.speed = 8;
                    b.dano = ataque;
                    b.alvo = alvo_inimigo;
                    atq_cooldown = velocidade_de_ataque;
                }
                
                // Se o inimigo está parado, o soldado também para
                if (!inimigo_movendo) {
                    // Fica parado atirando
                } else {
                    // Se o inimigo está andando, pode seguir e atirar
                    if (dist > alcance_em_pixels - 30) { // Mantém distância mínima
                        var dir_x = alvo_inimigo.x - x;
                        var dir_y = alvo_inimigo.y - y;
                        var dist_norm = point_distance(0, 0, dir_x, dir_y);
                        if (dist_norm > 0) {
                            var dist_ideal = alcance_em_pixels - 20;
                            var target_x = x + (dir_x / dist_norm) * (dist - dist_ideal);
                            var target_y = y + (dir_y / dist_norm) * (dist - dist_ideal);
                            mp_potential_step(target_x, target_y, velocidade, false);
                        }
                    }
                }
            } else if (dist > alcance_em_pixels && dist <= raio_de_visao) {
                // Aproxima-se do inimigo
                var dir_x = alvo_inimigo.x - x;
                var dir_y = alvo_inimigo.y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    var dist_ideal = alcance_em_pixels - 20;
                    var target_x = x + (dir_x / dist_norm) * (dist - dist_ideal);
                    var target_y = y + (dir_y / dist_norm) * (dist - dist_ideal);
                    mp_potential_step(target_x, target_y, velocidade, false);
                }
            } else {
                // Inimigo muito longe, volta para patrulha
                alvo_inimigo = noone;
                estado = "patrulhando";
            }
        } else {
            // Alvo não existe mais, volta para patrulha
            alvo_inimigo = noone;
            estado = "patrulhando";
        }
    break;
    
    case "seguindo":
        if (seguir_alvo != noone && instance_exists(seguir_alvo)) {
            var dist = point_distance(x, y, seguir_alvo.x, seguir_alvo.y);
            if (dist > 40) {
                mp_potential_step(seguir_alvo.x, seguir_alvo.y, velocidade, false);
            }
        } else {
            estado = "parado";
            seguir_alvo = noone;
        }
    break;
}
