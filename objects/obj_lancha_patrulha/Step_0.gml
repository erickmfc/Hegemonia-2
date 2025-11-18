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
        // ✅ CORREÇÃO: Se há um path A* ativo, não processar movimento manual (o GameMaker cuida disso)
        if (path_index != noone) {
            // Path A* está ativo - apenas verificar se chegou ao destino
            if (path_position >= 1.0) {
                path_end();
                estado = LanchaState.PARADO;
                estado_string = "parado";
                if (variable_instance_exists(id, "meu_caminho") && meu_caminho != noone) {
                    path_delete(meu_caminho);
                    meu_caminho = noone;
                }
            }
            exit; // Sair - o GameMaker processa o path automaticamente
        }
        
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

// --- 3. SINCRONIZAÇÃO (do Create event) ---
// Isso garante que as variáveis globais sejam atualizadas
if (variable_instance_exists(id, "func_sincronizar_timers")) {
    func_sincronizar_timers();
}
if (variable_instance_exists(id, "func_atualizar_modo_ataque")) {
    func_atualizar_modo_ataque();
}
if (variable_instance_exists(id, "func_sincronizar_destino")) {
    func_sincronizar_destino();
}
if (variable_instance_exists(id, "func_sincronizar_estado")) {
    func_sincronizar_estado();
}
if (variable_instance_exists(id, "func_sincronizar_indice")) {
    func_sincronizar_indice();
}
// --- FIM DA SINCRONIZAÇÃO ---

// Atualizar timer de recarga (se existir)
if (reload_timer > 0) {
    reload_timer--;
}

