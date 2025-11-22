// ===============================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA (Step Adaptado)
// Sistema Naval com Comandos Completos
// ===============================================

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == LanchaState.ATACANDO || estado_string == "atacando" ||
                              estado == LanchaState.MOVENDO ||
                              estado == LanchaState.PATRULHANDO);

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
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
        estado_string = "parado";
        alvo_unidade = noone;
        speed = 0;
        is_moving = false;
        if (global.debug_enabled) show_debug_message("⏹️ Lancha PAROU");
    }
    
    // Comandos K, clique esquerdo e clique direito agora são gerenciados pelo obj_input_manager
    // para evitar conflitos e manter o modo de patrulha persistente (igual aos aviões)
}

// ======================================================================
// --- 1.5. LÓGICA DE MOVIMENTO COM FÍSICA DE INÉRCIA (NOVO SISTEMA) ---
// ======================================================================
// Sistema baseado em motion_add para simular drift na água (estilo Rusted Warfare)
// Este sistema funciona quando estado == LanchaState.MOVENDO
// Variável de controle para usar novo sistema ou sistema antigo
usar_novo_sistema = false;

if (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO) {
    // Verificar se novo sistema está ativo (target_x/target_y definidos e diferentes da posição atual)
    var _tem_target = (variable_instance_exists(id, "target_x") && variable_instance_exists(id, "target_y"));
    if (_tem_target) {
        var _dist_target = point_distance(x, y, target_x, target_y);
        usar_novo_sistema = (_dist_target > 0.1); // Se target está definido e diferente da posição atual
    }
    
    if (usar_novo_sistema) {
        // === NOVO SISTEMA: Física de inércia com motion_add ===
        // 1. Verificar se há um destino ativo e se não chegamos lá
        var dist = point_distance(x, y, target_x, target_y);
        
        // ✅ CORREÇÃO: Usar tolerância maior durante patrulha (igual ao case PATRULHANDO)
        var _tolerancia_chegada = (estado == LanchaState.PATRULHANDO) ? 20 : stop_distance;
        
        if (dist > _tolerancia_chegada) {
            is_moving = true;
            
            // 2. Calcular o ângulo desejado para o alvo
            var target_dir = point_direction(x, y, target_x, target_y);
            
            // 3. Rotação Suave (Smooth Turn)
            // angle_difference calcula o menor caminho para girar (esquerda ou direita)
            var diff = angle_difference(image_angle, target_dir);
            
            // Girar o sprite gradualmente baseado no turnSpeed
            image_angle -= clamp(diff, -turnSpeed, turnSpeed);
            
            // 4. Aceleração Vetorial
            // Só acelera se o barco estiver quase alinhado com o alvo (evita andar de lado estranho)
            if (abs(diff) < 60) {
                motion_add(image_angle, acceleration);
            }
            
        } else {
            is_moving = false;
            // Chegou ao destino - parar apenas se não estiver patrulhando
            speed = 0;
            if (estado != LanchaState.PATRULHANDO) {
                estado = LanchaState.PARADO;
                estado_string = "parado";
            }
            // Se estiver patrulhando, o case PATRULHANDO vai gerenciar o próximo ponto
        }
        
        // 5. Limite de Velocidade (Clamp)
        // Garante que a lancha não ultrapasse a velocidade máxima
        if (speed > moveSpeed) {
            speed = moveSpeed;
        }
        
        // 6. Aplicação de Atrito (Física da Água)
        // A lancha sempre perde um pouco de velocidade (arrasto da água)
        speed = max(0, speed - friction_water);
        
        // 7. Atualizar direção do movimento visual se tiver velocidade suficiente
        // Isso faz com que colisões ou empurrões atualizem a lógica
        if (speed > 0.1) {
            // Opcional: Se quiser que a direção interna do GM siga o sprite
            // direction = image_angle; 
        }
    }
    // Se não usar novo sistema, o sistema antigo será executado no switch abaixo
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
    // ✅ CORREÇÃO: Buscar piratas explicitamente (prioridade alta)
    var _alvo_pirata = noone;
    var _menor_dist_pirata = radar_alcance + 100;
    
    if (object_exists(obj_navio_pirata)) {
        with (obj_navio_pirata) {
            if (nacao_proprietaria == 3) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.radar_alcance && _dist < _menor_dist_pirata) {
                    _menor_dist_pirata = _dist;
                    _alvo_pirata = id;
                }
            }
        }
    }
    if (object_exists(obj_navio_pirata2)) {
        with (obj_navio_pirata2) {
            if (nacao_proprietaria == 3) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.radar_alcance && _dist < _menor_dist_pirata) {
                    _menor_dist_pirata = _dist;
                    _alvo_pirata = id;
                }
            }
        }
    }
    if (object_exists(obj_navio_pirata3)) {
        with (obj_navio_pirata3) {
            if (nacao_proprietaria == 3) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.radar_alcance && _dist < _menor_dist_pirata) {
                    _menor_dist_pirata = _dist;
                    _alvo_pirata = id;
                }
            }
        }
    }
    
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
    
    // ✅ Priorizar piratas se encontrados (prioridade MÁXIMA)
    if (instance_exists(_alvo_pirata) && point_distance(x, y, _alvo_pirata.x, _alvo_pirata.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_pirata;
        _tipo_alvo = "naval (Pirata)";
    } else if (instance_exists(_alvo_naval) && _alvo_naval != id && _alvo_naval.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_naval.x, _alvo_naval.y) <= radar_alcance) {
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

// --- 3. SINCRONIZAÇÃO (do Create event) ---
// Isso garante que as variáveis globais sejam atualizadas
if (variable_instance_exists(id, "func_sincronizar_timers")) {
    func_sincronizar_timers();
}
if (variable_instance_exists(id, "func_atualizar_modo_ataque")) {
    func_atualizar_modo_ataque();
}
if (variable_instance_exists(id, "func_sincronizar_estado")) {
    func_sincronizar_estado();
}
// --- FIM DA SINCRONIZAÇÃO ---

// Atualizar timer de recarga (se existir)
if (reload_timer > 0) {
    reload_timer--;
}

// --- 4. MÁQUINA DE ESTADOS PRINCIPAL ---
switch (estado) {
    // ==========================================================
    // ESTADO: PARADO
    // ==========================================================
    case LanchaState.PARADO:
        speed = 0;
        break;
    
    // ==========================================================
    // ESTADO: MOVENDO - NAVEGAÇÃO COM ROTAÇÃO MELHORADA (SISTEMA ANTIGO)
    // ==========================================================
    // NOTA: Se usar_novo_sistema == true, este bloco será pulado (já processado acima)
    case LanchaState.MOVENDO:
        // Se o novo sistema está ativo, pular este bloco
        if (usar_novo_sistema) {
            break;
        }
        // Verificar se destino é válido
        if (!variable_instance_exists(id, "destino_x") || !variable_instance_exists(id, "destino_y")) {
            estado = LanchaState.PARADO;
            estado_string = "parado";
            speed = 0;
            break;
        }
        
        var _dist = point_distance(x, y, destino_x, destino_y);
        var _dir_destino = point_direction(x, y, destino_x, destino_y);
        
        // ✅ DETECÇÃO DE "PRESA" - Verificar se está se aproximando do destino (menos agressivo)
        if (!variable_instance_exists(id, "distancia_anterior")) {
            distancia_anterior = _dist;
            timer_presa = 0;
        }
        
        // Se não está se aproximando significativamente (tolerância maior)
        if (_dist >= distancia_anterior - 3) { // ✅ AUMENTADO: Tolerância de 3 pixels
            timer_presa++;
        } else {
            // Está se aproximando - resetar timer
            timer_presa = 0;
        }
        
        distancia_anterior = _dist;
        
        // ✅ PRIORIDADE 1: Se chegou ao destino, PARAR
        if (_dist <= tolerancia_chegada) {
            estado = LanchaState.PARADO;
            estado_string = "parado";
            speed = 0;
            timer_presa = 0;
            // ✅ Se está muito perto (dentro da tolerância), mover para o destino exato
            if (_dist > 0) {
                x = destino_x;
                y = destino_y;
            }
            if (global.debug_enabled) show_debug_message("🚢 Lancha: Chegou ao destino! Distância: " + string(_dist));
        } else {
            // ✅ Se está presa há muito tempo E está muito perto, considerar chegada
            var _esta_presa = (timer_presa >= max_timer_presa);
            var _tolerancia_efetiva = _esta_presa ? tolerancia_chegada * 2.5 : tolerancia_chegada;
            
            if (_esta_presa && _dist <= _tolerancia_efetiva) {
                if (global.debug_enabled) show_debug_message("🚢 Lancha: Presa detectada! Considerando chegada. Dist: " + string(_dist));
                estado = LanchaState.PARADO;
                estado_string = "parado";
                speed = 0;
                timer_presa = 0;
                break;
            }
            // 1. ROTACIONAR em direção ao destino
            var _angulo_atual = image_angle;
            var _diff_angulo = angle_difference(_angulo_atual, _dir_destino);
            var _abs_diff = abs(_diff_angulo);
            
            // Rotacionar suavemente em direção ao destino
            if (_abs_diff > 2) {
                var _rotacao = min(velocidade_rotacao, _abs_diff);
                image_angle += sign(_diff_angulo) * -_rotacao;
                image_angle = (image_angle mod 360 + 360) mod 360;
            }
            
            // 2. MOVER - Sempre tentar chegar ao destino
            var _dir_movimento = _dir_destino; // Padrão: mover diretamente ao destino
            
            // ✅ Se está muito perto do destino (< 60 pixels), mover diretamente (ignorar rotação)
            if (_dist < 60) {
                _dir_movimento = _dir_destino; // Sempre direto ao destino quando perto
            } else if (!_esta_presa) {
                // Movimento natural apenas se não estiver presa E não estiver muito perto
                // Se está bem alinhado (diferença < 30°), mover na direção apontada
                if (_abs_diff < 30) {
                    _dir_movimento = image_angle;
                } else if (_abs_diff < 90) {
                    // Curva moderada - interpolar entre direção atual e destino
                    var _peso = _abs_diff / 90; // 0 a 1
                    // Interpolação manual de ângulos
                    var _diff = angle_difference(image_angle, _dir_destino);
                    _dir_movimento = image_angle + _diff * (_peso * 0.5);
                    _dir_movimento = (_dir_movimento mod 360 + 360) mod 360;
                }
                // Se diferença > 90°, mover diretamente ao destino para evitar órbitas
            }
            // Se está presa, sempre mover diretamente ao destino (já definido acima)
            
            _dir_movimento = (_dir_movimento mod 360 + 360) mod 360;
            
            // ✅ Se está muito perto do destino (< 80 pixels), mover diretamente ignorando colisões
            var _muito_perto = (_dist < 80);
            
            // Mover
            var _novo_x = x + lengthdir_x(velocidade, _dir_movimento);
            var _novo_y = y + lengthdir_y(velocidade, _dir_movimento);
            
            // ✅ Se está muito perto, mover diretamente ao destino (ignorar colisões)
            if (_muito_perto) {
                // Mover diretamente em direção ao destino
                var _dist_mov = min(velocidade, _dist); // Não ultrapassar o destino
                _novo_x = x + lengthdir_x(_dist_mov, _dir_destino);
                _novo_y = y + lengthdir_y(_dist_mov, _dir_destino);
                x = _novo_x;
                y = _novo_y;
            } else {
                // ✅ VERIFICAR COLISÃO COM EDIFÍCIOS ANTES DE MOVER (apenas se não estiver muito perto)
                var _colidiu = (position_meeting(_novo_x, _novo_y, obj_quartel_marinha) || 
                               position_meeting(_novo_x, _novo_y, obj_quartel) ||
                               position_meeting(_novo_x, _novo_y, obj_casa) ||
                               position_meeting(_novo_x, _novo_y, obj_banco));
                
                if (_colidiu && !_esta_presa) {
                    // Tentar se mover perpendicularmente para contornar (apenas se não estiver presa)
                    var _dir_contorno = _dir_destino + 90;
                    _novo_x = x + lengthdir_x(velocidade * 0.7, _dir_contorno);
                    _novo_y = y + lengthdir_y(velocidade * 0.7, _dir_contorno);
                    
                    // Se ainda colidir, tentar do outro lado
                    if (position_meeting(_novo_x, _novo_y, obj_quartel_marinha) || 
                        position_meeting(_novo_x, _novo_y, obj_quartel)) {
                        _dir_contorno = _dir_destino - 90;
                        _novo_x = x + lengthdir_x(velocidade * 0.7, _dir_contorno);
                        _novo_y = y + lengthdir_y(velocidade * 0.7, _dir_contorno);
                    }
                }
                
                // Se ainda colidir mas está presa, mover mesmo assim (forçar passagem)
                // Isso evita que fique completamente travada
                if (!_colidiu || _esta_presa || !position_meeting(_novo_x, _novo_y, obj_quartel_marinha)) {
                    x = _novo_x;
                    y = _novo_y;
                }
            }
            
            speed = velocidade;
        }
        break;
    
    // ==========================================================
    // ESTADO: ATACANDO
    // ==========================================================
    case LanchaState.ATACANDO:
        speed = 0;
        
        // ✅ NOVO: Validação completa do alvo antes de processar
        var _alvo_valido = (instance_exists(alvo_unidade) && 
                           alvo_unidade != noone && 
                           !is_undefined(alvo_unidade.x) && 
                           !is_undefined(alvo_unidade.y) &&
                           alvo_unidade.x >= 0 && alvo_unidade.y >= 0);
        
        if (_alvo_valido) {
            var _distancia_alvo = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
            
            // Sistema de tiro à distância
            if (_distancia_alvo <= missil_alcance && reload_timer <= 0) {
                // ✅ NOVO: Verificar novamente se alvo ainda é válido antes de disparar
                if (instance_exists(alvo_unidade) && !is_undefined(alvo_unidade.x) && !is_undefined(alvo_unidade.y)) {
                    var _missil = scr_get_projectile_from_pool(obj_tiro_simples, x, y, "Instances");
                    if (instance_exists(_missil)) {
                        // ✅ NOVO: Verificar se alvo ainda existe antes de atribuir
                        if (instance_exists(alvo_unidade) && !is_undefined(alvo_unidade.x) && !is_undefined(alvo_unidade.y)) {
                            _missil.alvo = alvo_unidade;
                            _missil.dono = id;
                            _missil.dano = 35; // Dano ajustado
                            
                            // ✅ CORREÇÃO: Reduzir velocidade para alvos terrestres (mais preciso)
                            var _alvo_aereo = (alvo_unidade.object_index == obj_helicoptero_militar || 
                                              alvo_unidade.object_index == obj_caca_f5 || 
                                              alvo_unidade.object_index == obj_f6 ||
                                              alvo_unidade.object_index == obj_f15 ||
                                              alvo_unidade.object_index == obj_c100);
                            
                            if (_alvo_aereo) {
                                _missil.speed = 8; // Velocidade normal para alvos aéreos
                            } else {
                                _missil.speed = 4; // ✅ REDUZIDO: Velocidade menor para alvos terrestres (mais preciso)
                            }
                            
                            // ✅ CORREÇÃO CRÍTICA: Calcular direção apenas se alvo é válido
                            var _dir_alvo = point_direction(x, y, alvo_unidade.x, alvo_unidade.y);
                            if (!is_undefined(_dir_alvo) && !is_nan(_dir_alvo)) {
                                _missil.direction = _dir_alvo;
                                _missil.image_angle = _dir_alvo;
                            } else {
                                // Direção inválida - destruir míssil
                                scr_return_projectile_to_pool(_missil);
                                if (global.debug_enabled) show_debug_message("❌ Lancha: Direção inválida para alvo, míssil cancelado");
                            }
                            
                            if (variable_instance_exists(_missil, "timer_vida")) {
                                _missil.timer_vida = 300;
                            }
                            reload_timer = reload_time;
                            if (global.debug_enabled) show_debug_message("🚀 Lancha atirou à distância (" + string(round(_distancia_alvo)) + "px) em direção " + string(round(_dir_alvo)) + "°");
                        } else {
                            // Alvo desapareceu - destruir míssil
                            scr_return_projectile_to_pool(_missil);
                        }
                    }
                }
            }
        } else {
            if (global.debug_enabled) show_debug_message("✅ Alvo destruído ou inválido! Retornando para: " + string(estado_anterior));
            estado = estado_anterior;
            alvo_unidade = noone;
        }
        break;
    
    // ==========================================================
    // ESTADO: PATRULHANDO
    // ==========================================================
    case LanchaState.PATRULHANDO:
        // Sistema de patrulha igual aos outros navios/aviões
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
            // Garantir que indice_patrulha_atual está dentro dos limites
            if (!variable_instance_exists(id, "indice_patrulha_atual")) {
                indice_patrulha_atual = 0;
            }
            var _total_pontos = ds_list_size(pontos_patrulha);
            if (indice_patrulha_atual >= _total_pontos) {
                indice_patrulha_atual = 0;
            }
            
            // ✅ CORREÇÃO: Verificar se chegou ao ponto atual ANTES de definir novo destino
            var _dist_ponto_atual = point_distance(x, y, destino_x, destino_y);
            var _tolerancia_patrulha = 20; // Tolerância maior para patrulha (igual aos outros navios)
            
            if (_dist_ponto_atual <= _tolerancia_patrulha) {
                // Chegou ao ponto - ir para o próximo
                indice_patrulha_atual = (indice_patrulha_atual + 1) % _total_pontos;
                if (global.debug_enabled) {
                    show_debug_message("🚢 Lancha: Chegou ao ponto, indo para o próximo (" + string(indice_patrulha_atual + 1) + " de " + string(_total_pontos) + ")");
                }
            }
            
            // Obter ponto atual de patrulha (pode ter mudado se avançou)
            var _ponto_atual = pontos_patrulha[| indice_patrulha_atual];
            if (is_array(_ponto_atual) && array_length(_ponto_atual) >= 2) {
                // Definir destino para o ponto atual
                destino_x = _ponto_atual[0];
                destino_y = _ponto_atual[1];
                target_x = _ponto_atual[0];
                target_y = _ponto_atual[1];
                is_moving = true;
                usar_novo_sistema = true; // Usar novo sistema de física
            } else {
                // Ponto inválido - parar
                estado = LanchaState.PARADO;
                estado_string = "parado";
                is_moving = false;
                speed = 0;
            }
        } else {
            // Sem pontos de patrulha - voltar para parado
            estado = LanchaState.PARADO;
            estado_string = "parado";
            is_moving = false;
            speed = 0;
        }
        break;

}

