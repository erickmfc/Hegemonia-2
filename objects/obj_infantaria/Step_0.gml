/// STEP EVENT - Lógica do soldado

// =============================================
// VERIFICAÇÃO CRÍTICA (SEMPRE PROCESSAR)
// =============================================
if (hp_atual <= 0) {
    instance_destroy();
    exit;
}

// =============================================
// ✅ STANDBY DESABILITADO PARA UNIDADES INIMIGAS
// (Sistema estava impedindo ataque da IA)
// =============================================
/*
if (scr_is_enemy_unit(id)) {
    if (variable_instance_exists(id, "standby_mode") && standby_mode) {
        // Unidade em standby - apenas atualizar posição básica se estiver movendo
        if (variable_instance_exists(id, "estado") && estado == "movendo") {
            // Movimento simplificado em standby (apenas a cada 3 frames)
            var _frame_count = (variable_global_exists("game_frame") ? global.game_frame : current_time) % 3;
            if (_frame_count != 0) {
                exit; // Pular Step
            }
            // Continuar para processar movimento simplificado abaixo
            var dist_destino = point_distance(x, y, destino_x, destino_y);
            if (dist_destino > velocidade * 2) {
                var dir_x = destino_x - x;
                var dir_y = destino_y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    x += (dir_x / dist_norm) * velocidade * 2;
                    y += (dir_y / dist_norm) * velocidade * 2;
                }
            } else {
                x = destino_x;
                y = destino_y;
                estado = "parado";
            }
        }
        exit; // Unidade parada em standby - pular Step completamente
    }
}
*/

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

// ✅ SEMPRE processar se selecionado ou em combate crítico
var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando");

// ✅ Se não for sempre processar, verificar frame skip
if (!should_always_process && skip_frames_enabled) {
    // Obter LOD atual usando script otimizado
    var current_lod = scr_get_lod_level();
    
    // Calcular se deve pular este frame
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        // === MODO FRAME SKIP: Processar apenas movimento básico ===
        
        // Se está movendo, aplicar movimento simplificado
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade, speed_mult);
            
            if (!still_moving && estado == "movendo") {
                estado = "parado";
            }
        }
        
        // Sair sem processar IA, animações, cooldowns, etc.
        exit;
    }
    
    // Atualizar lod_level para outras lógicas
    lod_level = current_lod;
}

// =======================
// RESFRIAMENTO DO TIRO
// =======================
if (atq_cooldown > 0) atq_cooldown--;

// =======================
// DETECÇÃO DE INIMIGOS
// =======================
// Só procura novo alvo se modo ataque está ativo
if (modo_ataque && (estado != "atacando" || alvo == noone || !instance_exists(alvo))) {
    // Buscar inimigos considerando nacao_proprietaria
    var _nacao = (variable_instance_exists(id, "nacao_proprietaria")) ? nacao_proprietaria : 1;
    var _alcance = variable_instance_exists(id, "alcance_visao") && is_real(alcance_visao) ? alcance_visao : 200;
    alvo = scr_buscar_inimigo(x, y, _alcance, _nacao);
    if (alvo != noone && point_distance(x, y, alvo.x, alvo.y) <= _alcance) {
        estado = "atacando";
    }
} else if (!modo_ataque) {
    // Modo passivo - não ataca
    alvo = noone;
    if (estado == "atacando") estado = "parado";
}

