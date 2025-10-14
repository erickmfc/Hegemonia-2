/// STEP EVENT - Lógica do Míssil Aéreo (SIMPLIFICADA)
/// Sistema de interceptação robusto e funcional

// Incrementar tempo de vida
tempo_vida++;
distancia_percorrida += velocidade_atual;

// === VERIFICAÇÕES DE DESTRUIÇÃO ===
if (tempo_vida >= tempo_vida_maximo) {
    // Míssil expirou por tempo
    estado = "destruido";
    instance_destroy();
    exit;
}

if (distancia_percorrida >= alcance_maximo) {
    // Míssil expirou por distância
    estado = "destruido";
    instance_destroy();
    exit;
}

// === VERIFICAÇÃO DE ALVO ===
if (alvo == noone || !instance_exists(alvo)) {
    // Alvo não existe mais, míssil se autodestrói
    estado = "destruido";
    instance_destroy();
    exit;
}

// === VERIFICAÇÃO DE LANÇADOR ===
if (lancador == noone || !instance_exists(lancador)) {
    // Lançador não existe mais, míssil se autodestrói
    estado = "destruido";
    instance_destroy();
    exit;
}

// === LÓGICA DE INTERCEPTAÇÃO SIMPLIFICADA ===
switch (estado) {
    
    case "voando":
        // Calcular distância até o alvo
        var dist_alvo = point_distance(x, y, alvo.x, alvo.y);
        
        // Verificar se atingiu o alvo (proximidade)
        if (dist_alvo <= 30) {
            // Míssil atingiu o alvo!
            estado = "explodindo";
            
            // Aplicar dano ao alvo
            if (instance_exists(alvo)) {
                // Verificar se o alvo tem sistema de vida
                if (variable_instance_exists(alvo, "vida")) {
                    alvo.vida -= dano;
                    show_debug_message("Míssil atingiu alvo! Dano: " + string(dano));
                    
                    // Verificar se o alvo foi destruído
                    if (alvo.vida <= 0) {
                        show_debug_message("Alvo destruído pelo míssil!");
                    }
                } else if (variable_instance_exists(alvo, "hp")) {
                    alvo.hp -= dano;
                    show_debug_message("Míssil atingiu alvo! Dano: " + string(dano));
                    
                    if (alvo.hp <= 0) {
                        show_debug_message("Alvo destruído pelo míssil!");
                    }
                }
            }
            
            // Criar efeito de explosão
            if (particulas_explosao) {
                var expl = instance_create_layer(x, y, layer, obj_explosao_pequena);
                if (instance_exists(expl)) {
                    expl.image_scale = 0.8;
                }
            }
            
            // Destruir míssil
            instance_destroy();
            exit;
        }
        
        // === MOVIMENTO DIRECIONADO SIMPLES ===
        // Calcular direção para o alvo
        var direcao_alvo = point_direction(x, y, alvo.x, alvo.y);
        
        // Inicializar direction se não estiver definida
        if (!variable_instance_exists(id, "direction")) {
            direction = direcao_alvo;
        }
        
        // Ajustar direção gradualmente para suavizar o movimento
        var diferenca_angulo = angle_difference(direction, direcao_alvo);
        direction += diferenca_angulo * 0.2; // 20% de correção por frame
        
        // Aplicar movimento
        hspeed = lengthdir_x(velocidade_atual, direction);
        vspeed = lengthdir_y(velocidade_atual, direction);
        
        // Atualizar ângulo da imagem
        image_angle = direction;
        
        // === EFEITO DE RASTRO ===
        if (rastro_ativo && (tempo_vida mod 2) == 0) {
            var rastro = instance_create_layer(x - hspeed, y - vspeed, layer, obj_rastro_missil);
            if (instance_exists(rastro)) {
                rastro.image_alpha = 0.4;
                rastro.image_scale = 0.6;
            }
        }
        
    break;
    
    case "explodindo":
        // Estado de explosão (geralmente dura apenas 1 frame)
        instance_destroy();
    break;
    
    case "destruido":
        // Estado de destruição
        instance_destroy();
    break;
}

// === VERIFICAÇÃO DE COLISÃO COM LIMITES ===
if (x < 0 || x > room_width || y < 0 || y > room_height) {
    // Míssil saiu dos limites da sala
    estado = "destruido";
    instance_destroy();
    exit;
}
