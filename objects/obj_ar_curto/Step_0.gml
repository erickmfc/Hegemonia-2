// ================================================
// HEGEMONIA GLOBAL - OBJETO: AR-CURTO (Míssil Ar-Ar)
// Step Event - Sistema SIMPLIFICADO
// ================================================

// === VERIFICAÇÃO DE SEGURANÇA ===
if (!instance_exists(alvo)) {
    instance_destroy();
    exit;
}

// === GUARDAR POSIÇÃO ANTERIOR (para detecção de colisão por linha) ===
var _x_anterior = x;
var _y_anterior = y;

// === MOVIMENTO SIMPLES E DIRETO ===
var _dir = point_direction(x, y, alvo.x, alvo.y);
image_angle = _dir;
direction = _dir;

// Move diretamente em direção ao alvo
x += lengthdir_x(speed, _dir);
y += lengthdir_y(speed, _dir);

// === COLISÃO E DANO (SIMPLIFICADO) ===
var _raio_colisao = 20;
var _distancia_atual = point_distance(x, y, alvo.x, alvo.y);
var _distancia_anterior = point_distance(_x_anterior, _y_anterior, alvo.x, alvo.y);

// ✅ CORREÇÃO: Verificar se passou pelo alvo OU se está muito perto
var _passou_pelo_alvo = (_distancia_anterior > _distancia_atual && _distancia_atual <= _raio_colisao);
var _esta_muito_perto = (_distancia_atual <= _raio_colisao);

// ✅ CORREÇÃO: Também verificar colisão por linha (mais preciso para projéteis rápidos)
var _colisao_linha = false;
if (variable_instance_exists(alvo, "sprite_index") && sprite_exists(alvo.sprite_index)) {
    _colisao_linha = collision_line(_x_anterior, _y_anterior, x, y, alvo, false, true);
}

if (_passou_pelo_alvo || _esta_muito_perto || _colisao_linha) {
    // APLICAR DANO
    if (variable_instance_exists(alvo, "hp_atual")) {
        alvo.hp_atual -= dano;
    } else if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= dano;
    } else if (variable_instance_exists(alvo, "hp")) {
        alvo.hp -= dano;
    }
    
    // ✅ REMOVIDO: Não criar explosão para evitar lag e som
    // A explosão estava causando travamento e som indesejado
    
    // ✅ CRÍTICO: Destruir míssil imediatamente
    instance_destroy();
    exit;
}

// === VERIFICAÇÃO DE LIMITES E TIMER ===
if (x < 0 || x > room_width || y < 0 || y > room_height) {
    instance_destroy();
    exit;
}

timer_vida--;
if (timer_vida <= 0) {
    instance_destroy();
}