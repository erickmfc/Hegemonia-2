/// @description Controle de seleção de unidades - SISTEMA UNIVERSAL COM ZOOM

// =========================================================================
// INÍCIO DO CÓDIGO DE SELEÇÃO UNIVERSAL (COM ZOOM E QUALQUER MAPA)
// =========================================================================

// Checa por um único clique do botão esquerdo do mouse
if (mouse_check_button_pressed(mb_left)) {

    // --- PASSO 1: Obter as coordenadas do mouse na TELA (GUI) ---
    // Esta é a posição X e Y do cursor na janela do jogo.
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);

    // --- PASSO 2: Obter as informações da CÂMERA atual ---
    // Pegamos a referência da câmera que está ativa na primeira viewport
    var _cam = view_camera[0];
    
    // Onde a câmera está posicionada dentro do MUNDO do jogo
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    
    // O tamanho da "lente" da câmera (quanto do MUNDO ela está enxergando)
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);

    // --- PASSO 3: Calcular o nível de ZOOM atual ---
    // Comparamos o tamanho da lente da câmera com o tamanho da tela para saber o zoom.
    var _zoom_level_x = _cam_w / display_get_gui_width();
    var _zoom_level_y = _cam_h / display_get_gui_height();

    // --- PASSO 4: A CONVERSÃO MÁGICA ---
    // CORREÇÃO: Usar função global para coordenadas consistentes
    var _coords = global.scr_mouse_to_world();
    var _mouse_world_x = _coords[0];
    var _mouse_world_y = _coords[1];

    // --- PASSO 5: Verificar se clicou em edifício primeiro ---
    // CORREÇÃO: Usar position_meeting para detecção mais precisa
    var edificio_clicado = noone;
    
    // Lista de todos os edifícios que podem ser clicados
    var edificios = [
        obj_quartel,
        obj_quartel_marinha, 
        obj_aeroporto_militar,
        obj_casa,
        obj_banco,
        obj_research_center
    ];
    
    // Verificar cada edifício usando position_meeting
    for (var i = 0; i < array_length(edificios); i++) {
        var _edificio_obj = edificios[i];
        if (object_exists(_edificio_obj)) {
            var _instancia = instance_position(_mouse_world_x, _mouse_world_y, _edificio_obj);
            if (_instancia != noone) {
                edificio_clicado = _instancia;
                break;
            }
        }
    }
    
    if (edificio_clicado != noone) {
        show_debug_message("Clique em edifício detectado - ignorando seleção de unidades");
        show_debug_message("Edifício: " + object_get_name(edificio_clicado.object_index) + " ID: " + string(edificio_clicado));
        // CORREÇÃO: Remover return para permitir que Mouse Events dos edifícios sejam executados
        // O Mouse Event do edifício será processado normalmente após este Step Event
    }

    // --- PASSO 6: Usar as coordenadas CORRETAS para selecionar ---
    // Agora, em vez de 'mouse_x', usamos nossas novas variáveis _mouse_world_x/y
    var _instancia_selecionada = noone;
    
    // Verifica navios primeiro para melhor detecção
    var hit_lp = collision_point(_mouse_world_x, _mouse_world_y, obj_lancha_patrulha, false, true);
    if (hit_lp != noone) _instancia_selecionada = hit_lp;
    
    if (_instancia_selecionada == noone) {
        // Debug: verificar se há Constellations no jogo
        var _total_constellations = instance_number(obj_Constellation);
        show_debug_message("🔍 Total de Constellations no jogo: " + string(_total_constellations));
        
        if (_total_constellations > 0) {
            // Listar posições de todos os Constellations
            with (obj_Constellation) {
                show_debug_message("🚢 Constellation ID: " + string(id) + " em (" + string(x) + ", " + string(y) + ")");
                show_debug_message("🚢 Bbox: left=" + string(bbox_left) + " right=" + string(bbox_right) + " top=" + string(bbox_top) + " bottom=" + string(bbox_bottom));
            }
        }
        
        // Tentar diferentes métodos de detecção
        var hit_constellation = collision_point(_mouse_world_x, _mouse_world_y, obj_Constellation, false, true);
        show_debug_message("🔍 Resultado collision_point: " + string(hit_constellation));
        
        // Método alternativo
        var hit_constellation_alt = instance_position(_mouse_world_x, _mouse_world_y, obj_Constellation);
        show_debug_message("🔍 Resultado instance_position: " + string(hit_constellation_alt));
        
        // Método manual - verificar se o mouse está dentro da bounding box
        var hit_constellation_manual = noone;
        with (obj_Constellation) {
            show_debug_message("🔍 Verificando Constellation ID: " + string(id));
            show_debug_message("🔍 Mouse: (" + string(_mouse_world_x) + ", " + string(_mouse_world_y) + ")");
            show_debug_message("🔍 Bbox: (" + string(bbox_left) + ", " + string(bbox_top) + ") a (" + string(bbox_right) + ", " + string(bbox_bottom) + ")");
            
            if (_mouse_world_x >= bbox_left && _mouse_world_x <= bbox_right && 
                _mouse_world_y >= bbox_top && _mouse_world_y <= bbox_bottom) {
                hit_constellation_manual = id;
                show_debug_message("🔍 Constellation detectado via bbox manual!");
                break;
            }
        }
        show_debug_message("🔍 Resultado bbox manual: " + string(hit_constellation_manual));
        
        // Usar o método que funcionar
        if (hit_constellation_manual != noone) {
            hit_constellation = hit_constellation_manual;
        } else if (hit_constellation_alt != noone) {
            hit_constellation = hit_constellation_alt;
        }
        
        if (hit_constellation != noone) {
            _instancia_selecionada = hit_constellation;
            show_debug_message("🚢 CONSTELLATION DETECTADO VIA CONTROLADOR!");
            show_debug_message("🚢 ID do Constellation: " + string(hit_constellation));
            show_debug_message("🚢 Posição do mouse: (" + string(_mouse_world_x) + ", " + string(_mouse_world_y) + ")");
            show_debug_message("🚢 Posição do Constellation: (" + string(hit_constellation.x) + ", " + string(hit_constellation.y) + ")");
        } else {
            show_debug_message("❌ NENHUM CONSTELLATION DETECTADO no clique!");
        }
    }
    
    if (_instancia_selecionada == noone) {
        var hit_inf = collision_point(_mouse_world_x, _mouse_world_y, obj_infantaria, false, true);
        if (hit_inf != noone) _instancia_selecionada = hit_inf;
    }
    if (_instancia_selecionada == noone) {
        var hit_aa = collision_point(_mouse_world_x, _mouse_world_y, obj_soldado_antiaereo, false, true);
        if (hit_aa != noone) _instancia_selecionada = hit_aa;
    }
    if (_instancia_selecionada == noone) {
        var hit_tk = collision_point(_mouse_world_x, _mouse_world_y, obj_tanque, false, true);
        if (hit_tk != noone) _instancia_selecionada = hit_tk;
    }
    if (_instancia_selecionada == noone) {
        var hit_baa = collision_point(_mouse_world_x, _mouse_world_y, obj_blindado_antiaereo, false, true);
        if (hit_baa != noone) _instancia_selecionada = hit_baa;
    }
    if (_instancia_selecionada == noone) {
        var hit_f5 = collision_point(_mouse_world_x, _mouse_world_y, obj_caca_f5, false, true);
        if (hit_f5 != noone) _instancia_selecionada = hit_f5;
    }
    if (_instancia_selecionada == noone) {
        var hit_heli = collision_point(_mouse_world_x, _mouse_world_y, obj_helicoptero_militar, false, true);
        if (hit_heli != noone) _instancia_selecionada = hit_heli;
    }

    // --- PASSO 7: Lógica de Seleção ---
    if (instance_exists(_instancia_selecionada)) {
        // Se estávamos esperando um alvo para o comando SEGUIR
        if (instance_exists(global.esperando_alvo_seguir)) {
            global.esperando_alvo_seguir.alvo_seguir = _instancia_selecionada;
            
            // Determinar o estado correto baseado no tipo de unidade
            if (global.esperando_alvo_seguir.object_index == obj_caca_f5) {
                // Sistema simplificado - apenas define alvo para seguir
                global.esperando_alvo_seguir.alvo_seguir = _instancia_selecionada;
            } else if (global.esperando_alvo_seguir.object_index == obj_helicoptero_militar) {
                global.esperando_alvo_seguir.estado = "seguindo";
            }
            
            show_debug_message("🎯 Alvo definido para seguir: " + object_get_name(_instancia_selecionada.object_index));
            global.esperando_alvo_seguir = noone; // Reseta o modo
        } else {
            // Seleção normal de unidades
            // Desselecionar todas as outras unidades primeiro
            with (obj_infantaria) { selecionado = false; }
            with (obj_soldado_antiaereo) { selecionado = false; }
            with (obj_tanque) { selecionado = false; }
            with (obj_blindado_antiaereo) { selecionado = false; }
            with (obj_lancha_patrulha) { selecionado = false; }
            with (obj_Constellation) { selecionado = false; }
            with (obj_caca_f5) { selecionado = false; }
            with (obj_helicoptero_militar) { selecionado = false; }
            
            // Selecionar a unidade clicada
            _instancia_selecionada.selecionado = true;
            global.unidade_selecionada = _instancia_selecionada;
            
            // Debug para verificar seleção da lancha
            if (object_get_name(_instancia_selecionada.object_index) == "obj_lancha_patrulha") {
                show_debug_message("🚢 LANCHA SELECIONADA VIA CONTROLADOR!");
                show_debug_message("🚢 ID da lancha: " + string(_instancia_selecionada));
                show_debug_message("🚢 global.unidade_selecionada: " + string(global.unidade_selecionada));
                show_debug_message("🚢 Tem pontos_patrulha: " + string(variable_instance_exists(_instancia_selecionada, "pontos_patrulha")));
            }
            
            // Debug para verificar seleção do Constellation
            if (object_get_name(_instancia_selecionada.object_index) == "obj_Constellation") {
                show_debug_message("🚢 CONSTELLATION SELECIONADO VIA CONTROLADOR!");
                show_debug_message("🚢 ID do Constellation: " + string(_instancia_selecionada));
                show_debug_message("🚢 global.unidade_selecionada: " + string(global.unidade_selecionada));
                show_debug_message("🚢 Estado: " + string(_instancia_selecionada.estado));
                show_debug_message("🚢 Selecionado: " + string(_instancia_selecionada.selecionado));
            }
            
            // ======================================================================
            // FUNCIONALIDADE DE CENTRALIZAR CÂMERA DESATIVADA
            // ======================================================================
            // var _input_manager = instance_find(obj_input_manager, 0);
            // if (instance_exists(_input_manager)) {
            //     // Manda o gerenciador de câmera mover a câmera para a posição da unidade
            //     _input_manager.camera_x = _instancia_selecionada.x;
            //     _input_manager.camera_y = _instancia_selecionada.y;
            //     
            //     show_debug_message("📷 Câmera centralizada na unidade: " + object_get_name(_instancia_selecionada.object_index));
            // }
            // ======================================================================
            
            show_debug_message("Seleção: " + object_get_name(_instancia_selecionada.object_index));
            show_debug_message("📍 Coordenadas mundo: (" + string(_mouse_world_x) + ", " + string(_mouse_world_y) + ")");
        }
    } else {
        // Se clicamos no vazio
        if (instance_exists(global.esperando_alvo_seguir)) {
            // Cancelar modo de seguir se clicou no vazio
            show_debug_message("❌ Modo SEGUIR cancelado - clique no vazio");
            global.esperando_alvo_seguir = noone;
        } else {
            // Desseleção normal
            with (obj_infantaria) { selecionado = false; }
            with (obj_soldado_antiaereo) { selecionado = false; }
            with (obj_tanque) { selecionado = false; }
            with (obj_blindado_antiaereo) { selecionado = false; }
            with (obj_lancha_patrulha) { selecionado = false; }
            with (obj_Constellation) { selecionado = false; }
            with (obj_caca_f5) { selecionado = false; }
            with (obj_helicoptero_militar) { selecionado = false; }
            global.unidade_selecionada = noone;
            
            show_debug_message("Clique no vazio.");
            show_debug_message("📍 Coordenadas mundo: (" + string(_mouse_world_x) + ", " + string(_mouse_world_y) + ")");
        }
    }
    
    // === LÓGICA DE ADICIONAR PONTOS DE PATRULHA ===
    if (instance_exists(global.definindo_patrulha)) {
        // Adicionar ponto de patrulha no local clicado
        // Verificar qual variável de patrulha usar baseado no tipo de objeto
        var _unidade = global.definindo_patrulha;
        var _lista_patrulha = noone;
        
        // Determinar qual lista de patrulha usar baseado no objeto
        if (_unidade.object_index == obj_infantaria) {
            _lista_patrulha = _unidade.patrulha; // obj_infantaria usa 'patrulha'
        } else if (_unidade.object_index == obj_lancha_patrulha) {
            _lista_patrulha = _unidade.pontos_patrulha; // obj_lancha_patrulha usa 'pontos_patrulha'
        } else if (_unidade.object_index == obj_caca_f5) {
            _lista_patrulha = _unidade.pontos_patrulha; // obj_caca_f5 usa 'pontos_patrulha'
        } else if (_unidade.object_index == obj_helicoptero_militar) {
            _lista_patrulha = _unidade.pontos_patrulha; // obj_helicoptero_militar usa 'pontos_patrulha'
        } else if (_unidade.object_index == obj_Constellation) {
            // Constellation não tem sistema de patrulha no código novo
            _lista_patrulha = noone;
        } else {
            // Para outros objetos, tentar 'patrol_points' ou 'pontos_patrulha'
            if (variable_instance_exists(_unidade, "patrol_points")) {
                _lista_patrulha = _unidade.patrol_points;
            } else if (variable_instance_exists(_unidade, "pontos_patrulha")) {
                _lista_patrulha = _unidade.pontos_patrulha;
            } else if (variable_instance_exists(_unidade, "patrulha")) {
                _lista_patrulha = _unidade.patrulha;
            }
        }
        
        // Adicionar ponto se a lista foi encontrada
        if (_lista_patrulha != noone && ds_exists(_lista_patrulha, ds_type_list)) {
            ds_list_add(_lista_patrulha, [_mouse_world_x, _mouse_world_y]);
            show_debug_message("📍 Ponto de patrulha adicionado: (" + string(_mouse_world_x) + ", " + string(_mouse_world_y) + ")");
            show_debug_message("📊 Total de pontos: " + string(ds_list_size(_lista_patrulha)));
        } else {
            show_debug_message("❌ ERRO: Lista de patrulha não encontrada para " + object_get_name(_unidade.object_index));
        }
    }
}
// =========================================================================
// FIM DO CÓDIGO DE SELEÇÃO
// =========================================================================

