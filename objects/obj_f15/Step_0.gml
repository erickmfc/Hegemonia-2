// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-15 (Step com Ataque Agressivo)
// ===============================================

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

// ✅ SEMPRE processar se selecionado ou em combate crítico
var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" || estado == "decolando" || estado == "pousando");

// ✅ Se não for sempre processar, verificar frame skip
if (!should_always_process && skip_frames_enabled) {
    // Obter LOD atual (com fallback se script não existir)
    var current_lod = 2; // Default: detalhe normal
    var current_zoom = 1.0;
    if (instance_exists(obj_input_manager)) {
        current_zoom = obj_input_manager.zoom_level;
    }
    if (current_zoom >= 2.0) current_lod = 3;
    else if (current_zoom >= 0.8) current_lod = 2;
    else if (current_zoom >= 0.4) current_lod = 1;
    else current_lod = 0;
    
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        // Frame skip: movimento básico apenas (F-15 usa sistema de velocidade próprio)
        if (estado == "movendo" || estado == "patrulhando") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (velocidade_atual > 0) {
                // ✅ CORREÇÃO: Normalizar velocidade antes de aplicar multiplicador do LOD
                var _vel_normalizada = scr_normalize_unit_speed(velocidade_atual);
                x += lengthdir_x(_vel_normalizada * speed_mult, image_angle);
                y += lengthdir_y(_vel_normalizada * speed_mult, image_angle);
            }
        }
        exit;
    }
    lod_level = current_lod;
}

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O) - mesmos do F-5
    if (keyboard_check_pressed(ord("P"))) { 
        modo_ataque = false; 
        show_debug_message("🛡️ F-15 Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_ataque = true; 
        show_debug_message("⚔️ F-15 Modo ATAQUE AGRESSIVO");
    }

    // Comando de Pouso (L)
    if (keyboard_check_pressed(ord("L")) && estado != "pousado") {
        estado = "pousando";
    }
}

// ======================================================================
// --- 2. NOVA LÓGICA: AQUISIÇÃO DE ALVO (PRIORIDADE MÁXIMA) ---
// ======================================================================
// Se o modo ataque está ativo E o avião não está pousando/decolando E não está já atacando...
if (modo_ataque && estado != "pousando" && estado != "decolando" && estado != "atacando") {
    // ✅ REMOVIDO: Debug excessivo que causava lentidão
    // Usar a função global de detecção de inimigos
    var _alvo_encontrado = scr_buscar_inimigo(x, y, radar_alcance, nacao_proprietaria);
    
    // Se encontrou um inimigo dentro do radar...
    if (instance_exists(_alvo_encontrado)) {
        // ✅ Debug apenas quando encontra inimigo (evento raro)
        if (variable_global_exists("debug_enabled") && global.debug_enabled && current_time mod 5000 < 17) {
            show_debug_message("✅ F-15 encontrou inimigo! Tipo: " + string(_alvo_encontrado.object_index));
        }
        estado_anterior = estado; // GUARDA o que estava fazendo (ex: "patrulhando")
        estado = "atacando";      // MUDA o estado para "atacando"
        alvo_em_mira = _alvo_encontrado; // Trava a mira no inimigo
    }
    // ✅ REMOVIDO: Debug de "não encontrou inimigos" - muito frequente
}
// ======================================================================

