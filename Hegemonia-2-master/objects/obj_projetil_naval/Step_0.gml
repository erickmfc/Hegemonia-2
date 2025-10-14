/// STEP EVENT - Lógica do Projétil Naval
/// Sistema de projétil para combate naval

tempo_vida++;

// Debug a cada 30 frames (0.5 segundos)
if (tempo_vida % 30 == 0) {
    show_debug_message("🚀 Projétil naval em voo - Vida: " + string(tempo_vida) + "/" + string(tempo_vida_maximo));
    show_debug_message("📍 Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("🎯 Alvo: " + string(alvo) + " | Direção: " + string(direction) + "°");
    show_debug_message("⚡ Velocidade: " + string(velocidade_base) + " | Alcance: " + string(point_distance(x, y, xstart, ystart)) + "/" + string(alcance_maximo));
}

// Verificar tempo de vida
if (tempo_vida >= tempo_vida_maximo) {
    show_debug_message("⏰ Projétil naval expirou por tempo de vida");
    instance_destroy();
    exit;
}

// Verificar alcance máximo
if (point_distance(x, y, xstart, ystart) >= alcance_maximo) {
    show_debug_message("📏 Projétil naval expirou por alcance máximo");
    instance_destroy();
    exit;
}

// Verificar se alvo ainda existe
if (alvo == noone || !instance_exists(alvo)) {
    show_debug_message("❌ Alvo perdido, destruindo projétil naval");
    instance_destroy();
    exit;
}

// Mover projétil
x += lengthdir_x(velocidade_base, direction);
y += lengthdir_y(velocidade_base, direction);

// Verificar colisão com alvo
if (point_distance(x, y, alvo.x, alvo.y) < 15) {
    show_debug_message("💥 PROJÉTIL NAVAL ACERTOU O ALVO!");
    
    // Aplicar dano
    var _dano_aplicado = false;
    
    if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= dano;
        _dano_aplicado = true;
        show_debug_message("🎯 Projétil naval acertou! Dano: " + string(dano) + " | Vida restante: " + string(alvo.vida));
    } else if (variable_instance_exists(alvo, "hp_atual")) {
        alvo.hp_atual -= dano;
        _dano_aplicado = true;
        show_debug_message("🎯 Projétil naval acertou! Dano: " + string(dano) + " | HP restante: " + string(alvo.hp_atual));
    }
    
    if (!_dano_aplicado) {
        show_debug_message("⚠️ Projétil naval: Não foi possível aplicar dano ao alvo");
    }
    
    // Criar explosão aquática
    var explosao = instance_create_layer(x, y, layer, obj_explosao_aquatica);
    
    // Destruir projétil
    instance_destroy();
}
