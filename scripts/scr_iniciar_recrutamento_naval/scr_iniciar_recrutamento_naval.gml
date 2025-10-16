/// @function scr_iniciar_recrutamento_naval(_quartel_id, _tipo_unidade)
/// @description Inicia o recrutamento de uma unidade naval específica
/// @param {Id.Instance} _quartel_id ID do quartel naval
/// @param {String} _tipo_unidade Tipo de unidade a ser recrutada
/// @return {Bool} Retorna true se o recrutamento foi iniciado

function scr_iniciar_recrutamento_naval(_quartel_id, _tipo_unidade) {
    // ===============================================
    // HEGEMONIA GLOBAL - INICIAR RECRUTAMENTO NAVAL
    // Sistema para iniciar recrutamento de unidades navais
    // ===============================================
    
    if (!instance_exists(_quartel_id)) {
        show_debug_message("❌ Quartel naval não encontrado");
        return false;
    }
    
    show_debug_message("🚢 Iniciando recrutamento naval: " + _tipo_unidade);
    
    // Verificar se o quartel é naval
    if (_quartel_id.object_index != obj_quartel_marinha) {
        show_debug_message("❌ Objeto não é um quartel naval");
        return false;
    }
    
    // Verificar recursos necessários
    var _recursos_ok = scr_verificar_recursos_naval(_tipo_unidade);
    if (!_recursos_ok) {
        show_debug_message("❌ Recursos insuficientes para recrutamento naval");
        return false;
    }
    
    // Iniciar recrutamento
    with (_quartel_id) {
        switch (_tipo_unidade) {
            case "lancha_patrulha":
                if (variable_instance_exists(id, "produzindo_lancha")) {
                    produzindo_lancha = true;
                    timer_producao_lancha = 180; // 3 segundos
                    show_debug_message("🚢 Lancha patrulha em produção");
                }
                break;
                
            case "fragata":
                if (variable_instance_exists(id, "produzindo_fragata")) {
                    produzindo_fragata = true;
                    timer_producao_fragata = 300; // 5 segundos
                    show_debug_message("🚢 Fragata em produção");
                }
                break;
                
            case "destroyer":
                if (variable_instance_exists(id, "produzindo_destroyer")) {
                    produzindo_destroyer = true;
                    timer_producao_destroyer = 420; // 7 segundos
                    show_debug_message("🚢 Destroyer em produção");
                }
                break;
                
            case "submarino":
                if (variable_instance_exists(id, "produzindo_submarino")) {
                    produzindo_submarino = true;
                    timer_producao_submarino = 600; // 10 segundos
                    show_debug_message("🚢 Submarino em produção");
                }
                break;
                
            default:
                show_debug_message("❌ Tipo de unidade naval não reconhecido: " + _tipo_unidade);
                return false;
        }
    }
    
    // Deduzir recursos
    scr_deduzir_recursos_naval(_tipo_unidade);
    
    show_debug_message("✅ Recrutamento naval iniciado com sucesso");
    return true;
}

/// @function scr_verificar_recursos_naval(_tipo_unidade)
/// @description Verifica se há recursos suficientes para recrutamento naval
/// @param {String} _tipo_unidade Tipo de unidade
/// @return {Bool} Retorna true se há recursos suficientes

function scr_verificar_recursos_naval(_tipo_unidade) {
    var _custo_dinheiro = 0;
    
    switch (_tipo_unidade) {
        case "lancha_patrulha":
            _custo_dinheiro = 800;
            break;
            
        case "fragata":
            _custo_dinheiro = 1500;
            break;
            
        case "destroyer":
            _custo_dinheiro = 2500;
            break;
            
        case "submarino":
            _custo_dinheiro = 3000;
            break;
            
        default:
            return false;
    }
    
    // Verificar dinheiro (sistema unificado)
    if (global.dinheiro < _custo_dinheiro) {
        show_debug_message("❌ Dinheiro insuficiente: " + string(global.dinheiro) + " < " + string(_custo_dinheiro));
        return false;
    }
    
    return true;
}

