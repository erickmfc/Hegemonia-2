// ===============================================
// HEGEMONIA GLOBAL - MINIMAP
// Evento Mouse Left Pressed - Clique para mover câmera
// ===============================================

// Verificar se o minimap está visível
if (!minimap_visible) {
    exit;
}

// Verificações de segurança
if (!variable_global_exists("map_width") || !variable_global_exists("map_height")) {
    exit;
}
if (!variable_global_exists("tile_size")) {
    exit;
}

// === CONFIGURAÇÃO DO MINIMAP ===
var _minimap_size = minimap_size;
var _minimap_margin = minimap_margin;
var _minimap_x = display_get_gui_width() - _minimap_size - _minimap_margin;
var _minimap_y = _minimap_margin;

// Obter coordenadas do mouse na GUI
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

// Verificar se o clique foi dentro do minimap
if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                      _minimap_x, _minimap_y, 
                      _minimap_x + _minimap_size, _minimap_y + _minimap_size)) {
    
    // === CALCULAR COORDENADAS DO MUNDO ===
    var _map_world_width = global.map_width * global.tile_size;
    var _map_world_height = global.map_height * global.tile_size;
    var _scale_x = _minimap_size / _map_world_width;
    var _scale_y = _minimap_size / _map_world_height;
    
    // Converter posição do clique no minimap para coordenadas do mundo
    // Posição relativa dentro do minimap (0.0 a 1.0)
    var _rel_x = (_mouse_gui_x - _minimap_x) / _minimap_size;
    var _rel_y = (_mouse_gui_y - _minimap_y) / _minimap_size;
    
    // Converter para coordenadas do mundo
    var _target_world_x = _rel_x * _map_world_width;
    var _target_world_y = _rel_y * _map_world_height;
    
    // === MOVER CÂMERA IMEDIATAMENTE ===
    // Obter referência da câmera do input_manager
    if (instance_exists(obj_input_manager)) {
        var _cam = obj_input_manager.camera;
        
        if (_cam != noone) {
            // Obter dimensões planejadas da câmera (baseado no zoom)
            var _cam_w_planned = room_width / obj_input_manager.zoom_level;
            var _cam_h_planned = room_height / obj_input_manager.zoom_level;
            
            // Centralizar a câmera no ponto clicado
            // camera_x e camera_y são o CENTRO da viewport
            var _new_cam_x = _target_world_x;
            var _new_cam_y = _target_world_y;
            
            // Limitar posição da câmera dentro dos limites do mapa
            var _borda_maxima = 10;
            _new_cam_x = clamp(_new_cam_x, _cam_w_planned / 2 - _borda_maxima, room_width - _cam_w_planned / 2 + _borda_maxima);
            _new_cam_y = clamp(_new_cam_y, _cam_h_planned / 2 - _borda_maxima, room_height - _cam_h_planned / 2 + _borda_maxima);
            
            // ✅ MOVER CÂMERA IMEDIATAMENTE
            obj_input_manager.camera_x = _new_cam_x;
            obj_input_manager.camera_y = _new_cam_y;
            
            // Atualizar posição da câmera imediatamente (usando mesma lógica do Step_2)
            camera_set_view_pos(_cam, _new_cam_x - _cam_w_planned / 2, _new_cam_y - _cam_h_planned / 2);
            
            show_debug_message("✅ Minimap: Câmera movida para (" + string(_target_world_x) + ", " + string(_target_world_y) + ")");
        }
    }
}
