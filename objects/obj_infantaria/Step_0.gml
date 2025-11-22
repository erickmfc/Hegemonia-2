/// STEP EVENT - Lógica do soldado

// =============================================
// VERIFICAÇÃO CRÍTICA (SEMPRE PROCESSAR)
// =============================================
if (hp_atual <= 0) {
    // ✅ CORREÇÃO: Verificar se função existe antes de chamar
    var _script_restos = asset_get_index("scr_criar_restos_unidade");
    if (_script_restos != -1) {
    scr_criar_restos_unidade(id);
    }
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
            var _dist_destino_standby = point_distance(x, y, destino_x, destino_y);
            if (_dist_destino_standby > velocidade * 2) {
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

// ✅ SEMPRE processar se selecionado, em combate crítico, OU se for unidade da IA
var _eh_unidade_ia = (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2);
var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" ||
                              _eh_unidade_ia); // ✅ NOVO: Unidades da IA sempre processam

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
            // ✅ CORREÇÃO: Normalizar velocidade antes de aplicar multiplicador do LOD
            var _vel_normalizada = scr_normalize_unit_speed(velocidade);
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, _vel_normalizada, speed_mult);
            
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
// ✅ NOVO: Unidades da IA sempre atacam automaticamente
if (_eh_unidade_ia) {
    // Forçar modo ataque para unidades da IA
    modo_ataque = true;
    
    // Se tem alvo definido externamente (pela IA do presidente), usar ele
    if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
        var _dist_alvo = point_distance(x, y, alvo.x, alvo.y);
        if (_dist_alvo <= alcance) {
            estado = "atacando";
        } else if (_dist_alvo > alcance && variable_instance_exists(id, "destino_x") && variable_instance_exists(id, "destino_y")) {
            // Mover em direção ao alvo se tiver destino definido
            estado = "movendo";
            destino_x = alvo.x;
            destino_y = alvo.y;
        }
    } else if (estado == "atacando" && (alvo == noone || !instance_exists(alvo))) {
        // Buscar novo alvo se o anterior foi destruído
        var _nacao = 2; // IA
        var _alcance = variable_instance_exists(id, "alcance_visao") && is_real(alcance_visao) ? alcance_visao : 200;
        alvo = scr_buscar_inimigo(x, y, _alcance, _nacao);
        if (alvo != noone && point_distance(x, y, alvo.x, alvo.y) <= _alcance) {
            estado = "atacando";
        } else {
            // Se tem destino definido, mover para lá
            if (variable_instance_exists(id, "destino_x") && variable_instance_exists(id, "destino_y")) {
                estado = "movendo";
            } else {
                estado = "parado";
            }
        }
    }
} else {
    // Jogador - lógica original
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
}

// ======================
// CONTROLE POR TECLAS
// ======================
if (selecionado) {
    
    // ✅ Modo Passivo (P) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("P"))) {
        modo_ataque = false;
        alvo = noone;
        if (estado == "atacando") estado = "parado";
        show_debug_message("🛡️ Infantaria em Modo PASSIVO");
    }
    
    // ✅ Modo Ataque (O) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("O"))) {
        modo_ataque = true;
        show_debug_message("⚔️ Infantaria em Modo ATAQUE AGRESSIVO");
    }
    
    // ✅ Parar (L) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("L"))) {
        estado = "parado";
        alvo = noone;
        // Limpar patrulha se existir
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
            ds_list_clear(pontos_patrulha);
        }
        show_debug_message("⏹️ Infantaria recebeu ordem para PARAR");
    }
    
    // ✅ Comandos K, clique esquerdo e clique direito agora são gerenciados pelo obj_input_manager
    // para evitar conflitos e manter o modo de patrulha persistente
}

