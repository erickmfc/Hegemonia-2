/// @description Lógica principal do navio (movimento, ataque, patrulha)

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == LanchaState.ATACANDO || submerso);

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == LanchaState.MOVENDO) {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                // ✅ CORREÇÃO: Normalizar velocidade antes de aplicar multiplicador do LOD
                var _vel_normalizada = scr_normalize_unit_speed(velocidade_movimento);
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, _vel_normalizada, speed_mult);
                if (!still_moving && estado == LanchaState.MOVENDO) {
                    estado = LanchaState.PARADO;
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O)
    if (keyboard_check_pressed(ord("P"))) { 
        modo_combate = LanchaMode.PASSIVO; 
        show_debug_message("🛡️ " + nome_unidade + " em Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_combate = LanchaMode.ATAQUE; 
        show_debug_message("⚔️ " + nome_unidade + " em Modo ATAQUE AGRESSIVO");
    }

    // Comando de Parar (L)
    if (keyboard_check_pressed(ord("L"))) {
        estado = LanchaState.PARADO;
        alvo_unidade = noone;
        show_debug_message("⏹️ " + nome_unidade + " recebeu ordem para PARAR");
    }
    
    // Comando K removido - agora gerenciado pelo obj_input_manager
}

// --- 1.5. SISTEMA DE SUBMERSÃO/EMERSÃO ---
// Cooldown de submersão
if (cooldown_submersao > 0) {
    cooldown_submersao--;
}

// Efeito visual de transparência
if (submerso) {
    image_alpha = 0.5; // Semi-transparente submerso
} else {
    image_alpha = 1.0; // Totalmente visível na superfície
}

// ======================================================================
// --- 2. LÓGICA DE AQUISIÇÃO DE ALVO (ADAPTADA PARA NAVAL) ---
// ======================================================================
// ✅ OTIMIZAÇÃO: Decrementar timer de verificação
if (timer_verificacao_inimigos > 0) {
    timer_verificacao_inimigos--;
}

