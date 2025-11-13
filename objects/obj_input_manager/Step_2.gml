// ===============================================
// HEGEMONIA GLOBAL - SISTEMA DE CÂMERA ROBUSTO
// Correção para zoom instável e movimentação demorada
// ===============================================

// === DEBUG CONTÍNUO (REDUZIDO PARA MELHOR PERFORMANCE) ===
if (current_time mod 10000 < 17 && global.debug_enabled) { // ✅ Alterado de 3000 para 10000 (10 segundos)
    show_debug_message("[INPUT] Modo construção: " + string(global.modo_construcao) + " | Construindo: " + string(global.construindo_agora));
    show_debug_message("[INPUT] Input Manager está ativo? SIM | Step_2 executando | Room: " + room_get_name(room));
}

// === SISTEMA DE ZOOM ROBUSTO COM LIMITES ===
var _wheel = mouse_wheel_down() - mouse_wheel_up();
if (_wheel != 0) {
    // ✅ CORREÇÃO: Zoom mais suave e responsivo
    var _zoom_factor = 0.25; // ✅ Aumentado para zoom mais responsivo com range maior
    
    zoom_level -= _wheel * _zoom_factor;
    // ✅ LIMITE MÍNIMO: 3.5 (não pode diminuir mais - jogo fica lento)
    // ✅ LIMITE MÁXIMO: 25.0 (pode ampliar bastante)
    zoom_level = clamp(zoom_level, 3.5, 25.0);
}

// === SISTEMA DE MOVIMENTO DE CÂMERA ROBUSTO ===
if (mouse_check_button(mb_middle)) {
    var _dx = window_mouse_get_x() - mouse_x_previous;
    var _dy = window_mouse_get_y() - mouse_y_previous;
    
    // ✅ CORREÇÃO: Movimento mais responsivo
    var _move_sensitivity = 1.2; // Aumentar sensibilidade
    camera_x -= _dx * zoom_level * _move_sensitivity;
    camera_y -= _dy * zoom_level * _move_sensitivity;
    
    // ✅ REMOVIDO: Debug do movimento da câmera que causa lentidão
    // Debug removido para melhorar performance
}

// === CONTROLE POR TECLADO WASD (FUNCIONA SEMPRE, EXCETO EM CONSTRUÇÃO) ===
// ✅ CORREÇÃO: WASD deve funcionar mesmo com menus abertos (mas não durante construção)
if (!instance_exists(global.construindo_edificio)) {
    // ✅ CORREÇÃO: Velocidade inversamente proporcional ao zoom - zoom alto = movimento mais lento
    var _spd = camera_speed * (1.0 / zoom_level) * 4.0;
    
    // Debug temporário para verificar se WASD está sendo detectado
    var _wasd_pressed = false;
    
    if (keyboard_check(ord("W"))) { 
        camera_y -= _spd;
        _wasd_pressed = true;
    }
    if (keyboard_check(ord("S"))) { 
        camera_y += _spd;
        _wasd_pressed = true;
    }
    if (keyboard_check(ord("A"))) { 
        camera_x -= _spd;
        _wasd_pressed = true;
    }
    if (keyboard_check(ord("D"))) { 
        camera_x += _spd;
        _wasd_pressed = true;
    }
    
    // ✅ REMOVIDO: Debug excessivo do WASD que causa lentidão
    // Debug removido para melhorar performance
} else {
    // Debug: Mostrar por que WASD está bloqueado
    if (current_time mod 3000 < 17) {
        show_debug_message("⚠️ WASD bloqueado - Construindo edifício: " + string(global.construindo_edificio));
    }
}

// === LIMITAR POSIÇÃO DA CÂMERA PARA EVITAR BUGS ===
// ✅ CORREÇÃO: Zoom deve DIVIDIR (não multiplicar) - zoom maior = câmera menor = ver mais perto
var _cam_w_planned = room_width / zoom_level;
var _cam_h_planned = room_height / zoom_level;

// ✅ Limitar posição da câmera permitindo apenas 10 pixels de borda preta fora do mapa
var _borda_maxima = 10; // Apenas 10 pixels de borda fora do mapa
camera_x = clamp(camera_x, _cam_w_planned / 2 - _borda_maxima, room_width - _cam_w_planned / 2 + _borda_maxima);
camera_y = clamp(camera_y, _cam_h_planned / 2 - _borda_maxima, room_height - _cam_h_planned / 2 + _borda_maxima);

