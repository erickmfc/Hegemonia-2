/// @description Sistema de Culling Otimizado para Câmera
/// Retorna área visível em coordenadas de tile

// ===============================================
// CALCULA ÁREA DE CULLING (tiles visíveis)
// ===============================================
/// @description Calcula e retorna área de tiles visíveis
/// @return {array} [tile_start_x, tile_start_y, tile_end_x, tile_end_y]
function scr_calculate_culling_area() {
    var cam = view_camera[0];
    if (cam == noone || !camera_exists(cam)) {
        // Fallback: toda a room
        return [
            floor(0 / global.tile_size),
            floor(0 / global.tile_size),
            ceil(room_width / global.tile_size),
            ceil(room_height / global.tile_size)
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
    tile_start_x = clamp(tile_start_x, 0, global.map_width - 1);
    tile_start_y = clamp(tile_start_y, 0, global.map_height - 1);
    tile_end_x = clamp(tile_end_x, 0, global.map_width - 1);
    tile_end_y = clamp(tile_end_y, 0, global.map_height - 1);
    
    return [tile_start_x, tile_start_y, tile_end_x, tile_end_y];
}
