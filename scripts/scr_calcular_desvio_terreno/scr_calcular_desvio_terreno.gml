// ===============================================
// HEGEMONIA GLOBAL - CÁLCULO DE DESVIO DE TERRENO
// Calcula rota alternativa quando caminho direto está bloqueado
// ===============================================

/// @function scr_calcular_desvio_terreno(_unidade_id, _x1, _y1, _x2, _y2)
/// @description Calcula desvio quando caminho direto está bloqueado
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _x1 - Posição X inicial
/// @param {real} _y1 - Posição Y inicial
/// @param {real} _x2 - Posição X destino
/// @param {real} _y2 - Posição Y destino
/// @returns {array} Array de pontos do caminho desviado

function scr_calcular_desvio_terreno(_unidade_id, _x1, _y1, _x2, _y2) {
    if (!instance_exists(_unidade_id)) return [];
    
    var _caminho = [];
    var _angulo = point_direction(_x1, _y1, _x2, _y2);
    var _distancia = point_distance(_x1, _y1, _x2, _y2);
    
    // Tentar desviar pela esquerda
    var _angulo_esquerda = _angulo - 90;
    var _ponto_esquerda_x = _x1 + lengthdir_x(_distancia * 0.5, _angulo_esquerda);
    var _ponto_esquerda_y = _y1 + lengthdir_y(_distancia * 0.5, _angulo_esquerda);
    
    // Verificar se ponto esquerda é válido
    if (scr_unidade_pode_terreno(_unidade_id, _ponto_esquerda_x, _ponto_esquerda_y)) {
        // Tentar caminho: origem -> esquerda -> destino
        if (scr_validar_caminho_terreno(_unidade_id, _x1, _y1, _ponto_esquerda_x, _ponto_esquerda_y, 10) &&
            scr_validar_caminho_terreno(_unidade_id, _ponto_esquerda_x, _ponto_esquerda_y, _x2, _y2, 10)) {
            array_push(_caminho, [_ponto_esquerda_x, _ponto_esquerda_y]);
            array_push(_caminho, [_x2, _y2]);
            return _caminho;
        }
    }
    
    // Tentar desviar pela direita
    var _angulo_direita = _angulo + 90;
    var _ponto_direita_x = _x1 + lengthdir_x(_distancia * 0.5, _angulo_direita);
    var _ponto_direita_y = _y1 + lengthdir_y(_distancia * 0.5, _angulo_direita);
    
    if (scr_unidade_pode_terreno(_unidade_id, _ponto_direita_x, _ponto_direita_y)) {
        if (scr_validar_caminho_terreno(_unidade_id, _x1, _y1, _ponto_direita_x, _ponto_direita_y, 10) &&
            scr_validar_caminho_terreno(_unidade_id, _ponto_direita_x, _ponto_direita_y, _x2, _y2, 10)) {
            array_push(_caminho, [_ponto_direita_x, _ponto_direita_y]);
            array_push(_caminho, [_x2, _y2]);
            return _caminho;
        }
    }
    
    // Se ambos falharem, tentar calcular contorno completo da massa
    var _caminho_contorno = scr_calcular_contorno_massa_terreno(_unidade_id, _x1, _y1, _x2, _y2, 800);
    if (array_length(_caminho_contorno) > 0) {
        return _caminho_contorno;
    }
    
    // Se ainda falhar, tentar encontrar posição válida próxima ao destino
    var _pos_valida = scr_encontrar_terra_proxima(_unidade_id, _x2, _y2);
    if (_pos_valida != noone) {
        array_push(_caminho, [_pos_valida[0], _pos_valida[1]]);
        return _caminho;
    }
    
    // Sem caminho possível
    return [];
}

/// @function scr_calcular_desvio_multi_ponto(_unidade_id, _x1, _y1, _x2, _y2, _raio_busca)
/// @description Calcula desvio com múltiplos pontos intermediários
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _x1 - Posição X inicial
/// @param {real} _y1 - Posição Y inicial
/// @param {real} _x2 - Posição X destino
/// @param {real} _y2 - Posição Y destino
/// @param {real} _raio_busca - Raio para buscar pontos válidos
/// @returns {array} Array de pontos do caminho

