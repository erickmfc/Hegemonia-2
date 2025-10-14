// ===============================================
// HEGEMONIA GLOBAL - FRAGATA STEP EVENT
// Sistema de movimento e combate unificado
// ===============================================

// === LÓGICA DE MODOS DE COMBATE ===
if (modo_combate == "passivo") {
    alvo = noone;
    if (estado == "atacando") estado = "parado";
} else if (modo_combate == "atacando") {
    // Procurar inimigos automaticamente
    if (alvo == noone || !instance_exists(alvo)) {
        var _inimigo_mais_proximo = noone;
        var _menor_distancia = alcance;
        
        // Buscar obj_inimigo primeiro (prioridade)
        var _inimigo = instance_nearest(x, y, obj_inimigo);
        if (_inimigo != noone) {
            var _dist = point_distance(x, y, _inimigo.x, _inimigo.y);
            if (_dist < _menor_distancia && _inimigo.nacao_proprietaria != nacao_proprietaria) {
                _menor_distancia = _dist;
                _inimigo_mais_proximo = _inimigo;
            }
        }
        
        // Se não encontrou obj_inimigo, buscar obj_infantaria
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
    }
}

// === MOVIMENTO BÁSICO ===
if (estado == "movendo" || movendo) {
    var _distancia = point_distance(x, y, destino_x, destino_y);
    
    if (_distancia > 5) {
        var _angulo = point_direction(x, y, destino_x, destino_y);
        image_angle = _angulo;
        
        var _velocidade_suave = min(velocidade, _distancia * 0.1);
        x += lengthdir_x(_velocidade_suave, _angulo);
        y += lengthdir_y(_velocidade_suave, _angulo);
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
        image_angle = _angulo;
        
        var _velocidade_suave = min(velocidade, distancia_alvo * 0.1);
        x += lengthdir_x(_velocidade_suave, _angulo);
        y += lengthdir_y(_velocidade_suave, _angulo);
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