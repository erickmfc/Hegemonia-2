/// @description Distribui unidades em formação estratégica (não grudadas)
/// @param {real} _ia_id ID da IA
/// @param {real} _centro_x Centro da formação
/// @param {real} _centro_y Centro da formação
/// @param {real} _raio_formacao Raio da formação (padrão: 200)

function scr_ia_distribuir_unidades(_ia_id, _centro_x, _centro_y, _raio_formacao = 200) {
    var _ia = _ia_id;
    
    // === COLETAR TODAS AS UNIDADES DA IA ===
    var _unidades_ia = [];
    var _index = 0;
    
    // Infantaria
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _unidades_ia[_index] = id;
            _index++;
        }
    }
    
    // Tanques
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _unidades_ia[_index] = id;
            _index++;
        }
    }
    
    // Soldados anti-aéreo
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _unidades_ia[_index] = id;
            _index++;
        }
    }
    
    if (array_length(_unidades_ia) == 0) return;
    
    // === DISTRIBUIR EM FORMAÇÃO CÍRCULAR OU LINHA ===
    var _num_unidades = array_length(_unidades_ia);
    var _espacamento = 80; // Distância entre unidades
    
    // Calcular formação baseada na quantidade
    var _formacao = "circular";
    if (_num_unidades > 12) {
        _formacao = "linha"; // Muitas unidades = linha
    }
    
    for (var i = 0; i < _num_unidades; i++) {
        var _unidade = _unidades_ia[i];
        if (!instance_exists(_unidade)) continue;
        
        var _pos_x = _centro_x;
        var _pos_y = _centro_y;
        
        if (_formacao == "circular") {
            // Formação circular
            var _angulo = (i / _num_unidades) * 360;
            var _raio = _raio_formacao;
            
            _pos_x = _centro_x + lengthdir_x(_raio, _angulo);
            _pos_y = _centro_y + lengthdir_y(_raio, _angulo);
            
        } else {
            // Formação em linha/quadrado
            var _colunas = ceil(sqrt(_num_unidades));
            var _linha = i div _colunas;
            var _coluna = i mod _colunas;
            
            var _offset_x = (_coluna - _colunas / 2) * _espacamento;
            var _offset_y = (_linha - (_num_unidades / _colunas) / 2) * _espacamento;
            
            _pos_x = _centro_x + _offset_x;
            _pos_y = _centro_y + _offset_y;
        }
        
        // Mover unidade para posição (se não estiver em combate)
        if (variable_instance_exists(_unidade, "estado")) {
            if (_unidade.estado != "atacando" && _unidade.estado != "movendo_para_alvo") {
                if (variable_instance_exists(_unidade, "destino_x")) {
                    _unidade.destino_x = _pos_x;
                    _unidade.destino_y = _pos_y;
                }
                if (variable_instance_exists(_unidade, "estado")) {
                    _unidade.estado = "movendo";
                }
            }
        }
    }
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("📐 IA distribuiu " + string(_num_unidades) + " unidades em formação " + _formacao);
    }
}
