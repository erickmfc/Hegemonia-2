// ===============================================
// HEGEMONIA GLOBAL - DESTROYER
// Sistema de Movimento e Combate
// ===============================================

// === LÓGICA DE MODOS DE COMBATE ===
if (modo_combate == "passivo") {
    alvo = noone;
    if (estado == "atacando") {
        estado = "parado";
    }
} else if (modo_combate == "atacando") {
    if (alvo == noone || !instance_exists(alvo)) {
        var inimigo = instance_nearest(x, y, obj_inimigo);
        if (inimigo != noone) {
            var distancia_inimigo = point_distance(x, y, inimigo.x, inimigo.y);
            if (distancia_inimigo <= alcance) {
                alvo = inimigo;
                estado = "atacando";
            }
        }
    }
}

// === MOVIMENTO BASICO COM ORIENTAÇÃO CORRETA ===
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
        moving_to_target = false;
    }
}

// === MOVIMENTO PARA ATAQUE COM ORIENTAÇÃO ===
if (estado == "atacando" && alvo != noone && instance_exists(alvo)) {
    var distancia_alvo = point_distance(x, y, alvo.x, alvo.y);
    
    if (distancia_alvo > alcance_tiro) {
        var _angulo = point_direction(x, y, alvo.x, alvo.y);
        image_angle = _angulo;
        
        var _velocidade_suave = min(velocidade, distancia_alvo * 0.1);
        x += lengthdir_x(_velocidade_suave, _angulo);
        y += lengthdir_y(_velocidade_suave, _angulo);
    }
}
