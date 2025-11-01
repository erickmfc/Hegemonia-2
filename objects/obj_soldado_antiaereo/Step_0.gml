// =============================================
// STEP - Verificação de Standby para unidades inimigas
// =============================================

// ✅ CORREÇÃO: Unidades inimigas em standby têm Step simplificado
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

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" ||
                              estado == "movendo" || // ✅ CORREÇÃO: Sempre processar quando está se movendo
                              estado == "patrulhando"); // ✅ CORREÇÃO: Sempre processar quando está patrulhando

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo" || variable_instance_exists(id, "destino_x")) {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            var dest_x = (variable_instance_exists(id, "destino_x")) ? destino_x : x;
            var dest_y = (variable_instance_exists(id, "destino_y")) ? destino_y : y;
            var still_moving = scr_process_lod_simple_movement(id, dest_x, dest_y, velocidade, speed_mult);
            
            if (!still_moving && estado == "movendo") {
                estado = "parado";
            }
        }
        exit;
    }
    lod_level = current_lod;
}

// =======================
// RESFRIAMENTO DO TIRO
// =======================
if (atq_cooldown > 0) atq_cooldown--;

// =======================
// DETECÇÃO DE INIMIGOS AÉREOS APENAS
// =======================
// Procura apenas alvos AÉREOS sempre, exceto quando em movimento manual
if (estado != "movendo") {
    // Se não está atacando ou perdeu o alvo, procurar novo alvo
    if (estado != "atacando" || alvo == noone || !instance_exists(alvo)) {
        // ✅ CORREÇÃO: Buscar apenas inimigos AÉREOS (verificar nacao_proprietaria)
        var _alvo_aereo = noone;
        var _menor_dist = 999999;
        
        // Buscar em todos os tipos aéreos, mas apenas INIMIGOS
        var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_c100, obj_f15];
        for (var i = 0; i < array_length(_tipos_aereos); i++) {
            if (!object_exists(_tipos_aereos[i])) continue;
            with (_tipos_aereos[i]) {
                // ✅ CORREÇÃO CRÍTICA: Verificar se é INIMIGO (nacao diferente)
                if (variable_instance_exists(id, "nacao_proprietaria") && 
                    nacao_proprietaria != other.nacao_proprietaria) {
                    var _dist = point_distance(x, y, other.x, other.y);
                    if (_dist <= other.alcance_visao && _dist < _menor_dist) {
                        _menor_dist = _dist;
                        _alvo_aereo = id;
                    }
                }
            }
        }
        
        alvo = _alvo_aereo;
        
        if (alvo != noone && instance_exists(alvo)) {
            estado = "atacando";
            show_debug_message("🎯 Soldado Anti-Aéreo detectou alvo aéreo INIMIGO!");
        } else {
            // Se não há alvo aéreo próximo, volta para patrulha se tiver pontos
            if (ds_list_size(patrulha) > 0) {
                estado = "patrulhando";
            } else {
                estado = "parado";
            }
        }
    }
}

