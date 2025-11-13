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
            // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom
            var _vel_normalizada = scr_normalize_unit_speed(velocidade);
            if (dist_destino > _vel_normalizada * 2) {
                var dir_x = destino_x - x;
                var dir_y = destino_y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    x += (dir_x / dist_norm) * _vel_normalizada * 2;
                    y += (dir_y / dist_norm) * _vel_normalizada * 2;
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
            // ✅ CORREÇÃO: Normalizar velocidade antes de aplicar multiplicador do LOD
            var _vel_normalizada = scr_normalize_unit_speed(velocidade);
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, _vel_normalizada, speed_mult);
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
    // ✅ Modo Passivo (P) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("P"))) {
        modo_ataque = false;
        alvo = noone;
        if (estado == "atacando") estado = "parado";
        show_debug_message("🛡️ Tanque em Modo PASSIVO");
    }
    
    // ✅ Modo Ataque (O) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("O"))) {
        modo_ataque = true;
        show_debug_message("⚔️ Tanque em Modo ATAQUE AGRESSIVO");
    }
    
    // ✅ Parar (L) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("L"))) {
        estado = "parado";
        alvo = noone;
        // Limpar patrulha se existir
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
            ds_list_clear(pontos_patrulha);
        }
        show_debug_message("⏹️ Tanque recebeu ordem para PARAR");
    }
    
    // ✅ Comandos K, clique esquerdo e clique direito agora são gerenciados pelo obj_input_manager
    // para evitar conflitos e manter o modo de patrulha persistente
}

// =======================
// ESTADOS
// =======================
switch (estado) {
    case "parado":
    break;
    
    case "movendo":
        if (point_distance(x, y, destino_x, destino_y) > 6) {
            // Calcular direção para o destino
            var dir = point_direction(x, y, destino_x, destino_y);
            
            // ✅ NOVO: Detectar obstáculos e calcular rota alternativa
            var _resultado_desvio = scr_detectar_obstaculo(x, y, dir, destino_x, destino_y, 50, id);
            var _direcao_final = _resultado_desvio[0];
            var _destino_temp_x = _resultado_desvio[1];
            var _destino_temp_y = _resultado_desvio[2];
            
            // ✅ NOVO: Se encontrou obstáculo, atualizar destino temporário para contornar
            if (_destino_temp_x != destino_x || _destino_temp_y != destino_y) {
                // Guardar destino original se ainda não foi guardado
                // ✅ CORREÇÃO: Verificar se variável existe antes de acessar
                if (!variable_instance_exists(id, "destino_original_x")) {
                    destino_original_x = destino_x;
                    destino_original_y = destino_y;
                }
                // Usar destino temporário para contornar obstáculo
                destino_x = _destino_temp_x;
                destino_y = _destino_temp_y;
                // Recalcular direção para o novo destino
                _direcao_final = point_direction(x, y, destino_x, destino_y);
            }
            
            // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom
            var _vel_normalizada = scr_normalize_unit_speed(velocidade);
            // Movimento com desvio se necessário
            var dx = lengthdir_x(_vel_normalizada, _direcao_final);
            var dy = lengthdir_y(_vel_normalizada, _direcao_final);
            x += dx;
            y += dy;
            image_angle = _direcao_final;
        } else {
            // Chegou ao destino temporário ou final
            // ✅ NOVO: Se estava usando destino temporário, voltar ao destino original
            // ✅ CORREÇÃO: Verificar se variável existe E se os valores são válidos (não undefined)
            if (variable_instance_exists(id, "destino_original_x") && variable_instance_exists(id, "destino_original_y") &&
                !is_undefined(destino_original_x) && !is_undefined(destino_original_y) &&
                is_real(destino_original_x) && is_real(destino_original_y)) {
                var _dist_original = point_distance(x, y, destino_original_x, destino_original_y);
                if (_dist_original > 50) {
                    destino_x = destino_original_x;
                    destino_y = destino_original_y;
                    estado = "movendo";
                } else {
                    // ✅ CORREÇÃO: Limpar variáveis temporárias (definir como undefined se existirem)
                    if (variable_instance_exists(id, "destino_original_x")) {
                        destino_original_x = undefined;
                    }
                    if (variable_instance_exists(id, "destino_original_y")) {
                        destino_original_y = undefined;
                    }
                    estado = "parado";
                }
            } else {
                estado = "parado";
            }
        }
    break;
    
    case "patrulhando":
        // ✅ CORREÇÃO: Sistema de patrulha igual navios/aviões com verificações de segurança
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
            // ✅ CORREÇÃO: Garantir que indice_patrulha_atual está dentro dos limites
            if (!variable_instance_exists(id, "indice_patrulha_atual")) {
                indice_patrulha_atual = 0;
            }
            var _total_pontos = ds_list_size(pontos_patrulha);
            if (indice_patrulha_atual >= _total_pontos) {
                indice_patrulha_atual = 0;
            }
            
            // Se chegou ao ponto atual, vai para o próximo
            if (point_distance(x, y, destino_x, destino_y) < 20) {
                indice_patrulha_atual = (indice_patrulha_atual + 1) % _total_pontos;
                var _ponto = pontos_patrulha[| indice_patrulha_atual];
                if (is_array(_ponto) && array_length(_ponto) >= 2) {
                    destino_x = _ponto[0];
                    destino_y = _ponto[1];
                }
            }
            
            // Movimento para o ponto atual
            if (point_distance(x, y, destino_x, destino_y) > 6) {
                // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom
                var _vel_normalizada = scr_normalize_unit_speed(velocidade);
                var dir = point_direction(x, y, destino_x, destino_y);
                x += lengthdir_x(_vel_normalizada, dir);
                y += lengthdir_y(_vel_normalizada, dir);
                image_angle = dir;
            }
        } else {
            // Sem pontos de patrulha - voltar para parado
            estado = "parado";
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
                        b.dano = 100;      // Dano aumentado
                        b.dano_area = 60;  // Dano de área para explosão (60px)
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
                    // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom
                    var _vel_normalizada = scr_normalize_unit_speed(velocidade);
                    x += lengthdir_x(_vel_normalizada, dir);
                    y += lengthdir_y(_vel_normalizada, dir);
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
