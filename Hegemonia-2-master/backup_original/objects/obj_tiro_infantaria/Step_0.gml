// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Step Event - Movimento e Colisão
// ================================================

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    instance_destroy();
    exit;
}

// === MOVIMENTO EM DIREÇÃO AO ALVO ===
if (alvo != noone && instance_exists(alvo)) {
    // Calcular direção para o alvo
    var dir_x = alvo.x - x;
    var dir_y = alvo.y - y;
    var dist = point_distance(x, y, alvo.x, alvo.y);
    
    if (dist > 0) {
        // Normalizar direção e aplicar velocidade
        x += (dir_x / dist) * speed;
        y += (dir_y / dist) * speed;
        
        // Verificar se atingiu o alvo
        if (dist <= speed) {
            // Atingiu o alvo!
            if (instance_exists(alvo)) {
                // Aplicar dano (compatível com obj_inimigo e obj_infantaria)
                if (variable_instance_exists(alvo, "vida")) {
                    alvo.vida -= dano;
                } else if (variable_instance_exists(alvo, "hp_atual")) {
                    alvo.hp_atual -= dano;
                }
                
                // Verificar se alvo morreu
                var vida_atual = 0;
                if (variable_instance_exists(alvo, "vida")) {
                    vida_atual = alvo.vida;
                } else if (variable_instance_exists(alvo, "hp_atual")) {
                    vida_atual = alvo.hp_atual;
                }
                
                if (vida_atual <= 0) {
                    instance_destroy(alvo);
                }
            }
            
            // Destruir o tiro
            instance_destroy();
        }
    } else {
        // Alvo muito próximo, destruir tiro
        instance_destroy();
    }
} else {
    // Alvo não existe mais, destruir tiro
    instance_destroy();
}
