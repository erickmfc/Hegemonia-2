/// @description Lógica principal do Navio Transporte

// === HERANÇA DO PAI PRIMEIRO (OBRIGATÓRIO) ===
event_inherited();

// === 1. PROCESSAR COMANDOS DO JOGADOR (SE SELECIONADO) ===
if (variable_instance_exists(id, "selecionado") && selecionado) {
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
        show_debug_message("✅ Navio CHEIO - Embarque desativado");
    } else {
        // Detectar infantaria
        with (obj_infantaria) {
            if (nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                other.funcao_embarcar_unidade(id);
            }
        }
        
        // Detectar aeronaves F-5
        with (obj_caca_f5) {
            if (nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                other.funcao_embarcar_aeronave(id);
            }
        }
        
        // Detectar helicópteros
        with (obj_helicoptero_militar) {
            if (nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                other.funcao_embarcar_aeronave(id);
            }
        }
        
        // Detectar tanques
        with (obj_tanque) {
            if (nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                other.funcao_embarcar_veiculo(id);
            }
        }
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