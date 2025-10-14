// Script: scr_verificar_integridade
// Verifica a integridade do sistema e reporta problemas

function scr_verificar_integridade() {
    show_debug_message("=== VERIFICAÇÃO DE INTEGRIDADE DO SISTEMA ===");
    
    var problemas_encontrados = 0;
    
    // Verificar se os enums estão definidos
    if (!variable_global_exists("TERRAIN")) {
        show_debug_message("❌ ERRO: Enum TERRAIN não está definido!");
        problemas_encontrados++;
    } else {
        show_debug_message("✅ Enum TERRAIN está definido");
    }
    
    if (!variable_global_exists("NATIONS")) {
        show_debug_message("❌ ERRO: Enum NATIONS não está definido!");
        problemas_encontrados++;
    } else {
        show_debug_message("✅ Enum NATIONS está definido");
    }
    
    // Verificar variáveis globais essenciais
    var variaveis_essenciais = [
        "dinheiro", "minerio", "petroleo", "populacao",
        "estoque_recursos", "map_width", "map_height", "map_grid",
        "pathfinding_grid", "tile_size"
    ];
    
    for (var i = 0; i < array_length(variaveis_essenciais); i++) {
        if (!variable_global_exists(variaveis_essenciais[i])) {
            show_debug_message("❌ ERRO: Variável global '" + variaveis_essenciais[i] + "' não está definida!");
            problemas_encontrados++;
        } else {
            show_debug_message("✅ Variável global '" + variaveis_essenciais[i] + "' está definida");
        }
    }
    
    // Verificar estruturas de dados
    if (variable_global_exists("estoque_recursos")) {
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            show_debug_message("✅ Mapa de estoque de recursos está válido");
        } else {
            show_debug_message("❌ ERRO: Mapa de estoque de recursos está corrompido!");
            problemas_encontrados++;
        }
    }
    
    if (variable_global_exists("map_grid")) {
        if (is_array(global.map_grid)) {
            show_debug_message("✅ Grid do mapa está válido");
        } else {
            show_debug_message("❌ ERRO: Grid do mapa está corrompido!");
            problemas_encontrados++;
        }
    }
    
    // Verificar objetos essenciais
    var objetos_essenciais = [
        "obj_game_manager", "obj_input_manager", "obj_resource_manager"
    ];
    
    for (var i = 0; i < array_length(objetos_essenciais); i++) {
        if (object_exists(objetos_essenciais[i])) {
            show_debug_message("✅ Objeto '" + objetos_essenciais[i] + "' existe");
        } else {
            show_debug_message("❌ ERRO: Objeto '" + objetos_essenciais[i] + "' não existe!");
            problemas_encontrados++;
        }
    }
    
    // Relatório final
    show_debug_message("=== RELATÓRIO DE INTEGRIDADE ===");
    if (problemas_encontrados == 0) {
        show_debug_message("✅ SISTEMA INTEGRO: Nenhum problema encontrado!");
    } else {
        show_debug_message("❌ PROBLEMAS ENCONTRADOS: " + string(problemas_encontrados) + " problemas detectados!");
    }
    
    return problemas_encontrados;
}