// Se o modo ataque está ativo E a lancha não está parada E não está já atacando alguém...
// ✅ OTIMIZAÇÃO: Só verificar inimigos periodicamente (quando timer chegar a 0) ou se não tem alvo
if (modo_combate == LanchaMode.ATAQUE && estado != LanchaState.ATACANDO && (timer_verificacao_inimigos <= 0 || alvo_unidade == noone || !instance_exists(alvo_unidade))) {
    // Prioriza alvos navais (qualquer objeto filho de obj_navio_base), depois aéreos e terrestres
    var _alvo_submarino = instance_nearest(x, y, obj_wwhendrick); // Usar obj_wwhendrick ao invés de obj_submarino
    var _alvo_naval = instance_nearest(x, y, obj_navio_base);
    var _alvo_f6 = instance_nearest(x, y, obj_f6);
    var _alvo_f5 = instance_nearest(x, y, obj_caca_f5);
    var _alvo_helicoptero = instance_nearest(x, y, obj_helicoptero_militar);
    // ✅ CORREÇÃO: obj_inimigo removido - buscar apenas obj_infantaria
    var _alvo_terrestre = noone;
    var _alvo_infantaria = instance_nearest(x, y, obj_infantaria);
    
    // ✅ NOVO: Procurar ESTRUTURAS INIMIGAS (casas, quarteis, bancos)
    var _alvo_casa = instance_nearest(x, y, obj_casa);
    var _alvo_banco = instance_nearest(x, y, obj_banco);
    var _alvo_quartel = instance_nearest(x, y, obj_quartel);
    var _alvo_quartel_marinha = instance_nearest(x, y, obj_quartel_marinha);
    var _alvo_aeroporto = instance_nearest(x, y, obj_aeroporto_militar);
    
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
    // ✅ NOVO: Verificar estruturas inimigas (prioridade baixa, mas atacáveis)
    else if (instance_exists(_alvo_quartel) && variable_instance_exists(_alvo_quartel, "nacao_proprietaria") && _alvo_quartel.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_quartel.x, _alvo_quartel.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_quartel;
        _tipo_alvo = "estrutura (Quartel inimigo)";
    } else if (instance_exists(_alvo_quartel_marinha) && variable_instance_exists(_alvo_quartel_marinha, "nacao_proprietaria") && _alvo_quartel_marinha.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_quartel_marinha.x, _alvo_quartel_marinha.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_quartel_marinha;
        _tipo_alvo = "estrutura (Quartel Marinha inimigo)";
    } else if (instance_exists(_alvo_aeroporto) && variable_instance_exists(_alvo_aeroporto, "nacao_proprietaria") && _alvo_aeroporto.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_aeroporto.x, _alvo_aeroporto.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_aeroporto;
        _tipo_alvo = "estrutura (Aeroporto inimigo)";
    } else if (instance_exists(_alvo_banco) && variable_instance_exists(_alvo_banco, "nacao_proprietaria") && _alvo_banco.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_banco.x, _alvo_banco.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_banco;
        _tipo_alvo = "estrutura (Banco inimigo)";
    } else if (instance_exists(_alvo_casa) && variable_instance_exists(_alvo_casa, "nacao_proprietaria") && _alvo_casa.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_casa.x, _alvo_casa.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_casa;
        _tipo_alvo = "estrutura (Casa inimiga)";
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
    
    // ✅ OTIMIZAÇÃO: Resetar timer após verificação
    timer_verificacao_inimigos = intervalo_verificacao_inimigos;
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
            // ✅ NOVO: Sistema de rotação de patrulha (horário/anti-horário)
            var _total_pontos = ds_list_size(pontos_patrulha);
            if (!variable_instance_exists(id, "direcao_patrulha")) {
                direcao_patrulha = 1; // Padrão: horário
            }
            indice_patrulha_atual = (indice_patrulha_atual + direcao_patrulha + _total_pontos) % _total_pontos;
            var _ponto = pontos_patrulha[| indice_patrulha_atual];
            destino_x = _ponto[0];
            destino_y = _ponto[1];
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
                       if (_nome_alvo == "obj_wwhendrick" || _nome_alvo == "obj_submarino_base") {
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
                               _missil.dano = 100; // ✅ AUMENTADO: Dano suficiente para matar soldados (era 25)
                               _missil.speed = 8;
                           } else if (_missil_obj == obj_missel_ice) {
                               // Míssil Ice anti-submarino
                               _missil.alvo = alvo_unidade;
                               // Dano já configurado no Create (75 base + bônus)
                               show_debug_message("❄️ Míssil Ice configurado contra submarino!");
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
        // ✅ CORREÇÃO: Rotação suave com velocidade de 0.8 graus por frame
        var _diff = angle_difference(image_angle, _dir);
        var _vel_rotacao = min(velocidade_rotacao, abs(_diff));
        image_angle += sign(_diff) * -_vel_rotacao;
        
        // ✅ REALISMO: Movimento curvo - sempre move na direção que está apontando enquanto vira
        // ✅ CORREÇÃO: Normalizar velocidade baseado no zoom para manter velocidade visual constante
        var _vel_normalizada = scr_normalize_unit_speed(velocidade_movimento);
        // Movimento na direção que o navio está apontando (cria curva suave)
        x += lengthdir_x(_vel_normalizada, image_angle);
        y += lengthdir_y(_vel_normalizada, image_angle);
        
        // ✅ EFEITO DE ESPUMA DO MAR (Rastro de água) - apenas se não estiver submerso
        if (!submerso) {
            if (!variable_instance_exists(id, "timer_espuma")) {
                timer_espuma = 0;
            }
            timer_espuma++;
            if (timer_espuma >= 3) {
                timer_espuma = 0;
                var _distancia_popa = 20;
                var _angulo_popa = image_angle + 180;
                var _layer_navio = layer_get_name(layer);
                
                // obj_WTrail4 no MEIO do navio
                if (object_exists(obj_WTrail4)) {
                    var _pos_espuma_x = x;
                    var _pos_espuma_y = y;
                    var _espuma = noone;
                    if (layer_exists(_layer_navio)) {
                        _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, _layer_navio, obj_WTrail4);
                    }
                    if (!instance_exists(_espuma) && layer_exists("Instances")) {
                        _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, "Instances", obj_WTrail4);
                    }
                    if (instance_exists(_espuma)) {
                        _espuma.timer_duracao = 90;
                        _espuma.timer_atual = 0;
                        if (_espuma.sprite_index == -1) {
                            _espuma.sprite_index = asset_get_index("WTrail4");
                        }
                        _espuma.image_xscale = 1.0 + random(0.4);
                        _espuma.image_yscale = 1.0 + random(0.4);
                        _espuma.image_blend = c_white;
                        _espuma.visible = true;
                        _espuma.image_alpha = 0.2;
                        if (variable_instance_exists(id, "depth")) {
                            _espuma.depth = depth + 1;
                        } else {
                            _espuma.depth = -100;
                        }
                        _espuma.image_angle = image_angle + random_range(-5, 5);
                    }
                }
                
                // ✅ obj_WbTrail1 no FINAL do navio (popa) - Submarino: sprite 270px, origem 135px, distância ~127px
                if (object_exists(obj_WbTrail1)) {
                    var _distancia_final = 127; // 270px * 0.47 ≈ 127px (proporção baseada na lancha patrulha)
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
                        _trail_popa.image_xscale = 3.0 * 0.8; // 80% do tamanho
                        _trail_popa.image_yscale = 3.0 * 0.8;
                        _trail_popa.image_alpha = 0.2; // Mesma transparência do trail4
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