// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO TANQUE
// Step Event - Sistema de Projétil com Pooling
// ================================================

// === VERIFICAÇÃO DE SEGURANÇA ===
if (!instance_exists(alvo)) {
    scr_return_projectile_to_pool(id);
    exit;
}

// === MOVIMENTO E ROTAÇÃO ===
var _dir = point_direction(x, y, alvo.x, alvo.y);
image_angle = _dir;
direction = _dir;

// Movimento em direção ao alvo
x += lengthdir_x(speed, _dir);
y += lengthdir_y(speed, _dir);

// === COLISÃO E DANO ===
if (point_distance(x, y, alvo.x, alvo.y) <= speed) {
    // Aplicar dano
    var _dano_aplicado = false;
    
    if (variable_instance_exists(alvo, "hp_atual")) {
        alvo.hp_atual -= dano;
        _dano_aplicado = true;
    } else if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= dano;
        _dano_aplicado = true;
    } else if (variable_instance_exists(alvo, "hp")) {
        alvo.hp -= dano;
        _dano_aplicado = true;
    }
    
    if (_dano_aplicado) {
        // === EXPLOSÃO VISUAL ===
        if (object_exists(obj_explosao_pequena)) {
            var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_pequena);
            if (instance_exists(_explosao)) {
                _explosao.image_blend = make_color_rgb(255, 200, 50);
                _explosao.image_xscale = 1.2;
                _explosao.image_yscale = 1.2;
            }
        }
    }
    
    // Retornar ao pool
    scr_return_projectile_to_pool(id);
    exit;
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    scr_return_projectile_to_pool(id);
    exit;
}

