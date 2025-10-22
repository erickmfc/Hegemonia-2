// ===============================================
// HEGEMONIA GLOBAL - SISTEMA DE CÂMERA ROBUSTO
// Correção para zoom instável e movimentação demorada
// ===============================================

// === DEBUG CONTÍNUO (A CADA 3 SEGUNDOS) ===
if (current_time mod 3000 < 17) { // Aprox. a cada 3 segundos
    show_debug_message("[INPUT] Modo construção: " + string(global.modo_construcao) + " | Construindo: " + string(global.construindo_agora));
}

// === SISTEMA DE ZOOM ROBUSTO ===
var _wheel = mouse_wheel_down() - mouse_wheel_up();
if (_wheel != 0) {
    // ✅ CORREÇÃO: Zoom mais suave e responsivo
    var _zoom_factor = 0.15; // Aumentar sensibilidade
    var _old_zoom = zoom_level;
    
    zoom_level -= _wheel * _zoom_factor;
    zoom_level = clamp(zoom_level, 0.2, 3.0); // Ampliar range de zoom
    
    // Debug do zoom
    if (abs(_old_zoom - zoom_level) > 0.01) {
        show_debug_message("🔍 ZOOM: " + string(_old_zoom) + " → " + string(zoom_level) + " (Δ" + string(_wheel) + ")");
    }
}

// === SISTEMA DE MOVIMENTO DE CÂMERA ROBUSTO ===
if (mouse_check_button(mb_middle)) {
    var _dx = window_mouse_get_x() - mouse_x_previous;
    var _dy = window_mouse_get_y() - mouse_y_previous;
    
    // ✅ CORREÇÃO: Movimento mais responsivo
    var _move_sensitivity = 1.2; // Aumentar sensibilidade
    camera_x -= _dx * zoom_level * _move_sensitivity;
    camera_y -= _dy * zoom_level * _move_sensitivity;
    
    // Debug do movimento
    if (abs(_dx) > 2 || abs(_dy) > 2) {
        show_debug_message("📷 CÂMERA: (" + string(camera_x) + ", " + string(camera_y) + ") Δ(" + string(_dx) + ", " + string(_dy) + ")");
    }
}

// === CONTROLE POR TECLADO MELHORADO ===
var _spd = camera_speed * zoom_level * 1.5; // ✅ CORREÇÃO: Velocidade aumentada
if (keyboard_check(ord("W"))) { 
    camera_y -= _spd;
    show_debug_message("⬆️ CÂMERA: W - Y: " + string(camera_y));
}
if (keyboard_check(ord("S"))) { 
    camera_y += _spd;
    show_debug_message("⬇️ CÂMERA: S - Y: " + string(camera_y));
}
if (keyboard_check(ord("A"))) { 
    camera_x -= _spd;
    show_debug_message("⬅️ CÂMERA: A - X: " + string(camera_x));
}
if (keyboard_check(ord("D"))) { 
    camera_x += _spd;
    show_debug_message("➡️ CÂMERA: D - X: " + string(camera_x));
}

// === ATUALIZAÇÃO IMEDIATA DA CÂMERA ===
// ✅ CORREÇÃO: Atualizar câmera IMEDIATAMENTE para evitar lag
var _cam_w = room_width * zoom_level;
var _cam_h = room_height * zoom_level;
camera_set_view_size(camera, _cam_w, _cam_h);
camera_set_view_pos(camera, camera_x - _cam_w / 2, camera_y - _cam_h / 2);

