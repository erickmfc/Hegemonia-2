/// @description Sistema de Spatial Grid para otimizar busca de unidades
/// Dividir mapa em células para busca rápida

/// @description Inicializar spatial grid
function scr_init_spatial_grid() {
    // ✅ CORREÇÃO: Verificar se já está inicializado corretamente
    if (variable_global_exists("spatial_grid_initialized") && global.spatial_grid_initialized) {
        return;
    }
    
    global.spatial_grid_cell_size = 512; // Células de 512x512 pixels
    global.spatial_grid_cols = ceil(room_width / global.spatial_grid_cell_size);
    global.spatial_grid_rows = ceil(room_height / global.spatial_grid_cell_size);
    
    // ✅ CORREÇÃO: Verificar se room_width e room_height são válidos
    if (global.spatial_grid_cols <= 0) global.spatial_grid_cols = 1;
    if (global.spatial_grid_rows <= 0) global.spatial_grid_rows = 1;
    
    var _grid_size = global.spatial_grid_cols * global.spatial_grid_rows;
    
    // Criar grid como array de lists
    global.spatial_grid = array_create(_grid_size);
    for (var i = 0; i < _grid_size; i++) {
        global.spatial_grid[i] = ds_list_create();
    }
    
    global.spatial_grid_initialized = true;
}

/// @description Obter índice da célula do grid para coordenada
function scr_get_grid_cell(wx, wy) {
    if (!variable_global_exists("spatial_grid_initialized")) scr_init_spatial_grid();
    
    var col = floor(wx / global.spatial_grid_cell_size);
    var row = floor(wy / global.spatial_grid_cell_size);
    col = clamp(col, 0, global.spatial_grid_cols - 1);
    row = clamp(row, 0, global.spatial_grid_rows - 1);
    return row * global.spatial_grid_cols + col;
}

/// @description Limpar e reconstruir spatial grid
function scr_rebuild_spatial_grid() {
    if (!variable_global_exists("spatial_grid_initialized") || !global.spatial_grid_initialized) {
        scr_init_spatial_grid();
    }
    
    // Limpar grid
    if (variable_global_exists("spatial_grid") && is_array(global.spatial_grid)) {
        for (var i = 0; i < array_length(global.spatial_grid); i++) {
            if (ds_exists(global.spatial_grid[i], ds_type_list)) {
                ds_list_clear(global.spatial_grid[i]);
            }
        }
        
        // Reconstruir adicionando todas as unidades
        with (all) {
            // Adicionar apenas unidades móveis (infantaria, tanques, navios, etc.)
            if (object_index == obj_infantaria || 
                object_index == obj_tanque || 
                object_index == obj_f15 ||
                object_index == obj_helicoptero_militar ||
                object_index == obj_lancha_patrulha ||
                object_index == obj_fragata) {
                var cell = scr_get_grid_cell(x, y);
                if (cell >= 0 && cell < array_length(global.spatial_grid)) {
                    ds_list_add(global.spatial_grid[cell], id);
                }
            }
        }
    }
}

/// @description Buscar unidades próximas usando spatial grid
function scr_find_nearby_units_spatial(wx, wy, radius) {
    if (!variable_global_exists("spatial_grid_initialized")) scr_init_spatial_grid();
    
    var nearby = [];
    var radius_sq = radius * radius; // Distância ao quadrado para otimização
    
    // Calcular células dentro do raio
    var start_col = floor((wx - radius) / global.spatial_grid_cell_size);
    var end_col = floor((wx + radius) / global.spatial_grid_cell_size);
    var start_row = floor((wy - radius) / global.spatial_grid_cell_size);
    var end_row = floor((wy + radius) / global.spatial_grid_cell_size);
    
    // Verificar apenas células relevantes
    for (var c = start_col; c <= end_col; c++) {
        for (var r = start_row; r <= end_row; r++) {
            if (c >= 0 && c < global.spatial_grid_cols && r >= 0 && r < global.spatial_grid_rows) {
                var cell_idx = r * global.spatial_grid_cols + c;
                var cell_list = global.spatial_grid[cell_idx];
                
                for (var i = 0; i < ds_list_size(cell_list); i++) {
                    var unit = cell_list[| i];
                    if (instance_exists(unit)) {
                        var dx = unit.x - wx;
                        var dy = unit.y - wy;
                        var dist_sq = dx * dx + dy * dy; // Evitar sqrt quando possível
                        
                        if (dist_sq <= radius_sq) {
                            array_push(nearby, unit);
                        }
                    }
                }
            }
        }
    }
    
    return nearby;
}
