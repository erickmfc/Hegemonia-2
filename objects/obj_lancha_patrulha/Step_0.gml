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
                // ✅ CORREÇÃO: Normalizar velocidade antes de aplicar multiplicador do LOD
                var _vel_normalizada = scr_normalize_unit_speed(velocidade_movimento);
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, _vel_normalizada, speed_mult);
                if (!still_moving && (estado == LanchaState.MOVENDO || estado_string == "movendo")) {
                    estado = LanchaState.PARADO;
                    estado_string = "parado";
                }
            }
            
            // ✅ CORREÇÃO: Incrementar timer de espuma mesmo quando frame skip está ativo
            // Isso garante que a espuma seja criada mesmo quando frames são pulados
            if (!variable_instance_exists(id, "timer_espuma")) {
                timer_espuma = 0;
            }
            timer_espuma++;
            if (timer_espuma >= 3) {
                timer_espuma = 0;
                // ✅ NOVO: Criar espuma mesmo em frame skip usando ambos os objetos
                var _distancia_popa = 20;
                var _angulo_popa = image_angle + 180;
                var _layer_navio = layer_get_name(layer);
                
                // ✅ CORREÇÃO: Apenas obj_WTrail4 no MEIO do navio com 20% de transparência
                var _obj_espuma = obj_WTrail4;
                
                if (object_exists(_obj_espuma)) {
                    // Posição no MEIO do navio (centro)
                    var _pos_espuma_x = x;
                    var _pos_espuma_y = y;
                    
                    var _espuma = noone;
                    
                    if (layer_exists(_layer_navio)) {
                        _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, _layer_navio, _obj_espuma);
                    }
                    
                    if (!instance_exists(_espuma) && layer_exists("Instances")) {
                        _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, "Instances", _obj_espuma);
                    }
                    
                    if (instance_exists(_espuma)) {
                        _espuma.timer_duracao = 90;
                        _espuma.timer_atual = 0;
                        
                        // ✅ CRÍTICO: Garantir que o sprite está definido
                        if (_espuma.sprite_index == -1) {
                            _espuma.sprite_index = asset_get_index("WTrail4");
                        }
                        
                        // ✅ CORREÇÃO: Reduzir escala em 80% (de 5.0-7.0 para 1.0-1.4)
                        _espuma.image_xscale = 1.0 + random(0.4);
                        _espuma.image_yscale = 1.0 + random(0.4);
                        _espuma.image_blend = c_white;
                        _espuma.visible = true;
                        _espuma.image_alpha = 0.2; // ✅ 20% de transparência
                        
                        // Depth maior = mais na frente
                        if (variable_instance_exists(id, "depth")) {
                            _espuma.depth = depth + 1;
                        } else {
                            _espuma.depth = -100;
                        }
                        _espuma.image_angle = image_angle + random_range(-5, 5);
                    }
                }
                
                // ✅ NOVO: obj_WbTrail1 no FINAL do navio (popa) - diferente do trail4 que está no centro
                if (object_exists(obj_WbTrail1)) {
                    // Posição na popa (final do sprite do navio) - 50% mais para a popa
                    // Sprite tem 160px de largura, origem em 80px, então final fica a ~80px do centro
                    var _distancia_final = 75; // 42 * 1.5 = 63, mas ajustado para 75 para ficar no final do sprite (160px/2 = 80px)
                    var _pos_popa_x = x + lengthdir_x(_distancia_final, _angulo_popa);
                    var _pos_popa_y = y + lengthdir_y(_distancia_final, _angulo_popa);
                    
                    var _trail_popa = noone;
                    
                    if (layer_exists(_layer_navio)) {
                        _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, _layer_navio, obj_WbTrail1);
                    }
                    
                    if (!instance_exists(_trail_popa) && layer_exists("Instances")) {
                        _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, "Instances", obj_WbTrail1);
                    }
                    
                    if (instance_exists(_trail_popa)) {
                        _trail_popa.timer_duracao = 90;
                        _trail_popa.timer_atual = 0;
                        
                        // ✅ Diminuir em 20% (80% do tamanho original = 0.8x)
                        _trail_popa.image_xscale = 3.0 * 0.8; // 2.4
                        _trail_popa.image_yscale = 3.0 * 0.8; // 2.4
                        
                        // ✅ Mesma transparência do trail4 (alpha = 0.2)
                        _trail_popa.image_alpha = 0.2;
                        // ✅ Cor original do sprite
                        _trail_popa.image_blend = c_white;
                        _trail_popa.visible = true;
                        
                        if (variable_instance_exists(id, "depth")) {
                            _trail_popa.depth = depth + 1;
                        } else {
                            _trail_popa.depth = -100;
                        }
                        
                        _trail_popa.image_angle = image_angle + random_range(-5, 5);
                    }
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
// ✅ OTIMIZAÇÃO: Decrementar timer de verificação
if (timer_verificacao_inimigos > 0) {
    timer_verificacao_inimigos--;
}

