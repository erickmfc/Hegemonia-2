/// @description Atualiza a mira da torre do M1A Abrams com rotação suave
/// @return {real} Ângulo final da torre

function scr_abrams_atualizar_mira() {
    // Verificar se tem alvo válido
    if (alvo == noone || !instance_exists(alvo)) {
        return angulo_torre;
    }
    
    // Calcular direção para o alvo
    var _dir_alvo = point_direction(x, y, alvo.x, alvo.y);
    
    // Definir ângulo alvo
    angulo_torre_alvo = _dir_alvo;
    
    // Calcular diferença angular (considerando wrap-around de 360 graus)
    var _diff = angulo_torre_alvo - angulo_torre;
    
    // Normalizar diferença para -180 a 180 graus
    while (_diff > 180) _diff -= 360;
    while (_diff < -180) _diff += 360;
    
    // Rotação suave em direção ao alvo
    if (abs(_diff) > velocidade_rotacao_torre) {
        // Ainda não chegou no alvo - rotacionar
        if (_diff > 0) {
            angulo_torre += velocidade_rotacao_torre;
        } else {
            angulo_torre -= velocidade_rotacao_torre;
        }
    } else {
        // Chegou no alvo - alinhar exatamente
        angulo_torre = angulo_torre_alvo;
    }
    
    // Normalizar ângulo para 0-360
    while (angulo_torre < 0) angulo_torre += 360;
    while (angulo_torre >= 360) angulo_torre -= 360;
    
    return angulo_torre;
}

