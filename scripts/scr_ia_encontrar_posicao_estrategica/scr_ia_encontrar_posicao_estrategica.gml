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
        // ✅ NOVO: Usar posições de costa conhecidas da IA
        if (variable_instance_exists(_ia, "territorio_identificado") && _ia.territorio_identificado) {
            if (variable_instance_exists(_ia, "posicoes_costa") && ds_list_size(_ia.posicoes_costa) > 0) {
                // Usar posições de costa conhecidas
                var _num_posicoes_costa = ds_list_size(_ia.posicoes_costa);
                var _posicoes_usar = min(_num_posicoes_costa, 20); // Máximo 20 posições
                
                for (var i = 0; i < _posicoes_usar; i++) {
                    var _pos_costa = ds_list_find_value(_ia.posicoes_costa, i);
                    if (is_struct(_pos_costa) && variable_struct_exists(_pos_costa, "x")) {
                        // Adicionar posição de costa e variações próximas
                        var _px_base = _pos_costa.x;
                        var _py_base = _pos_costa.y;
                        
                        // Adicionar posição exata
                        array_push(_posicoes_tentativas, {x: _px_base, y: _py_base, angulo: 0, distancia: _pos_costa.distancia_base});
                        
                        // Adicionar variações próximas (em círculo)
                        for (var j = 0; j < 4; j++) {
                            var _angulo = j * 90;
                            var _raio = 32 + random_range(0, 32); // 32-64 pixels de variação
                            var _px = _px_base + lengthdir_x(_raio, _angulo);
                            var _py = _py_base + lengthdir_y(_raio, _angulo);
                            
                            // Verificar se ainda está em água
                            if (scr_validar_terreno_construcao(obj_quartel_marinha, _px, _py, 96, 96)) {
                                array_push(_posicoes_tentativas, {x: _px, y: _py, angulo: _angulo, distancia: point_distance(_px, _py, _base_x, _base_y)});
                            }
                        }
                    }
                }
                
                show_debug_message("🌊 IA usando " + string(_posicoes_usar) + " posições de costa conhecidas");
            }
        }
        
        // Se não encontrou posições de costa ou não tem muitas, buscar água próxima como fallback
        if (array_length(_posicoes_tentativas) < 5) {
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
                    if (scr_validar_terreno_construcao(obj_quartel_marinha, _px, _py, 96, 96)) {
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
                        
                        if (scr_validar_terreno_construcao(obj_quartel_marinha, _px, _py, 96, 96)) {
                            array_push(_posicoes_tentativas, {x: _px, y: _py, angulo: _angulos[i]});
                            break; // Encontrou, para de buscar nesta direção
                        }
                        _distancia += 100; // Aumenta distância
                    }
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
        
        // ✅ NOVO: Para estruturas navais, verificar se está em água usando validação de terreno
        if (_tipo_estrutura == "naval") {
            if (!scr_validar_terreno_construcao(obj_quartel_marinha, _pos.x, _pos.y, 96, 96)) {
                _valida = false; // Não é água, inválida para quartel naval
            } else {
                // Bônus extra se for posição de costa conhecida
                if (variable_struct_exists(_pos, "distancia") && _pos.distancia < 2000) {
                    _score += 1500; // Grande bônus para costa próxima da base
                }
                _score += 1000; // Bônus base para estar em água válida
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
        show_debug_message("⚠️ IA não encontrou posição estratégica válida, tentando fallback...");
        
        if (_tipo_estrutura == "naval") {
            // Para naval, buscar água de novo com raio maior
            var _posicao_agua = scr_find_nearest_water(_base_x, _base_y, _raio_expansao * 2.5);
            if (_posicao_agua[0] != -1) {
                _melhor_pos.x = _posicao_agua[0];
                _melhor_pos.y = _posicao_agua[1];
                // ✅ CORRIGIDO: Usar validação real em vez de heurística
                _melhor_pos.valida = scr_validar_terreno_construcao(obj_quartel_marinha, _posicao_agua[0], _posicao_agua[1], 96, 96);
                if (_melhor_pos.valida) {
                    show_debug_message("✅ IA encontrou água no fallback: (" + string(_melhor_pos.x) + ", " + string(_melhor_pos.y) + ")");
                } else {
                    show_debug_message("⚠️ AVISO: scr_find_nearest_water retornou posição, mas validação de terreno falhou");
                }
            } else {
                // Último recurso: posição aleatória e marcar como inválida
                var _angulo_random = random(360);
                var _dist_random = _raio_minimo + random_range(100, 300);
                _melhor_pos.x = _base_x + lengthdir_x(_dist_random, _angulo_random);
                _melhor_pos.y = _base_y + lengthdir_y(_dist_random, _angulo_random);
                _melhor_pos.valida = false; // Não pode construir aqui
                show_debug_message("❌ IA não encontrou água para quartel naval");
            }
        } else {
            // Para outras estruturas, usar posição padrão e verificar se é válida
            var _tentativas_fallback = 20;
            var _encontrou_fallback = false;
            
            for (var i = 0; i < _tentativas_fallback && !_encontrou_fallback; i++) {
                var _angulo_random = random(360);
                var _dist_random = _raio_minimo + random_range(50, 200);
                var _px = _base_x + lengthdir_x(_dist_random, _angulo_random);
                var _py = _base_y + lengthdir_y(_dist_random, _angulo_random);
                
                // Verificar se não há overlap
                var _overlap = false;
                with (obj_fazenda) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                        if (point_distance(x, y, _px, _py) < 100) {
                            _overlap = true;
                        }
                    }
                }
                with (obj_quartel) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                        if (point_distance(x, y, _px, _py) < 100) {
                            _overlap = true;
                        }
                    }
                }
                
                if (!_overlap) {
                    _melhor_pos.x = _px;
                    _melhor_pos.y = _py;
                    _melhor_pos.valida = true;
                    _encontrou_fallback = true;
                    show_debug_message("✅ IA encontrou posição fallback válida: (" + string(_melhor_pos.x) + ", " + string(_melhor_pos.y) + ")");
                }
            }
            
            // Se ainda não encontrou, usar posição padrão mesmo assim
            if (!_encontrou_fallback) {
                var _angulo_random = random(360);
                var _dist_random = _raio_minimo + random_range(100, 300);
                _melhor_pos.x = _base_x + lengthdir_x(_dist_random, _angulo_random);
                _melhor_pos.y = _base_y + lengthdir_y(_dist_random, _angulo_random);
                _melhor_pos.valida = true; // Tentar mesmo assim
                show_debug_message("⚠️ IA usando posição padrão (pode ter overlap): (" + string(_melhor_pos.x) + ", " + string(_melhor_pos.y) + ")");
            }
        }
    }
    
    return _melhor_pos;
}
