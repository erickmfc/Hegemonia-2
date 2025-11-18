// ===============================================
// HEGEMONIA GLOBAL - SELEÇÃO INTELIGENTE DE UNIDADES
// Sistema Adaptativo baseado no Exército do Jogador
// ===============================================

/// @function scr_ia_selecionar_melhor_unidade(_presidente_id)
/// @description Seleciona a melhor unidade para recrutar baseada em recursos e estratégia
/// @param {id} _presidente_id - ID do objeto presidente
/// @returns {object} Tipo de objeto da melhor unidade

function scr_ia_selecionar_melhor_unidade(_presidente_id) {
    if (!instance_exists(_presidente_id)) return noone;
    
    // === ANÁLISE 1: Recursos disponíveis ===
    var _recursosAltos = (global.dinheiro > 100000);
    var _recursosMedios = (global.dinheiro > 50000);
    var _recursosBaixos = (global.dinheiro <= 50000);
    
    // === ANÁLISE 2: Composição do exercito do jogador ===
    var _analise_exercito = scr_ia_analisar_exercito_jogador();
    
    // Adaptar estrutura para compatibilidade
    var _avioes = _analise_exercito.total_aereas;
    var _navios = _analise_exercito.total_navais;
    var _terrestres = _analise_exercito.total_terrestres;
    
    // === DEBUG ===
    if (variable_global_exists("debug_enabled") && global.debug_enabled && frame_count % 300 == 0) {
        show_debug_message("🎯 IA Selecionando Unidade:");
        show_debug_message("   Dinheiro: $" + string(global.dinheiro));
        show_debug_message("   Avioes do Jogador: " + string(_avioes));
        show_debug_message("   Navios do Jogador: " + string(_navios));
        show_debug_message("   Terrestres do Jogador: " + string(_terrestres));
    }
    
    // === PRIORIDADES ESTRATÉGICAS ===
    
    // CONTRA-ESTRATÉGIA 1: Se jogador tem muitos aviões → priorizar defesa aérea
    if (_avioes > _terrestres * 0.5) {
        if (_recursosAltos) {
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚔️ IA: Jogador tem muitos aviões! → Recrutando Defesa Aérea Elite");
            }
            return obj_blindado_antiaereo; // Defesa pesada
        } else if (_recursosMedios) {
            return obj_soldado_antiaereo; // Defesa básica
        }
    }
    
    // CONTRA-ESTRATÉGIA 2: Se jogador tem muitos navios → priorizar submarinos ou aviões
    if (_navios > 3) {
        if (_recursosAltos) {
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚔️ IA: Jogador tem muitos navios! → Recrutando F-15 para bombardeio");
            }
            return obj_f15; // Aviões para bombardeio naval
        } else if (_recursosMedios) {
            return obj_submarino_base; // Submarinos para ataque furtivo
        }
    }
    
    // CONTRA-ESTRATÉGIA 3: Se jogador tem muitos tanques → priorizar aviões
    if (_terrestres > _avioes * 2) {
        if (_recursosAltos) {
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚔️ IA: Jogador tem muitos tanques! → Recrutando F-15 para ataque aéreo");
            }
            return obj_f15;
        } else if (_recursosMedios) {
            return obj_f6;
        }
    }
    
    // === ESTRATÉGIA PADRÃO: Balanceamento ===
    if (_recursosAltos) {
        // 40% Aviões Elite, 30% Defesa Aérea, 20% Tanques, 10% Naval
        var _sorte = random(100);
        if (_sorte < 40) {
            return obj_f15; // Elite aéreo
        } else if (_sorte < 70) {
            return obj_blindado_antiaereo; // Defesa
        } else if (_sorte < 90) {
            return obj_tanque; // Terrestre
        } else {
            return obj_submarino_base; // Naval
        }
    } else if (_recursosMedios) {
        // 35% Aviões, 25% Tanques, 25% Defesa, 15% Naval
        var _sorte = random(100);
        if (_sorte < 35) {
            return obj_f6; // Aviões intermediários
        } else if (_sorte < 60) {
            return obj_tanque; // Tanques
        } else if (_sorte < 85) {
            return obj_soldado_antiaereo; // Defesa
        } else {
            return obj_lancha_patrulha; // Naval
        }
    } else {
        // Recursos baixos → infantaria ou defesa básica
        var _sorte = random(100);
        if (_sorte < 70) {
            return obj_infantaria;
        } else {
            return obj_soldado_antiaereo;
        }
    }
}

/// @function scr_ia_contar_unidades_ia()
/// @description Conta unidades da IA
/// @returns {struct} Contagem de unidades

function scr_ia_contar_unidades_ia() {
    var _contagem = {
        total: 0,
        avioes: 0,
        terrestres: 0,
        navios: 0,
        defesa_aerea: 0
    };
    
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _contagem.terrestres++;
            _contagem.total++;
        }
    }
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _contagem.terrestres++;
            _contagem.total++;
        }
    }
    with (obj_f15) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _contagem.avioes++;
            _contagem.total++;
        }
    }
    with (obj_f6) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _contagem.avioes++;
            _contagem.total++;
        }
    }
    with (obj_RonaldReagan) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _contagem.navios++;
            _contagem.total++;
        }
    }
    
    return _contagem;
}