// --- 4. MÁQUINA DE ESTADOS PRINCIPAL ---
switch (estado) {
    // ==========================================================
    // ESTADO: MOVENDO
    // ==========================================================
    case LanchaState.MOVENDO:
        // 1. O navio TEM um caminho para seguir?
        if (path_index != noone) {
            // 2. O navio CHEGOU ao fim do caminho?
            // ✅ CORREÇÃO: Verificar também se está muito próximo do destino final (tolerância)
            var _chegou_ao_destino = false;
            if (path_position >= 1.0) {
                _chegou_ao_destino = true;
            } else if (variable_instance_exists(id, "destino_final_x") && variable_instance_exists(id, "destino_final_y")) {
                // Verificar se está muito próximo do destino final (tolerância de 20 pixels)
                var _dist_final = point_distance(x, y, destino_final_x, destino_final_y);
                if (_dist_final <= 20) {
                    _chegou_ao_destino = true;
                }
            }
            
            if (_chegou_ao_destino) {
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🚢 " + nome_unidade + " - Chegou ao destino A*. Parando completamente.");
                }
                
                // ✅ CORREÇÃO CRÍTICA: PARAR COMPLETAMENTE quando chegar ao destino
                // 1. Parar o path PRIMEIRO (múltiplas vezes para garantir)
                if (path_index != noone) {
                    path_end();
                }
                path_end(); // Garantir que parou
                
                // 2. Limpar variáveis de movimento e path
                speed = 0;
                if (variable_instance_exists(id, "meu_caminho") && meu_caminho != noone) {
                    path_delete(meu_caminho);
                    meu_caminho = noone;
                }
                
                // 3. Garantir que path_index está limpo
                if (path_index != noone) {
                    path_end();
                }
                
                // 4. Limpar variáveis de destino para evitar recálculo
                if (variable_instance_exists(id, "destino_final_x")) {
                    destino_final_x = x; // Definir como posição atual
                }
                if (variable_instance_exists(id, "destino_final_y")) {
                    destino_final_y = y; // Definir como posição atual
                }
                
                // 5. Mudar para PARADO ANTES de qualquer outra coisa
                estado = LanchaState.PARADO;
                if (variable_instance_exists(id, "estado_string")) {
                    estado_string = "parado";
                }
                
                // 6. ✅ CRÍTICO: Sair do bloco para não executar código de rotação
                break; // Sair do case MOVENDO imediatamente
            } else {
                // --- CORREÇÃO DA ROTAÇÃO (Anti-Spin/Vibração + Anti-Deslizamento) ---
                // 3. Se ainda estamos nos movendo (velocidade > 0) E path está ativo
                if (path_index != noone && variable_instance_exists(id, "meu_caminho") && meu_caminho != noone) {
                    // 4. Calcular direção usando posição atual e próxima do path
                    // ✅ CORREÇÃO: Calcular manualmente para evitar erro com path_direction
                    var _dir_caminho = 0; // ✅ CORREÇÃO: Declarar antes do bloco if
                    var _pos_atual = path_position;
                    var _pos_proxima = min(_pos_atual + 0.1, 1.0);
                    var _x_atual = x;
                    var _y_atual = y;
                    var _x_proxima = path_get_x(meu_caminho, _pos_proxima);
                    var _y_proxima = path_get_y(meu_caminho, _pos_proxima);
                    
                    // Verificar se as coordenadas são válidas
                    if (!is_undefined(_x_proxima) && !is_undefined(_y_proxima)) {
                        _dir_caminho = point_direction(_x_atual, _y_atual, _x_proxima, _y_proxima);
                        
                        // 5. ROTAÇÃO SUAVE (Com velocidade limitada para curvas realistas)
                        // Calcular diferença de ângulo
                        var _diff_angulo = angle_difference(image_angle, _dir_caminho);
                        var _abs_diff = abs(_diff_angulo);
                        
                        // ✅ NOVO: ANTI-DESLIZAMENTO - Se diferença > 120°, parar e girar primeiro
                        if (_abs_diff > 120) {
                            // Curva muito grande (>120°) - PARAR movimento e girar primeiro
                            if (path_speed > 0) {
                                // Parar o path temporariamente
                                var _velocidade_original = path_speed;
                                path_end();
                                // Reiniciar com velocidade 0 para parar
                                path_start(meu_caminho, 0, path_action_stop, false);
                                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                                    show_debug_message("🔄 NAVIO: Parando para girar (diferença: " + string(round(_abs_diff)) + "°)");
                                }
                            }
                        } else if (_abs_diff > 30) {
                            // Curva grande (30-120°) - Reduzir velocidade enquanto gira
                            if (path_speed > 0) {
                                var _velocidade_reduzida = path_speed * 0.3; // Reduzir para 30% da velocidade
                                path_end();
                                path_start(meu_caminho, _velocidade_reduzida, path_action_stop, false);
                            }
                        } else {
                            // Curva pequena (<30°) - Velocidade normal
                            if (path_speed == 0) {
                                // Se estava parado, retomar movimento normal
                                var _velocidade = velocidade_movimento;
                                if (variable_instance_exists(id, "velocidade_max")) {
                                    _velocidade = velocidade_max;
                                }
                                path_end();
                                path_start(meu_caminho, _velocidade, path_action_stop, false);
                            }
                        }
                        
                        // Obter velocidade de rotação (padrão se não existir)
                        var _vel_rot = 0.8; // Velocidade padrão
                        if (variable_instance_exists(id, "velocidade_rotacao")) {
                            _vel_rot = velocidade_rotacao;
                        }
                        
                        // Aplicar rotação suave limitada
                        // Se a diferença for muito grande (> 90°), reduzir velocidade para curva mais realista
                        if (_abs_diff > 90) {
                            // Curva muito grande - reduzir velocidade de rotação para curva mais realista
                            _vel_rot *= 0.5; // Reduzir pela metade para curvas grandes
                        } else if (_abs_diff > 45) {
                            // Curva moderada - reduzir um pouco
                            _vel_rot *= 0.75;
                        }
                        
                        // Aplicar rotação suave
                        if (abs(_diff_angulo) > 0.5) { // Só rotacionar se diferença for significativa
                            var _rotacao_aplicar = min(_vel_rot, abs(_diff_angulo));
                            image_angle += sign(_diff_angulo) * -_rotacao_aplicar;
                            
                            // Normalizar ângulo para 0-360
                            image_angle = (image_angle mod 360 + 360) mod 360;
                        }
                    }
                }
            }
        } else {
            // Se estamos em "MOVENDO" mas não temos caminho, algo deu errado. Parar.
            estado = LanchaState.PARADO;
            if (variable_instance_exists(id, "estado_string")) {
                estado_string = "parado";
            }
            speed = 0;
        }
        break;
    
    // ==========================================================
    // ESTADO: PARADO
    // ==========================================================
    case LanchaState.PARADO:
        speed = 0;
        // ✅ CORREÇÃO: Garantir que não há path ativo
        if (path_index != noone) {
            path_end();
        }
        // ✅ CORREÇÃO: Não aplicar rotação quando parado
        // A lógica de procurar inimigos está na seção 2 (Lógica de Aquisição de Alvo)
        break;
    
    // ==========================================================
    // ESTADO: ATACANDO
    // ==========================================================
    case LanchaState.ATACANDO:
        speed = 0;
        
        if (instance_exists(alvo_unidade)) {
            var _distancia_alvo = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
            
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

    // ==========================================================
    // ESTADO: PATRULHANDO
    // ==========================================================
    case LanchaState.PATRULHANDO:
        // A lógica de patrulha agora é 100% controlada pelo A*
        
        if (path_index != noone) {
            // Chegamos ao ponto de patrulha?
            if (path_position >= 1.0) {
                // ✅ NOVO: Parar o movimento atual primeiro
                path_end();
                speed = 0;
                
                // Pegar o próximo ponto de patrulha
                if (variable_instance_exists(id, "func_proximo_ponto")) {
                    func_proximo_ponto();
                }
                
                // Pedir um novo caminho A* para o próximo ponto
                if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                    if (variable_instance_exists(id, "indice_patrulha_atual")) {
                        var _p = pontos_patrulha[| indice_patrulha_atual];
                        
                        // ✅ NOVO: Calcular direção para o próximo ponto
                        var _dir_proximo = point_direction(x, y, _p[0], _p[1]);
                        var _diff_angulo = angle_difference(image_angle, _dir_proximo);
                        var _abs_diff = abs(_diff_angulo);
                        
                        // ✅ NOVO: Se diferença > 30°, girar primeiro antes de iniciar movimento
                        if (_abs_diff > 30) {
                            // Ainda precisa girar - não iniciar movimento ainda
                            // Aplicar rotação suave
                            var _vel_rot = 0.8;
                            if (variable_instance_exists(id, "velocidade_rotacao")) {
                                _vel_rot = velocidade_rotacao;
                            }
                            
                            // Reduzir velocidade de rotação para curvas grandes
                            if (_abs_diff > 90) {
                                _vel_rot *= 0.5;
                            } else if (_abs_diff > 45) {
                                _vel_rot *= 0.75;
                            }
                            
                            // Aplicar rotação
                            if (abs(_diff_angulo) > 0.5) {
                                var _rotacao_aplicar = min(_vel_rot, abs(_diff_angulo));
                                image_angle += sign(_diff_angulo) * -_rotacao_aplicar;
                                image_angle = (image_angle mod 360 + 360) mod 360;
                            }
                            
                            // Ainda girando - não iniciar caminho ainda
                        } else {
                            // ✅ Alinhado (<30°) - pode iniciar movimento
                            var _novo_caminho = scr_encontrar_caminho_naval(x, y, _p[0], _p[1], id);
                            
                            if (_novo_caminho != noone) {
                                var _velocidade = velocidade_movimento;
                                if (variable_instance_exists(id, "velocidade_max")) {
                                    _velocidade = velocidade_max;
                                }
                                path_start(_novo_caminho, _velocidade, path_action_stop, false);
                                meu_caminho = _novo_caminho; // Guarda o novo caminho
                            } else {
                                // Não achou caminho? Parar.
                                estado = LanchaState.PARADO;
                                if (variable_instance_exists(id, "estado_string")) {
                                    estado_string = "parado";
                                }
                            }
                        }
                    }
                }
            } else {
                // Girar enquanto patrulha (mesma lógica do MOVENDO com anti-deslizamento)
                if (path_index != noone && variable_instance_exists(id, "meu_caminho") && meu_caminho != noone) {
                    // ✅ CORREÇÃO: Calcular direção manualmente usando posição atual e próxima do path
                    var _pos_atual = path_position;
                    var _pos_proxima = min(_pos_atual + 0.1, 1.0);
                    var _x_atual = x;
                    var _y_atual = y;
                    var _x_proxima = path_get_x(meu_caminho, _pos_proxima);
                    var _y_proxima = path_get_y(meu_caminho, _pos_proxima);
                    
                    // Verificar se as coordenadas são válidas
                    if (!is_undefined(_x_proxima) && !is_undefined(_y_proxima)) {
                        var _dir_caminho = point_direction(_x_atual, _y_atual, _x_proxima, _y_proxima);
                        
                        // ROTAÇÃO SUAVE (mesma lógica do MOVENDO)
                        var _diff_angulo = angle_difference(image_angle, _dir_caminho);
                        var _abs_diff = abs(_diff_angulo);
                        
                        // ✅ NOVO: ANTI-DESLIZAMENTO - Se diferença > 120°, parar e girar primeiro
                        if (_abs_diff > 120) {
                            // Curva muito grande (>120°) - PARAR movimento e girar primeiro
                            if (path_speed > 0) {
                                var _velocidade_original = path_speed;
                                path_end();
                                path_start(meu_caminho, 0, path_action_stop, false);
                            }
                        } else if (_abs_diff > 30) {
                            // Curva grande (30-120°) - Reduzir velocidade enquanto gira
                            if (path_speed > 0) {
                                var _velocidade_reduzida = path_speed * 0.3;
                                path_end();
                                path_start(meu_caminho, _velocidade_reduzida, path_action_stop, false);
                            }
                        } else {
                            // Curva pequena (<30°) - Velocidade normal
                            if (path_speed == 0) {
                                var _velocidade = velocidade_movimento;
                                if (variable_instance_exists(id, "velocidade_max")) {
                                    _velocidade = velocidade_max;
                                }
                                path_end();
                                path_start(meu_caminho, _velocidade, path_action_stop, false);
                            }
                        }
                        
                        var _vel_rot = 0.8;
                        if (variable_instance_exists(id, "velocidade_rotacao")) {
                            _vel_rot = velocidade_rotacao;
                        }
                        
                        if (_abs_diff > 90) {
                            _vel_rot *= 0.5;
                        } else if (_abs_diff > 45) {
                            _vel_rot *= 0.75;
                        }
                        
                        if (abs(_diff_angulo) > 0.5) {
                            var _rotacao_aplicar = min(_vel_rot, abs(_diff_angulo));
                            image_angle += sign(_diff_angulo) * -_rotacao_aplicar;
                            image_angle = (image_angle mod 360 + 360) mod 360;
                        }
                    }
                }
            }
        }
        break;
}

