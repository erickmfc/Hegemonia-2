/// STEP EVENT - Lógica do Projétil Naval (Missile_AR)
/// Sistema de projétil para combate naval

tempo_vida++;

// Debug a cada 30 frames (0.5 segundos)
if (tempo_vida % 30 == 0) {
    show_debug_message("🚀 Míssil em voo - Vida: " + string(tempo_vida) + "/" + string(tempo_vida_maximo));
    show_debug_message("📍 Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("🎯 Alvo: " + string(alvo) + " | Direção: " + string(direction) + "°");
}

// Verificar tempo de vida
if (tempo_vida >= tempo_vida_maximo) {
    show_debug_message("⏰ Míssil expirou por tempo de vida");
    instance_destroy();
    exit;
}

// Verificar alcance máximo
if (point_distance(x, y, xstart, ystart) >= alcance_maximo) {
    show_debug_message("📏 Míssil expirou por alcance máximo");
    instance_destroy();
    exit;
}

// Verificar se alvo ainda existe
if (!variable_instance_exists(id, "alvo") || alvo == noone || !instance_exists(alvo)) {
    show_debug_message("❌ Alvo perdido, destruindo míssil");
    instance_destroy();
    exit;
}

// Criar rastro do projétil usando obj_WTrail4
if (rastro_ativo && tempo_vida mod 5 == 0) {
    var rastro = instance_create_layer(x - lengthdir_x(15, direction), y - lengthdir_y(15, direction), layer, obj_WTrail4);
    if (instance_exists(rastro)) {
        rastro.image_angle = direction;
        rastro.image_alpha = 0.8;
    }
}

// === SEGUIR O ALVO EM MOVIMENTO ===
if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
    // Recalcular direção para o alvo (míssil guiado)
    var _angulo_para_alvo = point_direction(x, y, alvo.x, alvo.y);
    direction = _angulo_para_alvo;
}

// Mover projétil na direção calculada
x += lengthdir_x(velocidade_base, direction);
y += lengthdir_y(velocidade_base, direction);

// Verificar colisão com alvo
if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo) && point_distance(x, y, alvo.x, alvo.y) < 20) {
    
    show_debug_message("💥 MÍSSIL ACERTOU O ALVO!");
    
    // === SISTEMA DE DANO ATUALIZADO ===
    var _dano_aplicado = false;
    
    // Tentar diferentes variáveis de vida
    if (variable_instance_exists(alvo, "hp_atual")) {
        alvo.hp_atual -= dano;
        _dano_aplicado = true;
        show_debug_message("🎯 Míssil terra-terra acertou! Dano: " + string(dano) + " | HP restante: " + string(alvo.hp_atual));
    } else if (variable_instance_exists(alvo, "hp")) {
        alvo.hp -= dano;
        _dano_aplicado = true;
        show_debug_message("🎯 Míssil terra-terra acertou! Dano: " + string(dano) + " | HP restante: " + string(alvo.hp));
    } else if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= dano;
        _dano_aplicado = true;
        show_debug_message("🎯 Míssil terra-terra acertou! Dano: " + string(dano) + " | Vida restante: " + string(alvo.vida));
    }
    
    if (!_dano_aplicado) {
        show_debug_message("⚠️ Míssil terra-terra: Não foi possível aplicar dano ao alvo");
    }
    
    // Criar explosão aquática
    var explosao = instance_create_layer(x, y, layer, obj_explosao_aquatica);
    
    // Destruir projétil
    instance_destroy();
}
