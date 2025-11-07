/// @description Escolhe o primeiro da fila quando há múltiplas unidades próximas em esquadrão
/// @param {real} _navio_x Posição X do navio
/// @param {real} _navio_y Posição Y do navio
/// @param {real} _tipo_unidade Tipo de objeto da unidade (ex: obj_infantaria)
/// @param {real} _raio_busca Raio de busca (padrão: 200 pixels)
/// @return {real} ID da unidade que está na frente da fila, ou noone se não encontrar

function scr_escolher_primeiro_da_fila(_navio_x, _navio_y, _tipo_unidade, _raio_busca = 200) {
    if (!object_exists(_tipo_unidade)) {
        return noone;
    }
    
    // Encontrar todas as unidades do tipo dentro do raio
    var _unidades_proximas = [];
    var _idx = 0;
    
    with (_tipo_unidade) {
        // ✅ CORREÇÃO: Verificar se é unidade inimiga (não da mesma nação do navio)
        // O navio ataca unidades da nação 2 (IA), então verificar nacao_proprietaria == 2
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            var _dist = point_distance(x, y, _navio_x, _navio_y);
            if (_dist <= _raio_busca) {
                _unidades_proximas[_idx] = {
                    id: id,
                    x: x,
                    y: y,
                    distancia: _dist
                };
                _idx++;
            }
        }
    }
    
    if (array_length(_unidades_proximas) == 0) {
        return noone;
    }
    
    // Se só há uma unidade, retornar ela
    if (array_length(_unidades_proximas) == 1) {
        return _unidades_proximas[0].id;
    }
    
    // ✅ CORREÇÃO: Escolher o primeiro da fila baseado na direção do navio para as unidades
    // O primeiro da fila é aquele que está mais próximo do navio E mais à frente na direção do movimento
    var _direcao_navio_para_unidades = point_direction(_navio_x, _navio_y, 
        _unidades_proximas[0].x, _unidades_proximas[0].y);
    
    // Calcular direção média das unidades (para determinar a direção da fila)
    var _centro_x = 0;
    var _centro_y = 0;
    for (var i = 0; i < array_length(_unidades_proximas); i++) {
        _centro_x += _unidades_proximas[i].x;
        _centro_y += _unidades_proximas[i].y;
    }
    _centro_x /= array_length(_unidades_proximas);
    _centro_y /= array_length(_unidades_proximas);
    
    // Direção da fila (do centro para o navio)
    var _direcao_fila = point_direction(_centro_x, _centro_y, _navio_x, _navio_y);
    
    // ✅ Escolher a unidade que está mais à frente na direção da fila
    var _primeiro_da_fila = noone;
    var _maior_projecao = -999999;
    
    for (var i = 0; i < array_length(_unidades_proximas); i++) {
        var _unidade = _unidades_proximas[i];
        
        // Calcular projeção da unidade na direção da fila
        var _offset_x = _unidade.x - _centro_x;
        var _offset_y = _unidade.y - _centro_y;
        
        // Projeção na direção da fila (produto escalar)
        var _projecao = lengthdir_x(1, _direcao_fila) * _offset_x + 
                       lengthdir_y(1, _direcao_fila) * _offset_y;
        
        // A unidade com maior projeção está mais à frente
        if (_projecao > _maior_projecao) {
            _maior_projecao = _projecao;
            _primeiro_da_fila = _unidade.id;
        }
    }
    
    // ✅ FALLBACK: Se não encontrou, escolher a mais próxima do navio
    if (!instance_exists(_primeiro_da_fila)) {
        var _menor_dist = 999999;
        for (var i = 0; i < array_length(_unidades_proximas); i++) {
            if (_unidades_proximas[i].distancia < _menor_dist) {
                _menor_dist = _unidades_proximas[i].distancia;
                _primeiro_da_fila = _unidades_proximas[i].id;
            }
        }
    }
    
    return _primeiro_da_fila;
}

