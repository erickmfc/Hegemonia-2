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
        if (estado == "movendo" || variable_instance_exists(id, "destino_x")) {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            var dest_x = (variable_instance_exists(id, "destino_x")) ? destino_x : x;
            var dest_y = (variable_instance_exists(id, "destino_y")) ? destino_y : y;
            // ✅ CORREÇÃO: Normalizar velocidade antes de aplicar multiplicador do LOD
            var _vel_normalizada = scr_normalize_unit_speed(velocidade);
            var still_moving = scr_process_lod_simple_movement(id, dest_x, dest_y, _vel_normalizada, speed_mult);
            
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
// DETECÇÃO DE INIMIGOS AÉREOS APENAS
// =======================
// ✅ NOVO: Respeitar modo_ataque igual outras unidades
if (modo_ataque && (estado != "atacando" || alvo == noone || !instance_exists(alvo))) {
    // Buscar apenas inimigos AÉREOS (verificar nacao_proprietaria)
        var _alvo_aereo = noone;
        var _menor_dist = 999999;
        
        // Buscar em todos os tipos aéreos, mas apenas INIMIGOS
        var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_c100, obj_f15, obj_su35];
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
            show_debug_message("🎯 Blindado Anti-Aéreo detectou alvo aéreo INIMIGO!");
    }
} else if (!modo_ataque) {
    // Modo passivo - não ataca
    alvo = noone;
    if (estado == "atacando") estado = "parado";
}

// CONTROLES (iguais ao soldado, com coordenadas de mundo)
if (selecionado) {
    // ✅ Modo Passivo (P) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("P"))) {
        modo_ataque = false;
        alvo = noone;
        if (estado == "atacando") estado = "parado";
        show_debug_message("🛡️ Blindado Anti-Aéreo em Modo PASSIVO");
    }
    
    // ✅ Modo Ataque (O) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("O"))) {
        modo_ataque = true;
        show_debug_message("⚔️ Blindado Anti-Aéreo em Modo ATAQUE AGRESSIVO");
    }
    
    // ✅ Parar (L) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("L"))) {
        estado = "parado";
        alvo = noone;
        // Limpar patrulha se existir
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
            ds_list_clear(pontos_patrulha);
        }
        show_debug_message("⏹️ Blindado Anti-Aéreo recebeu ordem para PARAR");
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
        // ✅ CORREÇÃO GM1041: Verificar se variáveis existem antes de usar
        if (variable_instance_exists(id, "destino_x") && variable_instance_exists(id, "destino_y") && variable_instance_exists(id, "velocidade")) {
            var _dest_x = destino_x;
            var _dest_y = destino_y;
            var _vel = velocidade;
            if (is_real(_dest_x) && is_real(_dest_y) && is_real(_vel)) {
                if (point_distance(x, y, _dest_x, _dest_y) > 6) {
                    // Calcular direção para o destino
                    var dir = point_direction(x, y, _dest_x, _dest_y);
                    
                    // ✅ NOVO: Detectar obstáculos e calcular rota alternativa
                    var _resultado_desvio = scr_detectar_obstaculo(x, y, dir, _dest_x, _dest_y, 50, id);
                    var _direcao_final = _resultado_desvio[0];
                    var _destino_temp_x = _resultado_desvio[1];
                    var _destino_temp_y = _resultado_desvio[2];
                    
                    // ✅ NOVO: Se encontrou obstáculo, atualizar destino temporário
                    if (_destino_temp_x != _dest_x || _destino_temp_y != _dest_y) {
                        // ✅ CORREÇÃO: Verificar se variável existe antes de acessar
                        if (!variable_instance_exists(id, "destino_original_x")) {
                            destino_original_x = _dest_x;
                            destino_original_y = _dest_y;
                        }
                        destino_x = _destino_temp_x;
                        destino_y = _destino_temp_y;
                        _direcao_final = point_direction(x, y, destino_x, destino_y);
                    }
                    
                    // Movimento com desvio se necessário
                    var dx = lengthdir_x(_vel, _direcao_final);
                    var dy = lengthdir_y(_vel, _direcao_final);
                    x += dx;
                    y += dy;
                    image_angle = _direcao_final;
                } else {
                    // Chegou ao destino temporário ou final
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
                    var _missil = scr_get_projectile_from_pool(obj_SkyFury_ar, x, y, "Instances");
                    if (instance_exists(_missil)) {
                        _missil.target = alvo;
                        _missil.alvo = alvo;
                        _missil.dono = id;
                        _missil.direction = point_direction(x, y, alvo.x, alvo.y);
                        atq_cooldown = atq_rate;
                        show_debug_message("🚀 Blindado Anti-Aéreo disparou SkyFury!");
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
                    // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom
                    var _vel_normalizada = scr_normalize_unit_speed(velocidade);
                    x += lengthdir_x(_vel_normalizada, dir);
                    y += lengthdir_y(_vel_normalizada, dir);
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

// =============================================
// ✅ SISTEMA DE COLISÃO FÍSICA
// =============================================
// Verificar colisões apenas a cada 3 frames para melhorar performance
// ✅ CORREÇÃO: Verificar se a função existe antes de chamar para evitar erro
if (variable_global_exists("game_frame") && global.game_frame % 3 == 0) {
    var _script_index = asset_get_index("scr_colisao_fisica_unidades");
    if (_script_index != -1 && asset_get_type(_script_index) == asset_script) {
        scr_colisao_fisica_unidades(id, 35, 0.9); // Raio médio para blindados
    }
}
