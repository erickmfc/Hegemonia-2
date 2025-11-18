/// @description Sistema de colisão física para unidades terrestres e navais
/// @param {instance} _unidade Instância da unidade
/// @param {real} _raio_colisao Raio de colisão (padrão: 30 pixels)
/// @param {real} _forca_repulsao Força de repulsão (padrão: 0.8 pixels)
/// @return {bool} true se houve colisão, false caso contrário

function scr_colisao_fisica_unidades(_unidade, _raio_colisao = 30, _forca_repulsao = 0.8) {
    if (!instance_exists(_unidade)) {
        return false;
    }
    
    var _colisao_detectada = false;
    var _x = _unidade.x;
    var _y = _unidade.y;
    
    // === LISTA DE UNIDADES TERRESTRES ===
    var _unidades_terrestres = [];
    if (object_exists(obj_infantaria)) array_push(_unidades_terrestres, obj_infantaria);
    if (object_exists(obj_tanque)) array_push(_unidades_terrestres, obj_tanque);
    if (object_exists(obj_blindado_antiaereo)) array_push(_unidades_terrestres, obj_blindado_antiaereo);
    if (object_exists(obj_soldado_antiaereo)) array_push(_unidades_terrestres, obj_soldado_antiaereo);
    
    // Verificar se obj_M1A_Abrams existe
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && object_exists(_obj_abrams)) {
        array_push(_unidades_terrestres, _obj_abrams);
    }
    
    // Verificar se obj_gepard existe
    var _obj_gepard = asset_get_index("obj_gepard");
    if (_obj_gepard != -1 && object_exists(_obj_gepard)) {
        array_push(_unidades_terrestres, _obj_gepard);
    }
    
    // === LISTA DE UNIDADES NAVALS ===
    var _unidades_navais = [];
    if (object_exists(obj_lancha_patrulha)) array_push(_unidades_navais, obj_lancha_patrulha);
    if (object_exists(obj_Constellation)) array_push(_unidades_navais, obj_Constellation);
    if (object_exists(obj_Independence)) array_push(_unidades_navais, obj_Independence);
    if (object_exists(obj_RonaldReagan)) array_push(_unidades_navais, obj_RonaldReagan);
    if (object_exists(obj_navio_base)) array_push(_unidades_navais, obj_navio_base);
    
    // Verificar se obj_submarino_base existe
    var _obj_submarino = asset_get_index("obj_submarino_base");
    if (_obj_submarino != -1 && object_exists(_obj_submarino)) {
        array_push(_unidades_navais, _obj_submarino);
    }
    
    // === LISTA DE EDIFÍCIOS ===
    var _edificios = [];
    if (object_exists(obj_casa)) array_push(_edificios, obj_casa);
    if (object_exists(obj_banco)) array_push(_edificios, obj_banco);
    if (object_exists(obj_fazenda)) array_push(_edificios, obj_fazenda);
    if (object_exists(obj_quartel)) array_push(_edificios, obj_quartel);
    if (object_exists(obj_quartel_marinha)) array_push(_edificios, obj_quartel_marinha);
    if (object_exists(obj_aeroporto_militar)) array_push(_edificios, obj_aeroporto_militar);
    if (object_exists(obj_research_center)) array_push(_edificios, obj_research_center);
    if (object_exists(obj_mina_ouro)) array_push(_edificios, obj_mina_ouro);
    if (object_exists(obj_mina_aluminio)) array_push(_edificios, obj_mina_aluminio);
    if (object_exists(obj_mina_cobre)) array_push(_edificios, obj_mina_cobre);
    if (object_exists(obj_mina_litio)) array_push(_edificios, obj_mina_litio);
    if (object_exists(obj_mina_titanio)) array_push(_edificios, obj_mina_titanio);
    if (object_exists(obj_mina_uranio)) array_push(_edificios, obj_mina_uranio);
    if (object_exists(obj_plantacao_borracha)) array_push(_edificios, obj_plantacao_borracha);
    if (object_exists(obj_poco_petroleo)) array_push(_edificios, obj_poco_petroleo);
    if (object_exists(obj_serraria)) array_push(_edificios, obj_serraria);
    
    // Verificar se obj_casa_da_moeda existe
    var _obj_casa_moeda = asset_get_index("obj_casa_da_moeda");
    if (_obj_casa_moeda != -1 && object_exists(_obj_casa_moeda)) {
        array_push(_edificios, _obj_casa_moeda);
    }
    
    // Verificar se obj_extrator_silicio existe
    var _obj_extrator = asset_get_index("obj_extrator_silicio");
    if (_obj_extrator != -1 && object_exists(_obj_extrator)) {
        array_push(_edificios, _obj_extrator);
    }
    
    // === VERIFICAR COLISÃO COM OUTRAS UNIDADES TERRESTRES ===
    // Apenas unidades terrestres colidem com outras unidades terrestres
    var _eh_unidade_terrestre = false;
    for (var i = 0; i < array_length(_unidades_terrestres); i++) {
        if (_unidade.object_index == _unidades_terrestres[i]) {
            _eh_unidade_terrestre = true;
            break;
        }
    }
    
    if (_eh_unidade_terrestre) {
        // Verificar colisão com outras unidades terrestres
        for (var i = 0; i < array_length(_unidades_terrestres); i++) {
            var _tipo_unidade = _unidades_terrestres[i];
            if (!object_exists(_tipo_unidade)) continue;
            
            var _instancia = noone;
            var _instancia_anterior = noone;
            
            while (true) {
                if (_instancia_anterior == noone) {
                    _instancia = instance_find(_tipo_unidade, 0);
                } else {
                    _instancia = instance_find(_tipo_unidade, _instancia_anterior);
                }
                
                if (_instancia == noone) break;
                if (_instancia == _unidade) { // Não verificar a si mesmo
                    _instancia_anterior = _instancia;
                    continue;
                }
                
                var _distancia = point_distance(_x, _y, _instancia.x, _instancia.y);
                
                // Se está muito próximo, empurrar para longe
                if (_distancia < _raio_colisao && _distancia > 0) {
                    _colisao_detectada = true;
                    
                    // Calcular direção de repulsão
                    var _angulo_repulsao = point_direction(_x, _y, _instancia.x, _instancia.y);
                    
                    // Empurrar ambas as unidades para longe uma da outra
                    var _forca_metade = _forca_repulsao * 0.5;
                    var _dx = lengthdir_x(_forca_metade, _angulo_repulsao);
                    var _dy = lengthdir_y(_forca_metade, _angulo_repulsao);
                    
                    // Mover a unidade atual para longe
                    var _novo_x = _x - _dx;
                    var _novo_y = _y - _dy;
                    
                    // Verificar se a nova posição não colide com edifícios
                    var _posicao_valida = true;
                    for (var e = 0; e < array_length(_edificios); e++) {
                        if (position_meeting(_novo_x, _novo_y, _edificios[e])) {
                            _posicao_valida = false;
                            break;
                        }
                    }
                    
                    if (_posicao_valida) {
                        _unidade.x = _novo_x;
                        _unidade.y = _novo_y;
                    }
                    
                    // Empurrar a outra unidade também
                    var _outro_novo_x = _instancia.x + _dx;
                    var _outro_novo_y = _instancia.y + _dy;
                    
                    // Verificar se a nova posição da outra unidade não colide com edifícios
                    var _outro_posicao_valida = true;
                    for (var e = 0; e < array_length(_edificios); e++) {
                        if (position_meeting(_outro_novo_x, _outro_novo_y, _edificios[e])) {
                            _outro_posicao_valida = false;
                            break;
                        }
                    }
                    
                    if (_outro_posicao_valida) {
                        _instancia.x = _outro_novo_x;
                        _instancia.y = _outro_novo_y;
                    }
                }
                
                _instancia_anterior = _instancia;
            }
        }
    }
    
    // === VERIFICAR COLISÃO COM UNIDADES NAVALS ===
    // Apenas unidades navais colidem com outras unidades navais
    var _eh_unidade_naval = false;
    for (var i = 0; i < array_length(_unidades_navais); i++) {
        if (_unidade.object_index == _unidades_navais[i]) {
            _eh_unidade_naval = true;
            break;
        }
    }
    
    if (_eh_unidade_naval) {
        // Aumentar raio de colisão para navios (são maiores)
        var _raio_naval = _raio_colisao * 1.5; // 45 pixels para navios
        
        // Verificar colisão com outras unidades navais
        for (var i = 0; i < array_length(_unidades_navais); i++) {
            var _tipo_unidade = _unidades_navais[i];
            if (!object_exists(_tipo_unidade)) continue;
            
            var _instancia = noone;
            var _instancia_anterior = noone;
            
            while (true) {
                if (_instancia_anterior == noone) {
                    _instancia = instance_find(_tipo_unidade, 0);
                } else {
                    _instancia = instance_find(_tipo_unidade, _instancia_anterior);
                }
                
                if (_instancia == noone) break;
                if (_instancia == _unidade) { // Não verificar a si mesmo
                    _instancia_anterior = _instancia;
                    continue;
                }
                
                var _distancia = point_distance(_x, _y, _instancia.x, _instancia.y);
                
                // Se está muito próximo, empurrar para longe
                if (_distancia < _raio_naval && _distancia > 0) {
                    _colisao_detectada = true;
                    
                    // Calcular direção de repulsão
                    var _angulo_repulsao = point_direction(_x, _y, _instancia.x, _instancia.y);
                    
                    // Empurrar ambas as unidades para longe uma da outra
                    var _forca_metade = _forca_repulsao * 0.5;
                    var _dx = lengthdir_x(_forca_metade, _angulo_repulsao);
                    var _dy = lengthdir_y(_forca_metade, _angulo_repulsao);
                    
                    // Mover a unidade atual para longe
                    var _novo_x = _x - _dx;
                    var _novo_y = _y - _dy;
                    
                    // Verificar limites do mapa
                    if (_novo_x >= 0 && _novo_x <= room_width && _novo_y >= 0 && _novo_y <= room_height) {
                        _unidade.x = _novo_x;
                        _unidade.y = _novo_y;
                    }
                    
                    // Empurrar a outra unidade também
                    var _outro_novo_x = _instancia.x + _dx;
                    var _outro_novo_y = _instancia.y + _dy;
                    
                    // Verificar limites do mapa
                    if (_outro_novo_x >= 0 && _outro_novo_x <= room_width && _outro_novo_y >= 0 && _outro_novo_y <= room_height) {
                        _instancia.x = _outro_novo_x;
                        _instancia.y = _outro_novo_y;
                    }
                }
                
                _instancia_anterior = _instancia;
            }
        }
    }
    
    // === VERIFICAR COLISÃO COM EDIFÍCIOS ===
    // Apenas unidades terrestres colidem com edifícios
    if (_eh_unidade_terrestre) {
        for (var i = 0; i < array_length(_edificios); i++) {
            var _edificio = _edificios[i];
            if (!object_exists(_edificio)) continue;
            
            // Verificar se está colidindo com o edifício
            if (position_meeting(_x, _y, _edificio)) {
                _colisao_detectada = true;
                
                // Encontrar o edifício mais próximo
                var _edificio_proximo = instance_nearest(_x, _y, _edificio);
                if (instance_exists(_edificio_proximo)) {
                    // Calcular direção oposta ao edifício
                    var _angulo_repulsao = point_direction(_edificio_proximo.x, _edificio_proximo.y, _x, _y);
                    var _distancia = point_distance(_x, _y, _edificio_proximo.x, _edificio_proximo.y);
                    
                    // Se muito próximo, empurrar para longe
                    if (_distancia < _raio_colisao * 1.5) {
                        var _forca_empurrao = _forca_repulsao * 2.0; // Força maior para edifícios
                        var _novo_x = _x + lengthdir_x(_forca_empurrao, _angulo_repulsao);
                        var _novo_y = _y + lengthdir_y(_forca_empurrao, _angulo_repulsao);
                        
                        // Verificar se a nova posição não colide com outros edifícios
                        var _posicao_valida = true;
                        for (var e = 0; e < array_length(_edificios); e++) {
                            if (position_meeting(_novo_x, _novo_y, _edificios[e])) {
                                _posicao_valida = false;
                                break;
                            }
                        }
                        
                        if (_posicao_valida) {
                            _unidade.x = _novo_x;
                            _unidade.y = _novo_y;
                        }
                    }
                }
            }
        }
    }
    
    return _colisao_detectada;
}

