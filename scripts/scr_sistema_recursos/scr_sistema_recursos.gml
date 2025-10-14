// ===============================================
// HEGEMONIA GLOBAL - SISTEMA DE RECURSOS CENTRALIZADO
// Evita Conflitos e Dedução Dupla
// ===============================================

/// @description Inicializar sistema de recursos global
function inicializar_recursos_globais() {
    // Recursos básicos
    global.dinheiro = 1000;
    global.minerio = 500;
    global.petroleo = 200;
    global.populacao = 100;
    
    // Contadores de unidades
    global.militares_totais = 0;
    global.navios_totais = 0;
    
    // Mapa consolidado de recursos
    global.estoque_recursos = ds_map_create();
    global.estoque_recursos[? "Dinheiro"] = global.dinheiro;
    global.estoque_recursos[? "Minério"] = global.minerio;
    global.estoque_recursos[? "Petróleo"] = global.petroleo;
    global.estoque_recursos[? "População"] = global.populacao;
    
    show_debug_message("✅ Sistema de recursos inicializado");
}

/// @description Verificar se há recursos suficientes
/// @param tipo_recurso Tipo do recurso ("dinheiro", "minerio", etc.)
/// @param quantidade Quantidade necessária
function verificar_recurso_disponivel(tipo_recurso, quantidade) {
    var _disponivel = 0;
    
    switch (tipo_recurso) {
        case "dinheiro":
            _disponivel = global.dinheiro;
            break;
        case "minerio":
            _disponivel = global.minerio;
            break;
        case "petroleo":
            _disponivel = global.petroleo;
            break;
        case "populacao":
            _disponivel = global.populacao - global.militares_totais;
            break;
        default:
            show_debug_message("❌ Tipo de recurso não reconhecido: " + string(tipo_recurso));
            return false;
    }
    
    return _disponivel >= quantidade;
}

/// @description Deduzir recurso de forma segura
/// @param tipo_recurso Tipo do recurso
/// @param quantidade Quantidade a deduzir
function deduzir_recurso_seguro(tipo_recurso, quantidade) {
    if (!verificar_recurso_disponivel(tipo_recurso, quantidade)) {
        show_debug_message("❌ Recursos insuficientes para dedução!");
        return false;
    }
    
    switch (tipo_recurso) {
        case "dinheiro":
            global.dinheiro -= quantidade;
            global.estoque_recursos[? "Dinheiro"] = global.dinheiro;
            break;
        case "minerio":
            global.minerio -= quantidade;
            global.estoque_recursos[? "Minério"] = global.minerio;
            break;
        case "petroleo":
            global.petroleo -= quantidade;
            global.estoque_recursos[? "Petróleo"] = global.petroleo;
            break;
        case "populacao":
            global.militares_totais += quantidade;
            global.estoque_recursos[? "População"] = global.populacao - global.militares_totais;
            break;
        default:
            show_debug_message("❌ Tipo de recurso não reconhecido: " + string(tipo_recurso));
            return false;
    }
    
    show_debug_message("💰 Recurso deduzido: " + string(quantidade) + " " + tipo_recurso);
    return true;
}

/// @description Adicionar recurso de forma segura
/// @param tipo_recurso Tipo do recurso
/// @param quantidade Quantidade a adicionar
function adicionar_recurso_seguro(tipo_recurso, quantidade) {
    switch (tipo_recurso) {
        case "dinheiro":
            global.dinheiro += quantidade;
            global.estoque_recursos[? "Dinheiro"] = global.dinheiro;
            break;
        case "minerio":
            global.minerio += quantidade;
            global.estoque_recursos[? "Minério"] = global.minerio;
            break;
        case "petroleo":
            global.petroleo += quantidade;
            global.estoque_recursos[? "Petróleo"] = global.petroleo;
            break;
        case "populacao":
            global.populacao += quantidade;
            global.estoque_recursos[? "População"] = global.populacao - global.militares_totais;
            break;
        default:
            show_debug_message("❌ Tipo de recurso não reconhecido: " + string(tipo_recurso));
            return false;
    }
    
    show_debug_message("💰 Recurso adicionado: " + string(quantidade) + " " + tipo_recurso);
    return true;
}

/// @description Obter quantidade de recurso disponível
/// @param tipo_recurso Tipo do recurso
function obter_recurso_disponivel(tipo_recurso) {
    switch (tipo_recurso) {
        case "dinheiro":
            return global.dinheiro;
        case "minerio":
            return global.minerio;
        case "petroleo":
            return global.petroleo;
        case "populacao":
            return global.populacao - global.militares_totais;
        default:
            return 0;
    }
}
