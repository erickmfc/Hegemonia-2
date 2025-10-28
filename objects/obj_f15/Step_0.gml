// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-15 (Step com Ataque Agressivo)
// ===============================================

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
    show_debug_message("🔍 F-15 buscando inimigos... nacao: " + string(nacao_proprietaria) + " | radar: " + string(radar_alcance));
    // Usar a função global de detecção de inimigos
    var _alvo_encontrado = scr_buscar_inimigo(x, y, radar_alcance, nacao_proprietaria);
    
    show_debug_message("🎯 Retorno scr_buscar_inimigo: " + string(_alvo_encontrado));
    
    // Se encontrou um inimigo dentro do radar...
    if (instance_exists(_alvo_encontrado)) {
        show_debug_message("✅ Inimigo encontrado! Tipo: " + string(_alvo_encontrado.object_index));
        estado_anterior = estado; // GUARDA o que estava fazendo (ex: "patrulhando")
        estado = "atacando";      // MUDA o estado para "atacando"
        alvo_em_mira = _alvo_encontrado; // Trava a mira no inimigo
        
        var _tipo_alvo = "desconhecido";
        if (_alvo_encontrado.object_index == obj_caca_f5 || _alvo_encontrado.object_index == obj_f6 || _alvo_encontrado.object_index == obj_f15) {
            _tipo_alvo = "aéreo (caça inimigo)";
        } else if (_alvo_encontrado.object_index == obj_helicoptero_militar) {
            _tipo_alvo = "aéreo (helicóptero)";
        } else {
            _tipo_alvo = "terrestre";
        }
        
        show_debug_message("🎯 F-15 detectou alvo " + _tipo_alvo + "! ID: " + string(alvo_em_mira));
    } else {
        show_debug_message("⚠️ F-15 não encontrou inimigos (modo_ataque: " + string(modo_ataque) + " | radar: " + string(radar_alcance) + ")");
    }
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
            
            // ✅ F-15 LANÇA MÚLTIPLOS MÍSSEIS SIMULTANEAMENTES (ar, terra e submarino)
            if (point_distance(x, y, destino_x, destino_y) <= radar_alcance && timer_ataque <= 0) {
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
                
                var _missois_lancados = 0;
                
                // ✅ AÉREO → SKY
                if (_alvo_aereo) {
                    var _missil_ar = instance_create_layer(x, y, "Instances", obj_SkyFury_ar);
                    if (instance_exists(_missil_ar)) {
                        _missil_ar.alvo = alvo_em_mira;
                        _missil_ar.target = alvo_em_mira;
                        _missil_ar.dono = id;
                        _missois_lancados++;
                        show_debug_message("✈️ F-15 lançou Sky contra alvo aéreo");
                    }
                }
                
                // ✅ TERRESTRE → HASH + IRONCLAD
                if (_alvo_terrestre) {
                    // Hash (70% de chance)
                    if (random(1) < 0.7) {
                        var _missil_hash = instance_create_layer(x, y, "Instances", obj_hash);
                        if (instance_exists(_missil_hash)) {
                            _missil_hash.alvo = alvo_em_mira;
                            _missil_hash.target = alvo_em_mira;
                            _missil_hash.dono = id;
                            _missois_lancados++;
                            show_debug_message("💥 F-15 lançou Hash contra alvo terrestre");
                        }
                    }
                    
                    // Ironclad (70% de chance)
                    if (random(1) < 0.7) {
                        var _missil_iron = instance_create_layer(x, y, "Instances", obj_Ironclad_terra);
                        if (instance_exists(_missil_iron)) {
                            _missil_iron.alvo = alvo_em_mira;
                            _missil_iron.target = alvo_em_mira;
                            _missil_iron.dono = id;
                            _missois_lancados++;
                            show_debug_message("💥 F-15 lançou Ironclad contra alvo terrestre");
                        }
                    }
                }
                
                // ✅ SUBMARINO → HASH
                if (_alvo_submarino) {
                    var _missil_sub = instance_create_layer(x, y, "Instances", obj_hash);
                    if (instance_exists(_missil_sub)) {
                        _missil_sub.alvo = alvo_em_mira;
                        _missil_sub.target = alvo_em_mira;
                        _missil_sub.dono = id;
                        _missois_lancados++;
                        show_debug_message("🌊 F-15 lançou Hash contra submarino");
                    }
                }
                
                timer_ataque = intervalo_ataque;
                show_debug_message("🚀🚀 F-15 LANÇOU " + string(_missois_lancados) + " MÍSSEIS!");
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
x += lengthdir_x(velocidade_atual, image_angle);
y += lengthdir_y(velocidade_atual, image_angle);

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (timer_ataque > 0) {
    timer_ataque--;
}
