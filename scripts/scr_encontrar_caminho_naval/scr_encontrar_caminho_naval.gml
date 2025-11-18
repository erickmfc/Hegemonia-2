// ===============================================
// HEGEMONIA GLOBAL - PATHFINDING A* NAVAL
// Sistema de navegação GPS para navios
// ===============================================

/// @function scr_encontrar_caminho_naval(x_inicio, y_inicio, x_fim, y_fim, obj_unidade)
/// @description Encontra um caminho A* pela água, evitando terra com uma margem de segurança
/// @param {Real} x_inicio - Posição X inicial
/// @param {Real} y_inicio - Posição Y inicial
/// @param {Real} x_fim - Posição X destino
/// @param {Real} y_fim - Posição Y destino
/// @param {Id.Instance} obj_unidade - A unidade que está se movendo
/// @returns {Path} Path do GameMaker ou noone se não encontrar caminho

function scr_encontrar_caminho_naval(x_inicio, y_inicio, x_fim, y_fim, obj_unidade) {
    if (!instance_exists(obj_unidade)) {
        show_debug_message("❌ NAVIO: Unidade não existe para pathfinding");
        return noone;
    }
    
    // 1. VERIFICAR SE O GRID GLOBAL EXISTE
    if (!variable_global_exists("navio_path_grid") || global.navio_path_grid == -1) {
        show_debug_message("❌ ERRO CRÍTICO: global.navio_path_grid não existe! O grid deve ser criado no obj_game_manager/Create.");
        return noone;
    }
    
    // 2. Criar o Caminho (Path)
    var _path = path_add();
    
    if (_path == -1) {
        show_debug_message("❌ NAVIO: Erro ao criar path");
        return noone;
    }
    
    // 3. Calcular o Caminho A* (Usando o grid GLOBAL)
    var _encontrou_caminho = mp_grid_path(
        global.navio_path_grid, // <-- USA O GRID GLOBAL!
        _path,          // O path vazio
        x_inicio,       // Posição X inicial
        y_inicio,       // Posição Y inicial
        x_fim,          // Posição X final
        y_fim,          // Posição Y final
        true            // Permitir movimento diagonal
    );
    
    // ✅ NOTA: NÃO DESTRUÍMOS O GRID GLOBAL (ele é reutilizado)
    
    // 6. Retornar o resultado
    if (_encontrou_caminho) {
        // ✅ CORREÇÃO: Verificar se path tem pontos válidos
        var _path_length = path_get_length(_path);
        var _path_points = path_get_number(_path);
        
        if (_path_length > 0 && _path_points > 0) {
            show_debug_message("✅ NAVIO: Caminho A* encontrado! Comprimento: " + string(round(_path_length)) + " pixels, " + string(_path_points) + " pontos");
            return _path; // Retorna o caminho criado
        } else {
            show_debug_message("❌ NAVIO: Path criado mas sem pontos válidos");
            path_delete(_path);
            return noone;
        }
    } else {
        show_debug_message("❌ NAVIO: ERRO! Não foi possível encontrar um caminho de (" + string(round(x_inicio)) + ", " + string(round(y_inicio)) + ") para (" + string(round(x_fim)) + ", " + string(round(y_fim)) + ")");
        path_delete(_path);
        return noone; // Retorna "ninguém" (falha)
    }
}