// === ATUALIZAÇÃO IMEDIATA DA CÂMERA (COM CACHE) ===
// ✅ OTIMIZAÇÃO: Cachear dimensões da câmera para evitar atualizações desnecessárias
// ✅ CORREÇÃO GM2016: Usar variáveis locais em vez de instância fora do Create
var _cam_cache_w = variable_instance_exists(id, "cam_cache_w") ? cam_cache_w : -1;
var _cam_cache_h = variable_instance_exists(id, "cam_cache_h") ? cam_cache_h : -1;

// Só atualizar câmera se as dimensões mudaram
if (_cam_cache_w != _cam_w_planned || _cam_cache_h != _cam_h_planned) {
    camera_set_view_size(camera, _cam_w_planned, _cam_h_planned);
    // ✅ CORREÇÃO GM2016: Variáveis já declaradas no Create, apenas atualizar
    cam_cache_w = _cam_w_planned;
    cam_cache_h = _cam_h_planned;
}

// Atualizar posição sempre (mas dimensões apenas quando necessário)
camera_set_view_pos(camera, camera_x - _cam_w_planned / 2, camera_y - _cam_h_planned / 2);

// === SISTEMA DE COORDENADAS UNIFICADO ===
// ✅ CORREÇÃO: Criar função global para coordenadas (compatibilidade)
if (!variable_global_exists("scr_mouse_to_world")) {
    // Função global para conversão de coordenadas
    global.scr_mouse_to_world = function() {
        // Usar nossa função centralizada
        return scr_mouse_to_world();
    };
}

// === REMOVIDO: COMANDOS DE TECLADO C E B ===
// ✅ CORREÇÃO: Teclas C e B foram movidas para Step_0 para evitar duplicação
// As teclas agora são processadas apenas no Step_0 para evitar toggle duplo

// --- LÓGICA DE INPUT DE JOGO (LEGACY COM SUPORTE A ZOOM) ---
if (instance_exists(global.construindo_edificio)) {
    // ✅ CORREÇÃO: Usar função global para coordenadas
    var _coords = global.scr_mouse_to_world();
    var _world_mouse_x = _coords[0];
    var _world_mouse_y = _coords[1];
    
    var _grid_x = floor(_world_mouse_x / global.tile_size) * global.tile_size;
    var _grid_y = floor(_world_mouse_y / global.tile_size) * global.tile_size;
    global.construindo_edificio.x = _grid_x;
    global.construindo_edificio.y = _grid_y;

    if (mouse_check_button_pressed(mb_left)) {
        // <-- CORREÇÃO APLICADA AQUI
        var _menu_y = window_get_height() - 100;
        if (mouse_y < _menu_y) {
            global.construindo_edificio = noone;
        }
    }
    if (mouse_check_button_pressed(mb_right)) {
        instance_destroy(global.construindo_edificio);
        global.construindo_edificio = noone;
    }
}

