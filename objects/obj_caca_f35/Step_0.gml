// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-35 (Step com Sistema de Mísseis Múltiplos)
// ===============================================

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" || estado == "pousando" || estado == "decolando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        // Movimento simplificado para aviões
        if (estado == "patrulhando" || estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            var _vel_normalizada = scr_normalize_unit_speed(velocidade_atual);
            x += lengthdir_x(_vel_normalizada * speed_mult, image_angle);
            y += lengthdir_y(_vel_normalizada * speed_mult, image_angle);
        }
        exit;
    }
    lod_level = current_lod;
}

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O)
    if (keyboard_check_pressed(ord("P"))) { 
        modo_ataque = false; 
        show_debug_message("🛡️ F-35 Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_ataque = true; 
        show_debug_message("⚔️ F-35 Modo ATAQUE AGRESSIVO");
    }

    // Comando de Pouso (L)
    if (keyboard_check_pressed(ord("L")) && estado != "pousado") {
        estado = "pousando";
    }
}

// ======================================================================
// --- 2. SISTEMA OTIMIZADO: AQUISIÇÃO DE ALVO (PRIORIDADE MÁXIMA) ---
// ======================================================================
if (timer_busca_alvo > 0) {
    timer_busca_alvo--;
}

// ✅ CORREÇÃO: Buscar inimigos mesmo quando não está em modo ataque (mas priorizar quando está)
// Se o avião não está pousando/decolando E não está já atacando...
if (estado != "pousando" && estado != "decolando" && estado != "atacando") {
    
    if (timer_busca_alvo <= 0) {
        timer_busca_alvo = intervalo_busca_alvo;
        
        // Usar função global de detecção de inimigos
        var _alvo_encontrado = scr_buscar_inimigo(x, y, radar_alcance, nacao_proprietaria);
        
        // ===============================================
        // ✅ SISTEMA DE STEALTH - F-35 (5ª GERAÇÃO)
        // Reduz chance de detecção por caças de gerações anteriores
        // ===============================================
        if (instance_exists(_alvo_encontrado) && stealth_ativo) {
            // Verificar se o detector é um caça e qual sua geração
            var _eh_caca = (_alvo_encontrado.object_index == obj_caca_f5 || 
                           _alvo_encontrado.object_index == obj_f6 ||
                           _alvo_encontrado.object_index == obj_f15 ||
                           _alvo_encontrado.object_index == obj_su35 ||
                           _alvo_encontrado.object_index == obj_caca_f35);
            
            if (_eh_caca && variable_instance_exists(_alvo_encontrado, "geracao_caca")) {
                var _geracao_detector = _alvo_encontrado.geracao_caca;
                
                // Caças de 2ª/3ª geração têm 70% menos chance de detectar F-35
                if (_geracao_detector <= FighterGeneration.GEN_3) {
                    var _chance_deteccao = random(100);
                    if (_chance_deteccao >= 30) {  // Apenas 30% de chance de detectar
                        _alvo_encontrado = noone;  // F-35 não detectado - vantagem stealth
                        if (variable_global_exists("debug_enabled") && global.debug_enabled && random(100) < 5) {
                            show_debug_message("🛡️ F-35: Stealth ativo! Caça de 2ª/3ª geração não detectou.");
                        }
                    }
                }
                // Caças de 4ª geração têm 40% menos chance
                else if (_geracao_detector == FighterGeneration.GEN_4) {
                    var _chance_deteccao = random(100);
                    if (_chance_deteccao >= 60) {  // 60% de chance de detectar
                        _alvo_encontrado = noone;
                        if (variable_global_exists("debug_enabled") && global.debug_enabled && random(100) < 5) {
                            show_debug_message("🛡️ F-35: Stealth ativo! F-15 não detectou.");
                        }
                    }
                }
                // SU-35 (4.5ª) tem 20% menos chance
                else if (_geracao_detector == FighterGeneration.GEN_4_PLUS) {
                    var _chance_deteccao = random(100);
                    if (_chance_deteccao >= 80) {  // 80% de chance de detectar
                        _alvo_encontrado = noone;
                        if (variable_global_exists("debug_enabled") && global.debug_enabled && random(100) < 5) {
                            show_debug_message("🛡️ F-35: Stealth ativo! SU-35 não detectou.");
                        }
                    }
                }
                // Apenas outros F-35 ou caças 5ª geração detectam normalmente (100%)
            }
        }
        
        if (instance_exists(_alvo_encontrado)) {
            // ✅ CORREÇÃO: Sempre atacar quando encontrar inimigo se modo_ataque estiver ativo
            if (modo_ataque) {
                estado_anterior = estado;
                estado = "atacando";
                alvo_em_mira = _alvo_encontrado;
                
                // ✅ CORREÇÃO: Mover imediatamente em direção ao alvo e garantir que está voando
                destino_x = _alvo_encontrado.x;
                destino_y = _alvo_encontrado.y;
                
                // ✅ CORREÇÃO: Se estiver pousado, decolar antes de atacar
                if (estado_anterior == "pousado") {
                    estado = "decolando";
                    altura_voo = 5;
                    velocidade_atual = 2;
                }
                
                // ✅ CORREÇÃO: Garantir que está em movimento
                if (estado_anterior == "pousado" || estado_anterior == "parado") {
                    estado = "atacando";
                }
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🎯 F-35: Alvo detectado! Tipo: " + string(_alvo_encontrado.object_index) + " | Perseguindo...");
                }
            } else {
                // Modo passivo - apenas avisar mas não atacar automaticamente
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🛡️ F-35: Inimigo detectado mas modo PASSIVO ativo (pressione O para atacar)");
                }
            }
        }
    }
}

