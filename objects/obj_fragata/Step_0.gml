// ===============================================
// HEGEMONIA GLOBAL - FRAGATA STEP EVENT
// Sistema de movimento e combate unificado
// ===============================================

// === LÓGICA DE MODOS DE COMBATE ===
// ✅ OTIMIZAÇÃO: Decrementar timer de verificação
if (timer_verificacao_inimigos > 0) {
    timer_verificacao_inimigos--;
}

if (modo_combate == "passivo") {
    alvo = noone;
    if (estado == "atacando") estado = "parado";
} else if (modo_combate == "atacando") {
    // Procurar inimigos automaticamente
    // ✅ OTIMIZAÇÃO: Só verificar inimigos periodicamente (quando timer chegar a 0) ou se não tem alvo
    if ((alvo == noone || !instance_exists(alvo)) && (timer_verificacao_inimigos <= 0)) {
        var _inimigo_mais_proximo = noone;
        var _menor_distancia = alcance;
        
        // ✅ CORREÇÃO: obj_inimigo removido - buscar apenas obj_infantaria
        // Buscar obj_infantaria
        if (_inimigo_mais_proximo == noone) {
            var _infantaria = instance_nearest(x, y, obj_infantaria);
            if (_infantaria != noone) {
                var _dist = point_distance(x, y, _infantaria.x, _infantaria.y);
                if (_dist < _menor_distancia && _infantaria.nacao_proprietaria != nacao_proprietaria) {
                    _menor_distancia = _dist;
                    _inimigo_mais_proximo = _infantaria;
                }
            }
        }
        
        // Se ainda não encontrou, buscar obj_tanque
        if (_inimigo_mais_proximo == noone) {
            var _tanque = instance_nearest(x, y, obj_tanque);
            if (_tanque != noone) {
                var _dist = point_distance(x, y, _tanque.x, _tanque.y);
                if (_dist < _menor_distancia && _tanque.nacao_proprietaria != nacao_proprietaria) {
                    _menor_distancia = _dist;
                    _inimigo_mais_proximo = _tanque;
                }
            }
        }
        
        if (_inimigo_mais_proximo != noone) {
            alvo = _inimigo_mais_proximo;
            estado = "atacando";
        }
        
        // ✅ OTIMIZAÇÃO: Resetar timer após verificação
        timer_verificacao_inimigos = intervalo_verificacao_inimigos;
    }
}

