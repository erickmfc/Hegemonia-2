// ================================================
// HEGEMONIA GLOBAL - M1A ABRAMS
// Step Event - Lógica Principal
// ================================================

// =============================================
// VERIFICAÇÃO DE ESTADO DESTRUÍDO
// =============================================
if (destruido) {
    // Tanque destruído - apenas atualizar animação se necessário
    exit;
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
        // Frame skip: movimento simplificado apenas
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            // ✅ CORREÇÃO: Normalizar velocidade antes de aplicar multiplicador do LOD
            var _vel_normalizada = scr_normalize_unit_speed(velocidade);
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
// VERIFICAÇÃO DE HP
// =======================
if (hp <= 0 && !destruido) {
    destruido = true;
    estado = "parado";
    alvo = noone;
    show_debug_message("💥 M1A Abrams DESTRUÍDO!");
}

// =======================
// DETECÇÃO DE INIMIGOS (melhorada)
// =======================
// ✅ CORRIGIDO: Unidades podem procurar inimigos mesmo movendo
if (modo_ataque && !destruido) {
    // Se não está atacando ou perdeu o alvo, procurar novo alvo
    if (estado != "atacando" || alvo == noone || !instance_exists(alvo)) {
        // ✅ CORREÇÃO: Usar scr_buscar_inimigo() para considerar nacao_proprietaria
        var _nacao = (variable_instance_exists(id, "nacao_proprietaria")) ? nacao_proprietaria : 1;
        var _alvo_temp = scr_buscar_inimigo(x, y, alcance_visao, _nacao);
        if (_alvo_temp != noone && _alvo_temp != undefined && instance_exists(_alvo_temp)) {
            alvo = _alvo_temp;
            show_debug_message("🎯 M1A Abrams encontrou alvo: " + object_get_name(_alvo_temp.object_index) + " | Distância: " + string(point_distance(x, y, _alvo_temp.x, _alvo_temp.y)));
        }
        
        if (alvo != noone && instance_exists(alvo)) {
            var _dist_alvo = point_distance(x, y, alvo.x, alvo.y);
            if (_dist_alvo <= alcance_visao) {
                estado = "atacando";
                show_debug_message("🎯 M1A Abrams entrando em modo ATAQUE! Distância: " + string(_dist_alvo) + " | Alcance visão: " + string(alcance_visao));
            }
        } else if (estado == "atacando") {
            // ✅ DEBUG: Informar quando não encontra alvo mas está em modo ataque
            show_debug_message("⚠️ M1A Abrams em modo ataque mas sem alvo! Procurando...");
        }
    }
} else if (!modo_ataque) {
    // Modo passivo - não ataca
    alvo = noone;
    if (estado == "atacando") {
        estado = "parado";
        show_debug_message("🛡️ M1A Abrams em modo PASSIVO - parando ataque");
    }
}

// CONTROLES
if (selecionado && !destruido) {
    // ✅ Modo Passivo (P) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("P"))) {
        modo_ataque = false;
        alvo = noone;
        if (estado == "atacando") estado = "parado";
        show_debug_message("🛡️ M1A Abrams em Modo PASSIVO");
    }
    
    // ✅ Modo Ataque (O) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("O"))) {
        modo_ataque = true;
        show_debug_message("⚔️ M1A Abrams em Modo ATAQUE AGRESSIVO");
    }
    
    // ✅ Parar (L) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("L"))) {
        estado = "parado";
        alvo = noone;
        // Limpar patrulha se existir
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
            ds_list_clear(pontos_patrulha);
        }
        // Cancelar modo de definição de patrulha
        if (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id) {
            global.definindo_patrulha_unidade = noone;
        }
        show_debug_message("⏹️ M1A Abrams recebeu ordem para PARAR");
    }
    
    // ✅ CORREÇÃO: Patrulha (K) é gerenciada pelo obj_input_manager
    // Removida lógica local para evitar conflitos - o obj_input_manager cuida de tudo
}

