// ===============================================
// VINCULAR NAVIO PIRATA AOS PILARES PRÓXIMOS
// ===============================================

function scr_vincular_pirata_pilares(_navio_pirata, _raio_busca = 1000) {
    if (!instance_exists(_navio_pirata)) return false;
    
    // Limpar lista anterior
    ds_list_clear(_navio_pirata.pilares_patrulha);
    
    // Buscar todos os pilares próximos
    var _pilares_encontrados = [];
    with (obj_pilar_pirata) {
        var _dist = point_distance(_navio_pirata.x, _navio_pirata.y, x, y);
        if (_dist <= _raio_busca) {
            array_push(_pilares_encontrados, {
                id: id,
                distancia: _dist
            });
        }
    }
    
    // Ordenar por distância (bubble sort)
    for (var i = 0; i < array_length(_pilares_encontrados) - 1; i++) {
        for (var j = 0; j < array_length(_pilares_encontrados) - 1 - i; j++) {
            if (_pilares_encontrados[j].distancia > _pilares_encontrados[j + 1].distancia) {
                var _temp = _pilares_encontrados[j];
                _pilares_encontrados[j] = _pilares_encontrados[j + 1];
                _pilares_encontrados[j + 1] = _temp;
            }
        }
    }
    
    // Adicionar pilares (máximo 8)
    var _max_pilares = min(8, array_length(_pilares_encontrados));
    for (var i = 0; i < _max_pilares; i++) {
        ds_list_add(_navio_pirata.pilares_patrulha, _pilares_encontrados[i].id);
    }
    
    // Definir primeiro pilar como destino
    if (ds_list_size(_navio_pirata.pilares_patrulha) > 0) {
        var _primeiro_pilar = _navio_pirata.pilares_patrulha[| 0];
        if (instance_exists(_primeiro_pilar)) {
            _navio_pirata.destino_x = _primeiro_pilar.x;
            _navio_pirata.destino_y = _primeiro_pilar.y;
            _navio_pirata.target_x = _primeiro_pilar.x;
            _navio_pirata.target_y = _primeiro_pilar.y;
            _navio_pirata.estado = LanchaState.PATRULHANDO;
            
            show_debug_message("🏴‍☠️ " + _navio_pirata.nome_unidade + " vinculado a " + string(_max_pilares) + " pilares");
            return true;
        }
    }
    
    show_debug_message("🏴‍☠️ " + _navio_pirata.nome_unidade + " - ERRO: Nenhum pilar encontrado em " + string(_raio_busca) + "px");
    return false;
}

