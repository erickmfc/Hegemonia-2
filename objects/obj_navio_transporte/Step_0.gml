/// @description Lógica principal do Navio Transporte

// === HERANÇA DO PAI PRIMEIRO (OBRIGATÓRIO) ===
event_inherited();

// === 1. PROCESSAR COMANDOS DO JOGADOR (SE SELECIONADO) ===
if (variable_instance_exists(id, "selecionado") && selecionado) {
    
    // === COMANDO J - MENU DE CARGA ===
    if (keyboard_check_pressed(ord("J"))) {
        menu_carga_aberto = !menu_carga_aberto;
        if (menu_carga_aberto) {
            show_debug_message("📋 MENU DE CARGA ABERTO");
        } else {
            show_debug_message("✅ MENU DE CARGA FECHADO");
        }
    }
    
    // COMANDO P - TOGGLE EMBARQUE/DESEMBARQUE
    if (keyboard_check_pressed(ord("P"))) { 
        var _total_embarcado = soldados_count + unidades_count + avioes_count;
        
        if (_total_embarcado > 0) {
            // Se tem unidades embarcadas, desembarcar
            estado_transporte = NavioTransporteEstado.DESEMBARCANDO;
            modo_embarque = false;
            desembarque_timer = desembarque_intervalo;  // Começar imediatamente
            show_debug_message("📦 MODO DESEMBARQUE - " + string(_total_embarcado) + " unidades");
        } else {
            // Se está vazio, embarcar
            modo_embarque = true;
            estado_transporte = NavioTransporteEstado.EMBARQUE_ATIVO;
            show_debug_message("🚚 MODO EMBARQUE ATIVO - Aguardando unidades próximas");
        }
    }
    
    // COMANDO L - PARAR
    if (keyboard_check_pressed(ord("L"))) {
        if (variable_instance_exists(id, "estado")) estado = LanchaState.PARADO;
        if (variable_instance_exists(id, "estado_transporte")) estado_transporte = NavioTransporteEstado.PARADO;
        modo_embarque = false;
        menu_carga_aberto = false;
        alvo_unidade = noone;
        show_debug_message("⏹️ Navio parado - Todos os comandos cancelados");
    }
    
    // COMANDO K - PATRULHA
    if (keyboard_check_pressed(ord("K"))) {
        if (variable_instance_exists(id, "pontos_patrulha") && ds_list_size(pontos_patrulha) == 0) {
            show_debug_message("🔄 Modo Patrulha - Clique para adicionar pontos");
            if (variable_instance_exists(id, "estado")) estado = LanchaState.DEFININDO_PATRULHA;
        } else {
            show_debug_message("✅ Rota de patrulha definida");
            if (variable_instance_exists(id, "func_iniciar_patrulha")) func_iniciar_patrulha();
        }
    }
    
    // COMANDO O - TOGGLE ATAQUE/PASSIVO
    if (keyboard_check_pressed(ord("O"))) {
        if (variable_instance_exists(id, "modo_combate")) {
            if (modo_combate == LanchaMode.PASSIVO) {
                modo_combate = LanchaMode.ATAQUE;
                show_debug_message("⚔️ Modo ATAQUE ativado");
        } else {
                modo_combate = LanchaMode.PASSIVO;
                show_debug_message("🛡️ Modo PASSIVO ativado");
            }
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
        show_debug_message("✅ Navio CHEIO - Embarque desativado");
                   } else {
        // ✅ SISTEMA UNIFICADO: Detectar TODAS as unidades e embarcar automaticamente
        var _unidades_detectadas = ds_list_create();
        
        // Coletar TODAS as unidades próximas (qualquer tipo que funciona com o navio)
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
            show_debug_message("--- [NAVIO] Verificando Tanque ID: " + string(id) + " ---");
            
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
            show_debug_message("--- [NAVIO] Verificando Blindado ID: " + string(id) + " ---");
            
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
            funcao_embarcar_unidade(_unidade);
        }
        
        ds_list_destroy(_unidades_detectadas);
    }
}

// === 3. SISTEMA DE DESEMBARQUE ===
if (estado_transporte == NavioTransporteEstado.DESEMBARCANDO) {
    desembarque_timer++;
    
    if (desembarque_timer >= desembarque_intervalo) {
        desembarque_timer = 0;
        
        // Verificar se há unidades embarcadas
        var _total_embarcado = (soldados_count + unidades_count + avioes_count);
        
        if (_total_embarcado > 0) {
            // Prioridade: Soldados > Veículos > Aeronaves
            if (soldados_count > 0) {
                funcao_desembarcar_soldado();
            } else if (unidades_count > 0) {
                funcao_desembarcar_veiculo();
            } else if (avioes_count > 0) {
                funcao_desembarcar_aeronave();
                   }
               } else {
            // Desembarque completo - voltar ao estado normal
            estado_transporte = NavioTransporteEstado.PARADO;
            show_debug_message("✅ Desembarque completo!");
        }
    }
}

// === 4. COMBATE REMOVIDO - Navio Transporte foca em transporte, não combate ===
// (Combate é gerenciado pelo objeto pai via herança)

// === 4. MOVIMENTO DELEGADO AO PAI ===
// (Lógica de movimento está no obj_navio_base, acessado via event_inherited())