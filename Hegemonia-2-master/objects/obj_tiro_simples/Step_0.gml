// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Step Event - Sistema ROBUSTO E SEM ERROS
// ================================================

// === VERIFICAÇÃO DE SEGURANÇA ===
if (!instance_exists(alvo)) {
    instance_destroy();
    exit;
}

// === MOVIMENTO E ROTAÇÃO ===
if (instance_exists(alvo)) {
    var _dir = point_direction(x, y, alvo.x, alvo.y);
    direction = _dir;
    image_angle = _dir;
    
    // Mantém a velocidade constante
    x += lengthdir_x(speed, direction);
    y += lengthdir_y(speed, direction);
}

// === COLISÃO E DANO ===
if (point_distance(x, y, alvo.x, alvo.y) <= speed) {
    
    // APLICAR DANO SEGURO
    var _dano_aplicado = false;
    
    if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= dano;
        _dano_aplicado = true;
    } else if (variable_instance_exists(alvo, "hp_atual")) {
        alvo.hp_atual -= dano;
        _dano_aplicado = true;
    } else if (variable_instance_exists(alvo, "hp")) {
        alvo.hp -= dano;
        _dano_aplicado = true;
    } else {
        alvo.vida = 100;
        alvo.vida -= dano;
        _dano_aplicado = true;
    }
    
    if (_dano_aplicado) {
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(dano));
    }
    
    // === EXPLOSÃO SEGURA ===
    if (object_exists(obj_explosao_aquatica)) {
        var _explosao = instance_create_depth(x, y, 0, obj_explosao_aquatica);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(150, 200, 255);
            _explosao.image_xscale = 2.0;
            _explosao.image_yscale = 2.0;
            _explosao.image_angle = random(360);
        }
    }
    
    instance_destroy();
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    instance_destroy();
}