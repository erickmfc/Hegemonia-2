// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Step Event - Sistema ROBUSTO E SEM ERROS
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

// ✅ CORREÇÃO CRÍTICA: Aplicar movimento do projétil (estava faltando!)
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// === COLISÃO E DANO ===
// ✅ CORREÇÃO: Usar velocidade + margem para detecção de colisão (evita passar direto)
var _raio_colisao = max(speed + 10, 15); // Raio baseado na velocidade + margem
if (point_distance(x, y, alvo.x, alvo.y) <= _raio_colisao) {
    
    // APLICAR DANO SEGURO
    var _dano_aplicado = false;
    
    if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= dano;
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(dano) + " | Vida restante: " + string(alvo.vida));
    } else if (variable_instance_exists(alvo, "hp_atual")) {
        alvo.hp_atual -= dano;
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(dano) + " | HP restante: " + string(alvo.hp_atual));
    } else if (variable_instance_exists(alvo, "hp")) {
        alvo.hp -= dano;
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(dano) + " | HP restante: " + string(alvo.hp));
    } else {
        alvo.vida = 100;
        alvo.vida -= dano;
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(dano) + " | Vida restante: " + string(alvo.vida));
    }
    
    // ✅ CORREÇÃO: Usar obj_explosao_terra para alvos terrestres e obj_explosao_ar para aéreos (tem som configurado)
    // Verificar se o alvo é aéreo ou terrestre
    var _alvo_aereo = (alvo.object_index == obj_helicoptero_militar || 
                      alvo.object_index == obj_caca_f5 || 
                      alvo.object_index == obj_f6 ||
                      alvo.object_index == obj_f15 ||
                      alvo.object_index == obj_c100);
    
    if (_alvo_aereo && object_exists(obj_explosao_ar)) {
        // Alvo aéreo - usar explosão aérea
        var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 150, 0); // Laranja para explosão aérea
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
            show_debug_message("💥 Explosão aérea criada!");
        }
    } else if (object_exists(obj_explosao_terra)) {
        // Alvo terrestre - usar explosão terrestre
        var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 100, 0); // Laranja para explosão terrestre
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
            show_debug_message("💥 Explosão terrestre criada!");
        }
    } else if (object_exists(obj_explosao_aquatica)) {
        // Fallback para obj_explosao_aquatica se outros não existirem
        var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_aquatica);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(150, 200, 255);
            _explosao.image_xscale = 2.0;
            _explosao.image_yscale = 2.0;
            _explosao.image_angle = random(360);
        }
    }
    
    scr_return_projectile_to_pool(id);
    exit;
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    // Explosão automática quando o projétil "expira"
    if (object_exists(obj_explosao_aquatica)) {
        var _explosao = instance_create_depth(x, y, 0, obj_explosao_aquatica);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 100, 100); // Vermelho para indicar que errou
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
            _explosao.image_angle = random(360);
        }
    }
    scr_return_projectile_to_pool(id);
    exit;
}