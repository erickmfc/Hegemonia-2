/// STEP EVENT - Lógica do Soldado Anti-Aéreo
/// Sistema idêntico à infantaria, mas especializado em alvos aéreos

// Incrementar contador
step_counter++;

// Verificação de vida
if (vida <= 0) {
    instance_destroy();
    exit;
}

// =======================
// RESFRIAMENTO DO TIRO
// =======================
if (atq_cooldown > 0) atq_cooldown--;

// =======================
// DETECÇÃO DE ALVOS (APENAS AÉREOS)
// =======================
// Só procura novo alvo se não estiver atacando
if (estado != "atacando" || alvo == noone || !instance_exists(alvo)) {
    // Buscar APENAS unidades aéreas inimigas
    alvo = noone;
    var menor_dist = 999999;
    
    // Debug: Nação do soldado anti-aéreo
    if (step_counter mod 180 == 0) {
        show_debug_message("🔍 Soldado Anti-Aéreo (ID: " + string(id) + ") | Nação: " + string(nacao_proprietaria) + " | Alcance: " + string(alcance_visao));
    }
    
    // Verificar objetos aéreos inimigos
    with (obj_caca_f5) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria != other.nacao_proprietaria) {
            var dist = point_distance(other.x, other.y, x, y);
            if (dist < menor_dist && dist <= other.alcance_visao) {
                alvo = id;
                menor_dist = dist;
            }
        }
    }
    
    with (obj_f15) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria != other.nacao_proprietaria) {
            var dist = point_distance(other.x, other.y, x, y);
            if (dist < menor_dist && dist <= other.alcance_visao) {
                alvo = id;
                menor_dist = dist;
            }
        }
    }
    
    with (obj_helicoptero_militar) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria != other.nacao_proprietaria) {
            var dist = point_distance(other.x, other.y, x, y);
            if (dist < menor_dist && dist <= other.alcance_visao) {
                alvo = id;
                menor_dist = dist;
            }
        }
    }
    
    with (obj_c100) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria != other.nacao_proprietaria) {
            var dist = point_distance(other.x, other.y, x, y);
            if (dist < menor_dist && dist <= other.alcance_visao) {
                alvo = id;
                menor_dist = dist;
            }
        }
    }
    
    with (obj_f6) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria != other.nacao_proprietaria) {
            var dist = point_distance(other.x, other.y, x, y);
            if (dist < menor_dist && dist <= other.alcance_visao) {
                alvo = id;
                menor_dist = dist;
            }
        }
    }
    
    // Se encontrou alvo aéreo dentro do alcance
    if (alvo != noone) {
        estado = "atacando";
        show_debug_message("🎯 Soldado Anti-Aéreo detectou alvo AÉREO! ID: " + string(alvo) + " | Distância: " + string(menor_dist) + " | Alcance: " + string(alcance_visao));
    } else {
        // Debug: verificar se há unidades aéreas por perto
        var unidades_aereas_proximas = 0;
        with (obj_caca_f5) {
            if (nacao_proprietaria != other.nacao_proprietaria) unidades_aereas_proximas++;
        }
        with (obj_f15) {
            if (nacao_proprietaria != other.nacao_proprietaria) unidades_aereas_proximas++;
        }
        with (obj_helicoptero_militar) {
            if (nacao_proprietaria != other.nacao_proprietaria) unidades_aereas_proximas++;
        }
        with (obj_c100) {
            if (nacao_proprietaria != other.nacao_proprietaria) unidades_aereas_proximas++;
        }
        with (obj_f6) {
            if (nacao_proprietaria != other.nacao_proprietaria) unidades_aereas_proximas++;
        }
        if (unidades_aereas_proximas > 0 && step_counter mod 180 == 0) { // Debug a cada 3 segundos
            show_debug_message("⚠️ Soldado Anti-Aéreo vê " + string(unidades_aereas_proximas) + " unidades aéreas inimigas, mas nenhuma no alcance");
        }
    }
}

