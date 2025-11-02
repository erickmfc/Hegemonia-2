/// @description Encontra posição estratégica para construir (evita grudar tudo junto)
/// @param {real} _ia_id ID da IA
/// @param {real} _tipo_estrutura Tipo: "economia", "militar", "naval", "aereo"
/// @param {real} _raio_minimo Distância mínima de outras estruturas (padrão: 250)
/// @return {array} {x: real, y: real, valida: bool}

function scr_ia_encontrar_posicao_estrategica(_ia_id, _tipo_estrutura = "economia", _raio_minimo = 250) {
    var _ia = _ia_id;
    
    // === CALCULAR POSIÇÕES ESTRATÉGICAS BASEADAS NO TIPO ===
    var _base_x = _ia.base_x;
    var _base_y = _ia.base_y;
    var _raio_expansao = _ia.raio_expansao;
    
    var _posicoes_tentativas = [];
    
    if (_tipo_estrutura == "economia") {
        // Fazendas: distribuir em círculo ao redor da base (não grudadas)
        var _num_fazendas = 0;
        with (obj_fazenda) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                _num_fazendas++;
            }
        }
        
        // Distribuir fazendas em ângulos diferentes (evita grudar)
        var _angulo_base = (_num_fazendas * 60) % 360; // Rotaciona posição
        var _distancia_base = 300 + (_num_fazendas * 100); // Aumenta distância conforme cria mais
        
        for (var i = 0; i < 8; i++) {
            var _angulo = _angulo_base + (i * 45); // 8 posições em círculo
            var _dist = _distancia_base + random_range(50, 150);
            var _px = _base_x + lengthdir_x(_dist, _angulo);
            var _py = _base_y + lengthdir_y(_dist, _angulo);
            array_push(_posicoes_tentativas, {x: _px, y: _py, angulo: _angulo});
        }
        
    } else if (_tipo_estrutura == "militar") {
        // Quartéis: posicionar estrategicamente para defesa/ataque
        var _num_quartel = 0;
        with (obj_quartel) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                _num_quartel++;
            }
        }
        
        // Distribuir quartéis em linha ou formação triangular
        var _distancia = 400 + (_num_quartel * 200); // Espaçamento aumentado
        
        // Formação em pontos estratégicos ao redor da base
        var _angulos_quartel = [0, 120, 240, 60, 180, 300]; // Hexágono
        for (var i = 0; i < array_length(_angulos_quartel); i++) {
            var _angulo = _angulos_quartel[i] + random_range(-15, 15);
            var _px = _base_x + lengthdir_x(_distancia, _angulo);
            var _py = _base_y + lengthdir_y(_distancia, _angulo);
            array_push(_posicoes_tentativas, {x: _px, y: _py, angulo: _angulo});
        }
        
    } else if (_tipo_estrutura == "naval") {
        // ✅ CORRIGIDO: Quartéis navais DEVEM estar EM ÁGUA
        // Buscar posições de água próximas à base
        var _posicao_agua = scr_find_nearest_water(_base_x, _base_y, _raio_expansao * 1.5);
        
        if (_posicao_agua[0] != -1) {
            // Encontrou água, usar essa posição e tentar variações ao redor
            var _px_base = _posicao_agua[0];
            var _py_base = _posicao_agua[1];
            
            // Tentar posições próximas em água (formar um círculo na água)
            for (var i = 0; i < 12; i++) {
                var _angulo = i * 30; // 12 posições em círculo
                var _raio_variacao = 50 + random_range(0, 100); // Variação de 50-150 pixels
                var _px = _px_base + lengthdir_x(_raio_variacao, _angulo);
                var _py = _py_base + lengthdir_y(_raio_variacao, _angulo);
                
                // Verificar se está em água antes de adicionar
                if (scr_check_water_tile(_px, _py)) {
                    array_push(_posicoes_tentativas, {x: _px, y: _py, angulo: _angulo});
                }
            }
        } else {
            // Não encontrou água próxima, tentar buscar em direções específicas
        var _angulos = [90, 135, 180, 225, 270]; // Direções onde pode ter água
        for (var i = 0; i < array_length(_angulos); i++) {
                var _distancia = 200;
                for (var j = 0; j < 10; j++) { // Tentar até 10 distâncias diferentes
                    var _px = _base_x + lengthdir_x(_distancia, _angulos[i]);
                    var _py = _base_y + lengthdir_y(_distancia, _angulos[i]);
                    
                    if (scr_check_water_tile(_px, _py)) {
            array_push(_posicoes_tentativas, {x: _px, y: _py, angulo: _angulos[i]});
                        break; // Encontrou, para de buscar nesta direção
                    }
                    _distancia += 100; // Aumenta distância
                }
            }
        }
        
    } else if (_tipo_estrutura == "aereo") {
        // Aeroportos: bem espaçados e em posições defensivas
        var _distancia = 500;
        var _angulos = [45, 135, 225, 315]; // Cantos estratégicos
        
        for (var i = 0; i < array_length(_angulos); i++) {
            var _px = _base_x + lengthdir_x(_distancia, _angulos[i]);
            var _py = _base_y + lengthdir_y(_distancia, _angulos[i]);
            array_push(_posicoes_tentativas, {x: _px, y: _py, angulo: _angulos[i]});
        }
    }
    
    // === TESTAR CADA POSIÇÃO E ESCOLHER A MELHOR ===
    var _melhor_pos = {x: _base_x + random_range(-100, 100), y: _base_y + random_range(-100, 100), valida: false};
    var _melhor_score = -1;
    
    for (var i = 0; i < array_length(_posicoes_tentativas); i++) {
        var _pos = _posicoes_tentativas[i];
        var _score = 0;
        var _valida = true;
        
        // Verificar distância mínima de outras estruturas
        var _estruturas_proximas = 0;
        
        // Verificar fazendas
        with (obj_fazenda) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                var _dist = point_distance(x, y, _pos.x, _pos.y);
                if (_dist < _raio_minimo) {
                    _valida = false; // Muito perto
                } else if (_dist < _raio_minimo * 2) {
                    _estruturas_proximas++; // Próximo mas aceitável
                }
            }
        }
        
        // Verificar quartéis
        with (obj_quartel) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                var _dist = point_distance(x, y, _pos.x, _pos.y);
                if (_dist < _raio_minimo) {
                    _valida = false;
                } else if (_dist < _raio_minimo * 2) {
                    _estruturas_proximas++;
                }
            }
        }
        
        // Verificar quartéis navais
        with (obj_quartel_marinha) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                var _dist = point_distance(x, y, _pos.x, _pos.y);
                if (_dist < _raio_minimo) {
                    _valida = false;
                }
            }
        }
        
        // ✅ NOVO: Para estruturas navais, verificar se está em água
        if (_tipo_estrutura == "naval") {
            if (!scr_check_water_tile(_pos.x, _pos.y)) {
                _valida = false; // Não é água, inválida para quartel naval
            } else {
                // Bônus extra se toda a área for água
                if (scr_check_water_area(_pos.x, _pos.y, 128, 128)) { // Assumindo tamanho padrão
                    _score += 2000; // Grande bônus para área totalmente em água
                }
            }
        }
        
        // Calcular score: preferir posições com algumas estruturas próximas (não isolado demais) mas não grudadas
        if (_valida) {
            _score = 1000 - (_estruturas_proximas * 100); // Menos estruturas próximas = melhor
            
            // Bônus: distância da base (não muito perto, não muito longe)
            var _dist_base = point_distance(_pos.x, _pos.y, _base_x, _base_y);
            if (_dist_base >= _raio_minimo && _dist_base <= _raio_expansao) {
                _score += 500; // Distância ideal
            }
            
            if (_score > _melhor_score) {
                _melhor_score = _score;
                _melhor_pos = {x: _pos.x, y: _pos.y, valida: true};
            }
        }
    }
    
    // Se não encontrou posição válida, tentar encontrar água novamente
    if (!_melhor_pos.valida || _melhor_score < 0) {
        if (_tipo_estrutura == "naval") {
            // Para naval, buscar água de novo com raio maior
            var _posicao_agua = scr_find_nearest_water(_base_x, _base_y, _raio_expansao * 2.5);
            if (_posicao_agua[0] != -1) {
                _melhor_pos.x = _posicao_agua[0];
                _melhor_pos.y = _posicao_agua[1];
                _melhor_pos.valida = scr_check_water_tile(_posicao_agua[0], _posicao_agua[1]);
            } else {
                // Último recurso: posição aleatória e marcar como inválida
                var _angulo_random = random(360);
                var _dist_random = _raio_minimo + random_range(100, 300);
                _melhor_pos.x = _base_x + lengthdir_x(_dist_random, _angulo_random);
                _melhor_pos.y = _base_y + lengthdir_y(_dist_random, _angulo_random);
                _melhor_pos.valida = false; // Não pode construir aqui
            }
        } else {
            // Para outras estruturas, usar posição padrão
        var _angulo_random = random(360);
        var _dist_random = _raio_minimo + random_range(100, 300);
        _melhor_pos.x = _base_x + lengthdir_x(_dist_random, _angulo_random);
        _melhor_pos.y = _base_y + lengthdir_y(_dist_random, _angulo_random);
        _melhor_pos.valida = true;
        }
    }
    
    return _melhor_pos;
}