// --- 5. EFEITO DE ESPUMA DO MAR (Rastro de água) ---
// Criar espuma quando estiver se movendo
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
                _espuma.image_angle = image_angle + random_range(-5, 5);
            }
        }
        
        // obj_WbTrail1 no FINAL do navio (popa)
        if (object_exists(obj_WbTrail1)) {
            var _distancia_final = 35;
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
                _trail_popa.image_xscale = 3.0 * 0.8;
                _trail_popa.image_yscale = 3.0 * 0.8;
                _trail_popa.image_alpha = 0.2;
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
} else {
    // Parado - resetar timer de espuma
    if (variable_instance_exists(id, "timer_espuma")) {
        timer_espuma = 0;
    }
}

// =============================================
// ✅ SISTEMA DE COLISÃO FÍSICA NAVAL
// =============================================
// Verificar colisões apenas a cada 5 frames para melhorar performance
// ✅ CORREÇÃO: Verificar se a função existe antes de chamar para evitar erro
if (variable_global_exists("game_frame") && global.game_frame % 5 == 0) {
    var _script_index = asset_get_index("scr_colisao_fisica_unidades");
    if (_script_index != -1 && asset_get_type(_script_index) == asset_script) {
        scr_colisao_fisica_unidades(id, 48, 1.0); // Raio ajustado para lanchas
    }
}