/// @function scr_deduzir_recursos_naval(_tipo_unidade)
/// @description Deduz os recursos necessários para recrutamento naval
/// @param {String} _tipo_unidade Tipo de unidade
/// @return {undefined}

function scr_deduzir_recursos_naval(_tipo_unidade) {
    var _custo_dinheiro = 0;
    
    switch (_tipo_unidade) {
        case "lancha_patrulha":
            _custo_dinheiro = 800;
            break;
            
        case "fragata":
            _custo_dinheiro = 1500;
            break;
            
        case "destroyer":
            _custo_dinheiro = 2500;
            break;
            
        case "submarino":
            _custo_dinheiro = 3000;
            break;
    }
    
    // Deduzir recursos (sistema unificado)
    global.dinheiro -= _custo_dinheiro;
    
    show_debug_message("💰 Recursos deduzidos: $" + string(_custo_dinheiro));
}

/// @function scr_cancelar_recrutamento_naval(_quartel_id)
/// @description Cancela o recrutamento naval em andamento
/// @param {Id.Instance} _quartel_id ID do quartel naval
/// @return {Bool} Retorna true se o cancelamento foi bem-sucedido

function scr_cancelar_recrutamento_naval(_quartel_id) {
    if (!instance_exists(_quartel_id)) {
        return false;
    }
    
    show_debug_message("❌ Cancelando recrutamento naval...");
    
    with (_quartel_id) {
        // Cancelar todas as produções
        if (variable_instance_exists(id, "produzindo_lancha")) {
            produzindo_lancha = false;
            timer_producao_lancha = 0;
        }
        if (variable_instance_exists(id, "produzindo_fragata")) {
            produzindo_fragata = false;
            timer_producao_fragata = 0;
        }
        if (variable_instance_exists(id, "produzindo_destroyer")) {
            produzindo_destroyer = false;
            timer_producao_destroyer = 0;
        }
        if (variable_instance_exists(id, "produzindo_submarino")) {
            produzindo_submarino = false;
            timer_producao_submarino = 0;
        }
    }
    
    show_debug_message("✅ Recrutamento naval cancelado");
    return true;
}

/// @function scr_verificar_status_recrutamento_naval(_quartel_id)
/// @description Verifica o status do recrutamento naval
/// @param {Id.Instance} _quartel_id ID do quartel naval
/// @return {String} Status do recrutamento

function scr_verificar_status_recrutamento_naval(_quartel_id) {
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
        if (variable_instance_exists(id, "produzindo_submarino") && produzindo_submarino) {
            return "produzindo_submarino";
        }
    }
    
    return "ocioso";
}

/// @function scr_acelerar_recrutamento_naval(_quartel_id, _fator_aceleracao)
/// @description Acelera o recrutamento naval
/// @param {Id.Instance} _quartel_id ID do quartel naval
/// @param {Real} _fator_aceleracao Fator de aceleração (ex: 2.0 = 2x mais rápido)
/// @return {Bool} Retorna true se a aceleração foi aplicada

function scr_acelerar_recrutamento_naval(_quartel_id, _fator_aceleracao) {
    if (!instance_exists(_quartel_id)) {
        return false;
    }
    
    show_debug_message("⚡ Acelerando recrutamento naval por " + string(_fator_aceleracao) + "x");
    
    with (_quartel_id) {
        // Acelerar todos os timers de produção
        if (variable_instance_exists(id, "timer_producao_lancha")) {
            timer_producao_lancha = max(1, timer_producao_lancha / _fator_aceleracao);
        }
        if (variable_instance_exists(id, "timer_producao_fragata")) {
            timer_producao_fragata = max(1, timer_producao_fragata / _fator_aceleracao);
        }
        if (variable_instance_exists(id, "timer_producao_destroyer")) {
            timer_producao_destroyer = max(1, timer_producao_destroyer / _fator_aceleracao);
        }
        if (variable_instance_exists(id, "timer_producao_submarino")) {
            timer_producao_submarino = max(1, timer_producao_submarino / _fator_aceleracao);
        }
    }
    
    show_debug_message("✅ Recrutamento naval acelerado");
    return true;
}