// === MOVIMENTO BÁSICO ===
if (estado == "movendo" || movendo) {
    var _distancia = point_distance(x, y, destino_x, destino_y);
    
    if (_distancia > 5) {
        var _angulo = point_direction(x, y, destino_x, destino_y);
        // ✅ CORREÇÃO: Rotação suave com velocidade de 0.8 graus por frame
        var _diff = angle_difference(image_angle, _angulo);
        var _vel_rotacao = min(velocidade_rotacao, abs(_diff));
        image_angle += sign(_diff) * -_vel_rotacao;
        
        // ✅ REALISMO: Movimento curvo - sempre move na direção que está apontando enquanto vira
        // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom
        var _vel_normalizada = scr_normalize_unit_speed(velocidade);
        var _velocidade_suave = min(_vel_normalizada, _distancia * 0.1);
        // Movimento na direção que o navio está apontando (cria curva suave)
        x += lengthdir_x(_velocidade_suave, image_angle);
        y += lengthdir_y(_velocidade_suave, image_angle);
        
        // ✅ EFEITO DE ESPUMA DO MAR (Rastro de água)
        if (!variable_instance_exists(id, "timer_espuma")) {
            timer_espuma = 0;
        }
        timer_espuma++;
        if (timer_espuma >= 3) {
            timer_espuma = 0;
            var _distancia_popa = 20;
            var _angulo_popa = image_angle + 180;
            var _layer_navio = layer_get_name(layer);
            
            // obj_WTrail4 no MEIO do navio
            if (object_exists(obj_WTrail4)) {
                var _pos_espuma_x = x;
                var _pos_espuma_y = y;
                var _espuma = noone;
                if (layer_exists(_layer_navio)) {
                    _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, _layer_navio, obj_WTrail4);
                }
                if (!instance_exists(_espuma) && layer_exists("Instances")) {
                    _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, "Instances", obj_WTrail4);
                }
                if (instance_exists(_espuma)) {
                    _espuma.timer_duracao = 90;
                    _espuma.timer_atual = 0;
                    if (_espuma.sprite_index == -1) {
                        _espuma.sprite_index = asset_get_index("WTrail4");
                    }
                    _espuma.image_xscale = 1.0 + random(0.4);
                    _espuma.image_yscale = 1.0 + random(0.4);
                    _espuma.image_blend = c_white;
                    _espuma.visible = true;
                    _espuma.image_alpha = 0.2;
                    if (variable_instance_exists(id, "depth")) {
                        _espuma.depth = depth + 1;
                    } else {
                        _espuma.depth = -100;
                    }
                    _espuma.image_angle = image_angle + random_range(-5, 5);
                }
            }
            
            // ✅ obj_WbTrail1 no FINAL do navio (popa) - Fragata: sprite 600px, distância ~282px
            if (object_exists(obj_WbTrail1)) {
                var _distancia_final = 282; // 600px * 0.47 ≈ 282px (proporção baseada na lancha patrulha)
                var _pos_popa_x = x + lengthdir_x(_distancia_final, _angulo_popa);
                var _pos_popa_y = y + lengthdir_y(_distancia_final, _angulo_popa);
                var _trail_popa = noone;
                if (layer_exists(_layer_navio)) {
                    _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, _layer_navio, obj_WbTrail1);
                }
                if (!instance_exists(_trail_popa) && layer_exists("Instances")) {
                    _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, "Instances", obj_WbTrail1);
                }
                if (instance_exists(_trail_popa)) {
                    _trail_popa.timer_duracao = 90;
                    _trail_popa.timer_atual = 0;
                    _trail_popa.image_xscale = 3.0 * 0.8; // 80% do tamanho
                    _trail_popa.image_yscale = 3.0 * 0.8;
                    _trail_popa.image_alpha = 0.2; // Mesma transparência do trail4
                    _trail_popa.image_blend = c_white;
                    _trail_popa.visible = true;
                    if (variable_instance_exists(id, "depth")) {
                        _trail_popa.depth = depth + 1;
                    } else {
                        _trail_popa.depth = -100;
                    }
                    _trail_popa.image_angle = image_angle + random_range(-5, 5);
                }
            }
        }
    } else {
        estado = "parado";
        movendo = false;
    }
}