// --- 3. MÁQUINA DE ESTADOS ---
// Gerencia as transições e lógicas de cada estado
switch (estado) {
    case "movendo":
        // Se chegou no destino, inicia o pouso
        if (point_distance(x, y, destino_x, destino_y) < 15 && velocidade_atual < 0.5) {
            estado = "pousando";
        }
        break;

    case "patrulhando":
        // Se chegou ao ponto atual, vai para o próximo
        if (point_distance(x, y, destino_x, destino_y) < 20) {
            indice_patrulha_atual = (indice_patrulha_atual + 1) % ds_list_size(pontos_patrulha);
            var _ponto = pontos_patrulha[| indice_patrulha_atual];
            destino_x = _ponto[0];
            destino_y = _ponto[1];
        }
        break;
        
    // --- ESTADO DE COMBATE ---
    case "atacando":
        // Se o alvo ainda existe, o persegue
        if (instance_exists(alvo_em_mira)) {
            destino_x = alvo_em_mira.x;
            destino_y = alvo_em_mira.y;
            
            // ✅ F-15 LANÇA MÚLTIPLOS MÍSSEIS SIMULTANEAMENTES (ar, terra, submarino e ESTRUTURAS)
            // ✅ VALIDAÇÃO: Verificar se alvo é válido antes de disparar
            var _alvo_valido = (instance_exists(alvo_em_mira) && 
                                alvo_em_mira != noone && 
                                !is_undefined(alvo_em_mira.x) && 
                                !is_undefined(alvo_em_mira.y) &&
                                point_distance(x, y, alvo_em_mira.x, alvo_em_mira.y) <= radar_alcance);
            
            if (_alvo_valido && timer_ataque <= 0) {
                // Detectar tipo de alvo
                var _alvo_aereo = (alvo_em_mira.object_index == obj_caca_f5 || 
                                  alvo_em_mira.object_index == obj_f6 || 
                                  alvo_em_mira.object_index == obj_f15 ||
                                  alvo_em_mira.object_index == obj_helicoptero_militar ||
                                  alvo_em_mira.object_index == obj_c100);
                
                var _alvo_terrestre = (alvo_em_mira.object_index == obj_infantaria ||
                                      alvo_em_mira.object_index == obj_tanque ||
                                      alvo_em_mira.object_index == obj_soldado_antiaereo ||
                                      alvo_em_mira.object_index == obj_blindado_antiaereo);
                
                var _alvo_submarino = (alvo_em_mira.object_index == obj_submarino_base ||
                                      alvo_em_mira.object_index == obj_wwhendrick);
                
                // ✅ NOVO: Detectar estruturas inimigas
                var _alvo_estrutura = (alvo_em_mira.object_index == obj_quartel ||
                                      alvo_em_mira.object_index == obj_aeroporto_militar ||
                                      alvo_em_mira.object_index == obj_quartel_marinha ||
                                      alvo_em_mira.object_index == obj_fazenda ||
                                      alvo_em_mira.object_index == obj_mina ||
                                      alvo_em_mira.object_index == obj_banco ||
                                      alvo_em_mira.object_index == obj_casa);
                
                // ✅ NOVO: Verificar se é presidente inimigo
                var _obj_presidente = asset_get_index("obj_presidente_1");
                var _alvo_presidente = false;
                if (_obj_presidente != -1 && asset_get_type(_obj_presidente) == asset_object) {
                    _alvo_presidente = (alvo_em_mira.object_index == _obj_presidente);
                }
                
                var _missois_lancados = 0;
                
                // ✅ AÉREO → SKY via pool
                if (_alvo_aereo && instance_exists(alvo_em_mira)) {
                    var _missil_ar = scr_get_projectile_from_pool(obj_SkyFury_ar, x, y, "Instances");
                    if (instance_exists(_missil_ar)) {
                        // ✅ VALIDAÇÃO: Verificar se alvo ainda existe antes de atribuir
                        if (instance_exists(alvo_em_mira)) {
                            _missil_ar.alvo = alvo_em_mira;
                            _missil_ar.target = alvo_em_mira;
                            _missil_ar.dono = id;
                            _missois_lancados++;
                            show_debug_message("✈️ F-15 lançou Sky contra alvo aéreo");
                        } else {
                            scr_return_projectile_to_pool(_missil_ar);
                        }
                    }
                }
                
                // ✅ TERRESTRE → HASH + IRONCLAD
                if (_alvo_terrestre && instance_exists(alvo_em_mira)) {
                    // Hash (70% de chance)
                    if (random(1) < 0.7) {
                        var _missil_hash = instance_create_layer(x, y, "Instances", obj_hash);
                        if (instance_exists(_missil_hash) && instance_exists(alvo_em_mira)) {
                            _missil_hash.alvo = alvo_em_mira;
                            _missil_hash.target = alvo_em_mira;
                            _missil_hash.dono = id;
                            _missois_lancados++;
                            show_debug_message("💥 F-15 lançou Hash contra alvo terrestre");
                        }
                    }
                    
                    // Ironclad (70% de chance) via pool
                    if (random(1) < 0.7) {
                        var _missil_iron = scr_get_projectile_from_pool(obj_Ironclad_terra, x, y, "Instances");
                        if (instance_exists(_missil_iron)) {
                            if (instance_exists(alvo_em_mira)) {
                                _missil_iron.alvo = alvo_em_mira;
                                _missil_iron.target = alvo_em_mira;
                                _missil_iron.dono = id;
                                _missois_lancados++;
                                show_debug_message("💥 F-15 lançou Ironclad contra alvo terrestre");
                            } else {
                                scr_return_projectile_to_pool(_missil_iron);
                            }
                        }
                    }
                }
                
                // ✅ SUBMARINO → HASH
                if (_alvo_submarino && instance_exists(alvo_em_mira)) {
                    var _missil_sub = instance_create_layer(x, y, "Instances", obj_hash);
                    if (instance_exists(_missil_sub) && instance_exists(alvo_em_mira)) {
                        _missil_sub.alvo = alvo_em_mira;
                        _missil_sub.target = alvo_em_mira;
                        _missil_sub.dono = id;
                        _missois_lancados++;
                        show_debug_message("🌊 F-15 lançou Hash contra submarino");
                    }
                }
                
                // ✅ NOVO: ESTRUTURAS E PRESIDENTE → IRONCLAD (míssil terra-terra poderoso)
                if ((_alvo_estrutura || _alvo_presidente) && instance_exists(alvo_em_mira)) {
                    // Lançar 2-3 mísseis Ironclad contra estruturas (mais devastador)
                    for (var _i = 0; _i < 2; _i++) {
                        var _missil_iron = scr_get_projectile_from_pool(obj_Ironclad_terra, x + random_range(-10, 10), y + random_range(-10, 10), "Instances");
                        if (instance_exists(_missil_iron)) {
                            if (instance_exists(alvo_em_mira)) {
                                _missil_iron.alvo = alvo_em_mira;
                                _missil_iron.target = alvo_em_mira;
                                _missil_iron.dono = id;
                                _missois_lancados++;
                            } else {
                                scr_return_projectile_to_pool(_missil_iron);
                            }
                        }
                    }
                    // Também lançar Hash para dano adicional
                    var _missil_hash = instance_create_layer(x, y, "Instances", obj_hash);
                    if (instance_exists(_missil_hash) && instance_exists(alvo_em_mira)) {
                        _missil_hash.alvo = alvo_em_mira;
                        _missil_hash.target = alvo_em_mira;
                        _missil_hash.dono = id;
                        _missois_lancados++;
                    }
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("🏗️ F-15 lançou " + string(_missois_lancados) + " mísseis contra estrutura/presidente!");
                    }
                }
                
                timer_ataque = intervalo_ataque;
                if (_missois_lancados > 0) {
                    show_debug_message("🚀🚀 F-15 LANÇOU " + string(_missois_lancados) + " MÍSSEIS!");
                }
            }
        } 
        // Se o alvo foi destruído...
        else {
            show_debug_message("✅ Alvo destruído! Retornando para: " + estado_anterior);
            estado = estado_anterior; // RETORNA para o que estava fazendo antes
            alvo_em_mira = noone;       // Limpa a mira
        }
        break;
}