// CONTROLES (iguais ao soldado, com coordenadas de mundo)
if (selecionado) {
    // Mover com clique direito
    if (mouse_check_button_pressed(mb_right) && !modo_patrulha) {
        // ✅ CORREÇÃO: Usar função global para coordenadas precisas
        var _coords = global.scr_mouse_to_world();
        var world_x = _coords[0];
        var world_y = _coords[1];
        
        // ✅ CORREÇÃO CRÍTICA: Clamp para dentro da sala
        world_x = clamp(world_x, 8, room_width - 8);
        world_y = clamp(world_y, 8, room_height - 8);
        
        // Contar unidades selecionadas (infantaria + soldado anti-aéreo + tanque + blindado anti-aéreo)
        var unidades_selecionadas = 0;
        with (obj_infantaria) { if (selecionado) unidades_selecionadas++; }
        with (obj_soldado_antiaereo) { if (selecionado) unidades_selecionadas++; }
        with (obj_tanque) { if (selecionado) unidades_selecionadas++; }
        with (obj_blindado_antiaereo) { if (selecionado) unidades_selecionadas++; }
        
        if (unidades_selecionadas > 1) {
            // MÚLTIPLAS UNIDADES - MOVIMENTO EM FORMAÇÃO
            var indice_formacao = 0;
            
            // Primeiro, mover infantaria
            with (obj_infantaria) {
                if (selecionado) {
                    // Calcular posição na formação (grid 4x4 para acomodar mais unidades)
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    
                    // Offset da formação (espaçamento de 50 pixels para tanques)
                    var offset_x = (coluna - 1.5) * 50;
                    var offset_y = (linha - 1.5) * 50;
                    
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
            
            // Por último, mover blindados anti-aéreos
            with (obj_blindado_antiaereo) {
                if (selecionado) {
                    // Calcular posição na formação (grid 4x4)
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    
                    // Offset da formação (espaçamento de 65 pixels para blindados - maiores que tanques)
                    var offset_x = (coluna - 1.5) * 65;
                    var offset_y = (linha - 1.5) * 65;
                    
                    // Posição final na formação
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
    
    // Patrulha (Q) - limpa patrulha anterior e inicia nova
    if (keyboard_check_pressed(ord("Q"))) {
        if (modo_patrulha) {
            // Se já está em modo patrulha, limpar e sair
            ds_list_clear(patrulha);
            modo_patrulha = false;
            estado = "parado";
        } else {
            // Entrar em modo patrulha
            ds_list_clear(patrulha);
            modo_patrulha = true;
            estado = "parado";
        }
    }
    
    // Adicionar pontos de patrulha com clique direito quando em modo patrulha
    if (modo_patrulha && mouse_check_button_pressed(mb_right)) {
        // ✅ CORREÇÃO: Usar função global para coordenadas precisas
        var _coords = global.scr_mouse_to_world();
        var px = _coords[0];
        var py = _coords[1];
        
        // ✅ CORREÇÃO CRÍTICA: Clamp para dentro da sala
        px = clamp(px, 8, room_width - 8);
        py = clamp(py, 8, room_height - 8);
        
        var pos = [px, py];
        // ✅ CORREÇÃO GM1041: Converter array para ds_list corretamente
        if (!ds_exists(patrulha, ds_type_list)) {
            patrulha = ds_list_create();
        }
        ds_list_add(patrulha, pos);
        
        // Se é o primeiro ponto, já começa a patrulhar
        if (ds_list_size(patrulha) == 1) {
            estado = "patrulhando";
            patrulha_indice = 0;
        }
    }
    
    // Seguir (E)
    if (keyboard_check_pressed(ord("E"))) {
        var sx = camera_get_view_x(view_camera[0]) + mouse_x;
        var sy = camera_get_view_y(view_camera[0]) + mouse_y;
        var alvo_seg = instance_position(sx, sy, obj_infantaria);
        if (alvo_seg != noone && alvo_seg != id) {
            seguir_alvo = alvo_seg;
            estado = "seguindo";
        }
    }
}

// =======================
// ESTADOS
// =======================
switch (estado) {
    case "parado":
    break;
    
    case "movendo":
        // ✅ CORREÇÃO GM1041: Verificar se variáveis existem antes de usar
        if (variable_instance_exists(id, "destino_x") && variable_instance_exists(id, "destino_y") && variable_instance_exists(id, "velocidade")) {
            var _dest_x = destino_x;
            var _dest_y = destino_y;
            var _vel = velocidade;
            if (is_real(_dest_x) && is_real(_dest_y) && is_real(_vel)) {
                if (point_distance(x, y, _dest_x, _dest_y) > 6) {
                    // Movimento estilo infantaria (sem rastro/borrao)
                    var dir = point_direction(x, y, _dest_x, _dest_y);
                    var dx = lengthdir_x(_vel, dir);
                    var dy = lengthdir_y(_vel, dir);
                    x += dx;
                    y += dy;
                    image_angle = dir;
                } else {
                    estado = "parado";
                }
            }
        }
    break;
    
    case "patrulhando":
        // ✅ CORREÇÃO: Verificar se há alvo AÉREO INIMIGO próximo durante a patrulha
        var inimigo_proximo = noone;
        var _menor_dist = 999999;
        
        // Buscar em todos os tipos aéreos, mas apenas INIMIGOS
        var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_c100, obj_f15];
        for (var i = 0; i < array_length(_tipos_aereos); i++) {
            if (!object_exists(_tipos_aereos[i])) continue;
            with (_tipos_aereos[i]) {
                // ✅ CORREÇÃO CRÍTICA: Verificar se é INIMIGO (nacao diferente)
                if (variable_instance_exists(id, "nacao_proprietaria") && 
                    nacao_proprietaria != other.nacao_proprietaria) {
                    var _dist = point_distance(x, y, other.x, other.y);
                    if (_dist <= other.alcance_visao && _dist < _menor_dist) {
                        _menor_dist = _dist;
                        inimigo_proximo = id;
                    }
                }
            }
        }
        
        if (inimigo_proximo != noone && instance_exists(inimigo_proximo)) {
            // Alvo aéreo INIMIGO detectado! Parar patrulha e atacar
            alvo = inimigo_proximo;
            estado = "atacando";
        } else if (ds_exists(patrulha, ds_type_list) && ds_list_size(patrulha) > 0) {
            // Continuar patrulha normalmente
            var pt = ds_list_find_value(patrulha, patrulha_indice);
            if (is_array(pt) && array_length(pt) >= 2) {
                var px = is_real(pt[0]) ? pt[0] : 0;
                var py = is_real(pt[1]) ? pt[1] : 0;
                if (variable_instance_exists(id, "velocidade") && is_real(velocidade)) {
                    if (point_distance(x, y, px, py) > 6) {
                        var dirp = point_direction(x, y, px, py);
                        x += lengthdir_x(velocidade, dirp);
                        y += lengthdir_y(velocidade, dirp);
                        image_angle = dirp;
                    } else {
                        patrulha_indice = (patrulha_indice + 1) mod ds_list_size(patrulha);
                    }
                }
            }
        }
    break;
    
    case "atacando":
        if (alvo != noone && !instance_exists(alvo)) {
            // Inimigo eliminado, procurar novo alvo
            alvo = noone;
            if (ds_list_size(patrulha) > 0) {
                estado = "patrulhando";
            } else {
                estado = "parado";
            }
        } else if (alvo != noone && instance_exists(alvo)) {
            var dist_alvo = point_distance(x, y, alvo.x, alvo.y);
            
            // Verificar se o alvo é aéreo
            var _alvo_aereo = (alvo.object_index == obj_helicoptero_militar || 
                              alvo.object_index == obj_caca_f5 || 
                              alvo.object_index == obj_f6 ||
                              alvo.object_index == obj_c100 ||
                              alvo.object_index == obj_f15);
            
            if (_alvo_aereo && dist_alvo <= alcance_tiro) {
                // Atira se estiver no alcance E for alvo aéreo
                if (atq_cooldown <= 0) {
                    // Criar míssil SkyFury via pool
                    var _missil = scr_get_projectile_from_pool(obj_SkyFury_ar, x, y, layer);
                    if (instance_exists(_missil)) {
                        _missil.direction = point_direction(x, y, alvo.x, alvo.y);
                        _missil.speed = 6;
                        _missil.dano = dano;
                        _missil.alvo = alvo;
                        _missil.lancador = id;
                        if (variable_instance_exists(_missil, "timer_vida")) {
                            _missil.timer_vida = 300;
                        }
                        atq_cooldown = atq_rate;
                        show_debug_message("🚀 Soldado Anti-Aéreo disparou Sky!");
                    }
                }
                image_angle = point_direction(x, y, alvo.x, alvo.y);
                
                // Tanque para para atirar com precisão
            } else if (dist_alvo > alcance_tiro && dist_alvo <= alcance_visao && variable_instance_exists(id, "velocidade") && is_real(velocidade)) {
                // Aproxima-se do inimigo
                var dir_x = alvo.x - x;
                var dir_y = alvo.y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    var dist_ideal = alcance_tiro - 30; // Mantém distância ideal
                    var target_x = x + (dir_x / dist_norm) * (dist_alvo - dist_ideal);
                    var target_y = y + (dir_y / dist_norm) * (dist_alvo - dist_ideal);
                    
                    var dir = point_direction(x, y, target_x, target_y);
                    x += lengthdir_x(velocidade, dir);
                    y += lengthdir_y(velocidade, dir);
                    image_angle = dir;
                }
            } else {
                // Inimigo muito longe, volta para patrulha
                alvo = noone;
                if (ds_exists(patrulha, ds_type_list) && ds_list_size(patrulha) > 0) {
                    estado = "patrulhando";
                } else {
                    estado = "parado";
                }
            }
        } else {
            // Alvo não existe mais, volta para patrulha
            alvo = noone;
            if (ds_exists(patrulha, ds_type_list) && ds_list_size(patrulha) > 0) {
                estado = "patrulhando";
            } else {
                estado = "parado";
            }
        }
    break;
    
    case "seguindo":
        if (seguir_alvo != noone) {
            if (instance_exists(seguir_alvo) && variable_instance_exists(id, "velocidade") && is_real(velocidade)) {
                mp_potential_step(seguir_alvo.x, seguir_alvo.y, velocidade, false);
                image_angle = point_direction(x, y, seguir_alvo.x, seguir_alvo.y);
            } else {
                estado = "parado";
                seguir_alvo = noone;
            }
        }
    break;
}
