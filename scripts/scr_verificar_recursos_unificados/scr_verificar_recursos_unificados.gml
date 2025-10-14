/// @description Verificar recursos unificados para produção
/// @param {struct} _unidade_data Dados da unidade a ser produzida
/// @return {bool} true se recursos suficientes, false caso contrário

function scr_verificar_recursos_unificados(_unidade_data) {
    // Verificar dinheiro
    if (global.dinheiro < _unidade_data.custo_dinheiro) {
        show_debug_message("❌ Dinheiro insuficiente: $" + string(_unidade_data.custo_dinheiro) + " necessário");
        return false;
    }
    
    // Verificar minério
    if (global.nacao_recursos[? "Minério"] < _unidade_data.custo_minerio) {
        show_debug_message("❌ Minério insuficiente: " + string(_unidade_data.custo_minerio) + " necessário");
        return false;
    }
    
    // Verificar população (se necessário)
    if (variable_instance_exists(global, "populacao_atual")) {
        if (global.populacao_atual < _unidade_data.custo_populacao) {
            show_debug_message("❌ População insuficiente: " + string(_unidade_data.custo_populacao) + " necessário");
            return false;
        }
    }
    
    return true;
}