// --- 4. LÓGICA DE MOVIMENTO E ALTITUDE (CÓDIGO UNIFICADO) ---
var _is_flying = (estado == "movendo" || estado == "patrulhando" || estado == "decolando" || estado == "atacando");
var _is_landing = (estado == "pousando");

if (_is_flying) {
    altura_voo = min(altura_maxima, altura_voo + 0.3);
    
    var _dist = point_distance(x, y, destino_x, destino_y);
    if (_dist > 5) {
        var _dir = point_direction(x, y, destino_x, destino_y);
        var _diff = angle_difference(_dir, image_angle);
        image_angle += clamp(_diff, -velocidade_rotacao, velocidade_rotacao);
        velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
    }
} else { // Pousado, Pousando ou Definindo Patrulha
    velocidade_atual = max(0, velocidade_atual - desaceleracao);
    if (_is_landing || estado == "pousado") {
        altura_voo = max(0, altura_voo - 0.3);
    }
    if (altura_voo == 0 && velocidade_atual == 0 && estado == "pousando") {
        estado = "pousado";
    }
}

// Aplica o movimento (só se move se tiver velocidade)
// ✅ CORREÇÃO: Normalizar velocidade baseado no zoom para manter velocidade visual constante
var _vel_normalizada = scr_normalize_unit_speed(velocidade_atual);
x += lengthdir_x(_vel_normalizada, image_angle);
y += lengthdir_y(_vel_normalizada, image_angle);

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (timer_ataque > 0) {
    timer_ataque--;
}
