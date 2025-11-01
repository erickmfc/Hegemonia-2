// ===============================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA (Step Adaptado)
// Sistema Naval com Comandos Completos
// ===============================================

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == LanchaState.ATACANDO || estado_string == "atacando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO || estado_string == "movendo" || estado_string == "patrulhando") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && (estado == LanchaState.MOVENDO || estado_string == "movendo")) {
                    estado = LanchaState.PARADO;
                    estado_string = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O) - adaptados para lancha
    if (keyboard_check_pressed(ord("P"))) { 
        modo_combate = LanchaMode.PASSIVO; 
        modo_ataque = false; // Atualizar variável de compatibilidade
        if (global.debug_enabled) show_debug_message("🛡️ Lancha Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_combate = LanchaMode.ATAQUE; 
        modo_ataque = true; // Atualizar variável de compatibilidade
        if (global.debug_enabled) show_debug_message("⚔️ Lancha Modo ATAQUE AGRESSIVO");
    }

    // Comando de Parar (L) - adaptado para lancha
    if (keyboard_check_pressed(ord("L"))) {
        estado = LanchaState.PARADO;
        modo_definicao_patrulha = false;
        alvo_unidade = noone;
        if (global.debug_enabled) show_debug_message("⏹️ Lancha PAROU");
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
    
    // ✅ NOVO: Procurar TODAS as unidades terrestres inimigas (não só obj_inimigo)
    var _alvo_infantaria = instance_nearest(x, y, obj_infantaria);
    var _alvo_tanque = instance_nearest(x, y, obj_tanque);
    var _alvo_soldado_aa = instance_nearest(x, y, obj_soldado_antiaereo);
    var _alvo_blindado_aa = instance_nearest(x, y, obj_blindado_antiaereo);
    var _alvo_inimigo = instance_nearest(x, y, obj_inimigo); // Fallback
    
    var _alvo_encontrado = noone;
    var _tipo_alvo = "";
    
    // Verifica alvos navais primeiro (prioridade máxima)
    if (instance_exists(_alvo_naval) && _alvo_naval != id && _alvo_naval.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_naval.x, _alvo_naval.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_naval;
        _tipo_alvo = "naval (Lancha inimiga)";
    } else if (instance_exists(_alvo_helicoptero) && _alvo_helicoptero.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_helicoptero.x, _alvo_helicoptero.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_helicoptero;
        _tipo_alvo = "aéreo (Helicóptero inimigo)";
    } 
    // ✅ NOVO: Verificar unidades terrestres inimigas
    else if (instance_exists(_alvo_infantaria) && _alvo_infantaria.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_infantaria.x, _alvo_infantaria.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_infantaria;
        _tipo_alvo = "terrestre (Infantaria inimiga)";
    } else if (instance_exists(_alvo_tanque) && _alvo_tanque.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_tanque.x, _alvo_tanque.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_tanque;
        _tipo_alvo = "terrestre (Tanque inimigo)";
    } else if (instance_exists(_alvo_soldado_aa) && _alvo_soldado_aa.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_soldado_aa.x, _alvo_soldado_aa.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_soldado_aa;
        _tipo_alvo = "terrestre (Soldado Anti-Aéreo inimigo)";
    } else if (instance_exists(_alvo_blindado_aa) && _alvo_blindado_aa.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_blindado_aa.x, _alvo_blindado_aa.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_blindado_aa;
        _tipo_alvo = "terrestre (Blindado Anti-Aéreo inimigo)";
    } else if (instance_exists(_alvo_inimigo) && _alvo_inimigo.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_inimigo.x, _alvo_inimigo.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_inimigo;
        _tipo_alvo = "terrestre (Inimigo genérico)";
    }
    
    // Se encontrou um inimigo dentro do radar...
    if (instance_exists(_alvo_encontrado)) {
        estado_anterior = estado; // GUARDA o que estava fazendo (ex: "patrulhando")
        estado = LanchaState.ATACANDO;      // MUDA o estado para "atacando"
        alvo_unidade = _alvo_encontrado; // Trava a mira no inimigo
        
        if (global.debug_enabled) show_debug_message("🎯 Alvo " + _tipo_alvo + " detectado! Interrompendo tarefa para atacar " + string(alvo_unidade));
    } else {
        // Debug: mostra por que não encontrou alvos
        if (global.debug_enabled) show_debug_message("🔍 Modo ataque ativo mas nenhum alvo inimigo encontrado no radar (alcance: " + string(radar_alcance) + ")");
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
        
           // --- ESTADO DE COMBATE NAVAL COM ORBITAÇÃO DINÂMICA ---
           case LanchaState.ATACANDO:
               if (instance_exists(alvo_unidade)) {
                   var _distancia_alvo = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
                   
                   // ✅ SISTEMA DE ORBITAÇÃO DINÂMICA
                   if (_distancia_alvo > missil_alcance) {
                       // Fora do alcance - persegue o inimigo
                       alvo_x = alvo_unidade.x;
                       alvo_y = alvo_unidade.y;
                   } else {
                       // ✅ DENTRO DO ALCANCE - Sistema de órbita inteligente
                       
                       // Distância ideal para tiro (90% do alcance máximo)
                       var _distancia_ideal = missil_alcance * 0.9;
                       
                       // Verifica se inimigo está se movendo
                       var _inimigo_se_movendo = false;
                       
                       // Verifica velocidade_atual se existir
                       if (variable_instance_exists(alvo_unidade, "velocidade_atual")) {
                           _inimigo_se_movendo = (alvo_unidade.velocidade_atual > 0);
                       }
                       
                       // Verifica estado se existir
                       if (variable_instance_exists(alvo_unidade, "estado")) {
                           _inimigo_se_movendo = _inimigo_se_movendo || (alvo_unidade.estado != "parado");
                       }
                       
                       // Fallback: verifica se está se movendo pela distância
                       if (!_inimigo_se_movendo) {
                           // Se não tem variáveis de movimento, assume que está se movendo se mudou de posição
                           _inimigo_se_movendo = (point_distance(x, y, alvo_unidade.x, alvo_unidade.y) > 5);
                       }
                       
                       if (_inimigo_se_movendo) {
                           // ✅ Inimigo se movendo - orbita para acompanhar
                           var _angulo_atual = point_direction(alvo_unidade.x, alvo_unidade.y, x, y);
                           var _angulo_orbita = _angulo_atual + 5; // Rotaciona 5 graus por frame
                           
                           alvo_x = alvo_unidade.x + lengthdir_x(_distancia_ideal, _angulo_orbita);
                           alvo_y = alvo_unidade.y + lengthdir_y(_distancia_ideal, _angulo_orbita);
                           
                           if (global.debug_enabled) show_debug_message("🔄 Lancha orbitando ao redor do inimigo em movimento");
                       } else {
                           // ✅ Inimigo parado - PARA completamente
                           // Não atualiza alvo_x e alvo_y - lancha fica parada
                           if (global.debug_enabled) show_debug_message("⏸️ Lancha parada - inimigo estático");
                       }
                   }
                   
                   // Sistema de tiro à distância
                   if (_distancia_alvo <= missil_alcance && reload_timer <= 0) {
                       var _missil = scr_get_projectile_from_pool(obj_tiro_simples, x, y, "Instances");
                       if (instance_exists(_missil)) {
                           _missil.alvo = alvo_unidade;
                           _missil.dono = id;
                           _missil.dano = 25;
                           _missil.speed = 8;
                           _missil.direction = point_direction(x, y, alvo_unidade.x, alvo_unidade.y);
                           if (variable_instance_exists(_missil, "timer_vida")) {
                               _missil.timer_vida = 300;
                           }
                           reload_timer = reload_time;
                           if (global.debug_enabled) show_debug_message("🚀 Lancha atirou à distância (" + string(round(_distancia_alvo)) + "px)");
                       }
                   }
               } else {
                   if (global.debug_enabled) show_debug_message("✅ Alvo destruído! Retornando para: " + string(estado_anterior));
                   estado = estado_anterior;
                   alvo_unidade = noone;
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