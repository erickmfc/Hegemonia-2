// ================================================
// HEGEMONIA GLOBAL - GEPARD ANTI-AÉREO
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
if (atq_cooldown_aereo > 0) atq_cooldown_aereo--; // ✅ NOVO: Cooldown separado para mísseis aéreos
if (atq_cooldown_terrestre > 0) atq_cooldown_terrestre--; // ✅ NOVO: Cooldown separado para projéteis terrestres
if (metralhadora_cooldown > 0) metralhadora_cooldown--; // ✅ NOVO: Cooldown de metralhadora (muito rápido)

// =======================
// VERIFICAÇÃO DE HP
// =======================
if (hp <= 0 && !destruido) {
    destruido = true;
    estado = "parado";
    alvo = noone;
    show_debug_message("💥 Gepard Anti-Aéreo DESTRUÍDO!");
}

// =======================
// DETECÇÃO DE INIMIGOS (melhorada) - DOIS ALVOS SIMULTÂNEOS
// =======================
// ✅ NOVO: Gepard pode atirar em alvos aéreos E terrestres simultaneamente
if (modo_ataque && !destruido) {
    var _nacao = (variable_instance_exists(id, "nacao_proprietaria")) ? nacao_proprietaria : 1;
    
    // ✅ DETECÇÃO DE ALVO AÉREO
    if (alvo_aereo == noone || !instance_exists(alvo_aereo)) {
        // Buscar alvos aéreos
        var _obj_su35 = asset_get_index("obj_su35");
        var _alvos_aereos = [];
        if (object_exists(obj_caca_f5)) {
            var _f5 = instance_nearest(x, y, obj_caca_f5);
            if (instance_exists(_f5) && _f5.nacao_proprietaria != _nacao && point_distance(x, y, _f5.x, _f5.y) <= alcance_visao) {
                array_push(_alvos_aereos, _f5);
            }
        }
        if (object_exists(obj_f15)) {
            var _f15 = instance_nearest(x, y, obj_f15);
            if (instance_exists(_f15) && _f15.nacao_proprietaria != _nacao && point_distance(x, y, _f15.x, _f15.y) <= alcance_visao) {
                array_push(_alvos_aereos, _f15);
            }
        }
        if (object_exists(obj_f6)) {
            var _f6 = instance_nearest(x, y, obj_f6);
            if (instance_exists(_f6) && _f6.nacao_proprietaria != _nacao && point_distance(x, y, _f6.x, _f6.y) <= alcance_visao) {
                array_push(_alvos_aereos, _f6);
            }
        }
        if (object_exists(obj_helicoptero_militar)) {
            var _heli = instance_nearest(x, y, obj_helicoptero_militar);
            if (instance_exists(_heli) && _heli.nacao_proprietaria != _nacao && point_distance(x, y, _heli.x, _heli.y) <= alcance_visao) {
                array_push(_alvos_aereos, _heli);
            }
        }
        
        // Escolher o mais próximo
        if (array_length(_alvos_aereos) > 0) {
            var _menor_dist = 999999;
            var _alvo_escolhido = noone;
            for (var i = 0; i < array_length(_alvos_aereos); i++) {
                var _dist = point_distance(x, y, _alvos_aereos[i].x, _alvos_aereos[i].y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _alvo_escolhido = _alvos_aereos[i];
                }
            }
            alvo_aereo = _alvo_escolhido;
        }
    }
    
    // ✅ DETECÇÃO DE ALVO TERRESTRE
    if (alvo_terrestre == noone || !instance_exists(alvo_terrestre)) {
        // Buscar alvos terrestres
        var _alvo_infantaria = noone;
        var _alvo_tanque = noone;
        var _alvo_abrams = noone;
        
        if (object_exists(obj_infantaria)) {
            _alvo_infantaria = instance_nearest(x, y, obj_infantaria);
            if (instance_exists(_alvo_infantaria) && _alvo_infantaria.nacao_proprietaria != _nacao && point_distance(x, y, _alvo_infantaria.x, _alvo_infantaria.y) <= alcance_visao) {
                // OK
            } else {
                _alvo_infantaria = noone;
            }
        }
        
        if (object_exists(obj_tanque)) {
            _alvo_tanque = instance_nearest(x, y, obj_tanque);
            if (instance_exists(_alvo_tanque) && _alvo_tanque.nacao_proprietaria != _nacao && point_distance(x, y, _alvo_tanque.x, _alvo_tanque.y) <= alcance_visao) {
                // OK
            } else {
                _alvo_tanque = noone;
            }
        }
        
        var _obj_abrams = asset_get_index("obj_M1A_Abrams");
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            _alvo_abrams = instance_nearest(x, y, _obj_abrams);
            if (instance_exists(_alvo_abrams) && _alvo_abrams.nacao_proprietaria != _nacao && point_distance(x, y, _alvo_abrams.x, _alvo_abrams.y) <= alcance_visao) {
                // OK
            } else {
                _alvo_abrams = noone;
            }
        }
        
        // Escolher o mais próximo
        var _menor_dist = 999999;
        var _alvo_escolhido = noone;
        if (instance_exists(_alvo_infantaria)) {
            var _dist = point_distance(x, y, _alvo_infantaria.x, _alvo_infantaria.y);
            if (_dist < _menor_dist) {
                _menor_dist = _dist;
                _alvo_escolhido = _alvo_infantaria;
            }
        }
        if (instance_exists(_alvo_tanque)) {
            var _dist = point_distance(x, y, _alvo_tanque.x, _alvo_tanque.y);
            if (_dist < _menor_dist) {
                _menor_dist = _dist;
                _alvo_escolhido = _alvo_tanque;
            }
        }
        if (instance_exists(_alvo_abrams)) {
            var _dist = point_distance(x, y, _alvo_abrams.x, _alvo_abrams.y);
            if (_dist < _menor_dist) {
                _menor_dist = _dist;
                _alvo_escolhido = _alvo_abrams;
            }
        }
        alvo_terrestre = _alvo_escolhido;
    }
    
    // Definir alvo principal (prioridade aéreo)
    if (instance_exists(alvo_aereo)) {
        alvo = alvo_aereo;
    } else if (instance_exists(alvo_terrestre)) {
        alvo = alvo_terrestre;
    } else {
        alvo = noone;
    }
    
    if (alvo != noone && instance_exists(alvo)) {
        estado = "atacando";
    } else if (estado == "atacando") {
        estado = "parado";
    }
} else if (!modo_ataque) {
    // Modo passivo - não ataca
    alvo = noone;
    alvo_aereo = noone;
    alvo_terrestre = noone;
    if (estado == "atacando") {
        estado = "parado";
        show_debug_message("🛡️ Gepard Anti-Aéreo em modo PASSIVO - parando ataque");
    }
}

