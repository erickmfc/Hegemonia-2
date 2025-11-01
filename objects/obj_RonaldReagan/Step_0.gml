/// @description Step 0 - Lógica de Embarque/Desembarque
// ===============================================
// HEGEMONIA GLOBAL - RONALD REAGAN (PORTA-AVIÕES)
// Step Event - Sistema de Transporte + Herança
// ===============================================

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == LanchaState.ATACANDO || 
                              estado_transporte == NavioTransporteEstado.EMBARQUE_ATIVO ||
                              estado_transporte == NavioTransporteEstado.DESEMBARCANDO);

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == LanchaState.MOVENDO) {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && estado == LanchaState.MOVENDO) {
                    estado = LanchaState.PARADO;
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}

// Chamar Step do pai PRIMEIRO para garantir que todas as variáveis existam
// ✅ CORREÇÃO GM2040: Verificar se o objeto tem parent antes de chamar event_inherited
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === 1. PROCESSAR COMANDOS DO JOGADOR (SE SELECIONADO) ===
if (variable_instance_exists(id, "selecionado") && selecionado) {
    // COMANDO P - EMBARQUE/DESEMBARQUE
    if (keyboard_check_pressed(ord("P"))) {
        if (estado_transporte == NavioTransporteEstado.PARADO || 
            estado_transporte == NavioTransporteEstado.NAVEGANDO) {
            
            if (!modo_embarque) {
                modo_embarque = true;
                estado_transporte = NavioTransporteEstado.EMBARQUE_ATIVO;
                estado_embarque = "embarcando";
                show_debug_message("🚚 RONALD REAGAN - MODO EMBARQUE ATIVO");
            } else {
                estado_transporte = NavioTransporteEstado.DESEMBARCANDO;
                modo_embarque = false;
                desembarque_ativo = true;
                show_debug_message("📦 RONALD REAGAN - MODO DESEMBARQUE");
            }
        }
    }
    
    // COMANDO J - MENU DE CARGA
    if (keyboard_check_pressed(ord("J"))) {
        menu_carga_aberto = !menu_carga_aberto;
        if (menu_carga_aberto) {
            show_debug_message("📋 Menu de Carga aberto");
        } else {
            show_debug_message("✅ Menu de Carga fechado");
        }
    }
}