// --- 3. DECREMENTAR TIMERS DE MÍSSEIS ---
if (timer_sky > 0) timer_sky--;
if (timer_iron > 0) timer_iron--;
if (timer_hash > 0) timer_hash--;
if (timer_lit > 0) timer_lit--;

// --- 4. MÁQUINA DE ESTADOS ---
switch (estado) {
    case "movendo":
        if (point_distance(x, y, destino_x, destino_y) < 15 && velocidade_atual < 0.5) {
            estado = "pousando";
        }
        break;

    case "patrulhando":
        // ✅ CORREÇÃO: Verificação de segurança para evitar divisão por zero
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
            // ✅ CORREÇÃO: Garantir que indice_patrulha_atual está dentro dos limites
            if (!variable_instance_exists(id, "indice_patrulha_atual")) {
                indice_patrulha_atual = 0;
            }
            var _total_pontos = ds_list_size(pontos_patrulha);
            if (indice_patrulha_atual >= _total_pontos) {
                indice_patrulha_atual = 0;
            }
            
            if (point_distance(x, y, destino_x, destino_y) < 20) {
                indice_patrulha_atual = (indice_patrulha_atual + 1) % _total_pontos;
                var _ponto = pontos_patrulha[| indice_patrulha_atual];
                if (is_array(_ponto) && array_length(_ponto) >= 2) {
                    destino_x = _ponto[0];
                    destino_y = _ponto[1];
                }
            }
        } else {
            // Sem pontos de patrulha - voltar para estado anterior
            estado = estado_anterior != "" ? estado_anterior : "pousado";
        }
        break;
        
    // --- ESTADO DE COMBATE ---
    case "atacando":
        var _alvo_valido = (instance_exists(alvo_em_mira) && 
                           alvo_em_mira != noone && 
                           !is_undefined(alvo_em_mira.x) && 
                           !is_undefined(alvo_em_mira.y) &&
                           point_distance(x, y, alvo_em_mira.x, alvo_em_mira.y) <= radar_alcance);
        
        if (_alvo_valido) {
            // Perseguir o alvo
            destino_x = alvo_em_mira.x;
            destino_y = alvo_em_mira.y;
            
            var _dist_alvo = point_distance(x, y, alvo_em_mira.x, alvo_em_mira.y);
            var _no_alcance_ataque = (_dist_alvo <= alcance_ataque);
            var _no_alcance_radar = (_dist_alvo <= radar_alcance);
            
            // ✅ SISTEMA DE DISPARO DE MÍSSEIS COM INTERVALOS DIFERENTES
            if (_no_alcance_ataque && instance_exists(alvo_em_mira)) {
                
                // Detectar tipo de alvo
                var _alvo_aereo = (alvo_em_mira.object_index == obj_caca_f5 || 
                                  alvo_em_mira.object_index == obj_f6 || 
                                  alvo_em_mira.object_index == obj_f15 ||
                                  alvo_em_mira.object_index == obj_su35 ||
                                  alvo_em_mira.object_index == obj_helicoptero_militar ||
                                  alvo_em_mira.object_index == obj_c100 ||
                                  alvo_em_mira.object_index == obj_caca_f35);
                
                var _alvo_terrestre = (alvo_em_mira.object_index == obj_infantaria ||
                                      alvo_em_mira.object_index == obj_tanque ||
                                      alvo_em_mira.object_index == obj_soldado_antiaereo ||
                                      alvo_em_mira.object_index == obj_blindado_antiaereo);
                
                var _alvo_submarino = (alvo_em_mira.object_index == obj_submarino_base ||
                                      alvo_em_mira.object_index == obj_wwhendrick);
                
                // ✅ SKY (3 segundos) - Para alvos aéreos
                if (_alvo_aereo && timer_sky <= 0) {
                    var _missil_sky = scr_get_projectile_from_pool(obj_SkyFury_ar, x, y, "Instances");
                    if (instance_exists(_missil_sky)) {
                        if (instance_exists(alvo_em_mira)) {
                            _missil_sky.alvo = alvo_em_mira;
                            _missil_sky.target = alvo_em_mira;
                            _missil_sky.dono = id;
                            timer_sky = intervalo_sky; // 3 segundos
                            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                                show_debug_message("🚀 F-35 lançou Sky contra alvo aéreo");
                            }
                        } else {
                            scr_return_projectile_to_pool(_missil_sky);
                        }
                    }
                }
                
                // ✅ IRON (5 segundos) - Para alvos terrestres
                if (_alvo_terrestre && timer_iron <= 0) {
                    var _missil_iron = scr_get_projectile_from_pool(obj_Ironclad_terra, x, y, "Instances");
                    if (instance_exists(_missil_iron)) {
                        if (instance_exists(alvo_em_mira)) {
                            _missil_iron.alvo = alvo_em_mira;
                            _missil_iron.target = alvo_em_mira;
                            _missil_iron.dono = id;
                            timer_iron = intervalo_iron; // 5 segundos
                            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                                show_debug_message("💥 F-35 lançou Iron contra alvo terrestre");
                            }
                        } else {
                            scr_return_projectile_to_pool(_missil_iron);
                        }
                    }
                }
                
                // ✅ HASH (6 segundos) - Para alvos terrestres e submarinos
                if ((_alvo_terrestre || _alvo_submarino) && timer_hash <= 0) {
                    var _missil_hash = instance_create_layer(x, y, "Instances", obj_hash);
                    if (instance_exists(_missil_hash) && instance_exists(alvo_em_mira)) {
                        _missil_hash.alvo = alvo_em_mira;
                        _missil_hash.target = alvo_em_mira;
                        _missil_hash.dono = id;
                        timer_hash = intervalo_hash; // 6 segundos
                        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                            show_debug_message("💣 F-35 lançou Hash contra alvo");
                        }
                    }
                }
                
                // ✅ LIT (7 segundos) - Para todos os tipos de alvo
                if (timer_lit <= 0) {
                    var _missil_lit = scr_get_projectile_from_pool(obj_lit, x, y, "Instances");
                    if (!instance_exists(_missil_lit)) {
                        _missil_lit = instance_create_layer(x, y, "Instances", obj_lit);
                    }
                    if (instance_exists(_missil_lit) && instance_exists(alvo_em_mira)) {
                        _missil_lit.alvo = alvo_em_mira;
                        _missil_lit.dono = id;
                        var _angulo = point_direction(x, y, alvo_em_mira.x, alvo_em_mira.y);
                        _missil_lit.direction = _angulo;
                        _missil_lit.image_angle = _angulo;
                        timer_lit = intervalo_lit; // 7 segundos
                        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                            show_debug_message("🔥 F-35 lançou Lit contra alvo");
                        }
                    }
                }
            }
            
            // Se saiu do alcance do radar, perder o alvo
            if (!_no_alcance_radar) {
                // ✅ CORREÇÃO: Voltar para patrulhando se estava patrulhando
                if (estado_anterior == "patrulhando") {
                    // Verificar se ainda tem pontos de patrulha
                    if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
                        estado = "patrulhando";
                        // Continuar patrulha do ponto atual
                        if (variable_instance_exists(id, "indice_patrulha_atual")) {
                            var _ponto = pontos_patrulha[| indice_patrulha_atual];
                            if (is_array(_ponto) && array_length(_ponto) >= 2) {
                                destino_x = _ponto[0];
                                destino_y = _ponto[1];
                            }
                        }
                    } else {
                        estado = estado_anterior;
                    }
                } else {
                    estado = estado_anterior;
                }
                alvo_em_mira = noone;
            }
        } 
        else {
            // ✅ CORREÇÃO: Alvo destruído ou inválido - voltar para patrulhando se estava patrulhando
            if (estado_anterior == "patrulhando") {
                // Verificar se ainda tem pontos de patrulha
                if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
                    estado = "patrulhando";
                    // Continuar patrulha do ponto atual
                    if (variable_instance_exists(id, "indice_patrulha_atual")) {
                        var _ponto = pontos_patrulha[| indice_patrulha_atual];
                        if (is_array(_ponto) && array_length(_ponto) >= 2) {
                            destino_x = _ponto[0];
                            destino_y = _ponto[1];
                        }
                    }
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("✅ F-35: Alvo destruído! Voltando a patrulhar.");
                    }
                } else {
                    // Sem pontos de patrulha - voltar para estado padrão
                    estado = estado_anterior != "" ? estado_anterior : "pousado";
                }
            } else {
                // Não estava patrulhando - voltar para estado anterior
                estado = estado_anterior;
            }
            alvo_em_mira = noone;
        }
        break;
}

