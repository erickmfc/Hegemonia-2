// ===============================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA (Navegação Estilo Rusted Warfare)
// ===============================================

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O) - apenas estes ficam na lancha
    if (keyboard_check_pressed(ord("P"))) { 
        modo_ataque = false; 
        show_debug_message("🛡️ Lancha Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_ataque = true; 
        show_debug_message("⚔️ Lancha Modo ATAQUE AGRESSIVO");
    }

    // Comando de Parada (L)
    if (keyboard_check_pressed(ord("L"))) {
        estado = "parado";
        velocidade_atual = 0;
        alvo_em_mira = noone;
        seguindo_alvo = false;
        show_debug_message("🛑 Lancha parada");
    }
}

// ======================================================================
// --- 2. SISTEMA DE DETECÇÃO DE ALVOS OTIMIZADO ---
// ======================================================================
// Verifica alvos apenas a cada 10 frames para melhorar performance
if (modo_ataque && estado != "parado" && estado != "atacando" && (global.game_frame % 10 == 0)) {
    var _alvo_encontrado = noone;
    var _tipo_alvo = "";
    var _menor_distancia = radar_alcance + 1;
    
    // Busca alvos navais (prioridade máxima)
    with (obj_lancha_patrulha) {
        if (id != other.id && nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.radar_alcance && _dist < _menor_distancia) {
                _menor_distancia = _dist;
                _alvo_encontrado = id;
                _tipo_alvo = "naval (Lancha inimiga)";
            }
        }
    }
    
    // Busca helicópteros se não encontrou alvo naval
    if (!instance_exists(_alvo_encontrado)) {
        with (obj_helicoptero_militar) {
            if (nacao_proprietaria != other.nacao_proprietaria) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.radar_alcance && _dist < _menor_distancia) {
                    _menor_distancia = _dist;
                    _alvo_encontrado = id;
                    _tipo_alvo = "aéreo (Helicóptero inimigo)";
                }
            }
        }
    }
    
    // Busca alvos terrestres se não encontrou outros
    if (!instance_exists(_alvo_encontrado)) {
        with (obj_inimigo) {
            if (nacao_proprietaria != other.nacao_proprietaria) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.radar_alcance && _dist < _menor_distancia) {
                    _menor_distancia = _dist;
                    _alvo_encontrado = id;
                    _tipo_alvo = "terrestre costeiro";
                }
            }
        }
    }
    
    // Se encontrou um inimigo dentro do radar...
    if (instance_exists(_alvo_encontrado)) {
        estado_anterior = estado;
        estado = "atacando";
        alvo_em_mira = _alvo_encontrado;
        seguindo_alvo = false;
        show_debug_message("🎯 Alvo " + _tipo_alvo + " detectado! Interrompendo tarefa para atacar " + string(alvo_em_mira));
    }
}

// ======================================================================
// --- 3. MÁQUINA DE ESTADOS ---
// ======================================================================
switch (estado) {
    case "movendo":
        // Se chegou no destino, para
        if (point_distance(x, y, destino_x, destino_y) < velocidade_maxima) {
            x = destino_x;
            y = destino_y;
            estado = "parado";
        }
        break;

    case "patrulhando":
        // Sistema de patrulha melhorado
        if (ds_list_size(pontos_patrulha) > 0) {
            // Se chegou ao ponto atual, vai para o próximo
            if (point_distance(x, y, destino_x, destino_y) < 8) {
                // Posiciona exatamente no ponto atual
                x = destino_x;
                y = destino_y;
                
                // Vai para o próximo ponto da patrulha
                indice_patrulha_atual = (indice_patrulha_atual + 1) % ds_list_size(pontos_patrulha);
                var _ponto = pontos_patrulha[| indice_patrulha_atual];
                destino_x = _ponto[0];
                destino_y = _ponto[1];
            }
        } else {
            estado = "parado";
        }
        break;
        
    case "atacando":
        // Se o alvo ainda existe, gerencia o combate
        if (instance_exists(alvo_em_mira)) {
            var _distancia_alvo = point_distance(x, y, alvo_em_mira.x, alvo_em_mira.y);
            
            // Se está dentro do alcance de ataque, PARA e atira
            if (_distancia_alvo <= alcance_ataque) {
                // PARA a lancha - não se move mais
                velocidade_atual = 0;
                seguindo_alvo = false;
                
                // Atira se o timer permitir
                if (timer_ataque <= 0) {
                    // Verifica se o alvo é uma unidade naval para usar míssil naval
                    var _missil;
                    if (alvo_em_mira.object_index == obj_lancha_patrulha) {
                        // Alvo naval - usa míssil naval
                        _missil = instance_create_layer(x, y, "Instances", obj_projetil_naval);
                    } else {
                        // Alvo terrestre/aéreo - usa míssil normal
                        _missil = instance_create_layer(x, y, "Instances", obj_tiro_simples);
                    }
                    
                    if (instance_exists(_missil)) {
                        _missil.alvo = alvo_em_mira;
                        _missil.dono = id;
                        timer_ataque = intervalo_ataque;
                    }
                }
            }
            // Se está fora do alcance de ataque mas dentro do radar, SEGUE o alvo
            else if (_distancia_alvo <= radar_alcance) {
                // Verifica se o alvo está se movendo
                if (alvo_em_mira.velocidade_atual > 0.5) {
                    // Alvo está se movendo - segue ele
                    seguindo_alvo = true;
                    destino_x = alvo_em_mira.x;
                    destino_y = alvo_em_mira.y;
                } else {
                    // Alvo parado - vai até ele mas para no alcance de ataque
                    seguindo_alvo = false;
                    var _dir = point_direction(x, y, alvo_em_mira.x, alvo_em_mira.y);
                    destino_x = alvo_em_mira.x - lengthdir_x(alcance_ataque * 0.8, _dir);
                    destino_y = alvo_em_mira.y - lengthdir_y(alcance_ataque * 0.8, _dir);
                }
            }
            // Se saiu do radar, para de atacar
            else {
                estado = estado_anterior;
                alvo_em_mira = noone;
                seguindo_alvo = false;
            }
        } 
        // Se o alvo foi destruído...
        else {
            estado = estado_anterior;
            alvo_em_mira = noone;
            seguindo_alvo = false;
        }
        break;
}

