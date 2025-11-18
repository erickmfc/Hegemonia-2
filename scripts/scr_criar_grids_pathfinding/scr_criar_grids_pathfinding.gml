// ===============================================
// HEGEMONIA GLOBAL - CRIAÇÃO DE GRIDS PARA PATHFINDING
// Cria grids separados por tipo de terreno usando mp_grid do GameMaker
// ===============================================

/// @function scr_criar_grids_pathfinding()
/// @description Cria grids de pathfinding separados por tipo de unidade usando mp_grid
/// @returns {bool} True se grids foram criados com sucesso

function scr_criar_grids_pathfinding() {
    
    // Verificar se map_grid existe
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        scr_log_aviso("PATHFINDING", "global.map_grid não existe!");
        return false;
    }
    
    // Verificar se tile_size existe
    if (!variable_global_exists("tile_size")) {
        scr_log_aviso("PATHFINDING", "global.tile_size não existe!");
        return false;
    }
    
    var _tile_size = global.tile_size;
    var _grid_cols = global.map_width;
    var _grid_rows = global.map_height;
    
    // === GRID PARA UNIDADES TERRESTRES ===
    // ✅ CORREÇÃO: Usar mp_grid em vez de array
    if (!variable_global_exists("grid_pathfinding_terrestre") || 
        !mp_grid_exists(global.grid_pathfinding_terrestre)) {
        
        // Destruir grid antigo se existir (mas não for mp_grid)
        if (variable_global_exists("grid_pathfinding_terrestre") && 
            !mp_grid_exists(global.grid_pathfinding_terrestre)) {
            // Era um array, não precisa destruir (será sobrescrito)
        }
        
        // Criar mp_grid
        global.grid_pathfinding_terrestre = mp_grid_create(0, 0, _grid_cols, _grid_rows, _tile_size, _tile_size);
        
        // Preencher grid: marcar células como obstáculo se NÃO podem ser atravessadas
        for (var i = 0; i < _grid_cols; i++) {
            for (var j = 0; j < _grid_rows; j++) {
                var _tile = global.map_grid[i][j];
                var _pode_terrestre = false;
                
                if (!is_undefined(_tile) && !is_undefined(_tile.terreno)) {
                    var _terreno = _tile.terreno;
                    // ✅ CORREÇÃO: Usar enums TERRAIN em vez de strings
                    // Terrestres podem: CAMPO, DESERTO, FLORESTA
                    _pode_terrestre = (_terreno == TERRAIN.CAMPO || _terreno == TERRAIN.DESERTO || 
                                       _terreno == TERRAIN.FLORESTA);
                } else {
                    _pode_terrestre = true; // Fallback: permitir
                }
                
                // Se NÃO pode atravessar, marcar como obstáculo
                if (!_pode_terrestre) {
                    mp_grid_add_cell(global.grid_pathfinding_terrestre, i, j);
                }
            }
        }
    }
    
    // === GRID PARA UNIDADES NAVALS ===
    // ✅ CORREÇÃO: Usar mp_grid em vez de array
    if (!variable_global_exists("grid_pathfinding_naval") || 
        !mp_grid_exists(global.grid_pathfinding_naval)) {
        
        // Criar mp_grid
        global.grid_pathfinding_naval = mp_grid_create(0, 0, _grid_cols, _grid_rows, _tile_size, _tile_size);
        
        // Preencher grid: marcar células como obstáculo se NÃO são água
        for (var i = 0; i < _grid_cols; i++) {
            for (var j = 0; j < _grid_rows; j++) {
                var _tile = global.map_grid[i][j];
                var _pode_naval = false;
                
                if (!is_undefined(_tile) && !is_undefined(_tile.terreno)) {
                    var _terreno = _tile.terreno;
                    // ✅ CORREÇÃO: Usar enum TERRAIN em vez de strings
                    // Navais só podem: AGUA
                    _pode_naval = (_terreno == TERRAIN.AGUA);
                } else {
                    _pode_naval = false; // Fallback: não permitir (seguro)
                }
                
                // Se NÃO é água, marcar como obstáculo
                if (!_pode_naval) {
                    mp_grid_add_cell(global.grid_pathfinding_naval, i, j);
                }
            }
        }
    }
    
    // === GRID PARA UNIDADES AÉREAS ===
    // ✅ CORREÇÃO: Usar mp_grid em vez de array
    // Aéreas podem voar sobre qualquer terreno, então grid vazio (sem obstáculos)
    if (!variable_global_exists("grid_pathfinding_aereo") || 
        !mp_grid_exists(global.grid_pathfinding_aereo)) {
        
        // Criar mp_grid vazio (sem obstáculos = todas as células são passáveis)
        global.grid_pathfinding_aereo = mp_grid_create(0, 0, _grid_cols, _grid_rows, _tile_size, _tile_size);
        // Não adicionar células = todas são passáveis
    }
    
    scr_log_info("PATHFINDING", "Grids de pathfinding (mp_grid) criados: Terrestre=" + string(_grid_cols) + "x" + string(_grid_rows) + 
                 ", Naval=" + string(_grid_cols) + "x" + string(_grid_rows) + 
                 ", Aéreo=" + string(_grid_cols) + "x" + string(_grid_rows));
    
    return true;
}

/// @function scr_obter_grid_pathfinding(_tipo_unidade)
/// @description Retorna grid apropriado para tipo de unidade (mp_grid)
/// @param {string} _tipo_unidade - "terrestre", "naval" ou "aereo"
/// @returns {mp_grid} Grid de pathfinding (mp_grid) ou noone

function scr_obter_grid_pathfinding(_tipo_unidade) {
    switch(_tipo_unidade) {
        case "terrestre":
            if (variable_global_exists("grid_pathfinding_terrestre") && 
                mp_grid_exists(global.grid_pathfinding_terrestre)) {
                return global.grid_pathfinding_terrestre;
            }
            break;
        case "naval":
            if (variable_global_exists("grid_pathfinding_naval") && 
                mp_grid_exists(global.grid_pathfinding_naval)) {
                return global.grid_pathfinding_naval;
            }
            break;
        case "aereo":
            if (variable_global_exists("grid_pathfinding_aereo") && 
                mp_grid_exists(global.grid_pathfinding_aereo)) {
                return global.grid_pathfinding_aereo;
            }
            break;
    }
    
    return noone;
}