// ======================
// CONTROLE POR TECLAS (IDÊNTICO À INFANTARIA)
// ======================
if (selecionado) {
    
    // ENTRAR/SAIR DO MODO PATRULHA (Q)
    if (keyboard_check_pressed(ord("Q"))) {
        if (!modo_patrulha) {
            modo_patrulha = true;
            ds_list_clear(patrulha);
            patrulha_indice = 0;
            show_debug_message("Modo patrulha ativado - clique direito nos pontos");
        } else {
            modo_patrulha = false;
            if (ds_list_size(patrulha) > 0) {
                estado = "patrulhando";
                show_debug_message("Patrulha iniciada com " + string(ds_list_size(patrulha)) + " pontos");
            } else {
                show_debug_message("Modo patrulha desativado - nenhum ponto definido");
            }
        }
    }
    
    // SAIR DO MODO PATRULHA (clique esquerdo)
    if (modo_patrulha && mouse_check_button_pressed(mb_left)) {
        modo_patrulha = false;
        if (ds_list_size(patrulha) > 0) {
            estado = "patrulhando";
            show_debug_message("Patrulha iniciada com " + string(ds_list_size(patrulha)) + " pontos");
        } else {
            show_debug_message("Modo patrulha desativado - nenhum ponto definido");
        }
    }
    
    // ADICIONAR PONTO DE PATRULHA (botão direito no modo patrulha)
    if (modo_patrulha && mouse_check_button_pressed(mb_right)) {
        // ✅ CORREÇÃO: Usar função global para coordenadas precisas
        var _coords = global.scr_mouse_to_world();
        var world_x = _coords[0];
        var world_y = _coords[1];
        
        // ✅ CORREÇÃO CRÍTICA: Clamp para dentro da sala
        world_x = clamp(world_x, 8, room_width - 8);
        world_y = clamp(world_y, 8, room_height - 8);
        
        var pos = [world_x, world_y];
        ds_list_add(patrulha, pos);
        show_debug_message("[PATRULHA] Ponto adicionado (mundo): " + string(world_x) + ", " + string(world_y));
    }
    
    // ANDAR (botão direito - só se não estiver no modo patrulha)
    if (!modo_patrulha && mouse_check_button_pressed(mb_right)) {
        // ✅ CORREÇÃO: Usar função global para coordenadas precisas
        var _coords = global.scr_mouse_to_world();
        var world_x = _coords[0];
        var world_y = _coords[1];
        
        // ✅ CORREÇÃO CRÍTICA: Clamp para dentro da sala
        world_x = clamp(world_x, 8, room_width - 8);
        world_y = clamp(world_y, 8, room_height - 8);
        
        // Verificar se há múltiplas unidades selecionadas (incluindo soldados anti-aéreos)
        var unidades_selecionadas = 0;
        var primeira_unidade = noone;
        
        // Contar infantaria selecionada
        with (obj_infantaria) {
            if (selecionado) {
                unidades_selecionadas++;
                if (primeira_unidade == noone) {
                    primeira_unidade = id;
                }
            }
        }
        
        // Contar soldados anti-aéreos selecionados
        with (obj_soldado_antiaereo) {
            if (selecionado) {
                unidades_selecionadas++;
                if (primeira_unidade == noone) {
                    primeira_unidade = id;
                }
            }
        }
        
        // Contar tanques selecionados
        with (obj_tanque) {
            if (selecionado) {
                unidades_selecionadas++;
                if (primeira_unidade == noone) {
                    primeira_unidade = id;
                }
            }
        }
        
        if (unidades_selecionadas > 1) {
            // MÚLTIPLAS UNIDADES - MOVIMENTO EM FORMAÇÃO
            var indice_formacao = 0;
            
            // Mover infantaria
            with (obj_infantaria) {
                if (selecionado) {
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    var offset_x = (coluna - 1.5) * 45;
                    var offset_y = (linha - 1.5) * 45;
                    destino_x = world_x + offset_x;
                    destino_y = world_y + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    indice_formacao++;
                }
            }
            
            // Mover soldados anti-aéreos
            with (obj_soldado_antiaereo) {
                if (selecionado) {
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    var offset_x = (coluna - 1.5) * 45;
                    var offset_y = (linha - 1.5) * 45;
                    destino_x = world_x + offset_x;
                    destino_y = world_y + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    indice_formacao++;
                }
            }
            
            // Mover tanques
            with (obj_tanque) {
                if (selecionado) {
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    var offset_x = (coluna - 1.5) * 60;
                    var offset_y = (linha - 1.5) * 60;
                    destino_x = world_x + offset_x;
                    destino_y = world_y + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    indice_formacao++;
                }
            }
            show_debug_message("Movimento em formação com " + string(unidades_selecionadas) + " unidades");
        } else {
            // UMA UNIDADE - MOVIMENTO NORMAL
            destino_x = world_x;
            destino_y = world_y;
            estado = "movendo";
            alvo = noone;
            image_angle = point_direction(x, y, destino_x, destino_y);
        }
    }
    
    // SEGUIR (E)
    if (keyboard_check_pressed(ord("E"))) {
        var world_x = camera_get_view_x(view_camera[0]) + mouse_x / camera_get_view_width(view_camera[0]) * camera_get_view_width(view_camera[0]);
        var world_y = camera_get_view_y(view_camera[0]) + mouse_y / camera_get_view_height(view_camera[0]) * camera_get_view_height(view_camera[0]);
        var alvo_seg = instance_position(world_x, world_y, obj_infantaria);
        if (alvo_seg == noone) alvo_seg = instance_position(world_x, world_y, obj_soldado_antiaereo);
        if (alvo_seg == noone) alvo_seg = instance_position(world_x, world_y, obj_tanque);
        
        if (alvo_seg != noone && alvo_seg != id) {
            seguir_alvo = alvo_seg;
            estado = "seguindo";
            show_debug_message("Soldado Anti-Aéreo seguindo unidade alvo");
        } else {
            show_debug_message("Nenhuma unidade encontrada para seguir");
        }
    }
    
    // PARAR (S)
    if (keyboard_check_pressed(ord("S"))) {
        estado = "parado";
        alvo = noone;
        seguir_alvo = noone;
        modo_patrulha = false;
        show_debug_message("Soldado Anti-Aéreo parado");
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
        ds_list_clear(patrulha);
        patrulha_indice = 0;
        modo_patrulha = false;
        estado = "parado";
        show_debug_message("Patrulha limpa");
    }
}