// =========================================================================
// SELEÇÃO MÚLTIPLA COM ARRASTAR (COORDENADAS COM ZOOM)
// =========================================================================

if (mouse_check_button(mb_left)) {
    if (!selecionando) {
        selecionando = true;
        
        // Usar o mesmo sistema de conversão de coordenadas
        var _mouse_gui_x = device_mouse_x_to_gui(0);
        var _mouse_gui_y = device_mouse_y_to_gui(0);
        var _cam = view_camera[0];
        var _cam_x = camera_get_view_x(_cam);
        var _cam_y = camera_get_view_y(_cam);
        var _cam_w = camera_get_view_width(_cam);
        var _cam_h = camera_get_view_height(_cam);
        var _zoom_level_x = _cam_w / display_get_gui_width();
        var _zoom_level_y = _cam_h / display_get_gui_height();
        
        inicio_selecao_x = _cam_x + (_mouse_gui_x * _zoom_level_x);
        inicio_selecao_y = _cam_y + (_mouse_gui_y * _zoom_level_y);
    }
} else {
    if (selecionando) {
        selecionando = false;
        
        // Usar o mesmo sistema de conversão de coordenadas
        var _mouse_gui_x = device_mouse_x_to_gui(0);
        var _mouse_gui_y = device_mouse_y_to_gui(0);
        var _cam = view_camera[0];
        var _cam_x = camera_get_view_x(_cam);
        var _cam_y = camera_get_view_y(_cam);
        var _cam_w = camera_get_view_width(_cam);
        var _cam_h = camera_get_view_height(_cam);
        var _zoom_level_x = _cam_w / display_get_gui_width();
        var _zoom_level_y = _cam_h / display_get_gui_height();
        
        var world_x = _cam_x + (_mouse_gui_x * _zoom_level_x);
        var world_y = _cam_y + (_mouse_gui_y * _zoom_level_y);
        
        var min_x = min(inicio_selecao_x, world_x);
        var max_x = max(inicio_selecao_x, world_x);
        var min_y = min(inicio_selecao_y, world_y);
        var max_y = max(inicio_selecao_y, world_y);
        
        with (obj_lancha_patrulha) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
                show_debug_message("🚢 Navio incluído na seleção múltipla!");
            }
        }
        with (obj_infantaria) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_soldado_antiaereo) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_tanque) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_blindado_antiaereo) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
            }
        }
        with (obj_caca_f5) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
                show_debug_message("✈️ F-5 incluído na seleção múltipla!");
            }
        }
        with (obj_helicoptero_militar) {
            if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                selecionado = true;
                show_debug_message("🚁 Helicóptero incluído na seleção múltipla!");
            }
        }
    }
}

