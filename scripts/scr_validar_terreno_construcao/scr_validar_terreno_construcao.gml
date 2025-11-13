/// @function scr_validar_terreno_construcao(_obj_a_construir, _pos_x, _pos_y, _largura, _altura)
/// @description Verifica se um edifício pode ser construído no terreno correto
/// @param {Asset.GMObject} _obj_a_construir O objeto a ser construído
/// @param {Real} _pos_x Posição X no mundo
/// @param {Real} _pos_y Posição Y no mundo
/// @param {Real} _largura Largura do edifício (opcional, padrão: 64)
/// @param {Real} _altura Altura do edifício (opcional, padrão: 64)
/// @return {Bool} true se pode construir, false caso contrário

function scr_validar_terreno_construcao(_obj_a_construir, _pos_x, _pos_y, _largura = 64, _altura = 64) {
    
    // === VERIFICAÇÕES DE SEGURANÇA ===
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        show_debug_message("❌ ERRO: global.map_grid não existe!");
        return false;
    }
    
    if (!variable_global_exists("tile_size")) {
        show_debug_message("❌ ERRO: global.tile_size não existe!");
        return false;
    }
    
    if (!variable_global_exists("map_width") || !variable_global_exists("map_height")) {
        show_debug_message("❌ ERRO: Dimensões do mapa não definidas!");
        return false;
    }
    
    // === PASSO 1: OBTER TERRENO PERMITIDO DO OBJETO ===
    var _terreno_permitido = undefined;
    
    // Tentar criar instância temporária para ler terreno_permitido
    var _inst_temp = noone;
    if (object_exists(_obj_a_construir)) {
        _inst_temp = instance_create_layer(0, 0, "Instances", _obj_a_construir);
        if (instance_exists(_inst_temp)) {
            if (variable_instance_exists(_inst_temp, "terreno_permitido")) {
                _terreno_permitido = _inst_temp.terreno_permitido;
            }
            instance_destroy(_inst_temp);
        }
    } else {
        show_debug_message("❌ ERRO: Objeto não existe!");
        return false;
    }
    
    // Se não conseguiu obter terreno_permitido, usar valores padrão
    if (is_undefined(_terreno_permitido)) {
        // Valores padrão baseados no objeto
        var _obj_name = object_get_name(_obj_a_construir);
        if (string_pos("marinha", _obj_name) > 0 || string_pos("naval", _obj_name) > 0) {
            _terreno_permitido = TERRAIN.AGUA;
        } else {
            _terreno_permitido = TERRAIN.CAMPO; // Padrão: terra
        }
        show_debug_message("⚠️ AVISO: terreno_permitido não encontrado, usando padrão: " + string(_terreno_permitido));
    }
    
    // === PASSO 2: CONVERTER POSIÇÃO PARA COORDENADAS DO GRID ===
    var _tile_size = global.tile_size;
    var _tile_x = floor(_pos_x / _tile_size);
    var _tile_y = floor(_pos_y / _tile_size);
    
    // Verificar limites do mapa
    if (_tile_x < 0 || _tile_x >= global.map_width || _tile_y < 0 || _tile_y >= global.map_height) {
        show_debug_message("❌ Construção fora dos limites do mapa!");
        return false;
    }
    
    // === PASSO 3: VERIFICAR TERRENO NO CENTRO ===
    if (_tile_x >= array_length(global.map_grid)) {
        show_debug_message("❌ ERRO: tile_x fora do array!");
        return false;
    }
    
    if (_tile_y >= array_length(global.map_grid[_tile_x])) {
        show_debug_message("❌ ERRO: tile_y fora do array!");
        return false;
    }
    
    var _tile_data = global.map_grid[_tile_x][_tile_y];
    if (is_undefined(_tile_data)) {
        show_debug_message("❌ ERRO: TileData não existe na posição (" + string(_tile_x) + ", " + string(_tile_y) + ")");
        return false;
    }
    
    var _terreno_no_tile = _tile_data.terreno;
    if (is_undefined(_terreno_no_tile)) {
        show_debug_message("❌ ERRO: terreno não definido no tile!");
        return false;
    }
    
    // Verificar se o terreno do centro é compatível
    if (_terreno_no_tile != _terreno_permitido) {
        show_debug_message("❌ Terreno incompatível! Precisa: " + string(_terreno_permitido) + ", Encontrado: " + string(_terreno_no_tile));
        return false;
    }
    
    // === PASSO 4: VERIFICAR ÁREA COMPLETA (para edifícios grandes) ===
    // Calcular quantos tiles o edifício ocupa
    var _tiles_largura = ceil(_largura / _tile_size);
    var _tiles_altura = ceil(_altura / _tile_size);
    
    // Verificar todos os tiles que o edifício ocupará
    var _tiles_para_verificar = [];
    
    // Adicionar tiles principais (centro e cantos)
    for (var i = 0; i < _tiles_largura; i++) {
        for (var j = 0; j < _tiles_altura; j++) {
            var _check_tile_x = _tile_x + i - floor(_tiles_largura / 2);
            var _check_tile_y = _tile_y + j - floor(_tiles_altura / 2);
            
            // Verificar limites
            if (_check_tile_x >= 0 && _check_tile_x < global.map_width &&
                _check_tile_y >= 0 && _check_tile_y < global.map_height) {
                
                array_push(_tiles_para_verificar, [_check_tile_x, _check_tile_y]);
            }
        }
    }
    
    // Verificar cada tile
    for (var k = 0; k < array_length(_tiles_para_verificar); k++) {
        var _check_tile = _tiles_para_verificar[k];
        var _cx = _check_tile[0];
        var _cy = _check_tile[1];
        
        // Verificações de segurança
        if (_cx >= array_length(global.map_grid)) continue;
        if (_cy >= array_length(global.map_grid[_cx])) continue;
        
        var _check_tile_data = global.map_grid[_cx][_cy];
        if (is_undefined(_check_tile_data)) continue;
        
        var _check_terreno = _check_tile_data.terreno;
        if (is_undefined(_check_terreno)) continue;
        
        // Se qualquer tile não for do terreno permitido, retorna false
        if (_check_terreno != _terreno_permitido) {
            show_debug_message("❌ Tile (" + string(_cx) + ", " + string(_cy) + ") tem terreno incompatível: " + string(_check_terreno));
            return false;
        }
    }
    
    // === SUCESSO ===
    show_debug_message("✅ Terreno válido para construção!");
    return true;
}
