// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE CONSTRUÇÃO
// Fase 4: Lógica de Posição do Fantasma (COM SUPORTE A ZOOM E CANCELAMENTO)
// =========================================================

// CANCELAMENTO COM CLIQUE DIREITO
if (mouse_check_button_pressed(mb_right) && global.construindo_agora != noone) {
    global.construindo_agora = noone;
    show_debug_message("[CONSTRUÇÃO] Fantasma cancelado com clique direito");
    exit; // Sair imediatamente após cancelamento
}

// Só faz alguma coisa se tivermos um edifício selecionado para construir.
if (global.construindo_agora != noone) {
    // CONVERTER COORDENADAS DO MOUSE PARA O MUNDO (SUPORTE A ZOOM)
    // Buscar o objeto input_manager para acessar as variáveis da câmera
    var _input_manager = instance_find(obj_input_manager, 0);
    
    if (instance_exists(_input_manager)) {
        // CORREÇÃO: Usar coordenadas da câmera já atualizadas
        // Obter coordenadas da câmera (sincronizadas com a view)
        var _cam_x = _input_manager.camera_x - (room_width * _input_manager.zoom_level) / 2;
        var _cam_y = _input_manager.camera_y - (room_height * _input_manager.zoom_level) / 2;
        
        // Converter mouse para coordenadas do mundo com precisão melhorada
        var _world_mouse_x = _cam_x + (mouse_x * _input_manager.zoom_level);
        var _world_mouse_y = _cam_y + (mouse_y * _input_manager.zoom_level);
        
        // MELHORAR SEGUIMENTO DO MOUSE - usar coordenadas mais precisas
        // Calcula a posição do mouse no mundo e a "trava" no grid mais próximo.
        // A função floor() arredonda o número para baixo, garantindo o alinhamento.
        var _new_grid_x = floor(_world_mouse_x / tile_size) * tile_size;
        var _new_grid_y = floor(_world_mouse_y / tile_size) * tile_size;
        
        // Atualizar posição imediatamente (sem interpolação para evitar atraso)
        grid_x = _new_grid_x;
        grid_y = _new_grid_y;
        
        // DEBUG: Mostrar informações de posição quando zoom != 1.0 ou movimento rápido detectado
        var _distance_moved = point_distance(grid_x, grid_y, _new_grid_x, _new_grid_y);
        if (_input_manager.zoom_level != 1.0 || _distance_moved > tile_size) {
            show_debug_message("[CONSTRUÇÃO] Zoom: " + string(_input_manager.zoom_level) + 
                             " | Mouse: (" + string(mouse_x) + ", " + string(mouse_y) + ")" +
                             " | Mundo: (" + string(_world_mouse_x) + ", " + string(_world_mouse_y) + ")" +
                             " | Grid: (" + string(grid_x) + ", " + string(grid_y) + ")" +
                             " | Dist: " + string(_distance_moved) +
                             " | Câmera: (" + string(_input_manager.camera_x) + ", " + string(_input_manager.camera_y) + ")");
        }
    } else {
        // Fallback: usar coordenadas diretas se não encontrar o input manager
        grid_x = floor(mouse_x / tile_size) * tile_size;
        grid_y = floor(mouse_y / tile_size) * tile_size;
        show_debug_message("AVISO: obj_input_manager não encontrado, usando coordenadas diretas");
    }
}