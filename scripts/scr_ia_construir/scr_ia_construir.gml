/// @description Módulo de Construção da IA
/// @param _ia_id ID da IA
/// @param _objeto_tipo Tipo de objeto a construir (ex: obj_fazenda, obj_quartel)
/// @param _x Posição X
/// @param _y Posição Y
/// @return true se construiu com sucesso, false caso contrário

function scr_ia_construir(_ia_id, _objeto_tipo, _x, _y) {
    var _ia = _ia_id;
    
    // ✅ NOVO: Usar posicionamento estratégico se tipo for conhecido
    var _tipo_estrutura = "economia"; // Default
    
    if (_objeto_tipo == obj_fazenda || _objeto_tipo == obj_mina) {
        _tipo_estrutura = "economia";
    } else if (_objeto_tipo == obj_quartel) {
        _tipo_estrutura = "militar";
    } else if (_objeto_tipo == obj_quartel_marinha) {
        _tipo_estrutura = "naval";
    } else if (_objeto_tipo == obj_aeroporto_militar) {
        _tipo_estrutura = "aereo";
    }
    
    // ✅ NOVO: Encontrar posição estratégica (evita grudar)
    var _pos_estrategica = scr_ia_encontrar_posicao_estrategica(_ia, _tipo_estrutura, 250);
    
    // Usar posição estratégica se válida, senão usar a recebida
    if (_pos_estrategica.valida) {
        _x = _pos_estrategica.x;
        _y = _pos_estrategica.y;
    }
    
    // 1. Obter custos
    var _custo_d = 0;
    var _custo_m = 0;
    var _nome_edificio = "";
    
    if (_objeto_tipo == obj_fazenda) {
        _custo_d = 500; // Custo reduzido para IA
        _custo_m = 0;
        _nome_edificio = "Fazenda";
    } else if (_objeto_tipo == obj_quartel) {
        _custo_d = 400;
        _custo_m = 250;
        _nome_edificio = "Quartel";
    } else if (_objeto_tipo == obj_mina) {
        _custo_d = 300;
        _custo_m = 100;
        _nome_edificio = "Mina";
    } else if (_objeto_tipo == obj_quartel_marinha) {
        _custo_d = 600;
        _custo_m = 350;
        _nome_edificio = "Quartel Naval";
    } else if (_objeto_tipo == obj_aeroporto_militar) {
        _custo_d = 800;
        _custo_m = 500;
        _nome_edificio = "Aeroporto Militar";
    }
    
    // 2. Verificar recursos
    if (global.ia_dinheiro < _custo_d || global.ia_minerio < _custo_m) {
        show_debug_message("❌ IA sem recursos: $" + string(global.ia_dinheiro) + " < $" + string(_custo_d) + " ou " + string(global.ia_minerio) + " < " + string(_custo_m));
        return false;
    }
    
    // ✅ NOVO: Verificar se quartel naval está em água
    if (_objeto_tipo == obj_quartel_marinha) {
        if (!scr_check_water_tile(_x, _y)) {
            // Tentar encontrar água próxima
            var _posicao_agua = scr_find_nearest_water(_x, _y, 500);
            if (_posicao_agua[0] != -1) {
                _x = _posicao_agua[0];
                _y = _posicao_agua[1];
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🌊 IA ajustou posição do quartel naval para água: (" + string(_x) + ", " + string(_y) + ")");
                }
            } else {
                show_debug_message("❌ IA não encontrou água próxima para quartel naval em (" + string(_x) + ", " + string(_y) + ")");
                return false;
            }
        }
    }
    
    // 3. Verificar se há espaço (sem overlap) com variação aleatória
    var _variacao_x = random_range(-50, 50); // Variação de ±50 pixels
    var _variacao_y = random_range(-50, 50); // Variação de ±50 pixels
    var _pos_x_final = _x + _variacao_x;
    var _pos_y_final = _y + _variacao_y;
    
    // ✅ CORRIGIDO: Se for quartel naval, garantir que a variação ainda está em água
    if (_objeto_tipo == obj_quartel_marinha) {
        if (!scr_check_water_tile(_pos_x_final, _pos_y_final)) {
            // Se a variação saiu da água, buscar água próxima
            var _pos_agua_variacao = scr_find_nearest_water(_pos_x_final, _pos_y_final, 100);
            if (_pos_agua_variacao[0] != -1) {
                _pos_x_final = _pos_agua_variacao[0];
                _pos_y_final = _pos_agua_variacao[1];
            } else {
                // Não encontrou, usar posição original (já validada como água)
                _pos_x_final = _x;
                _pos_y_final = _y;
            }
        }
    }
    
    var _ja_existe = instance_position(_pos_x_final, _pos_y_final, _objeto_tipo);
    if (_ja_existe != noone) {
        // Tentar posição alternativa se ocupada
        for (var _tentativa = 0; _tentativa < 5; _tentativa++) {
        _variacao_x = random_range(-80, 80);
        _variacao_y = random_range(-80, 80);
        _pos_x_final = _x + _variacao_x;
        _pos_y_final = _y + _variacao_y;
            
            // ✅ Se for quartel naval, verificar água novamente
            if (_objeto_tipo == obj_quartel_marinha) {
                if (!scr_check_water_tile(_pos_x_final, _pos_y_final)) {
                    var _pos_agua_alt = scr_find_nearest_water(_pos_x_final, _pos_y_final, 150);
                    if (_pos_agua_alt[0] != -1) {
                        _pos_x_final = _pos_agua_alt[0];
                        _pos_y_final = _pos_agua_alt[1];
                    } else {
                        continue; // Tentar próxima variação
                    }
                }
            }
            
        _ja_existe = instance_position(_pos_x_final, _pos_y_final, _objeto_tipo);
            if (_ja_existe == noone) {
                break; // Encontrou posição livre
            }
        }
        
        if (_ja_existe != noone) {
            show_debug_message("❌ IA: Posição ocupada após tentativas");
            return false;
        }
    }
    
    // 4. CRIAR a estrutura com posição variada
    var _nova_estrutura = instance_create_layer(_pos_x_final, _pos_y_final, "Instances", _objeto_tipo);
    if (instance_exists(_nova_estrutura)) {
        // IMPORTANTE: Definir nacao_proprietaria
        _nova_estrutura.nacao_proprietaria = _ia.nacao_proprietaria;
        
        // 5. DEDUZIR recursos
        global.ia_dinheiro -= _custo_d;
        global.ia_minerio -= _custo_m;
        
        show_debug_message("✅ IA construiu " + _nome_edificio + " em (" + string(_pos_x_final) + ", " + string(_pos_y_final) + ") com variação de (" + string(_variacao_x) + ", " + string(_variacao_y) + ")");
        show_debug_message("💰 IA recursos restantes: $" + string(global.ia_dinheiro) + " | Minério: " + string(global.ia_minerio));
        
        return true;
    }
    
    show_debug_message("❌ IA falhou ao criar " + _nome_edificio);
    return false;
}
