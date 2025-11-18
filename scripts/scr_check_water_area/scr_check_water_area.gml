/// @description Verifica se uma área é segura para navios (múltiplos pontos)
/// @param {real} center_x Coordenada X central
/// @param {real} center_y Coordenada Y central
/// @param {real} ship_width Largura do navio
/// @param {real} ship_height Altura do navio
/// @return {bool} true se toda a área for água

function scr_check_water_area(center_x, center_y, ship_width, ship_height) {
    // Verifica múltiplos pontos do navio para garantir que toda a área seja água
    var check_points = [
        // Centro
        [center_x, center_y],
        // Cantos
        [center_x - ship_width/2, center_y - ship_height/2],
        [center_x + ship_width/2, center_y - ship_height/2],
        [center_x - ship_width/2, center_y + ship_height/2],
        [center_x + ship_width/2, center_y + ship_height/2],
        // Pontos médios
        [center_x, center_y - ship_height/2],
        [center_x, center_y + ship_height/2],
        [center_x - ship_width/2, center_y],
        [center_x + ship_width/2, center_y]
    ];
    
    // Verifica se todos os pontos são água
    for (var i = 0; i < array_length(check_points); i++) {
        if (!scr_verificar_agua(check_points[i][0], check_points[i][1])) {
            return false;
        }
    }
    
    return true;
}