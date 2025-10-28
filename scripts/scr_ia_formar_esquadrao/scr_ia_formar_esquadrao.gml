/// @description Formar Esquadrão de Ataque da IA
/// @param _ia_id ID da IA
/// @return true se conseguiu formar esquadrão

function scr_ia_formar_esquadrao(_ia_id) {
    var _ia = _ia_id;
    
    // Limpar esquadrão anterior
    ds_list_clear(_ia.unidades_em_esquadrao);
    
    // Contar unidades disponíveis perto da base
    var _unidades_disponiveis = ds_list_create();
    
    // Procurar infantaria da IA
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            if (_dist <= 400) { // Dentro de 400 pixels da base
                ds_list_add(_unidades_disponiveis, {
                    id: id,
                    tipo: "infantaria",
                    distancia: _dist
                });
            }
        }
    }
    
    // Procurar tanques da IA
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            if (_dist <= 400) {
                ds_list_add(_unidades_disponiveis, {
                    id: id,
                    tipo: "tanque",
                    distancia: _dist
                });
            }
        }
    }
    
    // Procurar soldados anti-aéreo da IA
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            if (_dist <= 400) {
                ds_list_add(_unidades_disponiveis, {
                    id: id,
                    tipo: "antiaereo",
                    distancia: _dist
                });
            }
        }
    }
    
    // Verificar se temos unidades suficientes
    var _num_unidades = ds_list_size(_unidades_disponiveis);
    
    if (_num_unidades >= _ia.esquadrao_tamanho_minimo) {
        // Formar esquadrão com as unidades mais próximas
        var _limite = min(_num_unidades, 8); // Máximo 8 unidades por esquadrão
        
        for (var i = 0; i < _limite; i++) {
            var _unidade_data = ds_list_find_value(_unidades_disponiveis, i);
            if (is_struct(_unidade_data)) {
                if (variable_struct_exists(_unidade_data, "id") && instance_exists(_unidade_data.id)) {
                    ds_list_add(_ia.unidades_em_esquadrao, _unidade_data.id);
                }
            }
        }
        
        show_debug_message("⚔️ ESQUADRÃO FORMADO: " + string(ds_list_size(_ia.unidades_em_esquadrao)) + " unidades prontas para atacar!");
        
        // Marcar que esquadrão está formado
        _ia.esquadrao_formando = true;
        _ia.objetivo_atual = "atacar";
        
        ds_list_destroy(_unidades_disponiveis);
        return true;
    } else {
        show_debug_message("⚠️ IA não tem unidades suficientes para formar esquadrão (Tem: " + string(_num_unidades) + ", Precisa: " + string(_ia.esquadrao_tamanho_minimo) + ")");
        _ia.esquadrao_formando = false;
        
        ds_list_destroy(_unidades_disponiveis);
        return false;
    }
}
