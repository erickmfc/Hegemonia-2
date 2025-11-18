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
                       
                       // ✅ CORREÇÃO: Usar pool para mísseis que suportam pool
                       var _missil = noone;
                       if (_missil_obj == obj_SkyFury_ar || _missil_obj == obj_Ironclad_terra || _missil_obj == obj_tiro_simples) {
                           // Mísseis que suportam pool
                           _missil = scr_get_projectile_from_pool(_missil_obj, x, y, "Instances");
                       } else {
                           // Mísseis que não suportam pool (ex: obj_missel_ice)
                           _missil = instance_create_layer(x, y, "Instances", _missil_obj);
                       }
                       
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
        // A lógica de ataque está na seção 2 (Lógica de Aquisição de Alvo)
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
// Criar espuma quando estiver se movendo E não estiver submerso
if ((estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO) && (!variable_instance_exists(id, "submerso") || !submerso)) {
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
    // Parado ou submerso - resetar timer de espuma
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
        scr_colisao_fisica_unidades(id, 50, 1.2); // Raio maior para submarinos
    }
    // Se a função não existir, simplesmente não fazer nada (não causar erro)
}
