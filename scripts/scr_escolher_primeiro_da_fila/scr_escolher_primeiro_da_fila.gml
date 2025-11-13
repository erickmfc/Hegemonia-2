/// @description Escolhe o primeiro da fila quando há múltiplas unidades próximas em esquadrão
/// @param {real} _atacante_x Posição X do atacante (navio/míssil)
/// @param {real} _atacante_y Posição Y do atacante (navio/míssil)
/// @param {real} _tipo_unidade Tipo de objeto da unidade (ex: obj_infantaria)
/// @param {real} _raio_busca Raio de busca (padrão: 200 pixels)
/// @param {real} _nacao_atacante Nação do atacante (1 = jogador, 2 = IA) - padrão: 1
/// @return {real} ID da unidade que está na frente da fila, ou noone se não encontrar

function scr_escolher_primeiro_da_fila(_atacante_x, _atacante_y, _tipo_unidade, _raio_busca = 200, _nacao_atacante = 1) {
    if (!object_exists(_tipo_unidade)) {
        return noone;
    }
    
    // Encontrar todas as unidades do tipo dentro do raio
    var _unidades_proximas = [];
    var _idx = 0;
    
    // Determinar nação inimiga (oposta à do atacante)
    var _nacao_inimiga = (_nacao_atacante == 1) ? 2 : 1;
    
    with (_tipo_unidade) {
        // ✅ CORREÇÃO: Verificar se é unidade inimiga (não da mesma nação do atacante)
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_inimiga) {
            var _dist = point_distance(x, y, _atacante_x, _atacante_y);
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
    
    // ✅ CORREÇÃO MELHORADA: Escolher o primeiro da fila considerando direção do atacante
    // Se há múltiplas unidades muito próximas, escolher baseado na direção do atacante para o grupo
    
    // Encontrar a unidade mais próxima primeiro
    var _mais_proxima = noone;
    var _menor_dist = 999999;
    for (var i = 0; i < array_length(_unidades_proximas); i++) {
        if (_unidades_proximas[i].distancia < _menor_dist) {
            _menor_dist = _unidades_proximas[i].distancia;
            _mais_proxima = _unidades_proximas[i];
        }
    }
    
    // Se a unidade mais próxima está muito longe das outras, ela é o primeiro
    var _primeiro_da_fila = _mais_proxima.id;
    var _unidades_muito_proximas = 0;
    var _raio_proximidade = 50; // Se unidades estão dentro de 50px, considerar como "muito próximas"
    
    for (var i = 0; i < array_length(_unidades_proximas); i++) {
        var _dist_para_mais_proxima = point_distance(_unidades_proximas[i].x, _unidades_proximas[i].y, 
                                                      _mais_proxima.x, _mais_proxima.y);
        if (_dist_para_mais_proxima <= _raio_proximidade) {
            _unidades_muito_proximas++;
        }
    }
    
    // Se há múltiplas unidades muito próximas, escolher baseado na direção do atacante
    if (_unidades_muito_proximas >= 2) {
        // Calcular direção do atacante para o centro das unidades
        var _centro_x = 0;
        var _centro_y = 0;
        for (var i = 0; i < array_length(_unidades_proximas); i++) {
            _centro_x += _unidades_proximas[i].x;
            _centro_y += _unidades_proximas[i].y;
        }
        _centro_x /= array_length(_unidades_proximas);
        _centro_y /= array_length(_unidades_proximas);
        
        var _dir_atacante_para_centro = point_direction(_atacante_x, _atacante_y, _centro_x, _centro_y);
        
        // Escolher a unidade que está mais próxima do atacante na direção do atacante para o centro
        var _melhor_score = 999999;
        for (var i = 0; i < array_length(_unidades_proximas); i++) {
            var _unidade = _unidades_proximas[i];
            
            // Calcular vetor do atacante para a unidade
            var _vetor_x = _unidade.x - _atacante_x;
            var _vetor_y = _unidade.y - _atacante_y;
            
            // Projeção na direção do atacante para o centro
            var _dir_x = lengthdir_x(1, _dir_atacante_para_centro);
            var _dir_y = lengthdir_y(1, _dir_atacante_para_centro);
            var _projecao = _vetor_x * _dir_x + _vetor_y * _dir_y;
            
            // Score: menor projeção (mais próximo na direção) + distância como desempate
            var _score = _projecao + (_unidade.distancia * 0.01);
            
            if (_score < _melhor_score) {
                _melhor_score = _score;
                _primeiro_da_fila = _unidade.id;
            }
        }
    }
    
    return _primeiro_da_fila;
}

