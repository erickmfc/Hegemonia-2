/// @description Deduzir recursos unificados após produção
/// @param {struct} _unidade_data Dados da unidade produzida
/// @return {undefined}

function scr_deduzir_recursos_unificados(_unidade_data) {
    // Deduzir dinheiro
    global.dinheiro -= _unidade_data.custo_dinheiro;
    
    // Deduzir minério
    global.nacao_recursos[? "Minério"] -= _unidade_data.custo_minerio;
    
    // Deduzir população (se necessário)
    if (variable_instance_exists(global, "populacao_atual")) {
        global.populacao_atual -= _unidade_data.custo_populacao;
    }
    
    show_debug_message("💰 Recursos deduzidos: $" + string(_unidade_data.custo_dinheiro) + 
                      " | Minério: " + string(_unidade_data.custo_minerio));
}