// --- 5. LÓGICA DE MOVIMENTO E ALTITUDE ---
// ✅ CORREÇÃO: Estado "atacando" também deve voar e perseguir o alvo
var _is_flying = (estado == "movendo" || estado == "patrulhando" || estado == "decolando" || estado == "atacando");
var _is_landing = (estado == "pousando");

if (_is_flying) {
    altura_voo = min(altura_maxima, altura_voo + 0.3);
    
    // ✅ CORREÇÃO: Se está atacando, atualizar destino para seguir o alvo continuamente
    if (estado == "atacando" && instance_exists(alvo_em_mira)) {
        destino_x = alvo_em_mira.x;
        destino_y = alvo_em_mira.y;
    }
    
    var _dist = point_distance(x, y, destino_x, destino_y);
    if (_dist > 5) {
        var _dir = point_direction(x, y, destino_x, destino_y);
        var _diff = angle_difference(_dir, image_angle);
        image_angle += clamp(_diff, -velocidade_rotacao, velocidade_rotacao);
        velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
    }
} else {
    velocidade_atual = max(0, velocidade_atual - desaceleracao);
    if (_is_landing || estado == "pousado") {
        altura_voo = max(0, altura_voo - 0.3);
    }
    if (altura_voo == 0 && velocidade_atual == 0 && estado == "pousando") {
        estado = "pousado";
    }
}

// Aplicar movimento
var _vel_normalizada = scr_normalize_unit_speed(velocidade_atual);
var _proxima_x = x + lengthdir_x(_vel_normalizada, image_angle);
var _proxima_y = y + lengthdir_y(_vel_normalizada, image_angle);

// Validação de terreno
if (altura_voo <= 5 && (estado == "pousado" || estado == "pousando")) {
    if (!scr_unidade_pode_terreno(id, _proxima_x, _proxima_y)) {
        if (estado == "pousando") {
            estado = "movendo";
            altura_voo = 10;
        } else if (estado == "pousado") {
            estado = "decolando";
            altura_voo = 5;
            velocidade_atual = 2;
            var _terra_proxima = scr_encontrar_terra_proxima(id, x, y, 1000);
            if (_terra_proxima != noone && array_length(_terra_proxima) >= 2) {
                destino_x = _terra_proxima[0];
                destino_y = _terra_proxima[1];
            }
        }
        exit;
    }
}

x = _proxima_x;
y = _proxima_y;
