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
// ✅ CORREÇÃO: Verificar se o objeto tem parent antes de chamar event_inherited
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === ATUALIZAR POSIÇÃO DAS UNIDADES EMBARCADAS (SEGUIR O NAVIO) ===
// ✅ CORREÇÃO: Aviões, veículos e soldados devem seguir o navio quando embarcados
if (variable_instance_exists(id, "avioes_embarcados")) {
    for (var i = 0; i < ds_list_size(avioes_embarcados); i++) {
        var _aeronave_id = avioes_embarcados[| i];
        if (instance_exists(_aeronave_id)) {
            // Atualizar posição para seguir o navio
            _aeronave_id.x = x;
            _aeronave_id.y = y;
            // Garantir que está invisível
            _aeronave_id.visible = false;
        }
    }
}

if (variable_instance_exists(id, "unidades_embarcadas")) {
    for (var i = 0; i < ds_list_size(unidades_embarcadas); i++) {
        var _veiculo_id = unidades_embarcadas[| i];
        if (instance_exists(_veiculo_id)) {
            // Atualizar posição para seguir o navio
            _veiculo_id.x = x;
            _veiculo_id.y = y;
            // Garantir que está invisível
            _veiculo_id.visible = false;
        }
    }
}

if (variable_instance_exists(id, "soldados_embarcados")) {
    for (var i = 0; i < ds_list_size(soldados_embarcados); i++) {
        var _soldado_id = soldados_embarcados[| i];
        if (instance_exists(_soldado_id)) {
            // Atualizar posição para seguir o navio
            _soldado_id.x = x;
            _soldado_id.y = y;
            // Garantir que está invisível
            _soldado_id.visible = false;
        }
    }
}

