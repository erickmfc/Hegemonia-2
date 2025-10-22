/// @description Lógica do Tiro do Canhão
// ===============================================
// HEGEMONIA GLOBAL - TIRO DO CANHÃO
// Sistema de Metralhadora
// ===============================================

// === VERIFICAÇÃO DE SEGURANÇA ===
if (!instance_exists(alvo)) {
    instance_destroy();
    exit;
}

// === MOVIMENTO E ROTAÇÃO ===
var _dir = point_direction(x, y, alvo.x, alvo.y);
image_angle = _dir;
direction = _dir;

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
        show_debug_message("💥 Tiro do canhão atingiu alvo! Dano: " + string(dano));
    }
    
    // === EXPLOSÃO PEQUENA ===
    if (object_exists(obj_explosao_pequena)) {
        var _explosao = instance_create_depth(x, y, 0, obj_explosao_pequena);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 150, 50);
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
        }
    }
    
    instance_destroy();
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    instance_destroy();
}
