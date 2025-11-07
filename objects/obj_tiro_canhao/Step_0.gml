/// @description Lógica do Tiro do Canhão
// ===============================================
// HEGEMONIA GLOBAL - TIRO DO CANHÃO
// Sistema de Metralhadora
// ===============================================

// === VERIFICAÇÃO DE SEGURANÇA ===
if (!instance_exists(alvo)) {
    scr_return_projectile_to_pool(id);
    exit;
}

// === GUARDAR POSIÇÃO ANTERIOR (para detecção de colisão por linha) ===
var _x_anterior = x;
var _y_anterior = y;

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
    _colisao_linha = collision_line(_x_anterior, _y_anterior, x, y, alvo, false, true);
}

if (instance_exists(alvo) && (_passou_pelo_alvo || _esta_muito_perto || _colisao_linha)) {
    
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
            // ✅ CORREÇÃO: Usar posição do alvo para explosão (mais preciso)
            // ✅ CORREÇÃO CRÍTICA: Guardar posição ANTES de aplicar dano (alvo pode ser destruído)
            var _explosao_x = x; // Posição do projétil como fallback
            var _explosao_y = y;
            if (instance_exists(alvo)) {
                _explosao_x = alvo.x;
                _explosao_y = alvo.y;
            }
            
            // === EXPLOSÃO PEQUENA ===
            if (object_exists(obj_explosao_pequena)) {
                var _explosao = instance_create_depth(_explosao_x, _explosao_y, 0, obj_explosao_pequena);
                if (instance_exists(_explosao)) {
                    _explosao.image_blend = make_color_rgb(255, 150, 50);
                    _explosao.image_xscale = 1.5;
                    _explosao.image_yscale = 1.5;
                }
            }
            
            // ✅ CRÍTICO: Destruir projétil imediatamente após acertar
            scr_return_projectile_to_pool(id);
            exit;
        }
    } else {
        // Passar pelo dono/aliado sem causar dano
        // Não destroi o projétil, continua voando
    }
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    scr_return_projectile_to_pool(id);
    exit;
}
