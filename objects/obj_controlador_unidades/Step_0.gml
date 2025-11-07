/// @description Controle de seleção de unidades - SISTEMA UNIVERSAL COM ZOOM

// =========================================================================
// LISTA CENTRAL DE UNIDADES SELECIONÁVEIS
// =========================================================================
var _unidades_selecionaveis = [
    obj_Constellation,
    obj_Independence,
    obj_RonaldReagan,
    obj_c100,
    obj_lancha_patrulha,
    obj_infantaria,
    obj_soldado_antiaereo,
    obj_tanque,
    obj_blindado_antiaereo,
    obj_caca_f5,
    obj_helicoptero_militar
];

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
        obj_fazenda,
        obj_research_center
    ];
    
    // ✅ CORREÇÃO: Verificar cada edifício usando instance_position com margem para cliques próximos
    for (var i = 0; i < array_length(edificios); i++) {
        var _edificio_obj = edificios[i];
        if (object_exists(_edificio_obj)) {
            // Verificar com margem para pegar cliques próximos (5 pixels)
            var _instancia = instance_position(_mouse_world_x, _mouse_world_y, _edificio_obj);
            if (_instancia == noone) {
                // Tentar com pequena margem (5 pixels)
                _instancia = instance_position(_mouse_world_x + 5, _mouse_world_y + 5, _edificio_obj);
            }
            if (_instancia == noone) {
                _instancia = instance_position(_mouse_world_x - 5, _mouse_world_y - 5, _edificio_obj);
            }
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
    
    // --- PASSO 6: Usar as coordenadas CORRETAS para selecionar ---
    // Itera sobre a lista para encontrar a unidade clicada
    for (var i = 0; i < array_length(_unidades_selecionaveis); i++) {
        var _obj = _unidades_selecionaveis[i];
        var _inst = collision_point(_mouse_world_x, _mouse_world_y, _obj, true, true); // ✅ CORREÇÃO: Colisão precisa ativada
        if (_inst != noone) {
            _instancia_selecionada = _inst;
            break; // Para na primeira unidade encontrada
        }
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
            // ✅ CORREÇÃO: Sistema de seleção múltipla com Shift
            if (keyboard_check(vk_shift)) {
                // Seleção múltipla com Shift
                if (!_instancia_selecionada.selecionado) {
                    _instancia_selecionada.selecionado = true;
                    if (!variable_global_exists("unidades_selecionadas")) {
                        global.unidades_selecionadas = ds_list_create();
                    }
                    ds_list_add(global.unidades_selecionadas, _instancia_selecionada);
                    show_debug_message("➕ Unidade adicionada à seleção múltipla: " + object_get_name(_instancia_selecionada.object_index));
                } else {
                    // Remover da seleção se já estava selecionada
                    _instancia_selecionada.selecionado = false;
                    if (variable_global_exists("unidades_selecionadas")) {
                        var _index = ds_list_find_index(global.unidades_selecionadas, _instancia_selecionada);
                        if (_index >= 0) {
                            ds_list_delete(global.unidades_selecionadas, _index);
                        }
                    }
                    show_debug_message("➖ Unidade removida da seleção: " + object_get_name(_instancia_selecionada.object_index));
                }
            } else {
                // Seleção única (limpa todas as outras)
                for (var i = 0; i < array_length(_unidades_selecionaveis); i++) {
                    var _obj = _unidades_selecionaveis[i];
                    with (_obj) { selecionado = false; }
                }
                
                // Selecionar a unidade clicada
                _instancia_selecionada.selecionado = true;
                global.unidade_selecionada = _instancia_selecionada;
                
                // Limpar lista de seleção múltipla e adicionar apenas esta unidade
                if (!variable_global_exists("unidades_selecionadas")) {
                    global.unidades_selecionadas = ds_list_create();
                } else {
                    ds_list_clear(global.unidades_selecionadas);
                }
                ds_list_add(global.unidades_selecionadas, _instancia_selecionada);
            }
            
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
            
            // Debug para verificar seleção da Independence
            if (object_get_name(_instancia_selecionada.object_index) == "obj_Independence") {
                show_debug_message("🚢 INDEPENDENCE SELECIONADA VIA CONTROLADOR!");
                show_debug_message("🚢 ID da Independence: " + string(_instancia_selecionada));
                show_debug_message("🚢 global.unidade_selecionada: " + string(global.unidade_selecionada));
                show_debug_message("🚢 Estado: " + string(_instancia_selecionada.estado));
                show_debug_message("🚢 Selecionado: " + string(_instancia_selecionada.selecionado));
                show_debug_message("🚢 HP: " + string(_instancia_selecionada.hp_atual) + "/" + string(_instancia_selecionada.hp_max));
                show_debug_message("🚢 Velocidade: " + string(_instancia_selecionada.velocidade_movimento));
                show_debug_message("🚢 Tem canhão: " + string(instance_exists(_instancia_selecionada.canhao_instancia)));
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
            for (var i = 0; i < array_length(_unidades_selecionaveis); i++) {
                var _obj = _unidades_selecionaveis[i];
                with (_obj) { selecionado = false; }
            }
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
        if (variable_instance_exists(_unidade, "pontos_patrulha")) {
             _lista_patrulha = _unidade.pontos_patrulha;
        } else { // Fallback para sistemas mais antigos
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
        // ✅ CORREÇÃO GM1041: Verificar que _lista_patrulha é uma ds_list válida antes de adicionar
        if (_lista_patrulha != noone && is_real(_lista_patrulha) && ds_exists(_lista_patrulha, ds_type_list)) {
            // Adicionar coordenadas separadamente à ds_list
            ds_list_add(_lista_patrulha, _mouse_world_x);
            ds_list_add(_lista_patrulha, _mouse_world_y);
            show_debug_message("📍 Ponto de patrulha adicionado: (" + string(_mouse_world_x) + ", " + string(_mouse_world_y) + ")");
            show_debug_message("📊 Total de pontos: " + string(ds_list_size(_lista_patrulha) / 2));
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
        
        // Refatorado: Itera sobre o array de unidades selecionáveis
        for (var i = 0; i < array_length(_unidades_selecionaveis); i++) {
            var _obj = _unidades_selecionaveis[i];
            
            with (_obj) {
                if (x >= min_x && x <= max_x && y >= min_y && y <= max_y) {
                    selecionado = true;
                }
            }
        }
        show_debug_message("🖱️ Seleção múltipla finalizada.");
    }
}

// ===============================================
// GERENCIADOR DE COMANDOS PARA UNIDADE SELECIONADA
// ===============================================
if (instance_exists(global.unidade_selecionada)) {
    var _unidade = global.unidade_selecionada;
    
    // ✅ CORREÇÃO BUG: Navios de transporte NÃO recebem ordens de movimento via controlador
    // Eles têm seu próprio sistema de controle (Mouse_4 event)
    var _eh_navio_transporte = (_unidade.object_index == obj_navio_transporte || 
                                _unidade.object_index == obj_RonaldReagan ||
                                _unidade.object_index == obj_lancha_patrulha ||
                                _unidade.object_index == obj_Constellation ||
                                _unidade.object_index == obj_Independence ||
                                _unidade.object_index == obj_submarino_base);
    
    // Se é um navio, pular processamento de comandos (eles têm Mouse_4 próprio)
    if (_eh_navio_transporte) {
        // Silenciado por padrão para evitar spam no console
        if (variable_global_exists("debug_enabled") && global.debug_enabled && variable_global_exists("verbose_navios") && global.verbose_navios) {
            show_debug_message("⚠️ Navio de transporte detectado - ignorando controle centralizado");
            show_debug_message("   Navio usa Mouse_4 event próprio para movimento");
        }
        // Não fazer nada - o Mouse_4 do navio cuida disso
    } else {

    // Comandos para F-5 (COMANDOS CENTRALIZADOS NO INPUT MANAGER)
    //if (_unidade.object_index == obj_caca_f5) { // Condição removida para generalizar
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

        // Comando de Movimento (Clique Direito) - UNIFICADO PARA TODAS AS UNIDADES
        if (mouse_check_button_pressed(mb_right)) {
            // ✅ NOVO: Verificar se clicou no Porta-Aviões em modo embarque
            var _coords = global.scr_mouse_to_world();
            var _porta_avioes_proximo = instance_position(_coords[0], _coords[1], obj_RonaldReagan);
            
            if (instance_exists(_porta_avioes_proximo)) {
                // Verificar se está em modo embarque
                if (variable_instance_exists(_porta_avioes_proximo, "estado_embarque") &&
                    _porta_avioes_proximo.estado_embarque == "embarcando" &&
                    variable_instance_exists(_unidade, "destino_x")) {
                    
                    // Verificar se é embarcável
                    if (variable_instance_exists(_porta_avioes_proximo, "eh_embarcavel")) {
                        if (_porta_avioes_proximo.eh_embarcavel(_unidade.id)) {
                            // Ordenar unidade para IR PARA O NAVIO
                            _unidade.destino_x = _porta_avioes_proximo.x;
                            _unidade.destino_y = _porta_avioes_proximo.y;
                            
                            // ✅ SETAR FLAG DE EMBARQUE
                            _unidade.indo_embarcar = true;
                            
                            // Ativar movimento se for aéreo
                            if (variable_instance_exists(_unidade, "velocidade_atual")) {
                                _unidade.velocidade_atual = 5;
                            }
                            
                            // Ativar estado de movimento
                            if (variable_instance_exists(_unidade, "estado")) {
                                _unidade.estado = "movendo";
                            }
                            
                            show_debug_message("✅ " + object_get_name(_unidade.object_index) + " recebeu ordem de embarcar no Porta-Aviões!");
                            return; // Não processar movimento normal
                        }
                    }
                }
            }
            
            // ✅ CORREÇÃO: Bloquear movimento do C-100 quando em modo de embarque
            if (object_get_name(_unidade.object_index) == "obj_c100" && _unidade.modo_receber_carga) {
                show_debug_message("🚁 C-100: Comando de movimento bloqueado - modo embarque ativo");
                return; // Não processar movimento
            }
            
            // Se estiver definindo patrulha, adiciona um ponto
            if (global.definindo_patrulha == _unidade && variable_instance_exists(_unidade, "pontos_patrulha")) {
                var _coords_patrulha = global.scr_mouse_to_world();
                // Corrigindo erro GM1041 - usar ds_list_add com parâmetros separados
                ds_list_add(_unidade.pontos_patrulha, _coords_patrulha[0]);
                ds_list_add(_unidade.pontos_patrulha, _coords_patrulha[1]);
                show_debug_message("📍 Ponto de patrulha adicionado");
            } 
            // Senão, é uma ordem de movimento normal
            else {
                // Usar variável já declarada no escopo superior
                var _coords_mov = global.scr_mouse_to_world();
                
                // ✅ CORREÇÃO: Usar a função interna da unidade para dar a ordem de movimento.
                // Isso garante que a própria unidade lide com seus estados e destinos.
                if (variable_instance_exists(_unidade, "ordem_mover")) {
                    // Clamp destino para dentro da sala antes de delegar
                    var _tx = clamp(_coords_mov[0], 8, room_width - 8);
                    var _ty = clamp(_coords_mov[1], 8, room_height - 8);
                    _unidade.ordem_mover(_tx, _ty);
                    show_debug_message("🚢 Ordem de movimento enviada para " + object_get_name(_unidade.object_index) + " via função interna.");
                    
                    // Debug específico para Independence
                    if (object_get_name(_unidade.object_index) == "obj_Independence") {
                        show_debug_message("🚢 INDEPENDENCE: Ordem de movimento recebida!");
                        show_debug_message("🚢 INDEPENDENCE: Destino: (" + string(_tx) + ", " + string(_ty) + ")");
                        // ✅ CORREÇÃO GM2016: Usar variáveis locais para debug
                        var _estado_unidade = variable_instance_exists(_unidade, "estado") ? _unidade.estado : "desconhecido";
                        var _velocidade_unidade = variable_instance_exists(_unidade, "velocidade_movimento") ? _unidade.velocidade_movimento : 0;
                        show_debug_message("🚢 INDEPENDENCE: Estado atual: " + string(_estado_unidade));
                        show_debug_message("🚢 INDEPENDENCE: Velocidade: " + string(_velocidade_unidade));
                        show_debug_message("🚢 INDEPENDENCE: Tem ordem_mover: " + string(variable_instance_exists(_unidade, "ordem_mover")));
                    }
                } 
                // Fallback para unidades mais antigas que não têm a função 'ordem_mover'
                else if (variable_instance_exists(_unidade, "ESTADO_HELICOPTERO")) {
                        _unidade.estado = _unidade.estado == ESTADO_HELICOPTERO.POUSADO ? ESTADO_HELICOPTERO.DECOLANDO : ESTADO_HELICOPTERO.MOVENDO;
                        if (_unidade.estado == ESTADO_HELICOPTERO.DECOLANDO) { _unidade.timer_transicao = 60; }
                        show_debug_message("🎯 Ordem de movimento para helicóptero");
                } else {
                    // ✅ CORREÇÃO CRÍTICA: Sistema legado com clamp para evitar movimento fora da sala
                    var _tx_legacy = clamp(_coords_mov[0], 8, room_width - 8);
                    var _ty_legacy = clamp(_coords_mov[1], 8, room_height - 8);
                    
                    // ✅ CORREÇÃO ADICIONAL: Verificar se o destino é muito diferente do atual
                    var _distancia_atual = point_distance(_unidade.x, _unidade.y, _tx_legacy, _ty_legacy);
                    
                    // ✅ CORREÇÃO GM2016: Verificar se as variáveis existem antes de usar
                    var _distancia_anterior = 0;
                    if (variable_instance_exists(_unidade, "destino_x") && variable_instance_exists(_unidade, "destino_y")) {
                        _distancia_anterior = point_distance(_unidade.x, _unidade.y, _unidade.destino_x, _unidade.destino_y);
                    }
                    
                    // Se o novo destino é muito diferente do anterior, pode ser um erro de zoom
                    if (_distancia_anterior > 0 && abs(_distancia_atual - _distancia_anterior) > 200) {
                        show_debug_message("⚠️ AVISO: Destino muito diferente detectado - pode ser erro de zoom");
                        show_debug_message("   Distância anterior: " + string(_distancia_anterior) + " | Nova: " + string(_distancia_atual));
                        if (variable_instance_exists(_unidade, "destino_x") && variable_instance_exists(_unidade, "destino_y")) {
                            show_debug_message("   Destino anterior: (" + string(_unidade.destino_x) + ", " + string(_unidade.destino_y) + ")");
                        }
                        show_debug_message("   Novo destino: (" + string(_tx_legacy) + ", " + string(_ty_legacy) + ")");
                    }
                    
                    // ✅ CORREÇÃO GM2016: Declarar como var para evitar warning de instância fora do Create
                    var _alvo_unidade_temp = variable_instance_exists(_unidade, "alvo_unidade") ? _unidade.alvo_unidade : noone;
                    var _destino_x_temp = variable_instance_exists(_unidade, "destino_x") ? _unidade.destino_x : _unidade.x;
                    var _destino_y_temp = variable_instance_exists(_unidade, "destino_y") ? _unidade.destino_y : _unidade.y;
                    var _estado_temp = variable_instance_exists(_unidade, "estado") ? _unidade.estado : "parado";
                    
                    // Definir valores usando atribuição direta
                    _unidade.alvo_unidade = noone;
                    _unidade.destino_x = _tx_legacy;
                    _unidade.destino_y = _ty_legacy;
                    _unidade.estado = "movendo";
                    show_debug_message("🎯 Ordem de movimento (legado) para " + object_get_name(_unidade.object_index) + " - Destino: (" + string(_tx_legacy) + ", " + string(_ty_legacy) + ")");
                }
                    
                // Cancela outros modos se existirem
                if (variable_instance_exists(_unidade, "alvo_seguir")) {
                    _unidade.alvo_seguir = noone;
                }
                global.definindo_patrulha = noone;
            }
        }
    //} // Fim do if que foi removido
    } // ✅ FIM DO else para navios de transporte
}