// ======================
// CONTROLE POR TECLAS
// ======================
if (selecionado) {
    
    // ✅ NOVO: Modo Passivo (P)
    if (keyboard_check_pressed(ord("P"))) {
        modo_ataque = false;
        alvo = noone;
        if (estado == "atacando") estado = "parado";
        if (global.debug_enabled) show_debug_message("🛡️ Infantaria - Modo PASSIVO");
    }
    
    // ✅ NOVO: Modo Ataque (O)
    if (keyboard_check_pressed(ord("O"))) {
        modo_ataque = true;
        if (global.debug_enabled) show_debug_message("⚔️ Infantaria - Modo ATAQUE");
    }
    
    // ✅ NOVO: Parar (L)
    if (keyboard_check_pressed(ord("L"))) {
        estado = "parado";
        alvo = noone;
        modo_patrulha = false; // Cancela patrulha
        if (global.debug_enabled) show_debug_message("⏹️ Infantaria - PARADA");
    }
    
    // ENTRAR/SAIR DO MODO PATRULHA (Q)
    if (keyboard_check_pressed(ord("Q"))) {
        if (!modo_patrulha) {
            // Entrar no modo patrulha
            modo_patrulha = true;
            ds_list_clear(patrulha); // limpa patrulha anterior
            patrulha_indice = 0;
            if (global.debug_enabled) show_debug_message("Modo patrulha ativado - clique direito nos pontos");
        } else {
            // Sair do modo patrulha
            modo_patrulha = false;
            if (ds_list_size(patrulha) > 0) {
                estado = "patrulhando";
                if (global.debug_enabled) show_debug_message("Patrulha iniciada com " + string(ds_list_size(patrulha)) + " pontos");
            } else {
                if (global.debug_enabled) show_debug_message("Modo patrulha desativado - nenhum ponto definido");
            }
        }
    }
    
    // SAIR DO MODO PATRULHA (clique esquerdo)
    if (modo_patrulha && mouse_check_button_pressed(mb_left)) {
        modo_patrulha = false;
        if (ds_list_size(patrulha) > 0) {
            estado = "patrulhando";
            if (global.debug_enabled) show_debug_message("Patrulha iniciada com " + string(ds_list_size(patrulha)) + " pontos");
        } else {
            if (global.debug_enabled) show_debug_message("Modo patrulha desativado - nenhum ponto definido");
        }
    }
    
    // ADICIONAR PONTO DE PATRULHA (botão direito no modo patrulha)
    if (modo_patrulha && mouse_check_button_pressed(mb_right)) {
        // ✅ CORREÇÃO: Usar função para coordenadas precisas
        var _coords = scr_mouse_to_world();
        var world_x = _coords[0];
        var world_y = _coords[1];
        var pos = [world_x, world_y];
        ds_list_add(patrulha, pos);
        if (global.debug_enabled) show_debug_message("[PATRULHA] Ponto adicionado (mundo): " + string(world_x) + ", " + string(world_y));
    }
    
    // ANDAR (botão direito - só se não estiver no modo patrulha)
    if (!modo_patrulha && mouse_check_button_pressed(mb_right)) {
        // ✅ CORREÇÃO: Usar função para coordenadas precisas
        var _coords = scr_mouse_to_world();
        var world_x = _coords[0];
        var world_y = _coords[1];
        
        // ✅ CORREÇÃO CRÍTICA: Clamp para dentro da sala
        world_x = clamp(world_x, 8, room_width - 8);
        world_y = clamp(world_y, 8, room_height - 8);
        
        // Verificar se há múltiplas unidades selecionadas
        var unidades_selecionadas = 0;
        var primeira_unidade = noone;
        with (obj_infantaria) {
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
            
            // Primeiro, mover infantaria
            with (obj_infantaria) {
                if (selecionado) {
                    // Calcular posição na formação (grid 4x4 para acomodar mais unidades)
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    
                    // Offset da formação (espaçamento de 45 pixels para infantaria)
                    var offset_x = (coluna - 1.5) * 45;
                    var offset_y = (linha - 1.5) * 45;
                    
                    // Posição final na formação
                    destino_x = world_x + offset_x;
                    destino_y = world_y + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    
                    indice_formacao++;
                }
            }
            
            // Depois, mover tanques
            with (obj_tanque) {
                if (selecionado) {
                    // Calcular posição na formação (grid 4x4)
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    
                    // Offset da formação (espaçamento de 60 pixels para tanques - maiores)
                    var offset_x = (coluna - 1.5) * 60;
                    var offset_y = (linha - 1.5) * 60;
                    
                    // Posição final na formação
                    destino_x = world_x + offset_x;
                    destino_y = world_y + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    
                    indice_formacao++;
                }
            }
            if (global.debug_enabled) show_debug_message("Movimento em formação com " + string(unidades_selecionadas) + " unidades");
        } else {
            // UMA UNIDADE - MOVIMENTO NORMAL
            destino_x = world_x;
            destino_y = world_y;
            estado = "movendo";
            alvo = noone; // para de atacar
            image_angle = point_direction(x, y, destino_x, destino_y);
        }
    }
    
    // SEGUIR (E)
    if (keyboard_check_pressed(ord("E"))) {
        // ✅ CORREÇÃO: Usar função para coordenadas precisas
        var _coords = scr_mouse_to_world();
        var world_x = _coords[0];
        var world_y = _coords[1];
        var alvo_seg = instance_position(world_x, world_y, obj_infantaria);
        if (alvo_seg != noone && alvo_seg != id) {
            seguir_alvo = alvo_seg;
            estado = "seguindo";
            if (global.debug_enabled) show_debug_message("Seguindo unidade alvo");
} else {
            if (global.debug_enabled) show_debug_message("Nenhuma unidade encontrada para seguir");
        }
    }
    
    // PARAR (S)
    if (keyboard_check_pressed(ord("S"))) {
        estado = "parado";
        alvo = noone;
        seguir_alvo = noone;
        modo_patrulha = false;
        if (global.debug_enabled) show_debug_message("Soldado parado");
    }
    
    // CANCELAR SEGUIR (X)
    if (keyboard_check_pressed(ord("X"))) {
        seguir_alvo = noone;
        if (estado == "seguindo") {
            estado = "parado";
        }
        if (global.debug_enabled) show_debug_message("Comando de seguir cancelado");
    }
    
    // LIMPAR PATRULHA (R)
    if (keyboard_check_pressed(ord("R"))) {
        ds_list_clear(patrulha);
        patrulha_indice = 0;
        modo_patrulha = false;
        estado = "parado";
        if (global.debug_enabled) show_debug_message("Patrulha limpa");
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
        var dist_destino = point_distance(x, y, destino_x, destino_y);
        if (dist_destino > velocidade) {
            // Move na direção do destino
            var dir_x = destino_x - x;
            var dir_y = destino_y - y;
            var dist_norm = point_distance(0, 0, dir_x, dir_y);
            if (dist_norm > 0) {
                x += (dir_x / dist_norm) * velocidade;
                y += (dir_y / dist_norm) * velocidade;
                image_angle = point_direction(0, 0, dir_x, dir_y);
            }
        } else {
            // Para exatamente no destino
            x = destino_x;
            y = destino_y;
            estado = "parado";
        }
    break;
    
    case "patrulhando":
        // ✅ CORREÇÃO GM1041: Verificar se patrulha é ds_list válido
        if (ds_exists(patrulha, ds_type_list) && ds_list_size(patrulha) > 0) {
            // Se estamos iniciando patrulha, garante começar do ponto mais próximo ao soldado
            if (patrulha_indice >= ds_list_size(patrulha)) patrulha_indice = 0;
            var pt = ds_list_find_value(patrulha, patrulha_indice);
            if (is_array(pt) && array_length(pt) >= 2) {
                var px = is_real(pt[0]) ? pt[0] : x;
                var py = is_real(pt[1]) ? pt[1] : y;
                var _vel = variable_instance_exists(id, "velocidade") && is_real(velocidade) ? velocidade : 2;
                var dist_patrulha = point_distance(x, y, px, py);
                if (dist_patrulha > _vel) {
                    var dir_x = px - x;
                    var dir_y = py - y;
                    var dist_norm = point_distance(0, 0, dir_x, dir_y);
                    if (dist_norm > 0) {
                        x += (dir_x / dist_norm) * _vel;
                        y += (dir_y / dist_norm) * _vel;
                        image_angle = point_direction(0, 0, dir_x, dir_y);
                    }
                } else {
                    x = px;
                    y = py;
                    patrulha_indice = (patrulha_indice + 1) mod ds_list_size(patrulha);
                }
            }
        }
    break;
    
    case "atacando":
        if (alvo != noone && !instance_exists(alvo)) {
            // Inimigo eliminado, volta para patrulha
            alvo = noone;
            estado = "patrulhando";
        } else if (alvo != noone && instance_exists(alvo)) {
            // ✅ VERIFICAR SE O ALVO É AÉREO - SOLDADOS NÃO ATACAM AVIÕES
            var _alvo_aereo = (alvo.object_index == obj_caca_f5 || 
                              alvo.object_index == obj_f15 || 
                              alvo.object_index == obj_f6 ||
                              alvo.object_index == obj_helicoptero_militar ||
                              alvo.object_index == obj_c100);
            
            if (_alvo_aereo) {
                // É avião - soldados não podem atacar
                show_debug_message("⚠️ Soldado não pode atacar unidade aérea!");
                alvo = noone;
                estado = "patrulhando";
                break;
            }
            
            var dist_alvo = point_distance(x, y, alvo.x, alvo.y);
            
            // Verificar se o inimigo está se movendo
            var inimigo_movendo = false;
            if (variable_instance_exists(alvo, "velocidade") && alvo.velocidade > 0) {
                inimigo_movendo = true;
            } else if (variable_instance_exists(alvo, "speed") && alvo.speed > 0) {
                inimigo_movendo = true;
            } else if (variable_instance_exists(alvo, "estado") && alvo.estado == "movendo") {
                inimigo_movendo = true;
            }
            
            if (dist_alvo <= alcance) {
                // Atira se estiver no alcance
                if (atq_cooldown <= 0) {
                    var b = scr_get_projectile_from_pool(obj_tiro_infantaria, x, y, layer);
                    b.direction = point_direction(x, y, alvo.x, alvo.y);
                    b.speed = 8;
                    b.dano = 5;
                    b.alvo = alvo;
                    atq_cooldown = atq_rate;
                }
                image_angle = point_direction(x, y, alvo.x, alvo.y);
                
                // Se o inimigo está parado, o soldado também para
                if (!inimigo_movendo) {
                    // Fica parado atirando
                } else {
                    // Se o inimigo está andando, pode seguir e atirar
                    if (dist_alvo > alcance - 30) { // Mantém distância mínima
                        var dir_x = alvo.x - x;
                        var dir_y = alvo.y - y;
                        var dist_norm = point_distance(0, 0, dir_x, dir_y);
                        if (dist_norm > 0) {
                            var dist_ideal = alcance - 20;
                            var target_x = x + (dir_x / dist_norm) * (dist_alvo - dist_ideal);
                            var target_y = y + (dir_y / dist_norm) * (dist_alvo - dist_ideal);
                            mp_potential_step(target_x, target_y, velocidade, false);
                            image_angle = point_direction(0, 0, dir_x, dir_y);
                        }
                    }
                }
            } else if (dist_alvo > alcance && dist_alvo <= alcance_visao) {
                // Aproxima-se do inimigo
                var dir_x = alvo.x - x;
                var dir_y = alvo.y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    var dist_ideal = alcance - 20;
                    var target_x = x + (dir_x / dist_norm) * (dist_norm - dist_ideal);
                    var target_y = y + (dir_y / dist_norm) * (dist_norm - dist_ideal);
                    mp_potential_step(target_x, target_y, velocidade, false);
                    image_angle = point_direction(0, 0, dir_x, dir_y);
                }
            } else {
                // Inimigo muito longe, volta para patrulha
                alvo = noone;
                estado = "patrulhando";
            }
        } else {
            // Alvo não existe mais, volta para patrulha
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
