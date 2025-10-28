// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-6 (ALVO DE TESTE)
// Step Event - Baseado no F-5 com comportamento automático
// ===============================================

// --- 1. COMPORTAMENTO AUTOMÁTICO DE TESTE ---
if (modo_teste) {
    // Decolagem automática após timer
    if (timer_decolagem_automatica > 0) {
        timer_decolagem_automatica--;
        if (timer_decolagem_automatica <= 0 && estado == "pousado") {
            estado = "decolando";
            show_debug_message("🚀 F-6 iniciando decolagem automática para teste");
        }
    }
    
    // Patrulha automática após decolagem
    if (patrulha_automatica && estado == "decolando") {
        // Cria pontos de patrulha retangular dos soldados inimigos até o meio do mapa
        ds_list_clear(pontos_patrulha);
        
        // Pontos da área retangular de patrulha
        var _pontos_retangulo = [
            [patrulha_x_min, patrulha_y_min],     // Canto inferior esquerdo (soldados inimigos)
            [patrulha_x_max, patrulha_y_min],     // Canto inferior direito
            [patrulha_x_max, patrulha_y_max],     // Canto superior direito (meio do mapa)
            [patrulha_x_min, patrulha_y_max],     // Canto superior esquerdo
            [patrulha_x_min, patrulha_y_min]      // Volta ao início
        ];
        
        // Adicionar pontos intermediários para patrulha mais suave
        for (var i = 0; i < array_length(_pontos_retangulo) - 1; i++) {
            var _p1 = _pontos_retangulo[i];
            var _p2 = _pontos_retangulo[i + 1];
            
            // Adicionar ponto inicial
            ds_list_add(pontos_patrulha, _p1);
            
            // Adicionar pontos intermediários (dividir segmento em 3 partes)
            for (var j = 1; j <= 2; j++) {
                var _px = _p1[0] + (_p2[0] - _p1[0]) * (j / 3);
                var _py = _p1[1] + (_p2[1] - _p1[1]) * (j / 3);
                ds_list_add(pontos_patrulha, [_px, _py]);
            }
        }
        
        estado = "patrulhando";
        indice_patrulha_atual = 0;
        var _ponto = pontos_patrulha[| 0];
        destino_x = _ponto[0];
        destino_y = _ponto[1];
        patrulha_automatica = false; // Evita recriar pontos
        
        show_debug_message("🔄 F-6 iniciando patrulha RETANGULAR automática!");
        show_debug_message("📍 Área: (" + string(patrulha_x_min) + "," + string(patrulha_y_min) + ") até (" + string(patrulha_x_max) + "," + string(patrulha_y_max) + ")");
        show_debug_message("🎯 Pontos de patrulha: " + string(ds_list_size(pontos_patrulha)));
    }
}

// --- 2. MÁQUINA DE ESTADOS (BASEADA NO F-5) ---
switch (estado) {
    case "pousado":
        velocidade_atual = max(0, velocidade_atual - desaceleracao);
        altura_voo = max(0, altura_voo - 0.3);
        break;
        
    case "decolando":
        altura_voo = min(altura_maxima, altura_voo + 0.3);
        velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
        if (altura_voo >= altura_maxima * 0.8) {
            estado = "movendo";
        }
        break;

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
        
    case "pousando":
        altura_voo = max(0, altura_voo - 0.3);
        velocidade_atual = max(0, velocidade_atual - desaceleracao);
        if (altura_voo == 0 && velocidade_atual == 0) {
            estado = "pousado";
        }
        break;
}

// --- 3. LÓGICA DE MOVIMENTO E ALTITUDE ---
var _is_flying = (estado == "movendo" || estado == "patrulhando" || estado == "decolando" || estado == "caçando");
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
} else { // Pousado ou Pousando
    velocidade_atual = max(0, velocidade_atual - desaceleracao);
    if (_is_landing || estado == "pousado") {
        altura_voo = max(0, altura_voo - 0.3);
    }
}

// Aplica o movimento (só se move se tiver velocidade)
x += lengthdir_x(velocidade_atual, image_angle);
y += lengthdir_y(velocidade_atual, image_angle);