// ======================================================================
// --- 4. LÓGICA DE MOVIMENTO NAVAL ESTILO RUSTED WARFARE ---
// ======================================================================
// Sistema de movimento direto e responsivo
var _is_moving = (estado == "movendo" || estado == "patrulhando" || (estado == "atacando" && seguindo_alvo));

if (_is_moving) {
    var _dist = point_distance(x, y, destino_x, destino_y);
    var _threshold = max(3, velocidade_atual * 1.5); // Threshold dinâmico baseado na velocidade
    
    // Se chegou ao destino
    if (_dist <= _threshold) {
        x = destino_x;
        y = destino_y;
        velocidade_atual = max(0, velocidade_atual - desaceleracao * 2); // Desacelera rápido ao chegar
        if (estado == "movendo") {
            estado = "parado";
        }
    } else {
        // ✅ CALCULA DIREÇÃO PARA O ALVO
        var _dir_to_target = point_direction(x, y, destino_x, destino_y);
        
        // ✅ ROTAÇÃO INDEPENDENTE - Rotaciona suavemente para alinhar com o movimento
        var _angle_diff = angle_difference(_dir_to_target, image_angle);
        image_angle += sign(_angle_diff) * min(abs(_angle_diff), velocidade_rotacao);
        
        // ✅ ACELERAÇÃO SIMPLIFICADA
        if (_dist > velocidade_maxima * 10) {
            velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
        } else if (_dist > velocidade_maxima * 3) {
            velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao * 0.5);
        } else {
            var _target_speed = max(1.0, velocidade_maxima * (_dist / (velocidade_maxima * 3)));
            if (velocidade_atual > _target_speed) {
                velocidade_atual = max(_target_speed, velocidade_atual - desaceleracao);
            } else {
                velocidade_atual = min(_target_speed, velocidade_atual + aceleracao * 0.3);
            }
        }
        
        // ✅ APLICA MOVIMENTO DIRETO - Move DIRETAMENTE na direção do alvo
        x += lengthdir_x(velocidade_atual, _dir_to_target);
        y += lengthdir_y(velocidade_atual, _dir_to_target);
    }
} else {
    // Desaceleração suave quando parado
    velocidade_atual = max(0, velocidade_atual - desaceleracao);
}

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (timer_ataque > 0) {
    timer_ataque--;
}

// --- 6. SISTEMA DE ANTICOLISÃO NAVAL OTIMIZADO ---
if (global.game_frame % 8 == 0) {
    var _raio_separacao = 60;
    var _forca_repulsao = 0.2;
    
    with (obj_lancha_patrulha) {
        if (id != other.id) {
            var _distancia = point_distance(x, y, other.x, other.y);
            if (_distancia < _raio_separacao) {
                var _dir_repulsao = point_direction(x, y, other.x, other.y);
                other.x -= lengthdir_x(_forca_repulsao, _dir_repulsao);
                other.y -= lengthdir_y(_forca_repulsao, _dir_repulsao);
            }
        }
    }
}