function scr_calcular_desvio_multi_ponto(_unidade_id, _x1, _y1, _x2, _y2, _raio_busca = 200) {
    if (!instance_exists(_unidade_id)) return [];
    
    var _caminho = [];
    var _pontos_intermediarios = 3;
    
    for (var i = 1; i < _pontos_intermediarios; i++) {
        var _t = i / _pontos_intermediarios;
        var _x_inter = lerp(_x1, _x2, _t);
        var _y_inter = lerp(_y1, _y2, _t);
        
        // Se ponto intermediário não é válido, buscar próximo válido
        if (!scr_unidade_pode_terreno(_unidade_id, _x_inter, _y_inter)) {
            var _pos_valida = scr_encontrar_terra_proxima(_unidade_id, _x_inter, _y_inter, _raio_busca);
            if (_pos_valida != noone) {
                _x_inter = _pos_valida[0];
                _y_inter = _pos_valida[1];
            } else {
                continue; // Pular este ponto
            }
        }
        
        array_push(_caminho, [_x_inter, _y_inter]);
    }
    
    // Adicionar destino final
    if (scr_unidade_pode_terreno(_unidade_id, _x2, _y2)) {
        array_push(_caminho, [_x2, _y2]);
    } else {
        var _pos_valida = scr_encontrar_terra_proxima(_unidade_id, _x2, _y2);
        if (_pos_valida != noone) {
            array_push(_caminho, [_pos_valida[0], _pos_valida[1]]);
        }
    }
    
    return _caminho;
}

/// @function scr_calcular_contorno_massa_terreno(_unidade_id, _x1, _y1, _x2, _y2, _raio_maximo)
/// @description Calcula contorno completo ao redor de massa de terreno bloqueado
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _x1 - Posição X inicial
/// @param {real} _y1 - Posição Y inicial
/// @param {real} _x2 - Posição X destino
/// @param {real} _y2 - Posição Y destino
/// @param {real} _raio_maximo - Raio máximo de busca (padrão: 800)
/// @returns {array} Array de pontos do caminho que contorna a massa

