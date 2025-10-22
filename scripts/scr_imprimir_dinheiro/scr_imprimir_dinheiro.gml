/// @description Imprimir dinheiro - Habilidade da Casa da Moeda
function scr_imprimir_dinheiro() {
    
    // === VERIFICAÇÕES DE SEGURANÇA ===
    if (!pode_imprimir) {
        show_debug_message("❌ Casa da Moeda em cooldown");
        return;
    }
    
    // Verificar se as variáveis globais existem
    if (!variable_global_exists("taxa_inflacao")) {
        global.taxa_inflacao = 0.0;
    }
    if (!variable_global_exists("inflacao_maxima")) {
        global.inflacao_maxima = 0.50;
    }
    
    if (global.taxa_inflacao >= global.inflacao_maxima) {
        show_debug_message("⚠️ Inflação muito alta! Não é possível imprimir mais dinheiro");
        return;
    }
    
    // === EXECUTAR IMPRESSÃO ===
    global.dinheiro += quantidade_impressao;
    
    // === APLICAR INFLATION ===
    global.taxa_inflacao += inflacao_por_uso;
    
    // === ATIVAR COOLDOWN ===
    cooldown_impressao = cooldown_maximo;
    pode_imprimir = false;
    
    // === ATUALIZAR ESTOQUE ===
    if (ds_exists(global.estoque_recursos, ds_type_map)) {
        global.estoque_recursos[? "Dinheiro"] += quantidade_impressao;
    }
    
    // === FEEDBACK VISUAL ===
    show_debug_message("💰 IMPRESSÃO DE DINHEIRO EXECUTADA!");
    show_debug_message("💵 Dinheiro adicionado: $" + string(quantidade_impressao));
    show_debug_message("📈 Inflação atual: " + string(round(global.taxa_inflacao * 100)) + "%");
    show_debug_message("🏛️ Cooldown ativado: " + string(cooldown_maximo/60) + " segundos");
    
    // === CONSEQUÊNCIAS ===
    if (global.taxa_inflacao > 0.2) {
        show_debug_message("⚠️ ATENÇÃO: Inflação alta pode causar instabilidade social!");
    }
}