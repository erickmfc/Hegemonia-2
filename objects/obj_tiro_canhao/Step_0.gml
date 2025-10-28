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
if (instance_exists(alvo)) {
    // Ajustar direção continuamente para seguir o alvo
    direction = point_direction(x, y, alvo.x, alvo.y);
    image_angle = direction;
    
    // Movimento preciso usando lengthdir
    x += lengthdir_x(speed, direction);
    y += lengthdir_y(speed, direction);
}

// === COLISÃO E DANO ===
if (instance_exists(alvo) && point_distance(x, y, alvo.x, alvo.y) <= 20) { // Raio aumentado para 20 pixels
    
    // VERIFICAR SE NÃO É O DONO OU ALIADO
    var _pode_causar_dano = true;
    
    // Verificar se não é o dono
    if (instance_exists(dono) && alvo.id == dono.id) {
        _pode_causar_dano = false;
    }
    // Verificar se não é aliado (mesma nação)
    else if (variable_instance_exists(dono, "nacao_proprietaria") && 
             variable_instance_exists(alvo, "nacao_proprietaria") &&
             dono.nacao_proprietaria == alvo.nacao_proprietaria) {
        _pode_causar_dano = false;
    }
    
    if (_pode_causar_dano) {
        // APLICAR DANO
        var _dano_aplicado = false;
        
        if (variable_instance_exists(alvo, "hp_atual")) {
            alvo.hp_atual -= dano;
            _dano_aplicado = true;
            show_debug_message("💥 Tiro do canhão atingiu " + object_get_name(alvo.object_index) + "! Dano: " + string(dano) + " | HP atual: " + string(alvo.hp_atual) + "/" + string(alvo.hp_max));
        } else if (variable_instance_exists(alvo, "vida")) {
            alvo.vida -= dano;
            _dano_aplicado = true;
            show_debug_message("💥 Tiro do canhão atingiu " + object_get_name(alvo.object_index) + "! Dano: " + string(dano) + " | Vida: " + string(alvo.vida));
        } else if (variable_instance_exists(alvo, "hp")) {
            alvo.hp -= dano;
            _dano_aplicado = true;
            show_debug_message("💥 Tiro do canhão atingiu " + object_get_name(alvo.object_index) + "! Dano: " + string(dano) + " | HP: " + string(alvo.hp));
        }
        
        if (_dano_aplicado) {
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
    } else {
        // Passar pelo dono/aliado sem causar dano
        // Não destroi o projétil, continua voando
    }
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    instance_destroy();
}
