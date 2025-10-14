// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-5 (Step com Ataque Agressivo)
// ===============================================

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O) - apenas estes ficam no F-5
    if (keyboard_check_pressed(ord("P"))) { 
        modo_ataque = false; 
        show_debug_message("🛡️ F-5 Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_ataque = true; 
        show_debug_message("⚔️ F-5 Modo ATAQUE AGRESSIVO");
    }

    // Comando de Pouso (L)
    if (keyboard_check_pressed(ord("L")) && estado != "pousado") {
        estado = "pousando";
    }
    
    // Comandos K, clique esquerdo e clique direito agora são gerenciados pelo obj_input_manager
    // para evitar conflitos e manter o modo de patrulha persistente
}

// ======================================================================
// --- 2. NOVA LÓGICA: AQUISIÇÃO DE ALVO (PRIORIDADE MÁXIMA) ---
// ======================================================================
// Se o modo ataque está ativo E o avião não está pousando/decolando E não está já caçando alguém...
if (modo_ataque && estado != "pousando" && estado != "decolando" && estado != "atacando") {
    // Prioriza alvos aéreos primeiro
    var _alvo_aereo = instance_nearest(x, y, obj_caca_f5);
    var _alvo_f6 = instance_nearest(x, y, obj_f6);
    var _alvo_helicoptero = instance_nearest(x, y, obj_helicoptero_militar);
    var _alvo_terrestre = instance_nearest(x, y, obj_inimigo);
    
    var _alvo_encontrado = noone;
    var _tipo_alvo = "";
    
    // Verifica alvos aéreos primeiro (prioridade máxima)
    if (instance_exists(_alvo_aereo) && _alvo_aereo != id && _alvo_aereo.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_aereo.x, _alvo_aereo.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_aereo;
        _tipo_alvo = "aéreo (F-5 inimigo)";
    } else if (instance_exists(_alvo_f6) && _alvo_f6.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_f6.x, _alvo_f6.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_f6;
        _tipo_alvo = "aéreo (F-6 TESTE)";
    } else if (instance_exists(_alvo_helicoptero) && _alvo_helicoptero.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_helicoptero.x, _alvo_helicoptero.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_helicoptero;
        _tipo_alvo = "aéreo (Helicóptero inimigo)";
    } else if (instance_exists(_alvo_terrestre) && _alvo_terrestre.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_terrestre.x, _alvo_terrestre.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_terrestre;
        _tipo_alvo = "terrestre inimigo";
    }
    
    // Se encontrou um inimigo dentro do radar...
    if (instance_exists(_alvo_encontrado)) {
        estado_anterior = estado; // GUARDA o que estava fazendo (ex: "patrulhando")
        estado = "atacando";      // MUDA o estado para "atacando"
        alvo_em_mira = _alvo_encontrado; // Trava a mira no inimigo
        
        show_debug_message("🎯 Alvo " + _tipo_alvo + " detectado! Interrompendo tarefa para atacar " + string(alvo_em_mira));
    } else {
        // Debug: mostra por que não encontrou alvos
        show_debug_message("🔍 Modo ataque ativo mas nenhum alvo inimigo encontrado no radar (alcance: " + string(radar_alcance) + ")");
    }
}
// ======================================================================

// --- 3. MÁQUINA DE ESTADOS ---
// Gerencia as transições e lógicas de cada estado
switch (estado) {
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
        
    // --- NOVO ESTADO DE COMBATE ---
    case "atacando":
        // Se o alvo ainda existe, o persegue
        if (instance_exists(alvo_em_mira)) {
            destino_x = alvo_em_mira.x;
            destino_y = alvo_em_mira.y;
            
            // Atira se estiver no alcance e o timer permitir
            if (point_distance(x, y, destino_x, destino_y) <= radar_alcance && timer_ataque <= 0) {
                // Verifica se o alvo é uma unidade aérea para usar míssil ar-ar
                var _missil;
                if (alvo_em_mira.object_index == obj_caca_f5 || alvo_em_mira.object_index == obj_f6 || alvo_em_mira.object_index == obj_helicoptero_militar) {
                    // Alvo aéreo - usa míssil ar-ar
                    _missil = instance_create_layer(x, y, "Instances", obj_ar_curto);
                    show_debug_message("🚀 F-5 lançou míssil AR-CURTO em alvo aéreo: " + string(alvo_em_mira));
        } else {
                    // Alvo terrestre - usa míssil normal
                    _missil = instance_create_layer(x, y, "Instances", obj_tiro_simples);
                    show_debug_message("🚀 F-5 lançou míssil normal em alvo terrestre: " + string(alvo_em_mira));
                }
                
                if (instance_exists(_missil)) {
                    _missil.alvo = alvo_em_mira;
                    _missil.dono = id;
                    timer_ataque = intervalo_ataque;
                }
            }
        } 
        // Se o alvo foi destruído...
        else {
            show_debug_message("✅ Alvo destruído! Retornando para: " + estado_anterior);
            estado = estado_anterior; // RETORNA para o que estava fazendo antes
            alvo_em_mira = noone;       // Limpa a mira
        }
        break;
}

// --- 4. LÓGICA DE MOVIMENTO E ALTITUDE (CÓDIGO UNIFICADO) ---
var _is_flying = (estado == "movendo" || estado == "patrulhando" || estado == "decolando" || estado == "atacando");
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
} else { // Pousado, Pousando ou Definindo Patrulha
    velocidade_atual = max(0, velocidade_atual - desaceleracao);
    if (_is_landing || estado == "pousado") {
        altura_voo = max(0, altura_voo - 0.3);
    }
    if (altura_voo == 0 && velocidade_atual == 0 && estado == "pousando") {
        estado = "pousado";
    }
}

// Aplica o movimento (só se move se tiver velocidade)
x += lengthdir_x(velocidade_atual, image_angle);
y += lengthdir_y(velocidade_atual, image_angle);

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (timer_ataque > 0) {
    timer_ataque--;
}