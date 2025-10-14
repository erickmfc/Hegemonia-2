/// @function scr_forcar_producao_naval(_quartel_id, _tipo_unidade)
/// @description Força a produção de uma unidade naval específica
/// @param {Id.Instance} _quartel_id ID do quartel que vai produzir
/// @param {String} _tipo_unidade Tipo de unidade a ser produzida
/// @return {Bool} Retorna true se a produção foi iniciada com sucesso

function scr_forcar_producao_naval(_quartel_id, _tipo_unidade) {
    // ===============================================
    // HEGEMONIA GLOBAL - FORÇAR PRODUÇÃO NAVAL
    // Sistema para forçar produção de unidades navais
    // ===============================================
    
    if (!instance_exists(_quartel_id)) {
        show_debug_message("❌ Quartel não encontrado para produção naval");
        return false;
    }
    
    show_debug_message("🚢 Forçando produção naval: " + _tipo_unidade);
    
    // Verificar recursos necessários
    var _custo_dinheiro = 0;
    var _custo_minerio = 0;
    
    switch (_tipo_unidade) {
        case "lancha_patrulha":
            _custo_dinheiro = 800;
            _custo_minerio = 200;
            break;
            
        case "fragata":
            _custo_dinheiro = 1500;
            _custo_minerio = 400;
            break;
            
        case "destroyer":
            _custo_dinheiro = 2500;
            _custo_minerio = 600;
            break;
            
        default:
            show_debug_message("❌ Tipo de unidade naval não reconhecido: " + _tipo_unidade);
            return false;
    }
    
    // Verificar se há recursos suficientes
    if (global.dinheiro < _custo_dinheiro) {
        show_debug_message("❌ Dinheiro insuficiente para produção naval");
        return false;
    }
    
    if (global.nacao_recursos[? "Minério"] < _custo_minerio) {
        show_debug_message("❌ Minério insuficiente para produção naval");
        return false;
    }
    
    // Deduzir recursos
    global.dinheiro -= _custo_dinheiro;
    global.nacao_recursos[? "Minério"] -= _custo_minerio;
    
    // Iniciar produção
    with (_quartel_id) {
        switch (_tipo_unidade) {
            case "lancha_patrulha":
                if (variable_instance_exists(id, "produzindo_lancha")) {
                    produzindo_lancha = true;
                    timer_producao_lancha = 180; // 3 segundos
                }
                break;
                
            case "fragata":
                if (variable_instance_exists(id, "produzindo_fragata")) {
                    produzindo_fragata = true;
                    timer_producao_fragata = 300; // 5 segundos
                }
                break;
                
            case "destroyer":
                if (variable_instance_exists(id, "produzindo_destroyer")) {
                    produzindo_destroyer = true;
                    timer_producao_destroyer = 420; // 7 segundos
                }
                break;
        }
    }
    
    show_debug_message("✅ Produção naval forçada iniciada: " + _tipo_unidade);
    show_debug_message("💰 Custo: $" + string(_custo_dinheiro) + " dinheiro, " + string(_custo_minerio) + " minério");
    
    return true;
}

/// @function scr_forcar_producao_naval_emergencia()
/// @description Força produção naval de emergência (sem verificar recursos)
/// @return {undefined}

function scr_forcar_producao_naval_emergencia() {
    show_debug_message("🚨 PRODUÇÃO NAVAL DE EMERGÊNCIA ATIVADA");
    
    // Encontrar quartel naval mais próximo
    var _quartel_naval = instance_nearest(0, 0, obj_quartel_marinha);
    if (!instance_exists(_quartel_naval)) {
        show_debug_message("❌ Nenhum quartel naval encontrado");
        return;
    }
    
    // Forçar produção de lancha patrulha (mais rápida)
    scr_forcar_producao_naval(_quartel_naval, "lancha_patrulha");
    
    show_debug_message("🚢 Lancha de emergência em produção");
}

/// @function scr_verificar_producao_naval(_quartel_id)
/// @description Verifica o status da produção naval em um quartel
/// @param {Id.Instance} _quartel_id ID do quartel a verificar
/// @return {String} Status da produção

function scr_verificar_producao_naval(_quartel_id) {
    if (!instance_exists(_quartel_id)) {
        return "quartel_nao_encontrado";
    }
    
    with (_quartel_id) {
        if (variable_instance_exists(id, "produzindo_lancha") && produzindo_lancha) {
            return "produzindo_lancha";
        }
        if (variable_instance_exists(id, "produzindo_fragata") && produzindo_fragata) {
            return "produzindo_fragata";
        }
        if (variable_instance_exists(id, "produzindo_destroyer") && produzindo_destroyer) {
            return "produzindo_destroyer";
        }
    }
    
    return "ocioso";
}