// === 1. PROCESSAR COMANDOS DO JOGADOR (SE SELECIONADO) ===
if (variable_instance_exists(id, "selecionado") && selecionado) {
    
    // === COMANDO J - MENU DE CARGA ===
    if (keyboard_check_pressed(ord("J"))) {
        menu_carga_aberto = !menu_carga_aberto;
        if (menu_carga_aberto) {
            show_debug_message("📋 MENU DE CARGA ABERTO");
        } else {
            show_debug_message("✅ MENU DE CARGA FECHADO");
            // Resetar seleção ao fechar
            unidade_selecionada_desembarque = -1;
            tipo_unidade_selecionada = "";
        }
    }
    
    // === PROCESSAR CLIQUE NO MENU DE CARGA ===
    if (menu_carga_aberto && mouse_check_button_pressed(mb_left)) {
        var _menu_x = 100;
        var _menu_y = 100;
        var _menu_w = 450;
        var _menu_h = 500;
        
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        
        // Verificar se clique está dentro do menu
        if (_mx >= _menu_x && _mx <= _menu_x + _menu_w && _my >= _menu_y && _my <= _menu_y + _menu_h) {
            var _line_y = _menu_y + 45 + 25 + 25 + 25 + 30 + 15 + 40;
            var _col1_x = _menu_x + 20;
            var _item_height = 25;
            var _scroll_y = _line_y;
            var _item_index = 0;
            
            // Verificar clique em itens da lista
            // Aeronaves
            if (avioes_count > 0) {
                for (var i = 0; i < ds_list_size(avioes_embarcados); i++) {
                    var _unidade_id = avioes_embarcados[| i];
                    if (!instance_exists(_unidade_id)) continue;
                    
                    var _item_y = _scroll_y + (_item_index * _item_height);
                    if (_my >= _item_y - 2 && _my <= _item_y + _item_height - 2 && _mx >= _col1_x - 5 && _mx <= _menu_x + _menu_w - 20) {
                        unidade_selecionada_desembarque = _unidade_id;
                        tipo_unidade_selecionada = "aeronave";
                        show_debug_message("✈️ Aeronave selecionada para desembarque");
                        break;
                    }
                    _item_index++;
                }
            }
            
            // Veículos
            if (unidades_count > 0) {
                for (var i = 0; i < ds_list_size(unidades_embarcadas); i++) {
                    var _unidade_id = unidades_embarcadas[| i];
                    if (!instance_exists(_unidade_id)) continue;
                    
                    var _item_y = _scroll_y + (_item_index * _item_height);
                    if (_my >= _item_y - 2 && _my <= _item_y + _item_height - 2 && _mx >= _col1_x - 5 && _mx <= _menu_x + _menu_w - 20) {
                        unidade_selecionada_desembarque = _unidade_id;
                        tipo_unidade_selecionada = "veiculo";
                        show_debug_message("🚛 Veículo selecionado para desembarque");
                        break;
                    }
                    _item_index++;
                }
            }
            
            // Soldados
            if (soldados_count > 0) {
                for (var i = 0; i < ds_list_size(soldados_embarcados); i++) {
                    var _unidade_id = soldados_embarcados[| i];
                    if (!instance_exists(_unidade_id)) continue;
                    
                    var _item_y = _scroll_y + (_item_index * _item_height);
                    if (_my >= _item_y - 2 && _my <= _item_y + _item_height - 2 && _mx >= _col1_x - 5 && _mx <= _menu_x + _menu_w - 20) {
                        unidade_selecionada_desembarque = _unidade_id;
                        tipo_unidade_selecionada = "soldado";
                        show_debug_message("👥 Soldado selecionado para desembarque");
                        break;
                    }
                    _item_index++;
                }
            }
            
            // Verificar clique nos botões
            var _btn_y = _menu_y + _menu_h - 120;
            
            // Botão DESEMBARCAR 1
            var _btn1_x = _menu_x + 100;
            var _btn1_w = 140;
            var _btn1_h = 35;
            if (_mx >= _btn1_x - _btn1_w/2 && _mx <= _btn1_x + _btn1_w/2 && 
                _my >= _btn_y - _btn1_h/2 && _my <= _btn_y + _btn1_h/2) {
                if (unidade_selecionada_desembarque != -1) {
                    funcao_desembarcar_unidade_selecionada();
                }
            }
            
            // Botão DESEMBARCAR TODAS / PAUSAR
            var _btn2_x = _menu_x + 250;
            var _btn2_w = 140;
            var _btn2_h = 35;
            if (_mx >= _btn2_x - _btn2_w/2 && _mx <= _btn2_x + _btn2_w/2 && 
                _my >= _btn_y - _btn2_h/2 && _my <= _btn_y + _btn2_h/2) {
                desembarcando_todas = !desembarcando_todas;
                if (desembarcando_todas) {
                    estado_transporte = NavioTransporteEstado.DESEMBARCANDO;
                    show_debug_message("🚢 Desembarcando todas as unidades...");
                } else {
                    estado_transporte = NavioTransporteEstado.PARADO;
                    show_debug_message("⏸️ Desembarque pausado");
                }
            }
            
            // Botão FECHAR
            var _btn3_x = _menu_x + 400;
            var _btn3_w = 60;
            var _btn3_h = 35;
            if (_mx >= _btn3_x - _btn3_w/2 && _mx <= _btn3_x + _btn3_w/2 && 
                _my >= _btn_y - _btn3_h/2 && _my <= _btn_y + _btn3_h/2) {
                menu_carga_aberto = false;
                unidade_selecionada_desembarque = -1;
                tipo_unidade_selecionada = "";
            }
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
        // PPP (terceira vez) = DESEMBARQUE (todas as unidades)
        else if (comando_p_contador >= 3) {
            desembarcando_todas = true;
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
        is_moving = false; // ✅ CORREÇÃO: Parar de mostrar linha de movimento
        comando_p_contador = 0; // ✅ Resetar contador P ao parar
        comando_p_timer = 0;
        modo_embarque = false;
        menu_carga_aberto = false;
        alvo_unidade = noone;
        show_debug_message("⏹️ Navio parado - Todos os comandos cancelados");
    }
    
    // COMANDO K - PATRULHA
    // ✅ CORREÇÃO: Sistema de patrulha agora é gerenciado pelo obj_input_manager
    // Este código é mantido apenas para compatibilidade, mas o sistema principal está no input_manager
    if (keyboard_check_pressed(ord("K"))) {
        // Se não está definindo patrulha via input_manager, ativar localmente
        if (!variable_global_exists("definindo_patrulha_unidade") || !instance_exists(global.definindo_patrulha_unidade) || global.definindo_patrulha_unidade != id) {
            if (variable_instance_exists(id, "pontos_patrulha") && ds_list_size(pontos_patrulha) == 0) {
                show_debug_message("🔄 Modo Patrulha - Clique para adicionar pontos");
                if (variable_instance_exists(id, "estado")) estado = LanchaState.DEFININDO_PATRULHA;
                // ✅ CORREÇÃO: Definir global para compatibilidade com input_manager
                if (variable_global_exists("definindo_patrulha_unidade")) {
                    global.definindo_patrulha_unidade = id;
                }
            } else {
                show_debug_message("✅ Rota de patrulha definida");
                if (variable_instance_exists(id, "func_iniciar_patrulha")) func_iniciar_patrulha();
            }
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
        var _largura = variable_instance_exists(id, "largura_embarque") ? largura_embarque : 293.76; // ✅ AUMENTADO 50%
        var _altura = variable_instance_exists(id, "altura_embarque") ? altura_embarque : 352.08; // ✅ AUMENTADO 50%
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
        
        // ✅ CORREÇÃO: Adicionar M1A Abrams explicitamente
        var _obj_abrams = asset_get_index("obj_M1A_Abrams");
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            with (_obj_abrams) {
                if (variable_instance_exists(id, "nacao_proprietaria") && 
                    nacao_proprietaria == other.nacao_proprietaria && 
                    _ponto_no_retangulo(x, y, other.x, other.y, _largura, _altura, other.image_angle) &&
                    visible) {
                    ds_list_add(_unidades_detectadas, id);
                }
            }
        }
        
        // ✅ NOVO: Adicionar Gepard Anti-Aéreo
        var _obj_gepard = asset_get_index("obj_gepard");
        if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
            with (_obj_gepard) {
                if (variable_instance_exists(id, "nacao_proprietaria") && 
                    nacao_proprietaria == other.nacao_proprietaria && 
                    _ponto_no_retangulo(x, y, other.x, other.y, _largura, _altura, other.image_angle) &&
                    visible) {
                    ds_list_add(_unidades_detectadas, id);
                }
            }
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
        
        // ✅ CORREÇÃO: C-100 deve usar detecção por retângulo, não distância
        // ✅ CORREÇÃO: C-100 deve usar detecção por retângulo, não distância
        with (obj_c100) {
            if (variable_instance_exists(id, "nacao_proprietaria") && 
                nacao_proprietaria == other.nacao_proprietaria && 
                _ponto_no_retangulo(x, y, other.x, other.y, _largura, _altura, other.image_angle) &&
                visible) {
                ds_list_add(_unidades_detectadas, id);
            }
        }
        
        // ✅ NOVO: F-35 (obj_caca_f35)
        var _obj_f35 = asset_get_index("obj_caca_f35");
        if (_obj_f35 != -1 && asset_get_type(_obj_f35) == asset_object) {
            with (_obj_f35) {
                if (variable_instance_exists(id, "nacao_proprietaria") && 
                    nacao_proprietaria == other.nacao_proprietaria && 
                    point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                    visible) {
                    ds_list_add(_unidades_detectadas, id);
                }
            }
        }
        
        // ✅ NOVO: SU-35 (obj_su35)
        var _obj_su35 = asset_get_index("obj_su35");
        if (_obj_su35 != -1 && asset_get_type(_obj_su35) == asset_object) {
            with (_obj_su35) {
                if (variable_instance_exists(id, "nacao_proprietaria") && 
                    nacao_proprietaria == other.nacao_proprietaria && 
                    point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                    visible) {
                    ds_list_add(_unidades_detectadas, id);
                }
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
if (estado_transporte == NavioTransporteEstado.DESEMBARCANDO && desembarcando_todas) {
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
            desembarcando_todas = false;
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