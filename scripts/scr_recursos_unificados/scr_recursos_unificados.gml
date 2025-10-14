// ===============================================
// HEGEMONIA GLOBAL - SISTEMA DE RECURSOS UNIFICADO
// Verificação e Dedução de Recursos
// ===============================================

/// @description Verificar se há recursos suficientes para uma unidade
/// @param _unidade_data Dados da unidade
function scr_verificar_recursos_unificados(_unidade_data) {
    // Verificar dinheiro
    if (!variable_global_exists("dinheiro")) {
        global.dinheiro = 1000; // Valor padrão
    }
    if (global.dinheiro < _unidade_data.custo_dinheiro) {
        show_debug_message("❌ Dinheiro insuficiente: " + string(global.dinheiro) + "/" + string(_unidade_data.custo_dinheiro));
        return false;
    }
    
    // Verificar minério - usar sistema atual
    if (!variable_global_exists("minerio")) {
        global.minerio = 500; // Valor padrão
    }
    if (global.minerio < _unidade_data.custo_minerio) {
        show_debug_message("❌ Minério insuficiente: " + string(global.minerio) + "/" + string(_unidade_data.custo_minerio));
        return false;
    }
    
    // Verificar população (se necessário)
    if (variable_global_exists("populacao")) {
        var _populacao_disponivel = global.populacao - (variable_global_exists("militares_totais") ? global.militares_totais : 0);
        if (_populacao_disponivel < _unidade_data.custo_populacao) {
            show_debug_message("❌ População insuficiente: " + string(_populacao_disponivel) + "/" + string(_unidade_data.custo_populacao));
            return false;
        }
    }
    
    return true;
}

/// @description Deduzir recursos do estoque global
/// @param _unidade_data Dados da unidade
function scr_deduzir_recursos_unificados(_unidade_data) {
    // Deduzir dinheiro
    global.dinheiro -= _unidade_data.custo_dinheiro;
    
    // Deduzir minério - usar sistema atual
    global.minerio -= _unidade_data.custo_minerio;
    
    // Deduzir população (se necessário)
    if (variable_global_exists("populacao")) {
        if (!variable_global_exists("militares_totais")) {
            global.militares_totais = 0;
        }
        global.militares_totais += _unidade_data.custo_populacao;
    }
    
    show_debug_message("💰 Recursos deduzidos: $" + string(_unidade_data.custo_dinheiro) + 
                      " | Minério: " + string(_unidade_data.custo_minerio) +
                      " | População: " + string(_unidade_data.custo_populacao));
}

/// @description Obter recursos disponíveis
function scr_obter_recursos_disponiveis() {
    var _recursos = {
        dinheiro: variable_global_exists("dinheiro") ? global.dinheiro : 1000,
        minerio: variable_global_exists("minerio") ? global.minerio : 500,
        populacao: variable_global_exists("populacao") ? global.populacao : 100
    };
    
    return _recursos;
}