// CONTROLES
if (selecionado && !destruido) {
    // ✅ Modo Passivo (P) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("P"))) {
        modo_ataque = false;
        alvo = noone;
        if (estado == "atacando") estado = "parado";
        show_debug_message("🛡️ Gepard Anti-Aéreo em Modo PASSIVO");
    }
    
    // ✅ Modo Ataque (O) - IGUAL NAVIOS/AVIÕES
    if (keyboard_check_pressed(ord("O"))) {
        modo_ataque = true;
        show_debug_message("⚔️ Gepard Anti-Aéreo em Modo ATAQUE AGRESSIVO");
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
        show_debug_message("⏹️ Gepard Anti-Aéreo recebeu ordem para PARAR");
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
            
            // ✅ NOVO: ATIRAR EM DOIS ALVOS SIMULTANEAMENTE
            // Atirar em alvo aéreo (se existir e estiver no alcance) - COOLDOWN SEPARADO
            if (instance_exists(alvo_aereo)) {
                var _dist_aereo = point_distance(x, y, alvo_aereo.x, alvo_aereo.y);
                if (_dist_aereo <= alcance_tiro && atq_cooldown_aereo <= 0) {
                    // Calcular posição de spawn do míssil
                    var _comprimento_cano = 30;
                    var _angulo_torre_aereo = point_direction(x, y, alvo_aereo.x, alvo_aereo.y);
                    var _spawn_x_aereo = x + lengthdir_x(_comprimento_cano, _angulo_torre_aereo);
                    var _spawn_y_aereo = y + lengthdir_y(_comprimento_cano, _angulo_torre_aereo);
                    
                    var _layer_projetil = "Instances";
                    if (variable_instance_exists(id, "layer") && !is_undefined(layer)) {
                        _layer_projetil = layer;
                    }
                    
                    // ✅ DISPARAR MÍSSIL CONTRA ALVO AÉREO (baseado no SkyFury)
                    var _obj_typer39 = asset_get_index("obj_typer39");
                    if (_obj_typer39 != -1 && asset_get_type(_obj_typer39) == asset_object) {
                        var _missil = scr_get_projectile_from_pool(_obj_typer39, _spawn_x_aereo, _spawn_y_aereo, _layer_projetil);
                        if (!instance_exists(_missil)) {
                            _missil = instance_create_layer(_spawn_x_aereo, _spawn_y_aereo, _layer_projetil, _obj_typer39);
                        }
                        
                        if (instance_exists(_missil)) {
                            // ✅ Configurar como SkyFury (usar target)
                            _missil.visible = true;
                            _missil.image_alpha = 1.0;
                            _missil.target = alvo_aereo; // Usar target como SkyFury
                            _missil.alvo = alvo_aereo; // Compatibilidade
                            _missil.dono = id;
                            _missil.dano = 135;
                            _missil.speed = 9;
                            
                            // Calcular direção inicial
                            var _direcao_alvo = point_direction(_spawn_x_aereo, _spawn_y_aereo, alvo_aereo.x, alvo_aereo.y);
                            _missil.direction = _direcao_alvo;
                            _missil.image_angle = _direcao_alvo;
                            
                            // Resetar cooldown aéreo
                            atq_cooldown_aereo = atq_rate;
                        }
                    }
                }
            }
            
            // ✅ ATIRAR EM ALVO TERRESTRE (SEPARADO - simultâneo) - METRALHADORA AUTOMÁTICA
            if (instance_exists(alvo_terrestre)) {
                var _dist_terrestre = point_distance(x, y, alvo_terrestre.x, alvo_terrestre.y);
                // ✅ CORREÇÃO: Usar cooldown específico de metralhadora (muito rápido)
                if (_dist_terrestre <= alcance_tiro && metralhadora_cooldown <= 0) {
                    // Calcular posição de spawn do projétil terrestre
                    var _comprimento_cano = 30;
                    var _angulo_torre_terrestre = point_direction(x, y, alvo_terrestre.x, alvo_terrestre.y);
                    var _spawn_x_terrestre = x + lengthdir_x(_comprimento_cano, _angulo_torre_terrestre);
                    var _spawn_y_terrestre = y + lengthdir_y(_comprimento_cano, _angulo_torre_terrestre);
                    
                    var _layer_projetil = "Instances";
                    if (variable_instance_exists(id, "layer") && !is_undefined(layer)) {
                        _layer_projetil = layer;
                    }
                    
                    // ✅ DISPARAR TIRO DE METRALHADORA CONTRA ALVO TERRESTRE
                    var _obj_tiro_metralha = asset_get_index("obj_tiro_metralha");
                    if (_obj_tiro_metralha != -1 && asset_get_type(_obj_tiro_metralha) == asset_object) {
                        var _tiro = scr_get_projectile_from_pool(_obj_tiro_metralha, _spawn_x_terrestre, _spawn_y_terrestre, _layer_projetil);
                        if (!instance_exists(_tiro)) {
                            _tiro = instance_create_layer(_spawn_x_terrestre, _spawn_y_terrestre, _layer_projetil, _obj_tiro_metralha);
                        }
                        
                        if (instance_exists(_tiro)) {
                            // Configurar tiro de metralhadora
                            var _direcao_terrestre = point_direction(_spawn_x_terrestre, _spawn_y_terrestre, alvo_terrestre.x, alvo_terrestre.y);
                            _tiro.direction = _direcao_terrestre;
                            _tiro.image_angle = _direcao_terrestre;
                            _tiro.alvo = alvo_terrestre;
                            _tiro.dono = id;
                            _tiro.dano = 5; // Dano de metralhadora
                            _tiro.visible = true;
                            _tiro.image_alpha = 1.0;
                            
                            // ✅ Configurar velocidade do tiro (CRÍTICO para movimento)
                            _tiro.speed = 10; // Velocidade rápida para metralhadora
                            
                            // ✅ Garantir que o tiro está visível e ativo
                            if (variable_instance_exists(_tiro, "timer_vida")) {
                                _tiro.timer_vida = 90; // Resetar timer de vida
                            }
                            
                            // ✅ TOCAR SOM DE METRALHADORA (apenas a cada 6 frames para não sobrecarregar)
                            if (!variable_instance_exists(id, "metralhadora_som_timer")) metralhadora_som_timer = 0;
                            metralhadora_som_timer++;
                            if (metralhadora_som_timer >= 6) {
                                metralhadora_som_timer = 0;
                                var _som_metralhadora = asset_get_index("som_metralhadora");
                                if (_som_metralhadora != -1) {
                                    audio_play_sound(_som_metralhadora, 3, false);
                                }
                            }
                            
                            // ✅ Resetar cooldown de metralhadora (muito rápido para tiro automático)
                            metralhadora_cooldown = metralhadora_rate;
                        }
                    }
                }
            }
            
            // Tanque para para atirar com precisão
            if (dist > alcance_tiro && dist <= alcance_visao) {
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
