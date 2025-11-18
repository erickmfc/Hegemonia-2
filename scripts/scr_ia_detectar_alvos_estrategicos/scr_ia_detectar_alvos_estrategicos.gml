// ===============================================
// HEGEMONIA GLOBAL - DETECÇÃO DE ALVOS ESTRATÉGICOS
// Sistema para encontrar alvos prioritários para a IA
// ===============================================

/// @function scr_ia_encontrar_alvo_prioritario()
/// @description Encontra melhor alvo estratégico para ataque
/// @returns {id} ID do alvo ou noone

function scr_ia_encontrar_alvo_prioritario() {
    
    // === PRIORIDADE 1: Estruturas econômicas defensáveis ===
    with (obj_mina_ouro) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id; // Primeira mina encontrada
        }
    }
    with (obj_mina_aluminio) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    with (obj_mina_cobre) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    with (obj_fazenda) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    
    // === PRIORIDADE 2: Quartéis e bases militares ===
    with (obj_quartel) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    with (obj_quartel_marinha) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    with (obj_aeroporto_militar) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    
    // === PRIORIDADE 3: Centro de pesquisa (muito valioso) ===
    var _obj_centro = asset_get_index("obj_research_center");
    if (_obj_centro != -1 && asset_get_type(_obj_centro) == asset_object) {
        with (_obj_centro) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                return id;
            }
        }
    }
    
    // === PRIORIDADE 4: Unidades terrestres do jogador ===
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    
    // === PRIORIDADE 5: Unidades navais do jogador ===
    with (obj_RonaldReagan) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    with (obj_Independence) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    with (obj_Constellation) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            return id;
        }
    }
    
    // Se não encontrar nada, retorna noone
    return noone;
}

/// @function scr_ia_encontrar_alvos_multiplos(_quantidade)
/// @description Encontra múltiplos alvos estratégicos
/// @param {int} _quantidade - Número de alvos a encontrar
/// @returns {array} Array de IDs de alvos

function scr_ia_encontrar_alvos_multiplos(_quantidade = 3) {
    var _alvos = [];
    var _alvos_encontrados = 0;
    
    // === PRIORIDADE 1: Estruturas econômicas ===
    with (obj_mina_ouro) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            if (_alvos_encontrados < _quantidade) {
                array_push(_alvos, id);
                _alvos_encontrados++;
            }
        }
    }
    with (obj_fazenda) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            if (_alvos_encontrados < _quantidade) {
                array_push(_alvos, id);
                _alvos_encontrados++;
            }
        }
    }
    
    // === PRIORIDADE 2: Bases militares ===
    with (obj_quartel) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            if (_alvos_encontrados < _quantidade) {
                array_push(_alvos, id);
                _alvos_encontrados++;
            }
        }
    }
    
    // === PRIORIDADE 3: Unidades do jogador ===
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            if (_alvos_encontrados < _quantidade) {
                array_push(_alvos, id);
                _alvos_encontrados++;
            }
        }
    }
    
    return _alvos;
}

/// @function scr_ia_avaliar_valor_alvo(_alvo_id)
/// @description Avalia o valor estratégico de um alvo
/// @param {id} _alvo_id - ID do alvo
/// @returns {real} Valor do alvo (0-100)

function scr_ia_avaliar_valor_alvo(_alvo_id) {
    if (!instance_exists(_alvo_id)) return 0;
    
    var _obj_name = object_get_name(_alvo_id.object_index);
    var _valor = 0;
    
    // Estruturas econômicas: valor alto
    if (string_pos("mina", _obj_name) > 0) {
        _valor = 80;
    } else if (string_pos("fazenda", _obj_name) > 0) {
        _valor = 70;
    } else if (string_pos("research", _obj_name) > 0 || string_pos("pesquisa", _obj_name) > 0) {
        _valor = 90; // Centro de pesquisa: muito valioso
    } else if (string_pos("quartel", _obj_name) > 0) {
        _valor = 75; // Base militar
    } else if (string_pos("aeroporto", _obj_name) > 0) {
        _valor = 70; // Base aérea
    } else if (string_pos("tanque", _obj_name) > 0) {
        _valor = 60; // Unidade terrestre forte
    } else if (string_pos("navio", _obj_name) > 0 || string_pos("Ronald", _obj_name) > 0) {
        _valor = 85; // Navio: muito valioso
    } else {
        _valor = 50; // Valor padrão
    }
    
    return _valor;
}
