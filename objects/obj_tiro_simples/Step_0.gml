// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Step Event - Sistema ROBUSTO E SEM ERROS
// ================================================

// === VERIFICAÇÃO DE SEGURANÇA ===
if (!instance_exists(alvo)) {
    scr_return_projectile_to_pool(id);
    exit;
}

// === GUARDAR POSIÇÃO ANTERIOR (para detecção de colisão por linha) ===
var _x_anterior = x;
var _y_anterior = y;

// === MOVIMENTO E ROTAÇÃO ===
var _dir = point_direction(x, y, alvo.x, alvo.y);
image_angle = _dir;
direction = _dir;

// Aplicar movimento do projétil
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// === COLISÃO E DANO ===
// ✅ CORREÇÃO CRÍTICA: Verificar colisão usando linha (detecta se passou pelo alvo)
var _distancia_atual = point_distance(x, y, alvo.x, alvo.y);
var _distancia_anterior = point_distance(_x_anterior, _y_anterior, alvo.x, alvo.y);

// ✅ NOVO: Verificar se passou pelo alvo (distância anterior > atual) OU se está muito perto
var _raio_colisao = 25; // Raio fixo maior para garantir detecção
var _passou_pelo_alvo = (_distancia_anterior > _distancia_atual && _distancia_atual <= _raio_colisao);
var _esta_muito_perto = (_distancia_atual <= _raio_colisao);

// ✅ CORREÇÃO: Também verificar colisão por linha (mais preciso para projéteis rápidos)
var _colisao_linha = false;
if (variable_instance_exists(alvo, "sprite_index") && sprite_exists(alvo.sprite_index)) {
    // Verificar se a linha do movimento intersecta com o sprite do alvo
    var _raio_alvo = max(sprite_get_width(alvo.sprite_index), sprite_get_height(alvo.sprite_index)) / 2;
    _colisao_linha = collision_line(_x_anterior, _y_anterior, x, y, alvo, false, true);
}

if (_passou_pelo_alvo || _esta_muito_perto || _colisao_linha) {
    
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
    
    // ✅ CORREÇÃO: Usar posição do alvo para explosão (mais preciso)
    // ✅ CORREÇÃO CRÍTICA: Guardar posição ANTES de aplicar dano (alvo pode ser destruído)
    var _explosao_x = x; // Posição do projétil como fallback
    var _explosao_y = y;
    if (instance_exists(alvo)) {
        _explosao_x = alvo.x;
        _explosao_y = alvo.y;
    }
    
    // Verificar se o alvo é aéreo ou terrestre
    var _alvo_aereo = false;
    if (instance_exists(alvo)) {
        _alvo_aereo = (alvo.object_index == obj_helicoptero_militar || 
                      alvo.object_index == obj_caca_f5 || 
                      alvo.object_index == obj_f6 ||
                      alvo.object_index == obj_f15 ||
                      alvo.object_index == obj_c100);
    }
    
    if (_alvo_aereo && object_exists(obj_explosao_ar)) {
        var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_ar);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 150, 0);
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
        }
    } else if (object_exists(obj_explosao_terra)) {
        var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_terra);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 100, 0);
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
        }
    } else if (object_exists(obj_explosao_aquatica)) {
        var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_aquatica);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(150, 200, 255);
            _explosao.image_xscale = 2.0;
            _explosao.image_yscale = 2.0;
            _explosao.image_angle = random(360);
        }
    }
    
    // ✅ CRÍTICO: Destruir projétil imediatamente após acertar
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