// ========================
// LÓGICA DE ESTADOS (IDÊNTICA À INFANTARIA)
// ========================
switch (estado) {
    
    case "parado":
        // só espera
    break;
    
    case "movendo":
        var dist_destino = point_distance(x, y, destino_x, destino_y);
        if (dist_destino > velocidade) {
            var dir_x = destino_x - x;
            var dir_y = destino_y - y;
            var dist_norm = point_distance(0, 0, dir_x, dir_y);
            if (dist_norm > 0) {
                x += (dir_x / dist_norm) * velocidade;
                y += (dir_y / dist_norm) * velocidade;
                image_angle = point_direction(0, 0, dir_x, dir_y);
            }
        } else {
            x = destino_x;
            y = destino_y;
            estado = "parado";
        }
    break;
    
    case "patrulhando":
        if (ds_list_size(patrulha) > 0) {
            if (patrulha_indice >= ds_list_size(patrulha)) patrulha_indice = 0;
            var pt = patrulha[| patrulha_indice];
            var px = pt[0];
            var py = pt[1];
            var dist_patrulha = point_distance(x, y, px, py);
            if (dist_patrulha > velocidade) {
                var dir_x = px - x;
                var dir_y = py - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    x += (dir_x / dist_norm) * velocidade;
                    y += (dir_y / dist_norm) * velocidade;
                    image_angle = point_direction(0, 0, dir_x, dir_y);
                }
            } else {
                x = px;
                y = py;
                patrulha_indice = (patrulha_indice + 1) mod ds_list_size(patrulha);
            }
        }
    break;
    
    case "atacando":
        if (alvo != noone && !instance_exists(alvo)) {
            alvo = noone;
            estado = "patrulhando";
        } else if (alvo != noone && instance_exists(alvo)) {
            var dist_alvo = point_distance(x, y, alvo.x, alvo.y);
            
            // Verificar se o inimigo está se movendo
            var inimigo_movendo = false;
            if (variable_instance_exists(alvo, "velocidade") && alvo.velocidade > 0) {
                inimigo_movendo = true;
            } else if (variable_instance_exists(alvo, "speed") && alvo.speed > 0) {
                inimigo_movendo = true;
            } else if (variable_instance_exists(alvo, "estado") && alvo.estado == "movendo") {
                inimigo_movendo = true;
            } else if (variable_instance_exists(alvo, "vel") && alvo.vel > 0) {
                inimigo_movendo = true;
            }
            
            if (dist_alvo <= alcance_tiro) {
                // Lança míssil Sky se estiver no alcance
                if (atq_cooldown <= 0 && !missil_em_voo) {
                    // Criar míssil Sky (obj_sky) APENAS contra unidades aéreas
                    var m = instance_create_layer(x, y, layer, obj_sky);
                    m.direction = point_direction(x, y, alvo.x, alvo.y);
                    m.speed = 6; // Velocidade do míssil
                    m.dano = dano;
                    m.alvo = alvo;
                    m.lancador = id;
                    
                    missil_em_voo = true;
                    missil_criado = m;
                    atq_cooldown = atq_rate;
                    
                    // === SOM DE DISPARO COM CONTROLE DE DISTÂNCIA ===
                    // Calcular distância da câmera até a unidade
                    var camera_x = camera_get_view_x(view_camera[0]);
                    var camera_y = camera_get_view_y(view_camera[0]);
                    var camera_w = camera_get_view_width(view_camera[0]);
                    var camera_h = camera_get_view_height(view_camera[0]);
                    var camera_center_x = camera_x + camera_w / 2;
                    var camera_center_y = camera_y + camera_h / 2;
                    
                    var dist_camera = point_distance(x, y, camera_center_x, camera_center_y);
                    var max_dist_som = camera_w * 0.8; // Som audível até 80% da largura da tela
                    
                    // Calcular volume baseado na distância (0.0 a 1.0)
                    var volume_som = max(0.0, 1.0 - (dist_camera / max_dist_som));
                    
                    // Tocar som apenas se estiver próximo o suficiente
                    if (volume_som > 0.1) {
                        audio_play_sound(som_anti, volume_som, false, false);
                        show_debug_message("[SOM] Soldado Anti-Aéreo disparou - Volume: " + string(volume_som) + " | Distância: " + string(dist_camera));
                    }
                    
                    global.debug_log("Míssil aéreo lançado contra alvo!");
                }
                image_angle = point_direction(x, y, alvo.x, alvo.y);
                
                // Se o inimigo está parado, o soldado também para
                if (!inimigo_movendo) {
                    // Fica parado atirando
                } else {
                    // Se o inimigo está andando, pode seguir e atirar
                    if (dist_alvo > alcance_tiro - 30) {
                        var dir_x = alvo.x - x;
                        var dir_y = alvo.y - y;
                        var dist_norm = point_distance(0, 0, dir_x, dir_y);
                        if (dist_norm > 0) {
                            var dist_ideal = alcance_tiro - 20;
                            var target_x = x + (dir_x / dist_norm) * (dist_alvo - dist_ideal);
                            var target_y = y + (dir_y / dist_norm) * (dist_alvo - dist_ideal);
                            mp_potential_step(target_x, target_y, velocidade, false);
                            image_angle = point_direction(0, 0, dir_x, dir_y);
                        }
                    }
                }
            } else if (dist_alvo > alcance_tiro && dist_alvo <= alcance_visao) {
                // Aproxima-se do inimigo aéreo
                var dir_x = alvo.x - x;
                var dir_y = alvo.y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    var dist_ideal = alcance_tiro - 20;
                    var target_x = x + (dir_x / dist_norm) * (dist_alvo - dist_ideal);
                    var target_y = y + (dir_y / dist_norm) * (dist_alvo - dist_ideal);
                    mp_potential_step(target_x, target_y, velocidade, false);
                    image_angle = point_direction(0, 0, dir_x, dir_y);
                }
            } else {
                // Inimigo muito longe, volta para patrulha
                alvo = noone;
                estado = "patrulhando";
            }
        } else {
            alvo = noone;
            estado = "patrulhando";
        }
    break;
    
    case "seguindo":
        if (seguir_alvo != noone && instance_exists(seguir_alvo)) {
            var dist_seguir = point_distance(x, y, seguir_alvo.x, seguir_alvo.y);
            if (dist_seguir > 40) {
                mp_potential_step(seguir_alvo.x, seguir_alvo.y, velocidade, false);
                image_angle = point_direction(x, y, seguir_alvo.x, seguir_alvo.y);
            }
        } else {
            estado = "parado";
            seguir_alvo = noone;
        }
    break;
}

// =======================
// VERIFICAÇÃO DE MÍSSIL EM VOO
// =======================
if (missil_em_voo && missil_criado != noone) {
    if (!instance_exists(missil_criado)) {
        // Míssil foi destruído ou atingiu o alvo
        missil_em_voo = false;
        missil_criado = noone;
    }
}