function scr_calcular_contorno_massa_terreno(_unidade_id, _x1, _y1, _x2, _y2, _raio_maximo = 800) {
    if (!instance_exists(_unidade_id)) return [];
    
    // ✅ NOVO: Obter distância mínima da costa (zona de segurança)
    var _distancia_minima = 150; // Padrão
    if (variable_instance_exists(_unidade_id, "distancia_minima_costa")) {
        _distancia_minima = _unidade_id.distancia_minima_costa;
    }
    
    // ✅ CORREÇÃO: Verificar se função existe antes de usar (fallback se não estiver disponível)
    var _funcao_seguranca_existe = script_exists(asset_get_index("scr_unidade_pode_terreno_com_seguranca"));
    
    // ✅ NOVO: Verificar se destino está na zona de segurança
    var _destino_seguro = true;
    if (_funcao_seguranca_existe) {
        _destino_seguro = scr_unidade_pode_terreno_com_seguranca(_unidade_id, _x2, _y2, _distancia_minima);
    } else {
        // Fallback: usar verificação básica
        _destino_seguro = scr_unidade_pode_terreno(_unidade_id, _x2, _y2);
    }
    
    if (!_destino_seguro) {
        // Destino não está seguro - encontrar posição segura próxima
        var _agua_segura = scr_encontrar_agua_proxima(_x2, _y2, 1000);
        if (_agua_segura != noone && array_length(_agua_segura) >= 2) {
            // Verificar se posição encontrada está na zona de segurança
            var _tentativas = 0;
            var _funcao_zona_existe = script_exists(asset_get_index("scr_verificar_zona_seguranca"));
            while (_tentativas < 10) {
                var _agua_valida = true;
                if (_funcao_zona_existe) {
                    _agua_valida = scr_verificar_zona_seguranca(_unidade_id, _agua_segura[0], _agua_segura[1], _distancia_minima);
                } else {
                    _agua_valida = scr_unidade_pode_terreno(_unidade_id, _agua_segura[0], _agua_segura[1]);
                }
                if (_agua_valida) break;
                // Buscar mais longe
                _agua_segura = scr_encontrar_agua_proxima(_x2, _y2, 1000 + (_tentativas * 200));
                _tentativas++;
            }
            if (_agua_segura != noone && array_length(_agua_segura) >= 2) {
                _x2 = _agua_segura[0];
                _y2 = _agua_segura[1];
            }
        }
    }
    
    // Encontrar ponto de bloqueio no caminho (usando zona de segurança)
    var _angulo_original = point_direction(_x1, _y1, _x2, _y2);
    var _distancia_total = point_distance(_x1, _y1, _x2, _y2);
    var _ponto_bloqueio_x = _x1;
    var _ponto_bloqueio_y = _y1;
    var _encontrou_bloqueio = false;
    
    // Verificar caminho para encontrar onde está bloqueado (com zona de segurança)
    var _num_verificacoes = 30; // ✅ AUMENTADO: Mais verificações para melhor detecção
    for (var i = 1; i <= _num_verificacoes; i++) {
        var _t = i / _num_verificacoes;
        var _check_x = lerp(_x1, _x2, _t);
        var _check_y = lerp(_y1, _y2, _t);
        
        // ✅ NOVO: Verificar com zona de segurança (com fallback)
        var _ponto_valido = true;
        if (_funcao_seguranca_existe) {
            _ponto_valido = scr_unidade_pode_terreno_com_seguranca(_unidade_id, _check_x, _check_y, _distancia_minima);
        } else {
            _ponto_valido = scr_unidade_pode_terreno(_unidade_id, _check_x, _check_y);
        }
        
        if (!_ponto_valido) {
            _ponto_bloqueio_x = _check_x;
            _ponto_bloqueio_y = _check_y;
            _encontrou_bloqueio = true;
            break;
        }
    }
    
    if (!_encontrou_bloqueio) {
        // Sem bloqueio detectado - retornar caminho direto
        return [[_x2, _y2]];
    }
    
    // ✅ NOVO: Buscar pontos de contorno em espiral ao redor do ponto de bloqueio
    var _caminho = [];
    var _tile_size = 32; // Tamanho do tile (ajustar se necessário)
    if (variable_global_exists("tile_size")) {
        _tile_size = global.tile_size;
    }
    
    // Buscar pontos válidos em espiral ao redor do ponto de bloqueio
    var _raio_busca = 2;
    var _max_raio = floor(_raio_maximo / _tile_size);
    var _pontos_contorno = [];
    var _angulos_teste = [0, 45, 90, 135, 180, 225, 270, 315]; // 8 direções
    
    // Buscar primeiro ponto válido (ponto de partida do contorno)
    var _ponto_partida = noone;
    while (_raio_busca <= _max_raio && _ponto_partida == noone) {
        for (var a = 0; a < array_length(_angulos_teste); a++) {
            var _angulo_teste = _angulo_original + _angulos_teste[a];
            var _test_x = _ponto_bloqueio_x + lengthdir_x(_raio_busca * _tile_size, _angulo_teste);
            var _test_y = _ponto_bloqueio_y + lengthdir_y(_raio_busca * _tile_size, _angulo_teste);
            
            // ✅ NOVO: Verificar com zona de segurança (com fallback)
            var _ponto_valido = false;
            if (_funcao_seguranca_existe) {
                _ponto_valido = scr_unidade_pode_terreno_com_seguranca(_unidade_id, _test_x, _test_y, _distancia_minima);
            } else {
                _ponto_valido = scr_unidade_pode_terreno(_unidade_id, _test_x, _test_y);
            }
            
            if (_ponto_valido) {
                // Verificar se caminho da origem até este ponto é válido
                var _caminho_valido = false;
                var _funcao_caminho_seguranca_existe = script_exists(asset_get_index("scr_validar_caminho_terreno_com_seguranca"));
                if (_funcao_caminho_seguranca_existe) {
                    _caminho_valido = scr_validar_caminho_terreno_com_seguranca(_unidade_id, _x1, _y1, _test_x, _test_y, 10, _distancia_minima);
                } else {
                    _caminho_valido = scr_validar_caminho_terreno(_unidade_id, _x1, _y1, _test_x, _test_y, 10);
                }
                
                if (_caminho_valido) {
                    _ponto_partida = [_test_x, _test_y];
                    array_push(_pontos_contorno, _ponto_partida);
                    break;
                }
            }
        }
        _raio_busca++;
    }
    
    if (_ponto_partida == noone) {
        // Não encontrou ponto de partida - retornar array vazio para evitar loop infinito
        return [];
    }
    
    // ✅ NOVO: Buscar pontos intermediários que contornem a massa
    // Estratégia: buscar pontos válidos que se aproximem do destino
    var _ponto_atual = _ponto_partida;
    var _max_pontos = 10; // Limitar número de pontos para evitar loops infinitos
    var _iteracoes = 0;
    
    while (_iteracoes < _max_pontos) {
        _iteracoes++;
        
        // Calcular direção do ponto atual para o destino
        var _dir_para_destino = point_direction(_ponto_atual[0], _ponto_atual[1], _x2, _y2);
        var _dist_para_destino = point_distance(_ponto_atual[0], _ponto_atual[1], _x2, _y2);
        
        // Se está muito perto do destino, verificar se pode ir direto
        if (_dist_para_destino < 100) {
            if (scr_validar_caminho_terreno(_unidade_id, _ponto_atual[0], _ponto_atual[1], _x2, _y2, 10)) {
                // Caminho direto válido - adicionar destino e terminar
                array_push(_pontos_contorno, [_x2, _y2]);
                return _pontos_contorno;
            }
        }
        
        // Buscar próximo ponto válido na direção do destino
        var _proximo_ponto = noone;
        var _passo = min(150, _dist_para_destino * 0.3); // Passo adaptativo
        
        // Tentar múltiplas direções (priorizando direção do destino)
        var _angulos_prioridade = [
            _dir_para_destino,           // Direção direta
            _dir_para_destino + 30,      // 30° à direita
            _dir_para_destino - 30,      // 30° à esquerda
            _dir_para_destino + 60,      // 60° à direita
            _dir_para_destino - 60,      // 60° à esquerda
            _dir_para_destino + 90,      // 90° à direita
            _dir_para_destino - 90       // 90° à esquerda
        ];
        
        for (var a = 0; a < array_length(_angulos_prioridade); a++) {
            var _test_x = _ponto_atual[0] + lengthdir_x(_passo, _angulos_prioridade[a]);
            var _test_y = _ponto_atual[1] + lengthdir_y(_passo, _angulos_prioridade[a]);
            
            // ✅ NOVO: Verificar com zona de segurança (com fallback)
            var _ponto_valido = false;
            if (_funcao_seguranca_existe) {
                _ponto_valido = scr_unidade_pode_terreno_com_seguranca(_unidade_id, _test_x, _test_y, _distancia_minima);
            } else {
                _ponto_valido = scr_unidade_pode_terreno(_unidade_id, _test_x, _test_y);
            }
            
            if (_ponto_valido) {
                // Verificar se caminho do ponto atual até este ponto é válido
                var _caminho_valido = false;
                var _funcao_caminho_seguranca_existe = script_exists(asset_get_index("scr_validar_caminho_terreno_com_seguranca"));
                if (_funcao_caminho_seguranca_existe) {
                    _caminho_valido = scr_validar_caminho_terreno_com_seguranca(_unidade_id, _ponto_atual[0], _ponto_atual[1], _test_x, _test_y, 5, _distancia_minima);
                } else {
                    _caminho_valido = scr_validar_caminho_terreno(_unidade_id, _ponto_atual[0], _ponto_atual[1], _test_x, _test_y, 5);
                }
                
                if (_caminho_valido) {
                    _proximo_ponto = [_test_x, _test_y];
                    break;
                }
            }
        }
        
        if (_proximo_ponto == noone) {
            // Não encontrou próximo ponto - tentar busca em espiral maior
            var _raio_espiral = _passo * 1.5;
            for (var a = 0; a < 360; a += 15) {
                var _test_x = _ponto_atual[0] + lengthdir_x(_raio_espiral, _dir_para_destino + a);
                var _test_y = _ponto_atual[1] + lengthdir_y(_raio_espiral, _dir_para_destino + a);
                
                // ✅ NOVO: Verificar com zona de segurança (com fallback)
                var _ponto_valido = false;
                if (_funcao_seguranca_existe) {
                    _ponto_valido = scr_unidade_pode_terreno_com_seguranca(_unidade_id, _test_x, _test_y, _distancia_minima);
                } else {
                    _ponto_valido = scr_unidade_pode_terreno(_unidade_id, _test_x, _test_y);
                }
                
                if (_ponto_valido) {
                    var _caminho_valido = false;
                    var _funcao_caminho_seguranca_existe = script_exists(asset_get_index("scr_validar_caminho_terreno_com_seguranca"));
                    if (_funcao_caminho_seguranca_existe) {
                        _caminho_valido = scr_validar_caminho_terreno_com_seguranca(_unidade_id, _ponto_atual[0], _ponto_atual[1], _test_x, _test_y, 5, _distancia_minima);
                    } else {
                        _caminho_valido = scr_validar_caminho_terreno(_unidade_id, _ponto_atual[0], _ponto_atual[1], _test_x, _test_y, 5);
                    }
                    
                    if (_caminho_valido) {
                        _proximo_ponto = [_test_x, _test_y];
                        break;
                    }
                }
            }
        }
        
        if (_proximo_ponto == noone) {
            // Não conseguiu encontrar próximo ponto - retornar caminho parcial
            break;
        }
        
        array_push(_pontos_contorno, _proximo_ponto);
        _ponto_atual = _proximo_ponto;
        
        // Verificar se chegou perto o suficiente do destino
        if (point_distance(_ponto_atual[0], _ponto_atual[1], _x2, _y2) < 100) {
            if (scr_validar_caminho_terreno(_unidade_id, _ponto_atual[0], _ponto_atual[1], _x2, _y2, 10)) {
                array_push(_pontos_contorno, [_x2, _y2]);
                return _pontos_contorno;
            }
        }
    }
    
    // Se chegou aqui, tentar ir direto para o destino (pode ter contornado)
    if (scr_unidade_pode_terreno(_unidade_id, _x2, _y2)) {
        array_push(_pontos_contorno, [_x2, _y2]);
    } else {
        // Destino ainda inválido - encontrar posição válida próxima
        var _pos_valida = noone;
        // Para navios, usar scr_encontrar_agua_proxima
        if (variable_instance_exists(_unidade_id, "terrenos_permitidos")) {
            var _terrenos = _unidade_id.terrenos_permitidos;
            if (is_array(_terrenos) && array_length(_terrenos) > 0 && _terrenos[0] == TERRAIN.AGUA) {
                _pos_valida = scr_encontrar_agua_proxima(_x2, _y2, 500);
            } else {
                _pos_valida = scr_encontrar_terra_proxima(_unidade_id, _x2, _y2, 500);
            }
        } else {
            _pos_valida = scr_encontrar_terra_proxima(_unidade_id, _x2, _y2, 500);
        }
        
        if (_pos_valida != noone && array_length(_pos_valida) >= 2) {
            array_push(_pontos_contorno, [_pos_valida[0], _pos_valida[1]]);
        }
    }
    
    return _pontos_contorno;
}
