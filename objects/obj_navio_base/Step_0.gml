/// @description Lógica principal do navio (movimento, ataque, patrulha)

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O) - adaptados para lancha
    if (keyboard_check_pressed(ord("P"))) { 
        modo_combate = LanchaMode.PASSIVO; 
        show_debug_message("🛡️ " + nome_unidade + " em Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_combate = LanchaMode.ATAQUE; 
        show_debug_message("⚔️ " + nome_unidade + " em Modo ATAQUE AGRESSIVO");
    }

    // Comando de Parar (L) - adaptado para lancha
    if (keyboard_check_pressed(ord("L"))) {
        estado = LanchaState.PARADO;
        alvo_unidade = noone;
        show_debug_message("⏹️ " + nome_unidade + " recebeu ordem para PARAR");
    }
    
    // Comandos K, clique esquerdo e clique direito agora são gerenciados pelo obj_input_manager
    // para evitar conflitos e manter o modo de patrulha persistente
}

// ======================================================================
// --- 2. LÓGICA DE AQUISIÇÃO DE ALVO (ADAPTADA PARA NAVAL) ---
// ======================================================================
// Se o modo ataque está ativo E a lancha não está parada E não está já atacando alguém...
if (modo_combate == LanchaMode.ATAQUE && estado != LanchaState.ATACANDO) {
    // Prioriza alvos navais (qualquer objeto filho de obj_navio_base), depois aéreos e terrestres
    var _alvo_submarino = noone;
    // Submarino desabilitado (obj_submarino não existe no projeto)
    var _alvo_naval = noone;
    if (object_exists(obj_navio_base)) {
        _alvo_naval = instance_nearest(x, y, obj_navio_base);
    }
    var _alvo_f6 = noone;
    if (object_exists(obj_f6)) {
        _alvo_f6 = instance_nearest(x, y, obj_f6);
    }
    var _alvo_f5 = noone;
    if (object_exists(obj_caca_f5)) {
        _alvo_f5 = instance_nearest(x, y, obj_caca_f5);
    }
    var _alvo_helicoptero = noone;
    if (object_exists(obj_helicoptero_militar)) {
        _alvo_helicoptero = instance_nearest(x, y, obj_helicoptero_militar);
    }
    var _alvo_terrestre = noone;
    if (object_exists(obj_inimigo)) {
        _alvo_terrestre = instance_nearest(x, y, obj_inimigo);
    }
    var _alvo_infantaria = noone;
    if (object_exists(obj_infantaria)) {
        _alvo_infantaria = instance_nearest(x, y, obj_infantaria);
    }
    
    var _alvo_encontrado = noone;
    var _tipo_alvo = "";
    
    // Verifica submarinos primeiro (prioridade MÁXIMA para míssil Ice)
    if (instance_exists(_alvo_submarino) && _alvo_submarino.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_submarino.x, _alvo_submarino.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_submarino;
        _tipo_alvo = "submarino inimigo";
    }
    // Verifica alvos navais (prioridade alta)
    else if (instance_exists(_alvo_naval) && _alvo_naval != id && _alvo_naval.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_naval.x, _alvo_naval.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_naval; // Pode ser Lancha, Constellation, etc.
        _tipo_alvo = "naval (" + object_get_name(_alvo_naval.object_index) + ")";
    } else if (instance_exists(_alvo_f6) && _alvo_f6.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_f6.x, _alvo_f6.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_f6;
        _tipo_alvo = "aéreo (F-6 inimigo)";
    } else if (instance_exists(_alvo_f5) && _alvo_f5.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_f5.x, _alvo_f5.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_f5;
        _tipo_alvo = "aéreo (F-5 inimigo)";
    } else if (instance_exists(_alvo_helicoptero) && _alvo_helicoptero.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_helicoptero.x, _alvo_helicoptero.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_helicoptero;
        _tipo_alvo = "aéreo (Helicóptero inimigo)";
    } else if (instance_exists(_alvo_infantaria) && _alvo_infantaria.nacao_proprietaria == 2 && point_distance(x, y, _alvo_infantaria.x, _alvo_infantaria.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_infantaria;
        _tipo_alvo = "inimigo (infantaria)";
    } else if (instance_exists(_alvo_terrestre) && _alvo_terrestre.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_terrestre.x, _alvo_terrestre.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_terrestre;
        _tipo_alvo = "terrestre inimigo";
    }
    
    // Se encontrou um inimigo dentro do radar...
    if (instance_exists(_alvo_encontrado)) {
        estado_anterior = estado; // GUARDA o que estava fazendo (ex: "patrulhando")
        estado = LanchaState.ATACANDO;      // MUDA o estado para "atacando"
        alvo_unidade = _alvo_encontrado; // Trava a mira no inimigo
        
        // DEBUG EXTRA PARA INDEPENDENCE
        if (nome_unidade == "Independence") {
            show_debug_message("🎯🎯🎯 INDEPENDENCE detectou alvo " + _tipo_alvo + "! Estado agora: ATACANDO");
        } else {
            show_debug_message("🎯 " + nome_unidade + " detectou alvo " + _tipo_alvo + "! Interrompendo tarefa para atacar.");
        }
    }
}
// ======================================================================

// --- 3. MÁQUINA DE ESTADOS (ADAPTADA PARA LANCHA) ---
// Gerencia as transições e lógicas de cada estado
switch (estado) {
    case LanchaState.PARADO:
        // Não faz nada, espera ordens.
        break;

    case LanchaState.MOVENDO:
        // A lógica de movimento está na seção 4. Se chegar ao destino, a seção 4 o colocará em PARADO.
        break;

    case LanchaState.PATRULHANDO:
        // Se chegou ao ponto atual, vai para o próximo
        if (point_distance(x, y, destino_x, destino_y) < 20) {
            func_proximo_ponto();
            show_debug_message("🚢 " + nome_unidade + " indo para o próximo ponto de patrulha.");
        }
        break;
        
           // --- ESTADO DE COMBATE NAVAL COM ORBITAÇÃO DINÂMICA ---
           case LanchaState.ATACANDO:
               if (instance_exists(alvo_unidade)) {
                   var _distancia_alvo = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
                   
                   // ✅ SISTEMA DE ORBITAÇÃO DINÂMICA
                   if (_distancia_alvo > missil_alcance) {
                       // Fora do alcance - persegue o inimigo
                       destino_x = alvo_unidade.x;
                       destino_y = alvo_unidade.y;
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
                           
                           destino_x = alvo_unidade.x + lengthdir_x(_distancia_ideal, _angulo_orbita);
                           destino_y = alvo_unidade.y + lengthdir_y(_distancia_ideal, _angulo_orbita);
                       } else {
                           // ✅ Inimigo parado - PARA completamente
                           // Não atualiza destino_x e destino_y - lancha fica parada para atirar
                       }
                   }
                   
                   // Sistema de tiro à distância com mísseis
                   // Permitir que objetos individuais desabilitem mísseis via flag `pode_disparar_missil`
                   var _nome_obj = object_get_name(object_index);
                   var _allow_missiles = true;
                   if (variable_instance_exists(id, "pode_disparar_missil")) _allow_missiles = pode_disparar_missil;

                   if (_distancia_alvo <= missil_alcance && reload_timer <= 0 && _allow_missiles) {
                       // Determinar tipo de míssil baseado no alvo
                       var _missil_obj = obj_tiro_simples; // Padrão
                       var _missil_nome = "Tiro Simples";
                       
                       // === PRIMEIRO: Verificar se é um submarino ===
                       var _nome_alvo = object_get_name(alvo_unidade.object_index);
                       if (_nome_alvo == "obj_submarino") {
                           // Alvo é submarino - usar Míssil Ice anti-submarino
                           _missil_obj = obj_missel_ice;
                           _missil_nome = "Míssil Ice (Anti-Submarino)";
                       } else {
                           // Verificar se é Constellation ou Independence (usa mísseis especiais)
                           if (_nome_obj == "obj_Constellation" || _nome_obj == "obj_Independence") {
                               // Verificar tipo de alvo para escolher míssil
                               if (_nome_alvo == "obj_helicoptero_militar" || 
                                   _nome_alvo == "obj_caca_f5" ||
                                   _nome_alvo == "obj_f6") {
                                   // Alvo aéreo - usar SkyFury
                                   _missil_obj = obj_SkyFury_ar;
                                   _missil_nome = "SkyFury Ar-Ar";
                               } else {
                                   // Alvo terrestre/naval - usar Ironclad
                                   _missil_obj = obj_Ironclad_terra;
                                   _missil_nome = "Ironclad Terra-Terra";
                               }
                           }
                       }
                       
                       var _missil = instance_create_layer(x, y, "Instances", _missil_obj);
                       if (instance_exists(_missil)) {
                           _missil.dono = id;
                           _missil.direction = point_direction(x, y, alvo_unidade.x, alvo_unidade.y);
                           
                           // Configurações específicas para cada tipo de míssil
                           if (_missil_obj == obj_tiro_simples) {
                               // Míssil simples padrão
                               _missil.target = alvo_unidade;
                               _missil.alvo = alvo_unidade;
                               _missil.dano = 25;
                               _missil.speed = 8;
                           } else if (_missil_obj == obj_missel_ice) {
                               // Míssil Ice anti-submarino
                               _missil.target = alvo_unidade;
                               _missil.alvo = alvo_unidade;
                               // Dano já configurado no Create (75 base + bônus)
                               show_debug_message("❄️ Míssil Ice configurado contra submarino!");
                           } else if (_missil_obj == obj_SkyFury_ar || _missil_obj == obj_Ironclad_terra) {
                               // Mísseis especiais do Constellation/Independence
                               _missil.target = alvo_unidade;
                               _missil.alvo = alvo_unidade;
                               show_debug_message("🎯 Míssil especial configurado: " + _missil_nome);
                           }
                           
                           reload_timer = reload_time; // Reseta o timer
                           show_debug_message("🚀 " + nome_unidade + " disparou " + _missil_nome + " contra " + _nome_alvo + "! Distância: " + string(round(_distancia_alvo)) + "px");
                       }
                   }
               } else {
                   show_debug_message("✅ Alvo destruído! " + nome_unidade + " retornando para estado anterior: " + string(estado_anterior));
                   estado = estado_anterior;
                   alvo_unidade = noone;
               }
               break;
}

// --- 4. LÓGICA DE MOVIMENTO NAVAL (ADAPTADA DO F5) ---
var _is_moving = (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO || (estado == LanchaState.ATACANDO && point_distance(x, y, destino_x, destino_y) > 5));

if (_is_moving) {
    var _dist = point_distance(x, y, destino_x, destino_y);
    if (_dist > 5) {
        var _dir = point_direction(x, y, destino_x, destino_y);
        // Rotação suave
        image_angle = angle_difference(image_angle, _dir) * -0.1 + image_angle;
        // Movimento
        x += lengthdir_x(velocidade_movimento, _dir);
        y += lengthdir_y(velocidade_movimento, _dir);
    } else {
        // Chegou ao destino (se estava se movendo)
        if (estado == LanchaState.MOVENDO) {
            estado = LanchaState.PARADO;
            show_debug_message("🚢 " + nome_unidade + " chegou ao destino. Estado: PARADO");
        }
    }
}

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (reload_timer > 0) {
    reload_timer--;
}