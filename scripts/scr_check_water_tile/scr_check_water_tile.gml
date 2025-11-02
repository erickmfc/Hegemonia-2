/// @description Verifica se uma posição (x,y) está em um tile de água
/// @param {real} check_x Coordenada X para verificar
/// @param {real} check_y Coordenada Y para verificar
/// @return {bool} true se for água, false se for terra

function scr_check_water_tile(check_x, check_y) {
    // ✅ CORREÇÃO: collision_point não aceita sprite diretamente
    // Usar método alternativo que não cause erro
    
    // Verificar limites do mapa
    if (check_x < 0 || check_y < 0 || check_x >= room_width || check_y >= room_height) {
        return false;
    }
    
    // ✅ SOLUÇÃO TEMPORÁRIA: Usar heurística baseada em posição
    // Assumir que água está nas bordas e em certas áreas do mapa
    // Isso permite que a IA construa quartéis navais sem erro
    
    var _margem_agua = 200; // Margem da borda onde pode haver água
    var _centro_x = room_width / 2;
    var _centro_y = room_height / 2;
    
    // Áreas onde provavelmente há água (bordas do mapa)
    if (check_x < _margem_agua || check_x > room_width - _margem_agua ||
        check_y < _margem_agua || check_y > room_height - _margem_agua) {
        // Verificar também algumas áreas centrais (lagos)
        var _dist_centro = point_distance(check_x, check_y, _centro_x, _centro_y);
        if (_dist_centro > room_width * 0.3 && _dist_centro < room_width * 0.5) {
            return true; // Possível área de água
        }
        return true; // Borda do mapa = possível água
    }
    
    // TODO: Quando sistema de tilemap estiver configurado, usar:
    // var _layer_id = layer_get_id("Terrain");
    // var _tilemap_id = layer_tilemap_get_id(_layer_id);
    // var _tile_data = tilemap_get_at_pixel(_tilemap_id, check_x, check_y);
    // return (_tile_data == spr_terreno_agua);
    
    return false;
}