// === 2. SISTEMA DE EMBARQUE AUTOMÁTICO ===
if (estado_transporte == NavioTransporteEstado.EMBARQUE_ATIVO && modo_embarque) {
    var _espaco_total = avioes_max + unidades_max + soldados_max;
    var _carregamento_total = avioes_count + unidades_count + soldados_count;
    
    if (_carregamento_total >= _espaco_total) {
        modo_embarque = false;
        estado_transporte = NavioTransporteEstado.EMBARQUE_OFF;
        show_debug_message("✅ RONALD REAGAN CHEIO - Embarque desativado");
    } else {
        // ✅ SISTEMA UNIFICADO: Detectar TODAS as unidades e embarcar automaticamente
        var _unidades_detectadas = ds_list_create();
        
        // Coletar TODAS as unidades próximas (qualquer tipo que funciona com o porta-aviões)
        with (obj_infantaria) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        with (obj_soldado_antiaereo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        with (obj_tanque) {
            show_debug_message("--- [RONALD] Verificando Tanque ID: " + string(id) + " ---");
            
            var cond1_nacao_existe = variable_instance_exists(id, "nacao_proprietaria");
            var cond2_nacao_ok = false;
            var tanque_nacao_str = "N/A"; // Valor padrão caso a variável não exista
            
            // ✅ CORREÇÃO: Só lê 'nacao_proprietaria' DEPOIS de confirmar que existe
            if (cond1_nacao_existe) {
                cond2_nacao_ok = (nacao_proprietaria == other.nacao_proprietaria);
                tanque_nacao_str = string(nacao_proprietaria); // Lê o valor de forma segura aqui
            }
            
            var dist = point_distance(other.x, other.y, x, y);
            var raio = other.raio_embarque;
            var cond3_distancia_ok = (dist < raio);
            var cond4_visivel_ok = visible;
            
            // <<< DEBUG: Mostrar o status de cada condição >>>
            show_debug_message("  Condição 1 (Nação Existe): " + string(cond1_nacao_existe));
            show_debug_message("  Condição 2 (Nação OK): " + string(cond2_nacao_ok) + " (Tanque: " + tanque_nacao_str + " | Navio: " + string(other.nacao_proprietaria) + ")");
            show_debug_message("  Condição 3 (Distância OK): " + string(cond3_distancia_ok) + " (Dist: " + string(dist) + " < Raio: " + string(raio) + ")");
            show_debug_message("  Condição 4 (Visível OK): " + string(cond4_visivel_ok));
            
            // Bloco original, mas agora sabemos por que falha se não entrar
            if (cond1_nacao_existe && cond2_nacao_ok && cond3_distancia_ok && cond4_visivel_ok) {
                ds_list_add(_unidades_detectadas, id);
                show_debug_message("  >>> SUCESSO: Tanque adicionado à lista!");
            } else {
                show_debug_message("  >>> FALHA: Tanque não atende a todas as condições.");
            }
            show_debug_message("------------------------------------");
        }
        
        with (obj_blindado_antiaereo) {
            show_debug_message("--- [RONALD] Verificando Blindado ID: " + string(id) + " ---");
            
            var cond1_nacao_existe = variable_instance_exists(id, "nacao_proprietaria");
            var cond2_nacao_ok = false;
            var blindado_nacao_str = "N/A"; // Valor padrão caso a variável não exista
            
            // ✅ CORREÇÃO: Só lê 'nacao_proprietaria' DEPOIS de confirmar que existe
            if (cond1_nacao_existe) {
                cond2_nacao_ok = (nacao_proprietaria == other.nacao_proprietaria);
                blindado_nacao_str = string(nacao_proprietaria); // Lê o valor de forma segura aqui
            }
            
            var dist = point_distance(other.x, other.y, x, y);
            var raio = other.raio_embarque;
            var cond3_distancia_ok = (dist < raio);
            var cond4_visivel_ok = visible;
            
            // <<< DEBUG: Mostrar o status de cada condição >>>
            show_debug_message("  Condição 1 (Nação Existe): " + string(cond1_nacao_existe));
            show_debug_message("  Condição 2 (Nação OK): " + string(cond2_nacao_ok) + " (Blindado: " + blindado_nacao_str + " | Navio: " + string(other.nacao_proprietaria) + ")");
            show_debug_message("  Condição 3 (Distância OK): " + string(cond3_distancia_ok) + " (Dist: " + string(dist) + " < Raio: " + string(raio) + ")");
            show_debug_message("  Condição 4 (Visível OK): " + string(cond4_visivel_ok));
            
            // Bloco original, mas agora sabemos por que falha se não entrar
            if (cond1_nacao_existe && cond2_nacao_ok && cond3_distancia_ok && cond4_visivel_ok) {
                ds_list_add(_unidades_detectadas, id);
                show_debug_message("  >>> SUCESSO: Blindado adicionado à lista!");
            } else {
                show_debug_message("  >>> FALHA: Blindado não atende a todas as condições.");
            }
            show_debug_message("------------------------------------");
        }
        
        with (obj_caca_f5) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        with (obj_f15) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        with (obj_helicoptero_militar) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        with (obj_c100) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        // Embarcar todas as unidades detectadas usando a função unificada
        for (var i = 0; i < ds_list_size(_unidades_detectadas); i++) {
            var _unidade = _unidades_detectadas[| i];
            embarcar_unidade(_unidade);
        }
        
        ds_list_destroy(_unidades_detectadas);
    }
}

// === 3. SISTEMA DE DESEMBARQUE ===
if (estado_transporte == NavioTransporteEstado.DESEMBARCANDO) {
    desembarque_timer++;
    
    if (desembarque_timer >= desembarque_intervalo) {
        desembarque_timer = 0;
        
        if (soldados_count > 0) {
            funcao_desembarcar_soldado();
        } else if (unidades_count > 0) {
            funcao_desembarcar_veiculo();
        } else if (avioes_count > 0) {
            funcao_desembarcar_aeronave();
        } else {
            estado_transporte = NavioTransporteEstado.PARADO;
            desembarque_ativo = false;
            show_debug_message("✅ Desembarque completo!");
        }
    }
}

// === 4. ATUALIZAR ESTADO TRANSPORTE DURANTE MOVIMENTO ===
if (variable_instance_exists(id, "estado") && 
    (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO)) {
    if (estado_transporte != NavioTransporteEstado.EMBARQUE_ATIVO && 
        estado_transporte != NavioTransporteEstado.DESEMBARCANDO) {
        estado_transporte = NavioTransporteEstado.NAVEGANDO;
    }
}

