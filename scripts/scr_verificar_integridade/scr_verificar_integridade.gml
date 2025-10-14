// Script: scr_verificar_integridade - VERSÃO SIMPLIFICADA
// Verifica a integridade do sistema básico

function scr_verificar_integridade() {
    show_debug_message("=== VERIFICAÇÃO DE INTEGRIDADE BÁSICA ===");
    
    var problemas_encontrados = 0;
    
    // Verificar enums básicos
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
    
    // Verificar variáveis globais básicas
    var variaveis_basicas = ["dinheiro", "minerio", "petroleo", "populacao", "tile_size"];
    
    for (var i = 0; i < array_length(variaveis_basicas); i++) {
        if (!variable_global_exists(variaveis_basicas[i])) {
            show_debug_message("❌ ERRO: Variável global '" + variaveis_basicas[i] + "' não está definida!");
            problemas_encontrados++;
        } else {
            show_debug_message("✅ Variável global '" + variaveis_basicas[i] + "' está definida");
        }
    }
    
    // Relatório final
    show_debug_message("=== RELATÓRIO DE INTEGRIDADE ===");
    if (problemas_encontrados == 0) {
        show_debug_message("✅ SISTEMA BÁSICO INTEGRO: Nenhum problema encontrado!");
    } else {
        show_debug_message("❌ PROBLEMAS ENCONTRADOS: " + string(problemas_encontrados) + " problemas detectados!");
    }
    
    return problemas_encontrados;
}