// === OUTROS COMANDOS DE DEBUG E TESTE ===
if (!instance_exists(global.construindo_edificio)) {
    
    // === DEBUG: TECLA R PARA FORÇAR PESQUISA (BYPASS DO CLIQUE) ===
    if (keyboard_check_pressed(ord("R"))) {
        show_debug_message("=== TESTE FORÇADO: INICIANDO PESQUISA DE BORRACHA ===");
        
        if (ds_exists(global.nacao_recursos, ds_type_map) && ds_exists(global.research_timers, ds_type_map)) {
            var _test_research = "Borracha";
            var _test_cost = 6000;
            
            if (global.dinheiro >= _test_cost && global.slots_pesquisa_usados < global.slots_pesquisa_total) {
                // Forçar início da pesquisa
                global.dinheiro -= _test_cost;
                global.nacao_recursos[? _test_research] = RESOURCE_STATUS.RESEARCHING;
                global.slots_pesquisa_usados++;
                global.research_timers[? _test_research] = 30 * game_get_speed(gamespeed_fps); // 30 segundos
                
                show_debug_message("✅ PESQUISA FORÇADA INICIADA COM SUCESSO!");
                show_debug_message("Recurso: " + _test_research);
                show_debug_message("Custo: $" + string(_test_cost));
                show_debug_message("Dinheiro restante: $" + string(global.dinheiro));
                show_debug_message("Slots: " + string(global.slots_pesquisa_usados) + "/" + string(global.slots_pesquisa_total));
            } else {
                show_debug_message("❌ FALHA: Dinheiro insuficiente ou sem slots");
                show_debug_message("Dinheiro: $" + string(global.dinheiro) + " (precisa $" + string(_test_cost) + ")");
                show_debug_message("Slots: " + string(global.slots_pesquisa_usados) + "/" + string(global.slots_pesquisa_total));
            }
        } else {
            show_debug_message("❌ FALHA: Variáveis globais não estão configuradas corretamente");
        }
        
        show_debug_message("=====================================================");
    }
    
    // === TESTE DE FUNCIONAMENTO DO TECLADO ===
    if (keyboard_check_pressed(ord("X"))) {
        show_debug_message("*** TECLA X FUNCIONA! O TECLADO ESTÁ RESPONDENDO ***");
    }
    
    // === COMANDOS TÁTICOS PARA UNIDADES SELECIONADAS (REMOVIDOS - DUPLICADOS) ===
    // Comandos E e Q já estão centralizados no Step_0 do obj_input_manager
    // Comandos de movimento e ataque também já estão no Step_0
    // Este código foi removido para evitar duplicação
    
    // === LÓGICA DE CONSTRUÇÃO NO MAPA (COM SUPORTE A ZOOM) ===
    // CANCELAMENTO COM CLIQUE DIREITO
    if (mouse_check_button_pressed(mb_right) && global.construindo_agora != noone) {
        global.construindo_agora = noone;
        show_debug_message("[INPUT MANAGER] Construção cancelada com clique direito");
    }
    
    if (mouse_check_button_pressed(mb_left) && global.construindo_agora != noone) {
        // Verifica se não clicou no menu
        var _menu_y = display_get_gui_height() - 100;
        if (mouse_y < _menu_y) {
            // ✅ CORREÇÃO: Usar função global para coordenadas
            var _coords = scr_mouse_to_world();
            var _world_mouse_x = _coords[0];
            var _world_mouse_y = _coords[1];
            
            // ✅ NOVA VERIFICAÇÃO: Verificar se clicou em edifício primeiro
            var _edificio_clicado = collision_point(_world_mouse_x, _world_mouse_y, obj_aeroporto_militar, false, true);
            if (_edificio_clicado == noone) {
                _edificio_clicado = collision_point(_world_mouse_x, _world_mouse_y, obj_quartel, false, true);
            }
            if (_edificio_clicado == noone) {
                _edificio_clicado = collision_point(_world_mouse_x, _world_mouse_y, obj_quartel_marinha, false, true);
            }
            if (_edificio_clicado == noone) {
                _edificio_clicado = collision_point(_world_mouse_x, _world_mouse_y, obj_casa, false, true);
            }
            if (_edificio_clicado == noone) {
                _edificio_clicado = collision_point(_world_mouse_x, _world_mouse_y, obj_banco, false, true);
            }
            if (_edificio_clicado == noone) {
                _edificio_clicado = collision_point(_world_mouse_x, _world_mouse_y, obj_fazenda, false, true);
            }
            
            // Se clicou em edifício, NÃO processar construção
            if (_edificio_clicado != noone) {
                show_debug_message("[INPUT MANAGER] Clique em edifício detectado - permitindo interação do edifício");
                exit; // Sair sem processar construção
            }
            
            // Se não clicou em edifício, continuar com a lógica de construção...
            // Construir edifício no local clicado (usando coordenadas do mundo)
            var _build_x = floor(_world_mouse_x / global.tile_size) * global.tile_size;
            var _build_y = floor(_world_mouse_y / global.tile_size) * global.tile_size;
            
            var _building_cost = 0;
            var _building_name = "";
            
            // Determinar custo baseado no objeto selecionado
            if (global.construindo_agora == asset_get_index("obj_casa")) {
                _building_cost = 1000;
                _building_name = "Casa";
            } else if (global.construindo_agora == asset_get_index("obj_banco")) {
                _building_cost = 2500;
                _building_name = "Banco";
            } else if (global.construindo_agora == asset_get_index("obj_quartel")) {
                _building_cost = 800;
                _building_name = "Quartel";
            } else if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
                _building_cost = 600;
                _building_name = "Quartel de Marinha";
            } else if (global.construindo_agora == asset_get_index("obj_fazenda")) {
                _building_cost = 2500000; // $2.500.000 CG
                _building_name = "Fazenda";
            } else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
                // ✅ AEROPORTO PROCESSADO PELO obj_controlador_construcao
                show_debug_message("[INPUT MANAGER] Aeroporto será processado pelo controlador de construção");
                exit; // Sair para deixar o controlador de construção processar
            }
            
            // Verificar se tem dinheiro e construir
            if (global.dinheiro >= _building_cost) {
                // Descontar dinheiro
                global.dinheiro -= _building_cost;
                
                // Criar edifício - CORREÇÃO GM1041
                var _new_building = noone;
                
                // Determinar qual objeto criar baseado no tipo
                if (global.construindo_agora == asset_get_index("obj_casa")) {
                    _new_building = instance_create_layer(_build_x, _build_y, "Instances", obj_casa);
                } else if (global.construindo_agora == asset_get_index("obj_banco")) {
                    _new_building = instance_create_layer(_build_x, _build_y, "Instances", obj_banco);
                } else if (global.construindo_agora == asset_get_index("obj_quartel")) {
                    _new_building = instance_create_layer(_build_x, _build_y, "Instances", obj_quartel);
                } else if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
                    _new_building = instance_create_layer(_build_x, _build_y, "Instances", obj_quartel_marinha);
                } else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
                    _new_building = instance_create_layer(_build_x, _build_y, "Instances", obj_aeroporto_militar);
                }
                
                if (instance_exists(_new_building)) {
                    show_debug_message("=== EDIFÍCIO CONSTRUÍDO (ZOOM: " + string(zoom_level) + ") ===");
                    show_debug_message("Tipo: " + _building_name);
                    show_debug_message("Custo: $" + string(_building_cost));
                    show_debug_message("Mouse: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
                    show_debug_message("Mundo: (" + string(_world_mouse_x) + ", " + string(_world_mouse_y) + ")");
                    show_debug_message("Posição: (" + string(_build_x) + ", " + string(_build_y) + ")");
                    show_debug_message("Dinheiro restante: $" + string(global.dinheiro));
                    
                    // Limpar seleção após construir
                    global.construindo_agora = noone;
                } else {
                    // Reembolsar se falhou
                    global.dinheiro += _building_cost;
                    show_debug_message("ERRO: Falha ao construir edifício!");
                }
            } else {
                show_debug_message("DINHEIRO INSUFICIENTE!");
                show_debug_message("Precisa: $" + string(_building_cost) + ", Tem: $" + string(global.dinheiro));
            }
        }
    }
}

