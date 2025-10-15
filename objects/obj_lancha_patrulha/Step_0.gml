// ===============================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA (Step Adaptado)
// Sistema Naval com Comandos Completos
// ===============================================

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O) - adaptados para lancha
    if (keyboard_check_pressed(ord("P"))) { 
        modo_combate = LanchaMode.PASSIVO; 
        modo_ataque = false; // Atualizar variável de compatibilidade
        show_debug_message("🛡️ Lancha Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_combate = LanchaMode.ATAQUE; 
        modo_ataque = true; // Atualizar variável de compatibilidade
        show_debug_message("⚔️ Lancha Modo ATAQUE AGRESSIVO");
    }

    // Comando de Parar (L) - adaptado para lancha
    if (keyboard_check_pressed(ord("L"))) {
        estado = LanchaState.PARADO;
        modo_definicao_patrulha = false;
        alvo_unidade = noone;
        show_debug_message("⏹️ Lancha PAROU");
    }
    
    // Comandos K, clique esquerdo e clique direito agora são gerenciados pelo obj_input_manager
    // para evitar conflitos e manter o modo de patrulha persistente
}

// ======================================================================
// --- 2. LÓGICA DE AQUISIÇÃO DE ALVO (ADAPTADA PARA NAVAL) ---
// ======================================================================
// Se o modo ataque está ativo E a lancha não está parada E não está já atacando alguém...
if (modo_combate == LanchaMode.ATAQUE && estado != LanchaState.PARADO && estado != LanchaState.ATACANDO) {
    // Prioriza alvos navais primeiro, depois terrestres
    var _alvo_naval = instance_nearest(x, y, obj_lancha_patrulha);
    var _alvo_helicoptero = instance_nearest(x, y, obj_helicoptero_militar);
    var _alvo_terrestre = instance_nearest(x, y, obj_inimigo);
    
    var _alvo_encontrado = noone;
    var _tipo_alvo = "";
    
    // Verifica alvos navais primeiro (prioridade máxima)
    if (instance_exists(_alvo_naval) && _alvo_naval != id && _alvo_naval.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_naval.x, _alvo_naval.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_naval;
        _tipo_alvo = "naval (Lancha inimiga)";
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
        estado = LanchaState.ATACANDO;      // MUDA o estado para "atacando"
        alvo_unidade = _alvo_encontrado; // Trava a mira no inimigo
        
        show_debug_message("🎯 Alvo " + _tipo_alvo + " detectado! Interrompendo tarefa para atacar " + string(alvo_unidade));
    } else {
        // Debug: mostra por que não encontrou alvos
        show_debug_message("🔍 Modo ataque ativo mas nenhum alvo inimigo encontrado no radar (alcance: " + string(radar_alcance) + ")");
    }
}
// ======================================================================

// --- 3. MÁQUINA DE ESTADOS (ADAPTADA PARA LANCHA) ---
// Gerencia as transições e lógicas de cada estado
switch (estado) {
    case LanchaState.MOVENDO:
        // Se chegou no destino, para
        if (point_distance(x, y, alvo_x, alvo_y) < 15) {
            estado = LanchaState.PARADO;
        }
        break;

    case LanchaState.PATRULHANDO:
        // Se chegou ao ponto atual, vai para o próximo
        if (point_distance(x, y, alvo_x, alvo_y) < 20) {
            indice_patrulha_atual = (indice_patrulha_atual + 1) % ds_list_size(pontos_patrulha);
            var _ponto = pontos_patrulha[| indice_patrulha_atual];
            alvo_x = _ponto[0];
            alvo_y = _ponto[1];
        }
        break;
        
    // --- ESTADO DE COMBATE NAVAL ---
    case LanchaState.ATACANDO:
        // Se o alvo ainda existe, o persegue
        if (instance_exists(alvo_unidade)) {
            alvo_x = alvo_unidade.x;
            alvo_y = alvo_unidade.y;
            
            // Atira se estiver no alcance e o timer permitir
            if (point_distance(x, y, alvo_x, alvo_y) <= missil_alcance && reload_timer <= 0) {
                // Cria míssil naval
                var _missil = instance_create_layer(x, y, "Instances", obj_tiro_simples);
                if (instance_exists(_missil)) {
                    _missil.alvo = alvo_unidade;
                    _missil.dono = id;
                    _missil.dano = 25;
                    _missil.speed = 8;
                    _missil.direction = point_direction(x, y, alvo_unidade.x, alvo_unidade.y);
                    reload_timer = reload_time;
                    show_debug_message("🚀 Lancha lançou míssil em: " + string(alvo_unidade));
                }
            }
        } 
        // Se o alvo foi destruído...
        else {
            show_debug_message("✅ Alvo destruído! Retornando para: " + string(estado_anterior));
            estado = estado_anterior; // RETORNA para o que estava fazendo antes
            alvo_unidade = noone;       // Limpa a mira
        }
        break;
}

// --- 4. LÓGICA DE MOVIMENTO NAVAL (ADAPTADA DO F5) ---
var _is_moving = (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO || estado == LanchaState.ATACANDO);
var _is_stopped = (estado == LanchaState.PARADO);

if (_is_moving) {
    var _dist = point_distance(x, y, alvo_x, alvo_y);
    if (_dist > 5) {
        var _dir = point_direction(x, y, alvo_x, alvo_y);
        image_angle = _dir; // Lancha aponta para o destino
        x += lengthdir_x(velocidade_movimento, _dir);
        y += lengthdir_y(velocidade_movimento, _dir);
    }
} else { // Parado
    // Lancha fica parada
}

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (reload_timer > 0) {
    reload_timer--;
}