// Se o modo ataque está ativo E não está já atacando alguém...
// ✅ OTIMIZAÇÃO: Só verificar inimigos periodicamente (quando timer chegar a 0) ou se não tem alvo
if (modo_combate == LanchaMode.ATAQUE && estado != LanchaState.ATACANDO && (timer_verificacao_inimigos <= 0 || alvo_unidade == noone || !instance_exists(alvo_unidade))) {
    // Prioriza alvos navais primeiro, depois terrestres
    var _alvo_naval = instance_nearest(x, y, obj_lancha_patrulha);
    var _alvo_helicoptero = instance_nearest(x, y, obj_helicoptero_militar);
    
    // ✅ NOVO: Procurar TODAS as unidades terrestres inimigas
    // ✅ CORREÇÃO: obj_inimigo removido
    var _alvo_infantaria = instance_nearest(x, y, obj_infantaria);
    var _alvo_tanque = instance_nearest(x, y, obj_tanque);
    var _alvo_soldado_aa = instance_nearest(x, y, obj_soldado_antiaereo);
    var _alvo_blindado_aa = instance_nearest(x, y, obj_blindado_antiaereo);
    
    // ✅ NOVO: Procurar ESTRUTURAS INIMIGAS (casas, quarteis, bancos)
    var _alvo_casa = instance_nearest(x, y, obj_casa);
    var _alvo_banco = instance_nearest(x, y, obj_banco);
    var _alvo_quartel = instance_nearest(x, y, obj_quartel);
    var _alvo_quartel_marinha = instance_nearest(x, y, obj_quartel_marinha);
    var _alvo_aeroporto = instance_nearest(x, y, obj_aeroporto_militar);
    
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
    }
    // ✅ CORREÇÃO: Removida referência a _alvo_inimigo (obj_inimigo foi removido do projeto)
    // ✅ NOVO: Verificar estruturas inimigas (prioridade baixa, mas atacáveis)
    else if (instance_exists(_alvo_quartel) && _alvo_quartel.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_quartel.x, _alvo_quartel.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_quartel;
        _tipo_alvo = "estrutura (Quartel inimigo)";
    } else if (instance_exists(_alvo_quartel_marinha) && _alvo_quartel_marinha.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_quartel_marinha.x, _alvo_quartel_marinha.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_quartel_marinha;
        _tipo_alvo = "estrutura (Quartel Marinha inimigo)";
    } else if (instance_exists(_alvo_aeroporto) && _alvo_aeroporto.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_aeroporto.x, _alvo_aeroporto.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_aeroporto;
        _tipo_alvo = "estrutura (Aeroporto inimigo)";
    } else if (instance_exists(_alvo_banco) && _alvo_banco.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_banco.x, _alvo_banco.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_banco;
        _tipo_alvo = "estrutura (Banco inimigo)";
    } else if (instance_exists(_alvo_casa) && _alvo_casa.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_casa.x, _alvo_casa.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_casa;
        _tipo_alvo = "estrutura (Casa inimiga)";
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
    
    // ✅ OTIMIZAÇÃO: Resetar timer após verificação
    timer_verificacao_inimigos = intervalo_verificacao_inimigos;
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
            // ✅ NOVO: Sistema de rotação de patrulha (horário/anti-horário)
            var _total_pontos = ds_list_size(pontos_patrulha);
            if (!variable_instance_exists(id, "direcao_patrulha")) {
                direcao_patrulha = 1; // Padrão: horário
            }
            indice_patrulha_atual = (indice_patrulha_atual + direcao_patrulha + _total_pontos) % _total_pontos;
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
                           _missil.dano = 35; // Dano ajustado
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

// ✅ DEBUG: Log periódico para diagnosticar estado (apenas se debug estiver ativo)
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    if (!variable_instance_exists(id, "debug_espuma_counter")) {
        debug_espuma_counter = 0;
    }
    debug_espuma_counter++;
    if (debug_espuma_counter % 60 == 0) { // A cada 60 frames (1 segundo)
        show_debug_message("🌊 DEBUG ESPUMA - Estado: " + string(estado) + " (" + string(LanchaState.MOVENDO) + "=MOVENDO) | _is_moving: " + string(_is_moving) + " | Timer: " + string(timer_espuma) + " | Alvo: (" + string(round(alvo_x)) + ", " + string(round(alvo_y)) + ")");
    }
}

