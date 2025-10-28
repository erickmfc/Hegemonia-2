/// @description Verifica se há espaço livre para construir um edifício
/// @param {real} _grid_x Posição X no grid
/// @param {real} _grid_y Posição Y no grid
/// @param {Asset.GMObject} _objeto_construir Objeto a ser construído
/// @param {real} _largura Largura do edifício (default: 64)
/// @param {real} _altura Altura do edifício (default: 64)
/// @return {bool} true se há espaço livre, false se ocupado

function scr_verificar_espaco_edificio(_grid_x, _grid_y, _objeto_construir, _largura = 64, _altura = 64) {
    
    // Lista de todos os edifícios que bloqueiam construção
    var _edificios = [
        obj_casa,
        obj_banco,
        obj_fazenda,
        obj_quartel,
        obj_quartel_marinha,
        obj_aeroporto_militar,
        obj_research_center,
        obj_casa_da_moeda
    ];
    
    // Verifica se há algum edifício ocupando a área
    for (var i = 0; i < array_length(_edificios); i++) {
        var _edificio_obj = _edificios[i];
        if (!object_exists(_edificio_obj)) continue;
        
        // Verifica múltiplos pontos para garantir que não há overlap
        var _check_points = [
            [_grid_x, _grid_y],  // Centro
            [_grid_x - _largura/2 + 10, _grid_y - _altura/2 + 10],  // Canto superior esquerdo
            [_grid_x + _largura/2 - 10, _grid_y - _altura/2 + 10],  // Canto superior direito
            [_grid_x - _largura/2 + 10, _grid_y + _altura/2 - 10],  // Canto inferior esquerdo
            [_grid_x + _largura/2 - 10, _grid_y + _altura/2 - 10]   // Canto inferior direito
        ];
        
        // Verifica todos os pontos
        for (var j = 0; j < array_length(_check_points); j++) {
            var _x = _check_points[j][0];
            var _y = _check_points[j][1];
            
            // Verifica se há alguma instância do edifício nesta posição
            if (instance_position(_x, _y, _edificio_obj) != noone) {
                return false; // Espaço ocupado
            }
        }
    }
    
    return true; // Espaço livre
}