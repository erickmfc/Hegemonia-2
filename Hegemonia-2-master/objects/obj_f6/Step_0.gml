// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-6 (ALVO DE TESTE)
// Step Event - Baseado no F-5 com comportamento automático
// ===============================================

// --- 1. COMPORTAMENTO AUTOMÁTICO DE TESTE ---
if (modo_teste) {
    // Decolagem automática após timer
    if (timer_decolagem_automatica > 0) {
        timer_decolagem_automatica--;
        if (timer_decolagem_automatica <= 0 && estado == "pousado") {
            estado = "decolando";
            show_debug_message("🚀 F-6 iniciando decolagem automática para teste");
        }
    }
    
    // Patrulha automática após decolagem
    if (patrulha_automatica && estado == "decolando") {
        // Cria pontos de patrulha em círculo ao redor da posição inicial
        var _centro_x = x;
        var _centro_y = y;
        var _num_pontos = 6;
        
        ds_list_clear(pontos_patrulha);
        for (var i = 0; i < _num_pontos; i++) {
            var _angulo = (360 / _num_pontos) * i;
            var _px = _centro_x + lengthdir_x(raio_patrulha_teste, _angulo);
            var _py = _centro_y + lengthdir_y(raio_patrulha_teste, _angulo);
            ds_list_add(pontos_patrulha, [_px, _py]);
        }
        
        estado = "patrulhando";
        indice_patrulha_atual = 0;
        var _ponto = pontos_patrulha[| 0];
        destino_x = _ponto[0];
        destino_y = _ponto[1];
        patrulha_automatica = false; // Evita recriar pontos
        
        show_debug_message("🔄 F-6 iniciando patrulha automática de teste com " + string(_num_pontos) + " pontos");
    }
}

// --- 2. MÁQUINA DE ESTADOS (BASEADA NO F-5) ---
switch (estado) {
    case "pousado":
        velocidade_atual = max(0, velocidade_atual - desaceleracao);
        altura_voo = max(0, altura_voo - 0.3);
        break;
        
    case "decolando":
        altura_voo = min(altura_maxima, altura_voo + 0.3);
        velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
        if (altura_voo >= altura_maxima * 0.8) {
            estado = "movendo";
        }
        break;

    case "movendo":
        // Se chegou no destino, inicia o pouso
        if (point_distance(x, y, destino_x, destino_y) < 15 && velocidade_atual < 0.5) {
            estado = "pousando";
        }
        break;

    case "patrulhando":
        // Se chegou ao ponto atual, vai para o próximo
        if (point_distance(x, y, destino_x, destino_y) < 20) {
            indice_patrulha_atual = (indice_patrulha_atual + 1) % ds_list_size(pontos_patrulha);
            var _ponto = pontos_patrulha[| indice_patrulha_atual];
            destino_x = _ponto[0];
            destino_y = _ponto[1];
        }
        break;
        
    case "pousando":
        altura_voo = max(0, altura_voo - 0.3);
        velocidade_atual = max(0, velocidade_atual - desaceleracao);
        if (altura_voo == 0 && velocidade_atual == 0) {
            estado = "pousado";
        }
        break;
}

// --- 3. LÓGICA DE MOVIMENTO E ALTITUDE ---
var _is_flying = (estado == "movendo" || estado == "patrulhando" || estado == "decolando");
var _is_landing = (estado == "pousando");

if (_is_flying) {
    altura_voo = min(altura_maxima, altura_voo + 0.3);
    
    var _dist = point_distance(x, y, destino_x, destino_y);
    if (_dist > 5) {
        var _dir = point_direction(x, y, destino_x, destino_y);
        var _diff = angle_difference(_dir, image_angle);
        image_angle += clamp(_diff, -velocidade_rotacao, velocidade_rotacao);
        velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
    }
} else { // Pousado ou Pousando
    velocidade_atual = max(0, velocidade_atual - desaceleracao);
    if (_is_landing || estado == "pousado") {
        altura_voo = max(0, altura_voo - 0.3);
    }
}

// Aplica o movimento (só se move se tiver velocidade)
x += lengthdir_x(velocidade_atual, image_angle);
y += lengthdir_y(velocidade_atual, image_angle);

// --- 4. VERIFICAÇÃO DE DESTRUIÇÃO ---
if (hp_atual <= 0) {
    show_debug_message("💥 F-6 DESTRUÍDO! Teste de míssil ar-ar bem-sucedido!");
    instance_destroy();
}