// --- 4. SISTEMA DE CAÇA ATIVA (SIMILAR AO F-5) ---
// Se está patrulhando ou movendo, pode entrar em modo de caça
if (estado == "patrulhando" || estado == "movendo") {
    // Detectar inimigos aéreos primeiro (prioridade máxima)
    var _inimigo_aereo = noone;
    var _inimigo_terrestre = noone;
    var _dist_aereo = radar_alcance + 1;
    var _dist_terrestre = radar_alcance + 1;
    
    // Buscar helicópteros militares inimigos
    with (obj_helicoptero_militar) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) { // Apenas helicópteros do jogador
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.radar_alcance && _dist < _dist_aereo) {
                _inimigo_aereo = id;
                _dist_aereo = _dist;
            }
        }
    }
    
    // Buscar caças F-5 inimigos
    with (obj_caca_f5) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) { // Apenas aviões do jogador
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.radar_alcance && _dist < _dist_aereo) {
                _inimigo_aereo = id;
                _dist_aereo = _dist;
            }
        }
    }
    
    // Buscar inimigos terrestres se não há alvos aéreos
    if (!instance_exists(_inimigo_aereo)) {
        with (obj_infantaria) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.alcance_missil_ar_terra && _dist < _dist_terrestre) {
                    _inimigo_terrestre = id;
                    _dist_terrestre = _dist;
                }
            }
        }
        
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.alcance_missil_ar_terra && _dist < _dist_terrestre) {
                    _inimigo_terrestre = id;
                    _dist_terrestre = _dist;
                }
            }
        }
        
        with (obj_blindado_antiaereo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.alcance_missil_ar_terra && _dist < _dist_terrestre) {
                    _inimigo_terrestre = id;
                    _dist_terrestre = _dist;
                }
            }
        }
    }
    
    // Se encontrou um inimigo, entrar em modo de caça
    if (instance_exists(_inimigo_aereo) || instance_exists(_inimigo_terrestre)) {
        var _alvo = instance_exists(_inimigo_aereo) ? _inimigo_aereo : _inimigo_terrestre;
        var _tipo_alvo = instance_exists(_inimigo_aereo) ? "aéreo" : "terrestre";
        
        show_debug_message("🎯 F-6 detectou alvo " + _tipo_alvo + "! Entrando em modo de caça!");
        
        // Entrar em modo de caça
        estado_anterior = estado; // Guarda o estado anterior
        estado = "caçando";
        alvo_em_mira = _alvo;
        destino_x = _alvo.x;
        destino_y = _alvo.y;
        
        // Aumentar altitude para caça (voar mais alto)
        altura_voo = min(altura_maxima, altura_voo + 5);
    }
}

// --- 5. ESTADO DE CAÇA ATIVA ---
if (estado == "caçando") {
    // Se o alvo ainda existe, perseguir ativamente
    if (instance_exists(alvo_em_mira)) {
        destino_x = alvo_em_mira.x;
        destino_y = alvo_em_mira.y;
        
        // Atacar se estiver no alcance e o timer permitir
        if (point_distance(x, y, destino_x, destino_y) <= radar_alcance && timer_ataque <= 0) {
            var _angulo = point_direction(x, y, alvo_em_mira.x, alvo_em_mira.y);
            var _missil = instance_create_layer(x, y, "Instances", obj_tiro_simples);
            
            if (instance_exists(_missil)) {
                _missil.alvo = alvo_em_mira;
                _missil.dono = id;
                
                // Verificar tipo de alvo para usar míssil apropriado
                if (alvo_em_mira.object_index == obj_helicoptero_militar || alvo_em_mira.object_index == obj_caca_f5) {
                    // Alvo aéreo - míssil ar-ar
                    _missil.dano = dano_missil_ar_ar;
                    _missil.speed = 12;
                    _missil.timer_vida = 120;
                    _missil.image_xscale = 2.5;
                    _missil.image_yscale = 2.5;
                    _missil.image_blend = c_red;
                    show_debug_message("🚀 F-6 lançou míssil ar-ar em alvo aéreo!");
                } else {
                    // Alvo terrestre - míssil ar-terra
                    _missil.dano = dano_missil_ar_terra;
                    _missil.speed = 10;
                    _missil.timer_vida = 150;
                    _missil.image_xscale = 2.0;
                    _missil.image_yscale = 2.0;
                    _missil.image_blend = c_yellow;
                    show_debug_message("🚀 F-6 lançou míssil ar-terra em alvo terrestre!");
                }
                
                _missil.direction = _angulo;
                timer_ataque = intervalo_ataque;
            }
        }
    } 
    // Se o alvo foi destruído, retornar ao estado anterior
    else {
        show_debug_message("✅ Alvo destruído! F-6 retornando para: " + estado_anterior);
        estado = estado_anterior;
        alvo_em_mira = noone;
        // Reduzir altitude de volta ao normal
        altura_voo = max(0, altura_voo - 3);
    }
    
    // Reduzir timer de ataque
    if (timer_ataque > 0) {
        timer_ataque--;
    }
}

// --- 6. SISTEMA DE DEBUG DE VIDA ---
// Mostrar informações de vida periodicamente (a cada 3 segundos)
if (modo_teste && (game_get_speed(gamespeed_fps) % 180 == 0)) { // 180 frames = 3 segundos a 60 FPS
    var _vida_percentual = (hp_atual / hp_max) * 100;
    show_debug_message("🛩️ F-6 Status: " + string(hp_atual) + "/" + string(hp_max) + " HP (" + string(_vida_percentual) + "%) | Estado: " + estado);
    
    if (estado == "caçando" && instance_exists(alvo_em_mira)) {
        var _dist_alvo = point_distance(x, y, alvo_em_mira.x, alvo_em_mira.y);
        show_debug_message("🎯 Caçando: " + string(alvo_em_mira.object_index) + " | Distância: " + string(_dist_alvo) + "px");
    }
}

// --- 7. VERIFICAÇÃO DE DESTRUIÇÃO ---
if (hp_atual <= 0) {
    show_debug_message("💥 F-6 DESTRUÍDO! HP: " + string(hp_atual) + "/" + string(hp_max));
    show_debug_message("🎯 Teste de sistema de combate concluído!");
    instance_destroy();
}