// ===============================================
// GERENCIADOR DE COMANDOS PARA UNIDADE SELECIONADA
// ===============================================
if (instance_exists(global.unidade_selecionada)) {
    var _unidade = global.unidade_selecionada;

    // Comandos para F-5 (COMANDOS CENTRALIZADOS NO INPUT MANAGER)
    if (_unidade.object_index == obj_caca_f5) {
        // Comandos P e O já estão no Step do próprio F-5
        // Comandos Q e E já estão no obj_input_manager
        // Aqui só mantemos comandos específicos do controlador

        // Comando de Teste de Mísseis (Tecla T)
        if (keyboard_check_pressed(ord("T"))) {
            show_debug_message("🔍 === TESTE SISTEMA MÍSSEIS F-5 ===");
            
            // Contar unidades
            var _f5_count = instance_number(obj_caca_f5);
            var _inimigo_count = instance_number(obj_inimigo);
            
            show_debug_message("📊 F-5s no mapa: " + string(_f5_count));
            show_debug_message("📊 Inimigos no mapa: " + string(_inimigo_count));
            
            if (_f5_count == 0) {
                show_debug_message("❌ ERRO: Nenhum F-5 encontrado no mapa!");
                return;
            }
            
            if (_inimigo_count == 0) {
                show_debug_message("❌ ERRO: Nenhum inimigo encontrado no mapa!");
                show_debug_message("💡 SOLUÇÃO: Crie alguns obj_inimigo no mapa para testar");
                return;
            }
            
            // Testar cada F-5
            with (obj_caca_f5) {
                show_debug_message("✈️ Testando F-5 ID: " + string(id));
                show_debug_message("   - Velocidade: " + string(velocidade_atual));
                show_debug_message("   - Modo ataque: " + string(modo_ataque));
                show_debug_message("   - Altura voo: " + string(altura_voo));
                show_debug_message("   - Timer ataque: " + string(timer_ataque));
                
                // Forçar modo ataque para teste
                modo_ataque = true;
                show_debug_message("   - Modo ataque ativado para teste");
                
                // Verificar inimigos próximos
                var _alvo_proximo = instance_nearest(x, y, obj_inimigo);
                if (instance_exists(_alvo_proximo)) {
                    var _distancia = point_distance(x, y, _alvo_proximo.x, _alvo_proximo.y);
                    show_debug_message("   - Inimigo mais próximo: " + string(_alvo_proximo) + " a " + string(_distancia) + " pixels");
                    show_debug_message("   - Alcance radar: " + string(radar_alcance));
                    
                    if (_distancia <= radar_alcance) {
                        show_debug_message("   ✅ F-5 pode atacar este inimigo!");
                    } else {
                        show_debug_message("   ❌ F-5 não pode atacar - muito longe");
                    }
                } else {
                    show_debug_message("   ❌ Nenhum inimigo encontrado");
                }
            }
            
            show_debug_message("🔍 === FIM DO TESTE ===");
        }

        // Comando de Movimento (Clique Direito)
        if (mouse_check_button_pressed(mb_right)) {
            // Se estiver definindo patrulha, adiciona um ponto
            if (global.definindo_patrulha == _unidade && variable_instance_exists(_unidade, "pontos_patrulha")) {
                var _coords = global.scr_mouse_to_world();
                ds_list_add(_unidade.pontos_patrulha, [_coords[0], _coords[1]]);
                show_debug_message("📍 Ponto de patrulha adicionado");
            } 
            // Senão, é uma ordem de movimento normal
            else {
                var _coords = global.scr_mouse_to_world();
                
                // Verificar se a unidade tem as variáveis necessárias
                if (variable_instance_exists(_unidade, "destino_x") && variable_instance_exists(_unidade, "destino_y")) {
                    _unidade.destino_x = _coords[0];
                    _unidade.destino_y = _coords[1];
                    
                    // Para Constellation, usar sistema simples
                    if (_unidade.object_index == obj_Constellation) {
                        _unidade.estado = "movendo";
                        show_debug_message("🚢 Ordem de movimento para Constellation");
                        show_debug_message("🚢 Constellation destino: (" + string(_coords[0]) + ", " + string(_coords[1]) + ")");
                        show_debug_message("🚢 Constellation estado alterado para: " + _unidade.estado);
                    }
                    // Para outras unidades
                    else {
                        show_debug_message("🎯 Ordem de movimento para " + object_get_name(_unidade.object_index));
                    }
                    
                    // Cancela outros modos se existirem
                    if (variable_instance_exists(_unidade, "alvo_seguir")) {
                        _unidade.alvo_seguir = noone;
                    }
                    global.definindo_patrulha = noone;
                }
            }
        }
    }
    
    // Comandos para Helicóptero (COMANDOS CENTRALIZADOS NO INPUT MANAGER)
    if (_unidade.object_index == obj_helicoptero_militar) {
        // Comandos P e O já estão no Step do próprio helicóptero
        // Comandos Q e E já estão no obj_input_manager
        // Aqui só mantemos comandos específicos do controlador

        // Comando de Movimento (Clique Direito)
        if (mouse_check_button_pressed(mb_right)) {
            // Se estiver definindo patrulha, adiciona um ponto
            if (global.definindo_patrulha == _unidade && variable_instance_exists(_unidade, "pontos_patrulha")) {
                var _coords = global.scr_mouse_to_world();
                ds_list_add(_unidade.pontos_patrulha, [_coords[0], _coords[1]]);
                show_debug_message("📍 Ponto de patrulha adicionado");
            } 
            // Senão, é uma ordem de movimento normal
            else {
                var _coords = global.scr_mouse_to_world();
                
                // Verificar se a unidade tem as variáveis necessárias
                if (variable_instance_exists(_unidade, "destino_x") && variable_instance_exists(_unidade, "destino_y")) {
                    _unidade.destino_x = _coords[0];
                    _unidade.destino_y = _coords[1];
                    
                    // Para Constellation, usar sistema simples
                    if (_unidade.object_index == obj_Constellation) {
                        _unidade.estado = "movendo";
                        show_debug_message("🚢 Ordem de movimento para Constellation");
                        show_debug_message("🚢 Constellation destino: (" + string(_coords[0]) + ", " + string(_coords[1]) + ")");
                        show_debug_message("🚢 Constellation estado alterado para: " + _unidade.estado);
                    }
                    // Para helicóptero, usar sistema específico
                    else if (variable_instance_exists(_unidade, "ESTADO_HELICOPTERO")) {
                        _unidade.estado = _unidade.estado == ESTADO_HELICOPTERO.POUSADO ? ESTADO_HELICOPTERO.DECOLANDO : ESTADO_HELICOPTERO.MOVENDO;
                        if (_unidade.estado == ESTADO_HELICOPTERO.DECOLANDO) { _unidade.timer_transicao = 60; }
                        show_debug_message("🎯 Ordem de movimento para helicóptero");
                    }
                    // Para outras unidades
                    else {
                        show_debug_message("🎯 Ordem de movimento para " + object_get_name(_unidade.object_index));
                    }
                    
                    // Cancela outros modos se existirem
                    if (variable_instance_exists(_unidade, "alvo_seguir")) {
                        _unidade.alvo_seguir = noone;
                    }
                    global.definindo_patrulha = noone;
                }
            }
        }
    }
}