// === SISTEMA DE COORDENADAS UNIFICADO ===
// ✅ CORREÇÃO: Criar função global para coordenadas
if (!variable_global_exists("scr_mouse_to_world")) {
    // Função global para conversão de coordenadas
    global.scr_mouse_to_world = function() {
        // Usar nossa função centralizada
        return scr_mouse_to_world();
    };
    show_debug_message("✅ Função global scr_mouse_to_world inicializada");
}

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
} else {
    // Research menu control - Press B to open/close
    if (keyboard_check_pressed(ord("B"))) {
        global.menu_pesquisa_aberto = !global.menu_pesquisa_aberto;
        show_debug_message("Research menu toggled: " + string(global.menu_pesquisa_aberto));
    }
    
    // === DEBUG: TECLA T PARA TESTAR SISTEMA DE PESQUISA ===
    if (keyboard_check_pressed(ord("T"))) {
        show_debug_message("========== TESTE DE DEBUG DO SISTEMA DE PESQUISA ==========");
        show_debug_message("global.menu_pesquisa_aberto: " + string(global.menu_pesquisa_aberto));
        
        if (instance_exists(obj_research_center)) {
            show_debug_message("obj_research_center existe: SIM");
        } else if (instance_exists(obj_centro_pesquisa)) {
            show_debug_message("obj_centro_pesquisa existe: SIM (fallback)");
        } else {
            show_debug_message("Nenhum objeto de pesquisa existe: NÃO");
        }
        
        show_debug_message("global.dinheiro: $" + string(global.dinheiro));
        show_debug_message("global.slots_pesquisa_usados/total: " + string(global.slots_pesquisa_usados) + "/" + string(global.slots_pesquisa_total));
        
        if (ds_exists(global.nacao_recursos, ds_type_map)) {
            show_debug_message("global.nacao_recursos: OK (" + string(ds_map_size(global.nacao_recursos)) + " entradas)");
        } else {
            show_debug_message("global.nacao_recursos: ERRO - não é um ds_map válido");
        }
        
        if (ds_exists(global.research_timers, ds_type_map)) {
            show_debug_message("global.research_timers: OK (" + string(ds_map_size(global.research_timers)) + " entradas)");
        } else {
            show_debug_message("global.research_timers: ERRO - não é um ds_map válido");
        }
        
        show_debug_message("==============================================================");
    }
    
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
    


    // === TECLA C PARA ATIVAR/DESATIVAR MODO DE CONSTRUÇÃO ===
    if (keyboard_check_pressed(ord("C"))) {
        show_debug_message("=== TECLA C PRESSIONADA ===");
        show_debug_message("Estado atual global.modo_construcao: " + string(global.modo_construcao));
        
        // DEBUG: Verificar se o menu de construção existe
        var _menu_instance = instance_find(obj_menu_construcao, 0);
        if (instance_exists(_menu_instance)) {
            show_debug_message("MENU ENCONTRADO! ID: " + string(_menu_instance) + " | Visível: " + string(_menu_instance.visible));
        } else {
            show_debug_message("ERRO: Menu de construção NÃO encontrado!");
        }
        
        global.modo_construcao = !global.modo_construcao;
        
        if (global.modo_construcao) {
            show_debug_message("MODO DE CONSTRUÇÃO: ATIVADO");
            show_debug_message("Verificar se menu aparece na tela");
        } else {
            show_debug_message("MODO DE CONSTRUÇÃO: DESATIVADO");
            global.construcao_selecionada = ""; // Limpa seleção ao desativar
            global.construindo_agora = noone; // Limpa seleção de construção
        }
        
        show_debug_message("Novo estado global.modo_construcao: " + string(global.modo_construcao));
        show_debug_message("===========================");
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

// ATUALIZAR CÂMERA PRIMEIRO para sincronizar com cálculos de coordenadas
var _cam_w_final = room_width * zoom_level;
var _cam_h_final = room_height * zoom_level;
camera_set_view_size(camera, _cam_w_final, _cam_h_final);
camera_set_view_pos(camera, camera_x - _cam_w_final / 2, camera_y - _cam_h_final / 2);

// === COMANDOS DE TESTE ===
// Tecla T: Teste de sistema
if (keyboard_check_pressed(ord("T"))) {
    show_debug_message("=== TESTE DE SISTEMA ===");
    show_debug_message("FPS: " + string(fps));
    show_debug_message("Instâncias ativas: " + string(instance_count));
    show_debug_message("Memória em uso: " + string(memory_get_usage() / 1024 / 1024) + " MB");
}

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