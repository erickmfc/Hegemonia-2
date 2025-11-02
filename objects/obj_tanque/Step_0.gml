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
        // Frame skip: movimento simplificado apenas
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade, speed_mult);
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
// DETECÇÃO DE INIMIGOS (melhorada)
// =======================
// ✅ CORRIGIDO: Unidades podem procurar inimigos mesmo movendo
if (modo_ataque) {
    // Se não está atacando ou perdeu o alvo, procurar novo alvo
    if (estado != "atacando" || alvo == noone || !instance_exists(alvo)) {
        // ✅ CORREÇÃO: Usar scr_buscar_inimigo() para considerar nacao_proprietaria
        var _nacao = (variable_instance_exists(id, "nacao_proprietaria")) ? nacao_proprietaria : 1;
        var _alvo_temp = scr_buscar_inimigo(x, y, alcance_visao, _nacao);
        if (_alvo_temp != noone && _alvo_temp != undefined && instance_exists(_alvo_temp)) {
            alvo = _alvo_temp;
        }
        
        if (alvo != noone && instance_exists(alvo) && point_distance(x, y, alvo.x, alvo.y) <= alcance_visao) {
            estado = "atacando";
            if (global.debug_enabled) show_debug_message("🎯 Tanque encontrou inimigo - atacando!");
        }
    }
} else if (!modo_ataque) {
    // Modo passivo - não ataca
    alvo = noone;
    if (estado == "atacando") estado = "parado";
}