// --- 5. EFEITO DE ESPUMA DO MAR (Rastro de água) ---
// Criar espuma quando estiver se movendo (igual aos outros navios)
if (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO) {
    if (!variable_instance_exists(id, "timer_espuma")) {
        timer_espuma = 0;
    }
    timer_espuma++;
    
    if (timer_espuma >= 3) { // Cria espuma a cada 3 frames
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
                _espuma.image_angle = image_angle; // ✅ Rastro sempre virado para a proa
            }
        }
        
        // obj_WbTrail1 no FINAL do navio (popa) - Lancha: menor que navios grandes
        if (object_exists(obj_WbTrail1)) {
            var _distancia_final = 15; // Lancha é menor, usar distância menor
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
                _trail_popa.image_xscale = 2.0 * 0.6; // Menor que navios grandes (lancha é menor)
                _trail_popa.image_yscale = 2.0 * 0.6;
                _trail_popa.image_alpha = 0.2;
                _trail_popa.image_blend = c_white;
                _trail_popa.visible = true;
                if (variable_instance_exists(id, "depth")) {
                    _trail_popa.depth = depth + 1;
                } else {
                    _trail_popa.depth = -100;
                }
                _trail_popa.image_angle = image_angle; // ✅ Rastro sempre virado para a proa
            }
        }
    }
} else {
    // Parado - resetar timer de espuma
    if (variable_instance_exists(id, "timer_espuma")) {
        timer_espuma = 0;
    }
}
