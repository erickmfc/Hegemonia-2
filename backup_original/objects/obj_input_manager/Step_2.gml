// === DEBUG CONTÍNUO (A CADA 3 SEGUNDOS) ===
if (current_time mod 3000 < 17) { // Aprox. a cada 3 segundos
    show_debug_message("[INPUT] Modo construção: " + string(global.modo_construcao) + " | Construindo: " + string(global.construindo_agora));
}

// --- CONTROLE DE CÂMERA ---
var _wheel = mouse_wheel_down() - mouse_wheel_up();
if (_wheel != 0) {
    zoom_level -= _wheel * 0.1 * zoom_level;
    zoom_level = clamp(zoom_level, 0.1, 2.0);
}
if (mouse_check_button(mb_middle)) {
    var _dx = window_mouse_get_x() - mouse_x_previous;
    var _dy = window_mouse_get_y() - mouse_y_previous;
    camera_x -= _dx * zoom_level;
    camera_y -= _dy * zoom_level;
}
var _spd = camera_speed * zoom_level;
if (keyboard_check(ord("W"))) { camera_y -= _spd; }
if (keyboard_check(ord("S"))) { camera_y += _spd; }
if (keyboard_check(ord("A"))) { camera_x -= _spd; }
if (keyboard_check(ord("D"))) { camera_x += _spd; }

// --- LÓGICA DE INPUT DE JOGO (LEGACY COM SUPORTE A ZOOM) ---
if (instance_exists(global.construindo_edificio)) {
    // CONVERTER COORDENADAS DO MOUSE PARA O MUNDO (SUPORTE A ZOOM)
    // CORREÇÃO: Usar coordenadas da câmera já atualizadas
    var _cam_x = camera_x - (room_width * zoom_level) / 2;
    var _cam_y = camera_y - (room_height * zoom_level) / 2;
    
    // Converter mouse para coordenadas do mundo com precisão melhorada
    var _world_mouse_x = _cam_x + (mouse_x * zoom_level);
    var _world_mouse_y = _cam_y + (mouse_y * zoom_level);
    
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
        } else {
            show_debug_message("obj_research_center existe: NÃO");
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
        global.modo_construcao = !global.modo_construcao;
        
        if (global.modo_construcao) {
            show_debug_message("MODO DE CONSTRUÇÃO: ATIVADO");
            // Criar menu e controlador se não existirem
            if (!instance_exists(obj_menu_construcao)) {
                instance_create_layer(0, 0, "Instances", obj_menu_construcao);
                show_debug_message("✅ obj_menu_construcao criado.");
            }
            if (!instance_exists(obj_controlador_construcao)) {
                instance_create_layer(0, 0, "Instances", obj_controlador_construcao);
                show_debug_message("✅ obj_controlador_construcao criado.");
            }
        } else {
            show_debug_message("MODO DE CONSTRUÇÃO: DESATIVADO");
            // Limpa seleção e destrói os objetos de construção
            global.construindo_agora = noone;
            
            with (obj_menu_construcao) {
                instance_destroy();
                show_debug_message("✅ obj_menu_construcao destruído.");
            }
            with (obj_controlador_construcao) {
                instance_destroy();
                show_debug_message("✅ obj_controlador_construcao destruído.");
            }
        }
        
        show_debug_message("Novo estado global.modo_construcao: " + string(global.modo_construcao));
        show_debug_message("===========================");
    }
    
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
            // CONVERTER COORDENADAS DO MOUSE PARA O MUNDO (SUPORTE A ZOOM)
            var _cam_x = camera_x - (room_width * zoom_level) / 2;
            var _cam_y = camera_y - (room_height * zoom_level) / 2;
            
            // Converter mouse para coordenadas do mundo
            var _world_mouse_x = _cam_x + (mouse_x * zoom_level);
            var _world_mouse_y = _cam_y + (mouse_y * zoom_level);
            
            // Construir edifício no local clicado (usando coordenadas do mundo)
            var _build_x = floor(_world_mouse_x / global.tile_size) * global.tile_size;
            var _build_y = floor(_world_mouse_y / global.tile_size) * global.tile_size;
            
            // --- LÓGICA REATORADA USANDO DS_MAP ---
            var _building_data = global.building_definitions[? global.construindo_agora];
            
            // Verificar se tem dinheiro e construir
            if (_building_data != undefined && global.dinheiro >= _building_data.cost) {
                // Descontar dinheiro
                global.dinheiro -= _building_data.cost;
                
                // Criar o edifício usando os dados da struct
                var _new_building = instance_create_layer(
                    _build_x, 
                    _build_y, 
                    "Instances", 
                    _building_data.object
                );
                
                if (instance_exists(_new_building)) {
                    show_debug_message("=== EDIFÍCIO CONSTRUÍDO (ZOOM: " + string(zoom_level) + ") ===");
                    show_debug_message("Tipo: " + _building_data.name);
                    show_debug_message("Custo: $" + string(_building_data.cost));
                    show_debug_message("Mouse: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
                    show_debug_message("Mundo: (" + string(_world_mouse_x) + ", " + string(_world_mouse_y) + ")");
                    show_debug_message("Posição: (" + string(_build_x) + ", " + string(_build_y) + ")");
                    show_debug_message("Dinheiro restante: $" + string(global.dinheiro));
                    
                    // Limpar seleção após construir
                    global.construindo_agora = noone;
                } else {
                    // Reembolsar se falhou
                    global.dinheiro += _building_data.cost;
                    show_debug_message("ERRO: Falha ao construir edifício!");
                }
            } else {
                show_debug_message("DINHEIRO INSUFICIENTE!");
                show_debug_message("Precisa: $" + string(_building_data.cost) + ", Tem: $" + string(global.dinheiro));
            }
        }
    }
}

// --- ATUALIZAÇÕES FINAIS ---
mouse_x_previous = window_mouse_get_x();
mouse_y_previous = window_mouse_get_y();

// ATUALIZAR CÂMERA PRIMEIRO para sincronizar com cálculos de coordenadas
var _cam_w = room_width * zoom_level;
var _cam_h = room_height * zoom_level;
camera_set_view_size(camera, _cam_w, _cam_h);
camera_set_view_pos(camera, camera_x - _cam_w / 2, camera_y - _cam_h / 2);