// =======================
// ESTADOS
// =======================
switch (estado) {
    case "parado":
        // ✅ NOVO: Atualizar mira mesmo parado (se tiver alvo)
        if (alvo != noone && instance_exists(alvo)) {
            // Lógica de atualização de mira inline
            var _dir_alvo = point_direction(x, y, alvo.x, alvo.y);
            angulo_torre_alvo = _dir_alvo;
            var _diff = angulo_torre_alvo - angulo_torre;
            while (_diff > 180) _diff -= 360;
            while (_diff < -180) _diff += 360;
            if (abs(_diff) > velocidade_rotacao_torre) {
                if (_diff > 0) {
                    angulo_torre += velocidade_rotacao_torre;
                } else {
                    angulo_torre -= velocidade_rotacao_torre;
                }
            } else {
                angulo_torre = angulo_torre_alvo;
            }
            while (angulo_torre < 0) angulo_torre += 360;
            while (angulo_torre >= 360) angulo_torre -= 360;
        }
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
            image_angle = _direcao_final; // Casco aponta na direção do movimento
            
            // ✅ NOVO: Atualizar mira mesmo enquanto move (se tiver alvo)
            if (alvo != noone && instance_exists(alvo)) {
                // Lógica de atualização de mira inline
                var _dir_alvo = point_direction(x, y, alvo.x, alvo.y);
                angulo_torre_alvo = _dir_alvo;
                var _diff = angulo_torre_alvo - angulo_torre;
                while (_diff > 180) _diff -= 360;
                while (_diff < -180) _diff += 360;
                if (abs(_diff) > velocidade_rotacao_torre) {
                    if (_diff > 0) {
                        angulo_torre += velocidade_rotacao_torre;
                    } else {
                        angulo_torre -= velocidade_rotacao_torre;
                    }
                } else {
                    angulo_torre = angulo_torre_alvo;
                }
                while (angulo_torre < 0) angulo_torre += 360;
                while (angulo_torre >= 360) angulo_torre -= 360;
            }
        } else {
            // Chegou ao destino temporário ou final
            if (variable_instance_exists(id, "destino_original_x") && variable_instance_exists(id, "destino_original_y") &&
                !is_undefined(destino_original_x) && !is_undefined(destino_original_y) &&
                is_real(destino_original_x) && is_real(destino_original_y)) {
                var _dist_original = point_distance(x, y, destino_original_x, destino_original_y);
                if (_dist_original > 50) {
                    destino_x = destino_original_x;
                    destino_y = destino_original_y;
                    estado = "movendo";
                } else {
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
        // ✅ NOVO: Sistema de patrulha igual navios/aviões
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
            // Se chegou ao ponto atual, vai para o próximo
            if (point_distance(x, y, destino_x, destino_y) < 20) {
                indice_patrulha_atual = (indice_patrulha_atual + 1) % ds_list_size(pontos_patrulha);
                var _ponto = pontos_patrulha[| indice_patrulha_atual];
                destino_x = _ponto[0];
                destino_y = _ponto[1];
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
            
            // ✅ NOVO: Atualizar mira durante patrulha (se tiver alvo)
            if (alvo != noone && instance_exists(alvo)) {
                // Lógica de atualização de mira inline
                var _dir_alvo = point_direction(x, y, alvo.x, alvo.y);
                angulo_torre_alvo = _dir_alvo;
                var _diff = angulo_torre_alvo - angulo_torre;
                while (_diff > 180) _diff -= 360;
                while (_diff < -180) _diff += 360;
                if (abs(_diff) > velocidade_rotacao_torre) {
                    if (_diff > 0) {
                        angulo_torre += velocidade_rotacao_torre;
                    } else {
                        angulo_torre -= velocidade_rotacao_torre;
                    }
                } else {
                    angulo_torre = angulo_torre_alvo;
                }
                while (angulo_torre < 0) angulo_torre += 360;
                while (angulo_torre >= 360) angulo_torre -= 360;
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
                show_debug_message("⚠️ M1A Abrams não pode atacar unidade aérea!");
                alvo = noone;
                if (ds_list_size(patrulha) > 0) {
                    estado = "patrulhando";
                } else {
                    estado = "parado";
                }
                break;
            }
            
            var dist = point_distance(x, y, alvo.x, alvo.y);
            
            // ✅ NOVO: Atualizar mira da torre (lógica inline)
            var _dir_alvo = point_direction(x, y, alvo.x, alvo.y);
            angulo_torre_alvo = _dir_alvo;
            var _diff = angulo_torre_alvo - angulo_torre;
            while (_diff > 180) _diff -= 360;
            while (_diff < -180) _diff += 360;
            if (abs(_diff) > velocidade_rotacao_torre) {
                if (_diff > 0) {
                    angulo_torre += velocidade_rotacao_torre;
                } else {
                    angulo_torre -= velocidade_rotacao_torre;
                }
            } else {
                angulo_torre = angulo_torre_alvo;
            }
            while (angulo_torre < 0) angulo_torre += 360;
            while (angulo_torre >= 360) angulo_torre -= 360;
            
            if (dist <= alcance_tiro) {
                // Atira se estiver no alcance
                if (atq_cooldown <= 0) {
                    // ✅ DEBUG: Informar que vai atirar (sempre mostrar para debug)
                    show_debug_message("💥 M1A Abrams PRONTO PARA ATIRAR! Distância: " + string(dist) + " | Alcance tiro: " + string(alcance_tiro) + " | Cooldown: " + string(atq_cooldown));
                    // ✅ NOVO: Disparo do Abrams (lógica inline)
                    // Calcular posição de spawn do projétil (ponta do cano)
                    var _comprimento_cano = 30;
                    var _spawn_x = x + lengthdir_x(_comprimento_cano, angulo_torre);
                    var _spawn_y = y + lengthdir_y(_comprimento_cano, angulo_torre);
                    
                    // ✅ NOVO: Usar obj_projetil_sabot diretamente
                    var _obj_projetil_sabot = asset_get_index("obj_projetil_sabot");
                    if (_obj_projetil_sabot != -1) {
                        // ✅ CORREÇÃO: Usar layer da instância ou padrão "Instances"
                        var _layer_projetil = "Instances"; // Padrão
                        if (variable_instance_exists(id, "layer") && !is_undefined(layer)) {
                            _layer_projetil = layer;
                        }
                        var _projetil = scr_get_projectile_from_pool(_obj_projetil_sabot, _spawn_x, _spawn_y, _layer_projetil);
                        
                        if (instance_exists(_projetil)) {
                            // Configurar projétil (valores já estão no Create, mas resetamos para garantir)
                            _projetil.direction = angulo_torre;
                            _projetil.speed = 15; // Projétil SABOT é mais rápido
                            _projetil.dano = 120; // Dano maior que tanque comum
                            _projetil.dano_area = 70; // Dano de área para explosão
                            _projetil.raio_area = 90; // Raio de explosão maior
                            _projetil.eh_tiro_tanque = true; // Flag para identificar tiro de tanque
                            _projetil.alvo = alvo; // Manter alvo
                            _projetil.image_blend = c_yellow; // Cor amarela para diferenciar
                            
                            // Resetar timer de vida
                            if (variable_instance_exists(_projetil, "timer_vida")) {
                                _projetil.timer_vida = 150; // Timer de vida (2.5 segundos)
                            }
                            
                            // ✅ Tocar som snd_tiro_abrams para CADA disparo
                            var _snd_tiro_abrams = asset_get_index("snd_tiro_abrams");
                            if (_snd_tiro_abrams != -1) {
                                // ✅ SEMPRE tocar o som quando disparar
                                audio_play_sound(_snd_tiro_abrams, 5, false);
                                
                                if (global.debug_enabled) {
                                    show_debug_message("🔊 Som snd_tiro_abrams tocado para disparo!");
                                }
                            } else {
                                show_debug_message("⚠️ ERRO: snd_tiro_abrams não encontrado!");
                            }
                            
                            show_debug_message("💥 M1A Abrams DISPAROU SABOT! Dano: " + string(_projetil.dano) + " | Alvo: " + object_get_name(alvo.object_index));
                        } else {
                            show_debug_message("⚠️ ERRO: Falha ao criar projétil SABOT do pool!");
                        }
                    } else {
                        show_debug_message("⚠️ ERRO: obj_projetil_sabot não encontrado!");
                    }
                    atq_cooldown = atq_rate;
                }
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
                    image_angle = dir; // Casco aponta na direção do movimento
                    
                    // ✅ NOVO: Atualizar mira mesmo enquanto persegue (lógica inline)
                    _dir_alvo = point_direction(x, y, alvo.x, alvo.y);
                    angulo_torre_alvo = _dir_alvo;
                    _diff = angulo_torre_alvo - angulo_torre;
                    while (_diff > 180) _diff -= 360;
                    while (_diff < -180) _diff += 360;
                    if (abs(_diff) > velocidade_rotacao_torre) {
                        if (_diff > 0) {
                            angulo_torre += velocidade_rotacao_torre;
                        } else {
                            angulo_torre -= velocidade_rotacao_torre;
                        }
                    } else {
                        angulo_torre = angulo_torre_alvo;
                    }
                    while (angulo_torre < 0) angulo_torre += 360;
                    while (angulo_torre >= 360) angulo_torre -= 360;
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
                // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom
                var _vel_normalizada = scr_normalize_unit_speed(velocidade);
                mp_potential_step(seguir_alvo.x, seguir_alvo.y, _vel_normalizada, false);
                image_angle = point_direction(x, y, seguir_alvo.x, seguir_alvo.y);
            } else {
                estado = "parado";
                seguir_alvo = noone;
            }
        }
    break;
}
