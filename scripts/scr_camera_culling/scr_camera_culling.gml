/// @description Sistema de Culling Otimizado para Câmera
/// Retorna área visível em coordenadas de tile

// ===============================================
// CALCULA ÁREA DE CULLING (tiles visíveis)
// ===============================================
/// @description Calcula e retorna área de tiles visíveis
/// @return {Array<Real>} [tile_start_x, tile_start_y, tile_end_x, tile_end_y]
function scr_calculate_culling_area() {
    var cam = view_camera[0];
    if (cam == noone || !camera_exists(cam)) {
        // Fallback: toda a room
        var _tile_size = variable_global_exists("tile_size") ? global.tile_size : 32;
        return [
            floor(0 / _tile_size),
            floor(0 / _tile_size),
            ceil(room_width / _tile_size),
            ceil(room_height / _tile_size)
        ];
    }
    
    // Coordenadas da viewport
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    // Margem extra para evitar pop-in (256 pixels)
    var margin = 256;
    
    // Calcula quais tiles desenhar
    var tile_start_x = floor((cam_x - margin) / global.tile_size);
    var tile_start_y = floor((cam_y - margin) / global.tile_size);
    var tile_end_x = ceil((cam_x + cam_w + margin) / global.tile_size);
    var tile_end_y = ceil((cam_y + cam_h + margin) / global.tile_size);
    
    // Garante limites do mapa
    var _map_w = variable_global_exists("map_width") ? global.map_width : 100;
    var _map_h = variable_global_exists("map_height") ? global.map_height : 100;
    tile_start_x = clamp(tile_start_x, 0, _map_w - 1);
    tile_start_y = clamp(tile_start_y, 0, _map_h - 1);
    tile_end_x = clamp(tile_end_x, 0, _map_w - 1);
    tile_end_y = clamp(tile_end_y, 0, _map_h - 1);
    
    // ✅ CORREÇÃO GM1045: Retornar array explicitamente
    var _result = [tile_start_x, tile_start_y, tile_end_x, tile_end_y];
    return _result;
}
