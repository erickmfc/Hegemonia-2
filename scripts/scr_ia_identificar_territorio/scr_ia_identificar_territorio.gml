/// @function scr_ia_identificar_territorio(_ia_id)
/// @description Identifica a área territorial da IA (tiles de terra, deserto ou gelo ao redor da base)
/// @param {real} _ia_id ID da IA
/// @return {ds_list} Lista de tiles territoriais [{tile_x, tile_y, terreno}]

function scr_ia_identificar_territorio(_ia_id) {
    var _ia = _ia_id;
    
    // Verificar se global.map_grid existe
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        show_debug_message("❌ ERRO: global.map_grid não existe!");
        return ds_list_create();
    }
    
    if (!variable_global_exists("tile_size")) {
        show_debug_message("❌ ERRO: global.tile_size não existe!");
        return ds_list_create();
    }
    
    // Converter posição base para coordenadas do grid
    var _tile_size = global.tile_size;
    var _tile_x_base = floor(_ia.base_x / _tile_size);
    var _tile_y_base = floor(_ia.base_y / _tile_size);
    
    // Lista de tiles territoriais
    var _tiles_territorio = ds_list_create();
    var _tiles_visitados = ds_map_create();
    
    // Fila para busca em largura (BFS) - começar do tile da base
    var _fila = ds_queue_create();
    ds_queue_enqueue(_fila, [_tile_x_base, _tile_y_base]);
    ds_map_add(_tiles_visitados, _tile_x_base + "_" + _tile_y_base, true);
    
    // Raio máximo de expansão territorial (em tiles)
    var _raio_maximo = 30; // 30 tiles = ~960 pixels (30 * 32)
    var _tiles_processados = 0;
    
    // Buscar tiles territoriais usando BFS
    while (!ds_queue_empty(_fila) && _tiles_processados < 1000) {
        var _tile_atual = ds_queue_dequeue(_fila);
        var _tx = _tile_atual[0];
        var _ty = _tile_atual[1];
        
        // Verificar limites
        if (_tx < 0 || _tx >= global.map_width || _ty < 0 || _ty >= global.map_height) {
            continue;
        }
        
        // Calcular distância da base
        var _dist_base = point_distance(_tx * _tile_size, _ty * _tile_size, _ia.base_x, _ia.base_y);
        if (_dist_base > _raio_maximo * _tile_size) {
            continue; // Muito longe da base
        }
        
        // Obter TileData
        var _tile_data = global.map_grid[_tx][_ty];
        if (is_undefined(_tile_data)) continue;
        
        var _terreno = _tile_data.terreno;
        
        // Verificar se é terreno territorial (terra, deserto ou gelo - não água)
        if (_terreno == TERRAIN.CAMPO || _terreno == TERRAIN.DESERTO || _terreno == TERRAIN.FLORESTA) {
            // Adicionar à lista de território
            ds_list_add(_tiles_territorio, {
                tile_x: _tx,
                tile_y: _ty,
                terreno: _terreno,
                distancia: _dist_base
            });
            
            // Adicionar tiles vizinhos à fila (4 direções: cima, baixo, esquerda, direita)
            var _vizinhos = [
                [_tx, _ty - 1], // Cima
                [_tx, _ty + 1], // Baixo
                [_tx - 1, _ty], // Esquerda
                [_tx + 1, _ty]  // Direita
            ];
            
            for (var i = 0; i < array_length(_vizinhos); i++) {
                var _vx = _vizinhos[i][0];
                var _vy = _vizinhos[i][1];
                var _chave = _vx + "_" + _vy;
                
                // Verificar se já foi visitado
                if (!ds_map_exists(_tiles_visitados, _chave)) {
                    ds_map_add(_tiles_visitados, _chave, true);
                    ds_queue_enqueue(_fila, [_vx, _vy]);
                }
            }
        }
        
        _tiles_processados++;
    }
    
    // Limpar estruturas temporárias
    ds_queue_destroy(_fila);
    ds_map_destroy(_tiles_visitados);
    
    show_debug_message("🗺️ IA identificou " + string(ds_list_size(_tiles_territorio)) + " tiles territoriais");
    
    return _tiles_territorio;
}

/// @function scr_ia_encontrar_costa(_ia_id, _tiles_territorio)
/// @description Encontra a costa (água adjacente) da área territorial da IA
/// @param {real} _ia_id ID da IA
/// @param {ds_list} _tiles_territorio Lista de tiles territoriais
/// @return {ds_list} Lista de posições de costa [{x, y, tile_x, tile_y}]

function scr_ia_encontrar_costa(_ia_id, _tiles_territorio) {
    var _ia = _ia_id;
    
    if (!variable_global_exists("tile_size")) {
        return ds_list_create();
    }
    
    var _tile_size = global.tile_size;
    var _posicoes_costa = ds_list_create();
    var _costa_visitada = ds_map_create();
    
    // Para cada tile territorial, verificar se tem água adjacente
    for (var i = 0; i < ds_list_size(_tiles_territorio); i++) {
        var _tile_territorio = ds_list_find_value(_tiles_territorio, i);
        var _tx = _tile_territorio.tile_x;
        var _ty = _tile_territorio.tile_y;
        
        // Verificar 8 direções (incluindo diagonais)
        var _direcoes = [
            [0, -1],  // Cima
            [1, -1],  // Cima-direita
            [1, 0],   // Direita
            [1, 1],   // Baixo-direita
            [0, 1],   // Baixo
            [-1, 1],  // Baixo-esquerda
            [-1, 0],  // Esquerda
            [-1, -1]  // Cima-esquerda
        ];
        
        for (var d = 0; d < array_length(_direcoes); d++) {
            var _dx = _direcoes[d][0];
            var _dy = _direcoes[d][1];
            var _tx_agua = _tx + _dx;
            var _ty_agua = _ty + _dy;
            
            // Verificar limites
            if (_tx_agua < 0 || _tx_agua >= global.map_width || 
                _ty_agua < 0 || _ty_agua >= global.map_height) {
                continue;
            }
            
            // Verificar se é água
            var _tile_data_agua = global.map_grid[_tx_agua][_ty_agua];
            if (is_undefined(_tile_data_agua)) continue;
            
            if (_tile_data_agua.terreno == TERRAIN.AGUA) {
                // Encontrou água adjacente! Esta é uma posição de costa
                var _chave_costa = _tx_agua + "_" + _ty_agua;
                
                // Verificar se já foi adicionada
                if (!ds_map_exists(_costa_visitada, _chave_costa)) {
                    ds_map_add(_costa_visitada, _chave_costa, true);
                    
                    // Converter para coordenadas do mundo
                    var _x_mundo = _tx_agua * _tile_size + _tile_size / 2;
                    var _y_mundo = _ty_agua * _tile_size + _tile_size / 2;
                    
                    ds_list_add(_posicoes_costa, {
                        x: _x_mundo,
                        y: _y_mundo,
                        tile_x: _tx_agua,
                        tile_y: _ty_agua,
                        distancia_base: point_distance(_x_mundo, _y_mundo, _ia.base_x, _ia.base_y)
                    });
                }
            }
        }
    }
    
    ds_map_destroy(_costa_visitada);
    
    show_debug_message("🌊 IA encontrou " + string(ds_list_size(_posicoes_costa)) + " posições de costa");
    
    return _posicoes_costa;
}

