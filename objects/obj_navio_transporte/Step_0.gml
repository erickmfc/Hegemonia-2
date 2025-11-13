/// @description Lógica principal do Navio Transporte

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
    
    // ✅ NOVO SISTEMA: P = EMBARQUE, PP = EMBARCADO, PPP = DESEMBARQUE
    if (keyboard_check_pressed(ord("P"))) {
        comando_p_contador++;
        comando_p_timer = 60; // Resetar após 1 segundo (60 frames)
        
        // P (primeira vez) = EMBARQUE ATIVO
        if (comando_p_contador == 1) {
            modo_embarque = true;
            estado_transporte = NavioTransporteEstado.EMBARQUE_ATIVO;
            show_debug_message("🚚 MODO EMBARQUE - Aguardando unidades próximas");
        }
        // PP (segunda vez) = EMBARCADO (fechado, pronto para navegar)
        else if (comando_p_contador == 2) {
            modo_embarque = false;
            estado_transporte = NavioTransporteEstado.EMBARQUE_OFF;
            var _total_embarcado = soldados_count + unidades_count + avioes_count;
            show_debug_message("✅ EMBARCADO - " + string(_total_embarcado) + " unidades a bordo");
        }
        // PPP (terceira vez) = DESEMBARQUE
        else if (comando_p_contador >= 3) {
            var _total_embarcado = soldados_count + unidades_count + avioes_count;
            if (_total_embarcado > 0) {
                estado_transporte = NavioTransporteEstado.DESEMBARCANDO;
                modo_embarque = false;
                desembarque_timer = desembarque_intervalo; // Começar imediatamente
                show_debug_message("📦 MODO DESEMBARQUE - " + string(_total_embarcado) + " unidades");
            } else {
                show_debug_message("⚠️ Nenhuma unidade embarcada para desembarcar");
            }
            comando_p_contador = 0; // Resetar após PPP
        }
    }
    
    // ✅ Resetar contador após 1 segundo sem pressionar P
    if (comando_p_timer > 0) {
        comando_p_timer--;
        if (comando_p_timer <= 0) {
            comando_p_contador = 0; // Resetar contador
        }
    }
    
    // COMANDO L - PARAR
    if (keyboard_check_pressed(ord("L"))) {
        if (variable_instance_exists(id, "estado")) estado = LanchaState.PARADO;
        if (variable_instance_exists(id, "estado_transporte")) estado_transporte = NavioTransporteEstado.PARADO;
        comando_p_contador = 0; // ✅ Resetar contador P ao parar
        comando_p_timer = 0;
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
        // ✅ CORREÇÃO: Usar detecção por retângulo em vez de círculo
        var _largura = variable_instance_exists(id, "largura_embarque") ? largura_embarque : 136; // ✅ REDUZIDO 20%
        var _altura = variable_instance_exists(id, "altura_embarque") ? altura_embarque : 163; // ✅ REDUZIDO 20%
        var _half_w = _largura / 2;
        var _half_h = _altura / 2;
        
        // Função auxiliar para verificar se ponto está dentro do retângulo rotacionado
        var _ponto_no_retangulo = function(px, py, cx, cy, w, h, angulo) {
            var _angulo_rad = degtorad(angulo);
            var _cos_a = dcos(_angulo_rad);
            var _sin_a = dsin(_angulo_rad);
            
            // Converter ponto para coordenadas locais do navio
            var _dx = px - cx;
            var _dy = py - cy;
            var _local_x = _dx * _cos_a + _dy * _sin_a;
            var _local_y = -_dx * _sin_a + _dy * _cos_a;
            
            // Verificar se está dentro do retângulo
            return (abs(_local_x) <= w/2 && abs(_local_y) <= h/2);
        };
        
        with (obj_infantaria) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                _ponto_no_retangulo(x, y, other.x, other.y, _largura, _altura, other.image_angle) &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        with (obj_soldado_antiaereo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                _ponto_no_retangulo(x, y, other.x, other.y, _largura, _altura, other.image_angle) &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                _ponto_no_retangulo(x, y, other.x, other.y, _largura, _altura, other.image_angle) &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        with (obj_blindado_antiaereo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                _ponto_no_retangulo(x, y, other.x, other.y, _largura, _altura, other.image_angle) &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        // ✅ CORREÇÃO: Verificar Abrams também (garantir que está sendo detectado)
        var _obj_abrams = asset_get_index("obj_M1A_Abrams");
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            with (_obj_abrams) {
                var _abrams_dentro_retangulo = _ponto_no_retangulo(x, y, other.x, other.y, _largura, _altura, other.image_angle);
                var _abrams_nacao_ok = false;
                var _abrams_visivel = visible;
                
                if (variable_instance_exists(id, "nacao_proprietaria")) {
                    _abrams_nacao_ok = (nacao_proprietaria == other.nacao_proprietaria);
                }
                
                show_debug_message("🔍 [NAVIO] Verificando Abrams ID: " + string(id));
                show_debug_message("  Dentro retângulo: " + string(_abrams_dentro_retangulo));
                show_debug_message("  Nação OK: " + string(_abrams_nacao_ok) + " (Abrams: " + string(nacao_proprietaria) + " | Navio: " + string(other.nacao_proprietaria) + ")");
                show_debug_message("  Visível: " + string(_abrams_visivel));
                
                if (_abrams_nacao_ok && _abrams_dentro_retangulo && _abrams_visivel) {
                    ds_list_add(_unidades_detectadas, id);
                    show_debug_message("✅ Abrams detectado e adicionado para embarque!");
                } else {
                    show_debug_message("❌ Abrams NÃO pode embarcar - condições não atendidas");
                }
            }
        } else {
            show_debug_message("⚠️ [NAVIO] obj_M1A_Abrams não encontrado!");
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
            comando_p_contador = 0; // ✅ Resetar contador P após desembarque completo
            comando_p_timer = 0;
            show_debug_message("✅ Desembarque completo!");
        }
    }
}

// === 4. COMBATE REMOVIDO - Navio Transporte foca em transporte, não combate ===
// (Combate é gerenciado pelo objeto pai via herança)

// === 4. MOVIMENTO DELEGADO AO PAI ===
// (Lógica de movimento está no obj_navio_base, acessado via event_inherited())
// (Lógica de movimento está no obj_navio_base, acessado via event_inherited())