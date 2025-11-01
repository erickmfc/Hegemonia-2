/// @description Move tropas estrategicamente (usando mais espaço do mapa)
/// @param {real} _ia_id ID da IA
/// @param {real} _alvo_x Alvo X
/// @param {real} _alvo_y Alvo Y
/// @param {real} _raio_ataque Raio de ataque ao redor do alvo

function scr_ia_mover_tropas_estrategico(_ia_id, _alvo_x, _alvo_y, _raio_ataque = 300) {
    var _ia = _ia_id;
    
    // === COLETAR UNIDADES DA IA ===
    var _unidades = [];
    var _index = 0;
    
    var _tipos_unidades = [
        obj_infantaria,
        obj_tanque,
        obj_soldado_antiaereo,
        obj_blindado_antiaereo
    ];
    
    for (var i = 0; i < array_length(_tipos_unidades); i++) {
        if (!object_exists(_tipos_unidades[i])) continue;
        
        with (_tipos_unidades[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                // Não mover se já está em combate direto
                if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
                    continue; // Já está atacando, não mover
                }
                
                _unidades[_index] = id;
                _index++;
            }
        }
    }
    
    if (array_length(_unidades) == 0) return;
    
    var _num_unidades = array_length(_unidades);
    
    // === DISTRIBUIR UNIDADES AO REDOR DO ALVO EM FORMAÇÃO ===
    // Formação circular ao redor do alvo para cercar
    
    for (var i = 0; i < _num_unidades; i++) {
        var _unidade = _unidades[i];
        if (!instance_exists(_unidade)) continue;
        
        // Calcular posição em círculo ao redor do alvo
        var _angulo = (i / _num_unidades) * 360;
        var _raio_posicao = _raio_ataque * (0.8 + random_range(0, 0.4)); // Variar distância
        
        var _pos_x = _alvo_x + lengthdir_x(_raio_posicao, _angulo);
        var _pos_y = _alvo_y + lengthdir_y(_raio_posicao, _angulo);
        
        // Ajustar para não ficar tudo exato (dar variação)
        _pos_x += random_range(-50, 50);
        _pos_y += random_range(-50, 50);
        
        // Comandar unidade para posição
        if (variable_instance_exists(_unidade, "destino_x")) {
            _unidade.destino_x = _pos_x;
            _unidade.destino_y = _pos_y;
        }
        
        if (variable_instance_exists(_unidade, "estado")) {
            _unidade.estado = "movendo";
        }
        
        // Definir alvo se estiver no alcance
        var _dist_alvo = point_distance(_pos_x, _pos_y, _alvo_x, _alvo_y);
        if (_dist_alvo <= _raio_ataque) {
            // Procurar inimigo próximo para essa unidade atacar
            var _inimigo_proximo = scr_buscar_inimigo(_pos_x, _pos_y, 200, _ia.nacao_proprietaria);
            if (instance_exists(_inimigo_proximo)) {
                if (variable_instance_exists(_unidade, "alvo")) {
                    _unidade.alvo = _inimigo_proximo;
                }
            }
        }
    }
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🎯 IA moveu " + string(_num_unidades) + " tropas em formação estratégica ao redor de (" + string(round(_alvo_x)) + ", " + string(round(_alvo_y)) + ")");
    }
}