// ========================
// LÓGICA DE ESTADOS
// ========================
switch (estado) {
    
    case "parado":
        // só espera
    break;
    
    case "movendo":
        var _dist_destino_movendo = point_distance(x, y, destino_x, destino_y);
        if (_dist_destino_movendo > velocidade) {
            // Calcular direção para o destino
            var dir_x = destino_x - x;
            var dir_y = destino_y - y;
            var dist_norm = point_distance(0, 0, dir_x, dir_y);
            if (dist_norm > 0) {
                var _direcao_original = point_direction(0, 0, dir_x, dir_y);
                
                // ✅ NOVO: Detectar obstáculos e calcular rota alternativa
                // ✅ MELHORADO: Aumentar distância de verificação quando há múltiplas unidades
                var _dist_verificacao = 40;
                var _unidades_proximas_count = 0;
                with (obj_infantaria) {
                    if (id != other.id && point_distance(x, y, other.x, other.y) < 100) {
                        _unidades_proximas_count++;
                    }
                }
                with (obj_tanque) {
                    if (id != other.id && point_distance(x, y, other.x, other.y) < 100) {
                        _unidades_proximas_count++;
                    }
                }
                
                // Se há muitas unidades próximas (formação), aumentar sensibilidade
                if (_unidades_proximas_count >= 2) {
                    _dist_verificacao = 60; // Aumentar distância de verificação em formações
                }
                
                var _resultado_desvio = scr_detectar_obstaculo(x, y, _direcao_original, destino_x, destino_y, _dist_verificacao, id);
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
                
                // ✅ CORREÇÃO: Se está indo embarcar, não parar mesmo perto do destino
                var _dist_destino = point_distance(x, y, destino_x, destino_y);
                var _tolerancia_chegada = 6;
                if (variable_instance_exists(id, "indo_embarcar") && indo_embarcar) {
                    _tolerancia_chegada = 2; // ✅ Tolerância menor quando indo embarcar (para chegar mais perto)
                }
                
                if (_dist_destino > _tolerancia_chegada) {
                    // ✅ NOVO: Para unidades da IA, garantir velocidade mínima
                    var _vel_efetiva = velocidade;
                    if (_eh_unidade_ia && velocidade <= 0) {
                        _vel_efetiva = 2; // Velocidade padrão se não tiver definida
                    }
                    
                    // ✅ CORREÇÃO: Guardar posição antes de mover para verificar travamento
                    var _x_antes = x;
                    var _y_antes = y;
                    
                    // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom para manter velocidade visual constante
                    var _vel_normalizada = scr_normalize_unit_speed(_vel_efetiva);
                    
                    // ✅ NOVO: Verificar terreno antes de mover
                    var _proxima_x = x + lengthdir_x(_vel_normalizada, _direcao_final);
                    var _proxima_y = y + lengthdir_y(_vel_normalizada, _direcao_final);
                    
                    // ✅ VERIFICAÇÃO DE TERRENO: Verificar se pode mover para a próxima posição
                    if (scr_unidade_pode_terreno(id, _proxima_x, _proxima_y)) {
                        // Terreno permitido - pode mover
                        x = _proxima_x;
                        y = _proxima_y;
                        image_angle = _direcao_final;
                    } else {
                        // Terreno proibido - parar e tentar encontrar terra próxima
                        var _terra_proxima = scr_encontrar_terra_proxima(id, x, y, 500);
                        if (_terra_proxima != noone && array_length(_terra_proxima) >= 2) {
                            destino_x = _terra_proxima[0];
                            destino_y = _terra_proxima[1];
                            estado = "movendo";
                        } else {
                            // Sem terra próxima - parar
                            estado = "parado";
                            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                                show_debug_message("⚠️ Infantaria parou: terreno proibido em (" + string(floor(_proxima_x)) + ", " + string(floor(_proxima_y)) + ")");
                            }
                        }
                    }
                    
                    // ✅ VERIFICAÇÃO: Se está travado (não se moveu muito)
                    var _dist_movida = point_distance(x, y, _x_antes, _y_antes);
                    if (_dist_movida < _vel_efetiva * 0.5) {
                        // Está travado - tentar desvio maior e atualizar destino
                        _direcao_final = _direcao_original + 90; // Virar 90 graus
                        var _nova_x = x + lengthdir_x(_vel_normalizada, _direcao_final);
                        var _nova_y = y + lengthdir_y(_vel_normalizada, _direcao_final);
                        
                        // ✅ CORREÇÃO CRÍTICA: Verificar terreno ANTES de mover
                        if (scr_unidade_pode_terreno(id, _nova_x, _nova_y)) {
                            // Terreno permitido - pode mover
                            destino_x = x + lengthdir_x(100, _direcao_final);
                            destino_y = y + lengthdir_y(100, _direcao_final);
                            x = _nova_x;
                            y = _nova_y;
                            image_angle = _direcao_final;
                        } else {
                            // Terreno proibido - tentar outra direção ou parar
                            _direcao_final = _direcao_original - 90; // Tentar direção oposta
                            _nova_x = x + lengthdir_x(_vel_normalizada, _direcao_final);
                            _nova_y = y + lengthdir_y(_vel_normalizada, _direcao_final);
                            
                            if (scr_unidade_pode_terreno(id, _nova_x, _nova_y)) {
                                destino_x = x + lengthdir_x(100, _direcao_final);
                                destino_y = y + lengthdir_y(100, _direcao_final);
                                x = _nova_x;
                                y = _nova_y;
                                image_angle = _direcao_final;
                            } else {
                                // Sem terreno válido - parar
                                estado = "parado";
                                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                                    show_debug_message("⚠️ Infantaria parou: travado e sem terreno válido");
                                }
                            }
                        }
                    }
                }
            }
        } else {
            // Chegou ao destino temporário ou final
            // ✅ NOVO: Se estava usando destino temporário, voltar ao destino original
            // ✅ CORREÇÃO: Verificar se variável existe E se os valores são válidos (não undefined)
            if (variable_instance_exists(id, "destino_original_x") && variable_instance_exists(id, "destino_original_y") &&
                !is_undefined(destino_original_x) && !is_undefined(destino_original_y) &&
                is_real(destino_original_x) && is_real(destino_original_y)) {
                // Verificar se chegou ao destino temporário (não é o original)
                var _dist_original = point_distance(x, y, destino_original_x, destino_original_y);
                if (_dist_original > 50) {
                    // Ainda não chegou ao destino original - continuar para ele
                    destino_x = destino_original_x;
                    destino_y = destino_original_y;
                    estado = "movendo";
                } else {
                    // Chegou ao destino original - limpar variáveis temporárias
                    // ✅ CORREÇÃO: Limpar variáveis temporárias (definir como undefined se existirem)
                    if (variable_instance_exists(id, "destino_original_x")) {
                        destino_original_x = undefined;
                    }
                    if (variable_instance_exists(id, "destino_original_y")) {
                        destino_original_y = undefined;
                    }
                    x = destino_x;
                    y = destino_y;
                    // ✅ NOVO: Se for unidade da IA e tem alvo, mudar para atacar
                    if (_eh_unidade_ia && variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
                        estado = "atacando";
                    } else {
                        estado = "parado";
                    }
                }
            } else {
                // Para exatamente no destino
                x = destino_x;
                y = destino_y;
                // ✅ NOVO: Se for unidade da IA e tem alvo, mudar para atacar
                if (_eh_unidade_ia && variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
                    estado = "atacando";
                } else {
                    estado = "parado";
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
            var _dist_destino_patrulha = point_distance(x, y, destino_x, destino_y);
            if (_dist_destino_patrulha > velocidade) {
                var dir_x = destino_x - x;
                var dir_y = destino_y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom
                    var _vel_normalizada = scr_normalize_unit_speed(velocidade);
                    x += (dir_x / dist_norm) * _vel_normalizada;
                    y += (dir_y / dist_norm) * _vel_normalizada;
                    image_angle = point_direction(0, 0, dir_x, dir_y);
                }
            }
        } else {
            // Sem pontos de patrulha - voltar para parado
            estado = "parado";
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
                // ✅ CORREÇÃO: Usar break para sair do case "atacando"
                break;
            } else {
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
                        b.dano = 15;
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
                                
                                // ✅ CORREÇÃO: Verificar terreno antes de usar mp_potential_step
                                if (scr_unidade_pode_terreno(id, target_x, target_y)) {
                                    var _x_antes_mp = x;
                                    var _y_antes_mp = y;
                                    mp_potential_step(target_x, target_y, velocidade, false);
                                    
                                    // ✅ CORREÇÃO: Verificar se realmente moveu para terreno válido
                                    if (!scr_unidade_pode_terreno(id, x, y)) {
                                        // Moveu para água - voltar para posição anterior
                                        x = _x_antes_mp;
                                        y = _y_antes_mp;
                                        // Tentar encontrar terra próxima
                                        var _script_id = asset_get_index("scr_encontrar_terra_proxima");
                                        if (_script_id != -1) {
                                            var _terra_proxima = scr_encontrar_terra_proxima(id, x, y, 200);
                                            if (_terra_proxima != noone && array_length(_terra_proxima) >= 2) {
                                                x = _terra_proxima[0];
                                                y = _terra_proxima[1];
                                            }
                                        }
                                    }
                                    image_angle = point_direction(0, 0, dir_x, dir_y);
                                } else {
                                    // Terreno proibido - não mover
                                    image_angle = point_direction(x, y, alvo.x, alvo.y);
                                }
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
                        
                        // ✅ CORREÇÃO: Verificar terreno antes de usar mp_potential_step
                        if (scr_unidade_pode_terreno(id, target_x, target_y)) {
                            var _x_antes_mp = x;
                            var _y_antes_mp = y;
                            mp_potential_step(target_x, target_y, velocidade, false);
                            
                            // ✅ CORREÇÃO: Verificar se realmente moveu para terreno válido
                            if (!scr_unidade_pode_terreno(id, x, y)) {
                                // Moveu para água - voltar para posição anterior
                                x = _x_antes_mp;
                                y = _y_antes_mp;
                                // Tentar encontrar terra próxima
                                var _script_id = asset_get_index("scr_encontrar_terra_proxima");
                                if (_script_id != -1) {
                                    var _terra_proxima = scr_encontrar_terra_proxima(id, x, y, 200);
                                    if (_terra_proxima != noone && array_length(_terra_proxima) >= 2) {
                                        x = _terra_proxima[0];
                                        y = _terra_proxima[1];
                                    }
                                }
                            }
                            image_angle = point_direction(0, 0, dir_x, dir_y);
                        } else {
                            // Terreno proibido - não mover
                            image_angle = point_direction(x, y, alvo.x, alvo.y);
                        }
                    }
                } else {
                    // Inimigo muito longe, volta para patrulha
                    alvo = noone;
                    estado = "patrulhando";
                }
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

// =============================================
// ✅ SISTEMA DE COLISÃO FÍSICA
// =============================================
// Verificar colisões apenas a cada 3 frames para melhorar performance
// ✅ CORREÇÃO: Verificar se a função existe antes de chamar para evitar erro
if (variable_global_exists("game_frame") && global.game_frame % 3 == 0) {
    var _script_index = asset_get_index("scr_colisao_fisica_unidades");
    if (_script_index != -1 && asset_get_type(_script_index) == asset_script) {
        // Função existe e é um script válido - chamar normalmente
        scr_colisao_fisica_unidades(id, 30, 0.8);
    }
    // Se a função não existir, simplesmente não fazer nada (não causar erro)
}