// CONTROLES
if (selecionado) {
    // ✅ NOVO: Modo Passivo (P)
    if (keyboard_check_pressed(ord("P"))) {
        modo_ataque = false;
        alvo = noone;
        if (estado == "atacando") estado = "parado";
        if (global.debug_enabled) show_debug_message("🛡️ Tanque - Modo PASSIVO");
    }
    
    // ✅ NOVO: Modo Ataque (O)
    if (keyboard_check_pressed(ord("O"))) {
        modo_ataque = true;
        if (global.debug_enabled) show_debug_message("⚔️ Tanque - Modo ATAQUE");
    }
    
    // ✅ NOVO: Parar (L)
    if (keyboard_check_pressed(ord("L"))) {
        estado = "parado";
        alvo = noone;
        modo_patrulha = false;
        if (global.debug_enabled) show_debug_message("⏹️ Tanque - PARADO");
    }
    
    // Movimento com clique direito (se não estiver no modo patrulha)
    // Mover com clique direito
    if (mouse_check_button_pressed(mb_right) && !modo_patrulha) {
        // ✅ CORREÇÃO: Usar função para coordenadas precisas
        var _coords = scr_mouse_to_world();
        var world_x = _coords[0];
        var world_y = _coords[1];
        
        // ✅ CORREÇÃO CRÍTICA: Clamp para dentro da sala
        world_x = clamp(world_x, 8, room_width - 8);
        world_y = clamp(world_y, 8, room_height - 8);
        
        // Contar unidades selecionadas (infantaria + tanque)
        var unidades_selecionadas = 0;
        with (obj_infantaria) { if (selecionado) unidades_selecionadas++; }
        with (obj_tanque) { if (selecionado) unidades_selecionadas++; }
        
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
        // ✅ CORREÇÃO: Usar função para coordenadas precisas
        var _coords = scr_mouse_to_world();
        var px = _coords[0];
        var py = _coords[1];
        
        // ✅ CORREÇÃO CRÍTICA: Clamp para dentro da sala
        px = clamp(px, 8, room_width - 8);
        py = clamp(py, 8, room_height - 8);
        
        var pos = [px, py];
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
        if (point_distance(x, y, destino_x, destino_y) > 6) {
            // Movimento estilo infantaria (sem rastro/borrao)
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
        // ✅ CORREÇÃO: Verificar se há inimigo próximo durante a patrulha usando scr_buscar_inimigo
        var _nacao_patrulha = (variable_instance_exists(id, "nacao_proprietaria")) ? nacao_proprietaria : 1;
        var _inimigo_temp = scr_buscar_inimigo(x, y, alcance_visao, _nacao_patrulha);
        var inimigo_proximo = (_inimigo_temp != undefined && _inimigo_temp != noone && instance_exists(_inimigo_temp)) ? _inimigo_temp : noone;
        
        if (inimigo_proximo != noone && instance_exists(inimigo_proximo) && point_distance(x, y, inimigo_proximo.x, inimigo_proximo.y) <= alcance_visao) {
            // Inimigo detectado! Parar patrulha e atacar
            alvo = inimigo_proximo;
            estado = "atacando";
            show_debug_message("🎯 Tanque detectou inimigo durante patrulha!");
        } else if (ds_list_size(patrulha) > 0) {
            // Continuar patrulha normalmente
            var pt = ds_list_find_value(patrulha, patrulha_indice);
            if (is_array(pt) && array_length(pt) >= 2) {
                var px = pt[0];
                var py = pt[1];
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
            // ✅ VERIFICAR SE O ALVO É AÉREO - TANQUES NÃO ATACAM AVIÕES
            var _alvo_aereo = (alvo.object_index == obj_caca_f5 || 
                              alvo.object_index == obj_f15 || 
                              alvo.object_index == obj_f6 ||
                              alvo.object_index == obj_helicoptero_militar ||
                              alvo.object_index == obj_c100);
            
            if (_alvo_aereo) {
                // É avião - tanques não podem atacar
                show_debug_message("⚠️ Tanque não pode atacar unidade aérea!");
                alvo = noone;
                if (ds_list_size(patrulha) > 0) {
                    estado = "patrulhando";
                } else {
                    estado = "parado";
                }
                break;
            }
            
            var dist = point_distance(x, y, alvo.x, alvo.y);
            
            if (dist <= alcance_tiro) {
                // Atira se estiver no alcance
                if (atq_cooldown <= 0) {
                    var b = scr_get_projectile_from_pool(obj_tiro_infantaria, x, y, layer);
                    if (instance_exists(b)) {
                        b.direction = point_direction(x, y, alvo.x, alvo.y);
                        b.speed = 12;      // mais rápido que infantaria
                        b.dano = 70;       // DOBRO DO DANO (era 35, agora 70)
                        b.dano_area = 40;  // Dano de área para explosão
                        b.raio_area = 80;  // Raio de explosão (80 pixels)
                        b.eh_tiro_tanque = true; // Flag para identificar tiro de tanque
                        b.alvo = alvo;     // manter alvo
                        b.image_blend = c_yellow; // cor amarela para diferenciar
                        if (variable_instance_exists(b, "timer_vida")) {
                            b.timer_vida = 120; // Resetar timer de vida
                        }
                    }
                    atq_cooldown = atq_rate;
                    
                    // ✅ CORREÇÃO: Tocar som apenas se a unidade estiver visível na câmera
                    // Verificação inline (sem depender de script)
                    var _cam = view_camera[0];
                    var _visivel = true; // Fallback: considerar visível
                    if (_cam != -1 && _cam != noone) {
                        var _cam_x = camera_get_view_x(_cam);
                        var _cam_y = camera_get_view_y(_cam);
                        var _cam_w = camera_get_view_width(_cam);
                        var _cam_h = camera_get_view_height(_cam);
                        if (_cam_w > 0 && _cam_h > 0) {
                            var _margin = 100;
                            var _view_left = _cam_x - _margin;
                            var _view_right = _cam_x + _cam_w + _margin;
                            var _view_top = _cam_y - _margin;
                            var _view_bottom = _cam_y + _cam_h + _margin;
                            _visivel = (x >= _view_left && x <= _view_right && y >= _view_top && y <= _view_bottom);
                        }
                    }
                    if (_visivel) {
                        if (variable_global_exists("som_tanque")) {
                            var _sound_index = asset_get_index("som_tanque");
                            if (_sound_index != -1) {
                                audio_play_sound(som_tanque, 5, false);
                            }
                        }
                    }
                }
                image_angle = point_direction(x, y, alvo.x, alvo.y);
                
                // Tanque para para atirar com precisão
            } else if (dist > alcance_tiro && dist <= alcance_visao) {
                // Aproxima-se do inimigo
                var dir_x = alvo.x - x;
                var dir_y = alvo.y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    var dist_ideal = alcance_tiro - 30; // Mantém distância ideal
                    var target_x = x + (dir_x / dist_norm) * (dist - dist_ideal);
                    var target_y = y + (dir_y / dist_norm) * (dist - dist_ideal);
                    
                    var dir = point_direction(x, y, target_x, target_y);
                    x += lengthdir_x(velocidade, dir);
                    y += lengthdir_y(velocidade, dir);
                    image_angle = dir;
                }
            } else {
                // Inimigo muito longe, volta para patrulha
                alvo = noone;
                if (ds_list_size(patrulha) > 0) {
                    estado = "patrulhando";
                } else {
                    estado = "parado";
                }
            }
        } else {
            // Alvo não existe mais, volta para patrulha
            alvo = noone;
            if (ds_list_size(patrulha) > 0) {
                estado = "patrulhando";
            } else {
                estado = "parado";
            }
        }
    break;
    
    case "seguindo":
        if (seguir_alvo != noone) {
            if (instance_exists(seguir_alvo)) {
                mp_potential_step(seguir_alvo.x, seguir_alvo.y, velocidade, false);
                image_angle = point_direction(x, y, seguir_alvo.x, seguir_alvo.y);
            } else {
                estado = "parado";
                seguir_alvo = noone;
            }
        }
    break;
}