// --- ATUALIZAÇÕES FINAIS ---
mouse_x_previous = window_mouse_get_x();
mouse_y_previous = window_mouse_get_y();

// ✅ OTIMIZAÇÃO: Removida atualização duplicada da câmera (já atualizada acima com cache)
// A câmera já é atualizada no início do Step com sistema de cache


// Tecla Q: Teste específico do quartel
if (keyboard_check_pressed(ord("Q"))) {
    show_debug_message("🔧 Teste do quartel iniciado...");
    // Chamada direta - se função não existir, será ignorada
    try {
        scr_teste_quartel_funcional();
    } catch (e) {
        show_debug_message("⚠️ Função scr_teste_quartel_funcional não encontrada");
    }
}

// Tecla R: Teste de criação manual de unidade
if (keyboard_check_pressed(ord("R"))) {
    show_debug_message("🔧 Teste de criação manual iniciado...");
    // Chamada direta - se função não existir, será ignorada
    try {
        scr_teste_criacao_unidade_manual();
    } catch (e) {
        show_debug_message("⚠️ Função scr_teste_criacao_unidade_manual não encontrada");
    }
}

// Tecla F: Diagnóstico do fantasma de construção
if (keyboard_check_pressed(ord("F"))) {
    show_debug_message("🔍 Iniciando diagnóstico do fantasma de construção...");
    try {
        scr_diagnostico_fantasma_construcao();
    } catch (e) {
        show_debug_message("⚠️ Função scr_diagnostico_fantasma_construcao não encontrada");
    }
}

// Tecla G: Teste manual do fantasma
if (keyboard_check_pressed(ord("G"))) {
    show_debug_message("🧪 Iniciando teste manual do fantasma...");
    try {
        scr_teste_fantasma_manual();
    } catch (e) {
        show_debug_message("⚠️ Função scr_teste_fantasma_manual não encontrada");
    }
}

// Tecla H: Forçar fantasma
if (keyboard_check_pressed(ord("H"))) {
    show_debug_message("🔥 Forçando fantasma de construção...");
    try {
        scr_forcar_fantasma();
    } catch (e) {
        show_debug_message("⚠️ Função scr_forcar_fantasma não encontrada");
    }
}

// Tecla F9: Diagnóstico da IA
if (keyboard_check_pressed(vk_f9)) {
    show_debug_message("🔍 Executando diagnóstico da IA...");
    try {
        scr_diagnostico_ia();
    } catch (e) {
        show_debug_message("⚠️ Função scr_diagnostico_ia não encontrada");
    }
}