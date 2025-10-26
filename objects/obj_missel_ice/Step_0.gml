/// STEP EVENT - Lógica do Míssil Ice (Anti-submarino)
/// Sistema de projétil especializado para combater submarinos

tempo_vida++;

// Debug a cada 30 frames (0.5 segundos)
if (tempo_vida % 30 == 0) {
    show_debug_message("❄️ Míssil Ice em voo - Vida: " + string(tempo_vida) + "/" + string(tempo_vida_maximo));
    show_debug_message("📍 Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("🎯 Alvo submarino: " + string(alvo) + " | Direção: " + string(direction) + "°");
}

// Verificar tempo de vida
if (tempo_vida >= tempo_vida_maximo) {
    show_debug_message("⏰ Míssil Ice expirou por tempo de vida");
    instance_destroy();
    exit;
}

// Verificar alcance máximo
if (point_distance(x, y, xstart, ystart) >= alcance_maximo) {
    show_debug_message("📏 Míssil Ice expirou por alcance máximo");
    instance_destroy();
    exit;
}

// Verificar se alvo (submarino) ainda existe
if (!variable_instance_exists(id, "alvo") || alvo == noone || !instance_exists(alvo)) {
    show_debug_message("❌ Alvo submarino perdido, destruindo míssil Ice");
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

// Verificar colisão com submarino alvo
if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo) && point_distance(x, y, alvo.x, alvo.y) < 25) {
    
    show_debug_message("❄️ 💥 MÍSSIL ICE ACERTOU O SUBMARINO!");
    
    // === SISTEMA DE DANO ESPECÍFICO PARA SUBMARINOS ===
    var _dano_aplicado = false;
    var _dano_final = dano;
    
    // Verificar se é realmente um submarino para aplicar bônus
    var _nome_obj_alvo = object_get_name(alvo.object_index);
    var _is_submarino = (_nome_obj_alvo == "obj_submarino");
    
    if (_is_submarino && variable_instance_exists(id, "dano_bonus_submarino")) {
        _dano_final = floor(dano * dano_bonus_submarino); // Dano com bônus
        show_debug_message("🎯 Dano com bônus anti-submarino aplicado!");
    }
    
    // Tentar diferentes variáveis de vida
    if (variable_instance_exists(alvo, "hp_atual")) {
        alvo.hp_atual -= _dano_final;
        _dano_aplicado = true;
        show_debug_message("🌊 Míssil Ice acertou submarino! Dano: " + string(_dano_final) + " | HP restante: " + string(alvo.hp_atual));
    } else if (variable_instance_exists(alvo, "hp")) {
        alvo.hp -= _dano_final;
        _dano_aplicado = true;
        show_debug_message("🌊 Míssil Ice acertou submarino! Dano: " + string(_dano_final) + " | HP restante: " + string(alvo.hp));
    } else if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= _dano_final;
        _dano_aplicado = true;
        show_debug_message("🌊 Míssil Ice acertou submarino! Dano: " + string(_dano_final) + " | Vida restante: " + string(alvo.vida));
    }
    
    if (!_dano_aplicado) {
        show_debug_message("⚠️ Míssil Ice: Não foi possível aplicar dano ao submarino");
    }
    
    // Criar explosão aquática especializada
    var explosao = instance_create_layer(x, y, layer, obj_explosao_aquatica);
    
    // Destruir projétil
    instance_destroy();
}