if (_is_moving) {
    var _dist = point_distance(x, y, alvo_x, alvo_y);
    var _tolerancia_chegada = 8; // Tolerância padrão
    
    if (_dist > _tolerancia_chegada) {
        var _dir = point_direction(x, y, alvo_x, alvo_y);
        
        // ✅ CORREÇÃO: Detectar se destino está atrás do navio
        var _diff = angle_difference(image_angle, _dir);
        var _abs_diff = abs(_diff);
        
        // ✅ CORREÇÃO: Inicializar variáveis se necessário
        if (!variable_instance_exists(id, "distancia_anterior")) {
            distancia_anterior = _dist;
            timer_afastando = 0;
            angulo_anterior = image_angle;
            timer_girando = 0;
        }
        
        // ✅ CORREÇÃO: Detectar curvas justas e ajustar comportamento
        // Curva muito justa (> 90°): precisa manobrar mais tempo
        // Curva moderada (60-90°): reduz velocidade
        // Curva suave (< 60°): velocidade normal
        
        var _curva_muito_justa = (_abs_diff > 90);
        var _curva_moderada = (_abs_diff > 60 && _abs_diff <= 90);
        var _curva_suave = (_abs_diff <= 60);
        
        // ✅ CORREÇÃO: Se diferença < 30°, destino está bem à frente - resetar timers e acelerar
        if (_abs_diff < 30) {
            // Destino está bem à frente - resetar todos os timers
            timer_afastando = 0;
            timer_girando = 0;
        }
        
        // Se diferença > 120°, destino está definitivamente atrás
        var _destino_atras = (_abs_diff > 120);
        
        // Verificar se está se aproximando
        var _estava_aproximando = (_dist < distancia_anterior - 2); // Margem de 2 pixels para evitar oscilação
        if (!_estava_aproximando && _dist > 15) { // Só conta se distância > 15 pixels
            timer_afastando++;
        } else {
            timer_afastando = max(0, timer_afastando - 3); // Reduz timer mais rápido se está se aproximando
        }
        
        // Verificar se está girando sem progresso (só se diferença ainda é grande)
        if (_abs_diff > 60) {
            var _angulo_mudou = abs(angle_difference(image_angle, angulo_anterior));
            if (_angulo_mudou > 3) { // Se girou mais de 3 graus
                timer_girando++;
            } else {
                timer_girando = max(0, timer_girando - 1); // Reduz se não está girando
            }
        } else {
            timer_girando = 0; // Resetar se já está alinhado
        }
        
        // Se está se afastando por mais de 1.5 segundos OU girando mais de 360° sem progresso
        if (timer_afastando > 90 || timer_girando > 120) { // 120 frames = ~360° a 3° por frame
            _destino_atras = true;
        }
        
        distancia_anterior = _dist;
        angulo_anterior = image_angle;
        
        // ✅ CORREÇÃO: Rotação suave
        var _vel_rotacao = min(velocidade_rotacao, abs(_diff));
        image_angle += sign(_diff) * -_vel_rotacao;
        
        // ✅ CORREÇÃO: Velocidade progressiva baseada no tipo de curva
        var _vel_normalizada = scr_normalize_unit_speed(velocidade_movimento);
        
        if (_destino_atras) {
            // Destino muito atrás (> 120°): velocidade mínima (15%)
            _vel_normalizada *= 0.15;
            _tolerancia_chegada = 25;
        } else if (_curva_muito_justa) {
            // Curva muito justa (90-120°): velocidade muito baixa (25%) - manobrar mais tempo
            _vel_normalizada *= 0.25;
        } else if (_curva_moderada) {
            // Curva moderada (60-90°): velocidade reduzida (40%) - começar a manobrar
            _vel_normalizada *= 0.4;
        } else if (_abs_diff > 45) {
            // Curva suave mas ainda precisa virar (45-60°): velocidade média (70%)
            _vel_normalizada *= 0.7;
        } else if (_abs_diff > 30) {
            // Quase alinhado (30-45°): velocidade alta (85%)
            _vel_normalizada *= 0.85;
        }
        // Se _abs_diff < 30°: velocidade normal (100%)
        
        // ✅ REALISMO: Movimento curvo - sempre move na direção que está apontando enquanto vira
        // Movimento na direção que o navio está apontando (cria curva suave)
        x += lengthdir_x(_vel_normalizada, image_angle);
        y += lengthdir_y(_vel_normalizada, image_angle);
        
        // ✅ CORREÇÃO: Verificar se chegou com tolerância ajustada
        var _dist_atual = point_distance(x, y, alvo_x, alvo_y);
        if (_dist_atual <= _tolerancia_chegada) {
            // Chegou ao destino
            if (estado == LanchaState.MOVENDO) {
                estado = LanchaState.PARADO;
                estado_string = "parado";
            } else if (estado == LanchaState.PATRULHANDO) {
                // Avançar para próximo ponto da patrulha
                indice_patrulha_atual = (indice_patrulha_atual + 1) % ds_list_size(pontos_patrulha);
                var _ponto = pontos_patrulha[| indice_patrulha_atual];
                alvo_x = _ponto[0];
                alvo_y = _ponto[1];
                destino_x = alvo_x;
                destino_y = alvo_y;
            }
            // Resetar variáveis de controle
            timer_afastando = 0;
            distancia_anterior = 0;
            timer_girando = 0;
        }
    } else {
        // Já chegou ao destino
        if (estado == LanchaState.MOVENDO) {
            estado = LanchaState.PARADO;
            estado_string = "parado";
        }
        // Resetar variáveis de controle
        timer_afastando = 0;
        distancia_anterior = 0;
        timer_girando = 0;
    }
    
    // ✅ EFEITO DE ESPUMA DO MAR (Rastro de água)
    // ✅ CORREÇÃO: Criar espuma SEMPRE que estiver se movendo, independente da distância
    // Garantir que timer_espuma existe
    if (!variable_instance_exists(id, "timer_espuma")) {
        timer_espuma = 0;
    }
    
    // ✅ CORREÇÃO: Verificar se está sobre água ANTES de criar espuma
    // ✅ TESTE: Temporariamente desabilitar verificação de água para diagnosticar
    // Se espuma aparecer sem verificação, o problema é na detecção de água
    var _sobre_agua = true; // scr_check_water_tile(x, y); // Descomentar quando detecção de água estiver funcionando
    
    if (_sobre_agua) {
        // ✅ CORREÇÃO CRÍTICA: Incrementar timer SEMPRE, não importa a distância
        timer_espuma++;
        
        if (timer_espuma >= 3) { // Cria espuma a cada 3 frames
            timer_espuma = 0;
            
            // ✅ NOVO: Usar AMBOS os objetos (obj_WbTrail1 e obj_WTrail4) para efeito variado
            // Criar múltiplas espumas em posições diferentes para rastro mais visível
            var _distancia_popa = 20; // Distância reduzida para ficar mais próxima
            var _angulo_popa = image_angle + 180; // Direção oposta ao movimento
            
            // ✅ CORREÇÃO: Tentar criar no mesmo layer do navio primeiro
            var _layer_navio = layer_get_name(layer);
            
            // ✅ CORREÇÃO: Apenas obj_WTrail4 no MEIO do navio com 20% de transparência
            var _obj_espuma = obj_WTrail4;
            
            // Verificar se objeto existe
            if (object_exists(_obj_espuma)) {
                // Posição no MEIO do navio (centro)
                var _pos_espuma_x = x;
                var _pos_espuma_y = y;
                
                var _espuma = noone;
                
                // Tentar criar no layer do navio
                if (layer_exists(_layer_navio)) {
                    _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, _layer_navio, _obj_espuma);
                }
                
                // Se falhou, tentar layer padrão
                if (!instance_exists(_espuma) && layer_exists("Instances")) {
                    _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, "Instances", _obj_espuma);
                }
                
                // ✅ CORREÇÃO: Configurar espuma
                if (instance_exists(_espuma)) {
                    // Aumentar duração (de 30 para 90 frames = 1.5 segundos)
                    _espuma.timer_duracao = 90;
                    _espuma.timer_atual = 0;
                    
                    // ✅ CRÍTICO: Garantir que o sprite está definido
                    if (_espuma.sprite_index == -1) {
                        _espuma.sprite_index = asset_get_index("WTrail4");
                    }
                    
                    // ✅ CORREÇÃO: Reduzir escala em 80% (de 5.0-7.0 para 1.0-1.4)
                    _espuma.image_xscale = 1.0 + random(0.4); // Variação de 1.0 a 1.4
                    _espuma.image_yscale = 1.0 + random(0.4);
                    
                    // Cor branca para espuma
                    _espuma.image_blend = c_white;
                    
                    // ✅ CRÍTICO: 20% de transparência (alpha = 0.2)
                    _espuma.visible = true;
                    _espuma.image_alpha = 0.2; // 20% de opacidade
                    
                    // ✅ CORREÇÃO: Configurar depth para aparecer acima da água
                    if (variable_instance_exists(id, "depth")) {
                        _espuma.depth = depth + 1; // Acima do navio
                    } else {
                        _espuma.depth = -100; // Depth padrão para efeitos
                    }
                    
                    // Rotacionar na direção do movimento
                    _espuma.image_angle = image_angle + random_range(-5, 5);
                } else if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("❌ FALHA AO CRIAR ESPUMA | Obj: " + string(_obj_espuma) + " | Layer: " + _layer_navio);
                }
            }
            
            // ✅ NOVO: obj_WbTrail1 no FINAL do navio (popa) - diferente do trail4 que está no centro
            if (object_exists(obj_WbTrail1)) {
                // Posição na popa (final do navio) - aumentar distância para ficar realmente no final
                var _distancia_final = 35; // Distância maior para ficar no final do navio
                var _pos_popa_x = x + lengthdir_x(_distancia_final, _angulo_popa);
                var _pos_popa_y = y + lengthdir_y(_distancia_final, _angulo_popa);
                
                var _trail_popa = noone;
                
                // Tentar criar no layer do navio
                if (layer_exists(_layer_navio)) {
                    _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, _layer_navio, obj_WbTrail1);
                }
                
                // Se falhou, tentar layer padrão
                if (!instance_exists(_trail_popa) && layer_exists("Instances")) {
                    _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, "Instances", obj_WbTrail1);
                }
                
                // Configurar obj_WbTrail1
                if (instance_exists(_trail_popa)) {
                    _trail_popa.timer_duracao = 90;
                    _trail_popa.timer_atual = 0;
                    
                    // ✅ Diminuir em 20% (80% do tamanho original = 0.8x)
                    _trail_popa.image_xscale = 3.0 * 0.8; // 2.4
                    _trail_popa.image_yscale = 3.0 * 0.8; // 2.4
                    
                    // ✅ Mesma transparência do trail4 (alpha = 0.2)
                    _trail_popa.image_alpha = 0.2;
                    // ✅ Cor original do sprite
                    _trail_popa.image_blend = c_white;
                    _trail_popa.visible = true;
                    
                    // Configurar depth
                    if (variable_instance_exists(id, "depth")) {
                        _trail_popa.depth = depth + 1;
                    } else {
                        _trail_popa.depth = -100;
                    }
                    
                    // Rotacionar na direção do movimento
                    _trail_popa.image_angle = image_angle + random_range(-5, 5);
                }
            }
        }
    } else {
        // Não está sobre água - resetar timer
        timer_espuma = 0;
    }
} else { // Parado
    // Lancha fica parada
    // Resetar timer de espuma quando parado
    if (variable_instance_exists(id, "timer_espuma")) {
        timer_espuma = 0;
    }
}

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (reload_timer > 0) {
    reload_timer--;
}