// === MOVIMENTO PARA ATAQUE ===
if (estado == "atacando" && alvo != noone && instance_exists(alvo)) {
    var distancia_alvo = point_distance(x, y, alvo.x, alvo.y);
    
    if (distancia_alvo > alcance_tiro) {
        // Mover para o alvo
        var _angulo = point_direction(x, y, alvo.x, alvo.y);
        // ✅ CORREÇÃO: Rotação suave com velocidade de 0.8 graus por frame
        var _diff = angle_difference(image_angle, _angulo);
        var _vel_rotacao = min(velocidade_rotacao, abs(_diff));
        image_angle += sign(_diff) * -_vel_rotacao;
        
        // ✅ REALISMO: Movimento curvo - sempre move na direção que está apontando enquanto vira
        // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom
        var _vel_normalizada = scr_normalize_unit_speed(velocidade);
        var _velocidade_suave = min(_vel_normalizada, distancia_alvo * 0.1);
        // Movimento na direção que o navio está apontando (cria curva suave)
        x += lengthdir_x(_velocidade_suave, image_angle);
        y += lengthdir_y(_velocidade_suave, image_angle);
        
        // ✅ EFEITO DE ESPUMA DO MAR (durante movimento de ataque)
        if (!variable_instance_exists(id, "timer_espuma")) {
            timer_espuma = 0;
        }
        timer_espuma++;
        if (timer_espuma >= 3) {
            timer_espuma = 0;
            var _distancia_popa = 20;
            var _angulo_popa = image_angle + 180;
            var _layer_navio = layer_get_name(layer);
            
            // obj_WTrail4 no MEIO do navio
            if (object_exists(obj_WTrail4)) {
                var _pos_espuma_x = x;
                var _pos_espuma_y = y;
                var _espuma = noone;
                if (layer_exists(_layer_navio)) {
                    _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, _layer_navio, obj_WTrail4);
                }
                if (!instance_exists(_espuma) && layer_exists("Instances")) {
                    _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, "Instances", obj_WTrail4);
                }
                if (instance_exists(_espuma)) {
                    _espuma.timer_duracao = 90;
                    _espuma.timer_atual = 0;
                    if (_espuma.sprite_index == -1) {
                        _espuma.sprite_index = asset_get_index("WTrail4");
                    }
                    _espuma.image_xscale = 1.0 + random(0.4);
                    _espuma.image_yscale = 1.0 + random(0.4);
                    _espuma.image_blend = c_white;
                    _espuma.visible = true;
                    _espuma.image_alpha = 0.2;
                    if (variable_instance_exists(id, "depth")) {
                        _espuma.depth = depth + 1;
                    } else {
                        _espuma.depth = -100;
                    }
                    _espuma.image_angle = image_angle + random_range(-5, 5);
                }
            }
            
            // ✅ obj_WbTrail1 no FINAL do navio (popa) - Fragata: sprite 600px, distância ~282px
            if (object_exists(obj_WbTrail1)) {
                var _distancia_final = 282;
                var _pos_popa_x = x + lengthdir_x(_distancia_final, _angulo_popa);
                var _pos_popa_y = y + lengthdir_y(_distancia_final, _angulo_popa);
                var _trail_popa = noone;
                if (layer_exists(_layer_navio)) {
                    _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, _layer_navio, obj_WbTrail1);
                }
                if (!instance_exists(_trail_popa) && layer_exists("Instances")) {
                    _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, "Instances", obj_WbTrail1);
                }
                if (instance_exists(_trail_popa)) {
                    _trail_popa.timer_duracao = 90;
                    _trail_popa.timer_atual = 0;
                    _trail_popa.image_xscale = 3.0 * 0.8;
                    _trail_popa.image_yscale = 3.0 * 0.8;
                    _trail_popa.image_alpha = 0.2;
                    _trail_popa.image_blend = c_white;
                    _trail_popa.visible = true;
                    if (variable_instance_exists(id, "depth")) {
                        _trail_popa.depth = depth + 1;
                    } else {
                        _trail_popa.depth = -100;
                    }
                    _trail_popa.image_angle = image_angle + random_range(-5, 5);
                }
            }
        }
    } else {
        // === ATAQUE DIRETO COM EFEITOS VISUAIS ===
        if (atq_cooldown <= 0) {
            
            // Aplicar dano diretamente com verificação de segurança
            with (alvo) {
                // Verificar se o objeto tem HP definido
                if (variable_instance_exists(id, "hp_atual")) {
                    hp_atual -= 40; // Dano maior da fragata
                    if (hp_atual <= 0) {
                        hp_atual = 0;
                        // Aqui você pode adicionar lógica de destruição
                    }
                } else {
                    // Se não tem HP, aplicar dano genérico
                    if (variable_instance_exists(id, "hp")) {
                        hp -= 40;
                        if (hp <= 0) hp = 0;
                    } else {
                        // Criar HP se não existir
                        hp_atual = 100;
                        hp_atual -= 40;
                        if (hp_atual <= 0) hp_atual = 0;
                    }
                }
            }
            
            // Criar efeito visual de explosão no alvo
            var _explosao = instance_create_layer(alvo.x, alvo.y, "Instances", obj_explosao_aquatica);
            if (instance_exists(_explosao)) {
                _explosao.image_blend = c_red; // Cor vermelha para fragata
                _explosao.image_xscale = 3.5;  // Explosão maior
                _explosao.image_yscale = 3.5;
            }
            
            // Criar efeito de rastro do míssil
            var _rastro = instance_create_layer(x, y, "Instances", obj_WTrail4);
            if (instance_exists(_rastro)) {
                _rastro.image_blend = c_red; // Cor vermelha para fragata
                _rastro.image_xscale = 4.5;   // Rastro maior
                _rastro.image_yscale = 4.5;
                _rastro.speed = 10;
                _rastro.direction = point_direction(x, y, alvo.x, alvo.y);
            }
            
            // Criar efeito visual de míssil usando obj_WTrail4
            var _missil_visual = instance_create_layer(x, y, "Instances", obj_WTrail4);
            if (instance_exists(_missil_visual)) {
                _missil_visual.image_blend = c_red; // Cor vermelha para fragata
                _missil_visual.image_xscale = 7.0;   // Míssil visual maior
                _missil_visual.image_yscale = 7.0;
                _missil_visual.speed = 10;
                _missil_visual.direction = point_direction(x, y, alvo.x, alvo.y);
            }
            
            // Resetar cooldown
            atq_cooldown = atq_rate;
            
            show_debug_message("🚀 Fragata atirou com SUCESSO! Dano: 40");
        }
    }
}

// === COOLDOWN DO ATAQUE ===
if (atq_cooldown > 0) atq_cooldown--;