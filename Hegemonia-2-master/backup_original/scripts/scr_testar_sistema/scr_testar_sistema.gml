// Script: scr_testar_sistema
// Testa o sistema básico do jogo

function scr_testar_sistema() {
    show_debug_message("=== TESTE DO SISTEMA ===");
    
    var testes_passaram = 0;
    var total_testes = 0;
    
    // Teste 1: Verificar se os enums estão definidos
    total_testes++;
    if (variable_global_exists("TERRAIN") && variable_global_exists("NATIONS")) {
        show_debug_message("✅ Teste 1: Enums definidos corretamente");
        testes_passaram++;
    } else {
        show_debug_message("❌ Teste 1: Enums não estão definidos!");
    }
    
    // Teste 2: Verificar variáveis globais essenciais
    total_testes++;
    var variaveis_ok = true;
    var variaveis_essenciais = ["dinheiro", "minerio", "petroleo", "populacao", "tile_size"];
    
    for (var i = 0; i < array_length(variaveis_essenciais); i++) {
        if (!variable_global_exists(variaveis_essenciais[i])) {
            variaveis_ok = false;
            break;
        }
    }
    
    if (variaveis_ok) {
        show_debug_message("✅ Teste 2: Variáveis globais essenciais OK");
        testes_passaram++;
    } else {
        show_debug_message("❌ Teste 2: Algumas variáveis globais estão faltando!");
    }
    
    // Teste 3: Verificar estruturas de dados
    total_testes++;
    if (variable_global_exists("estoque_recursos") && ds_exists(global.estoque_recursos, ds_type_map)) {
        show_debug_message("✅ Teste 3: Mapa de estoque de recursos OK");
        testes_passaram++;
    } else {
        show_debug_message("❌ Teste 3: Mapa de estoque de recursos com problema!");
    }
    
    // Teste 4: Verificar grid do mapa
    total_testes++;
    if (variable_global_exists("map_grid") && is_array(global.map_grid)) {
        show_debug_message("✅ Teste 4: Grid do mapa OK");
        testes_passaram++;
    } else {
        show_debug_message("❌ Teste 4: Grid do mapa com problema!");
    }
    
    // Teste 5: Verificar pathfinding
    total_testes++;
    if (variable_global_exists("pathfinding_grid") && global.pathfinding_grid != undefined) {
        show_debug_message("✅ Teste 5: Grade de pathfinding OK");
        testes_passaram++;
    } else {
        show_debug_message("❌ Teste 5: Grade de pathfinding com problema!");
    }
    
    // Relatório final
    show_debug_message("=== RELATÓRIO DE TESTES ===");
    show_debug_message("Testes passaram: " + string(testes_passaram) + "/" + string(total_testes));
    
    if (testes_passaram == total_testes) {
        show_debug_message("🎉 TODOS OS TESTES PASSARAM! Sistema funcionando corretamente.");
        return true;
    } else {
        show_debug_message("⚠️ ALGUNS TESTES FALHARAM! Verifique os problemas acima.");
        return false;
    }
}
