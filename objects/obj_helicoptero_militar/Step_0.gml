// ===============================================
// HEGEMONIA GLOBAL - HELICÓPTERO (Step Simplificado)
// ===============================================

// --- 1. CONTROLE DO JOGADOR ---
if (selecionado) {
    // Comando de Movimento (Clique Direito)
    if (mouse_check_button_pressed(mb_right)) {
        var _coords = global.scr_mouse_to_world();
        destino_x = _coords[0];
        destino_y = _coords[1];
        
        // Se estiver pousado, inicia decolagem
        if (!voando) {
            voando = true;
            estado = "movendo";
            show_debug_message("🚁 Helicóptero decolando para (" + string(destino_x) + ", " + string(destino_y) + ")");
        } else {
            estado = "movendo";
            show_debug_message("🎯 Helicóptero mudando destino para (" + string(destino_x) + ", " + string(destino_y) + ")");
        }
    }
    
    // ✅ NOVO: Comando de Pouso Manual (Tecla 'L')
    if (keyboard_check_pressed(ord("L"))) {
        if (voando) {
            voando = false; // Inicia pouso imediato
            estado = "pousado";
            destino_x = x; // Define destino como posição atual para parar
            destino_y = y;
            show_debug_message("🛬 Helicóptero pousando imediatamente!");
        } else {
            show_debug_message("ℹ️ Helicóptero já está pousado");
        }
    }
    
    // Comandos de Modo (Teclado)
    if (keyboard_check_pressed(ord("P"))) { 
        modo_ataque = false; 
        show_debug_message("😴 Helicóptero Modo PASSIVO"); 
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_ataque = true; 
        show_debug_message("⚔️ Helicóptero Modo ATAQUE"); 
    }
}

// --- 2. SISTEMA DE ALTITUDE ---
if (voando) {
    // Ganha altitude gradualmente
    altura_voo = min(altura_maxima, altura_voo + 0.2);
} else {
    // Perde altitude gradualmente
    altura_voo = max(0, altura_voo - 0.2);
}

// --- 3. LÓGICA DE MOVIMENTO SIMPLES ---
var _distancia_destino = point_distance(x, y, destino_x, destino_y);

if (_distancia_destino > 5 && voando) {
    // Acelera e gira em direção ao destino
    var _dir_alvo = point_direction(x, y, destino_x, destino_y);
    var _diff_ang = angle_difference(_dir_alvo, image_angle);
    image_angle += clamp(_diff_ang, -velocidade_rotacao, velocidade_rotacao);
    velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
} else {
    // Desacelera quando chega ou não está voando
    velocidade_atual = max(0, velocidade_atual - desaceleracao);
    
    // Se chegou ao destino e está voando, pode pousar
    if (_distancia_destino < 15 && voando && velocidade_atual < 0.5) {
        voando = false;
        estado = "pousado";
        show_debug_message("🛬 Helicóptero pousando no destino");
    }
}

// --- 4. APLICAR MOVIMENTO ---
x += lengthdir_x(velocidade_atual, image_angle);
y += lengthdir_y(velocidade_atual, image_angle);

// --- 5. SISTEMA DE ATAQUE (SÓ SE MODO ATAQUE E VOANDO) ---
if (modo_ataque && voando && velocidade_atual > 0) {
    if (timer_ataque > 0) {
        timer_ataque--;
    } else {
        var _alvo = instance_nearest(x, y, obj_inimigo);
        if (instance_exists(_alvo) && point_distance(x, y, _alvo.x, _alvo.y) <= radar_alcance) {
            var _missil = instance_create_layer(x, y, "Instances", obj_tiro_simples);
            if (instance_exists(_missil)) {
                _missil.alvo = _alvo;
                _missil.dono = id;
                _missil.dano = 30;
                timer_ataque = intervalo_ataque;
                show_debug_message("🚀 Helicóptero atirou em " + string(_alvo));
            }
        }
    }
}