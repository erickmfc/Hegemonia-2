// ===============================================
// HEGEMONIA GLOBAL - FORMAÇÕES TÁTICAS
// Sistema de formações militares para unidades
// ===============================================

/// @function sc_formacoes_taticas(unidades_array, tipo_formacao, parametros);
/// @description Organiza unidades em formações táticas específicas
/// @param {array} unidades_array - Array com IDs das unidades
/// @param {string} tipo_formacao - Tipo de formação ("linha", "coluna", "cunha", "quadrado", "losango")
/// @param {array} parametros - Parâmetros da formação [pos_x, pos_y, espacamento, direcao]

function sc_formacoes_taticas(unidades_array, tipo_formacao, parametros = [100, 100, 40, 0]) {
    var _pos_x = parametros[0];
    var _pos_y = parametros[1];
    var _espacamento = parametros[2];
    var _direcao = parametros[3];
    
    var _total_unidades = array_length(unidades_array);
    if (_total_unidades == 0) {
        show_debug_message("❌ ERRO: Nenhuma unidade para formar");
        return false;
    }
    
    var _posicoes = [];
    
    switch (tipo_formacao) {
        case "linha":
            // Formação em linha horizontal
            for (var i = 0; i < _total_unidades; i++) {
                var _offset_x = (i - (_total_unidades - 1) / 2) * _espacamento;
                var _offset_y = 0;
                _posicoes[i] = [_pos_x + _offset_x, _pos_y + _offset_y];
            }
            break;
            
        case "coluna":
            // Formação em coluna vertical
            for (var i = 0; i < _total_unidades; i++) {
                var _offset_x = 0;
                var _offset_y = i * _espacamento;
                _posicoes[i] = [_pos_x + _offset_x, _pos_y + _offset_y];
            }
            break;
            
        case "cunha":
            // Formação em cunha (V)
            var _linhas = ceil(_total_unidades / 3);
            var _unidade_atual = 0;
            for (var linha = 0; linha < _linhas; linha++) {
                var _unidades_linha = min(3, _total_unidades - _unidade_atual);
                for (var col = 0; col < _unidades_linha; col++) {
                    var _offset_x = (col - (_unidades_linha - 1) / 2) * _espacamento;
                    var _offset_y = linha * _espacamento;
                    _posicoes[_unidade_atual] = [_pos_x + _offset_x, _pos_y + _offset_y];
                    _unidade_atual++;
                }
            }
            break;
            
        case "quadrado":
            // Formação em quadrado
            var _lado = ceil(sqrt(_total_unidades));
            var _unidade_atual_quadrado = 0;
            for (var linha = 0; linha < _lado; linha++) {
                for (var col = 0; col < _lado && _unidade_atual_quadrado < _total_unidades; col++) {
                    var _offset_x = col * _espacamento;
                    var _offset_y = linha * _espacamento;
                    _posicoes[_unidade_atual_quadrado] = [_pos_x + _offset_x, _pos_y + _offset_y];
                    _unidade_atual_quadrado++;
                }
            }
            break;
            
        case "losango":
            // Formação em losango
            var _centro_x = _pos_x;
            var _centro_y = _pos_y;
            var _unidade_atual_2 = 0;
            
            // Centro
            if (_unidade_atual_2 < _total_unidades) {
                _posicoes[_unidade_atual_2] = [_centro_x, _centro_y];
                _unidade_atual_2++;
            }
            
            // Anéis concêntricos
            var _raio_losango = _espacamento;
            while (_unidade_atual_2 < _total_unidades) {
                var _pontos_anel = max(4, _total_unidades - _unidade_atual_2);
                for (var i = 0; i < _pontos_anel && _unidade_atual_2 < _total_unidades; i++) {
                    var _angulo = (360 / _pontos_anel) * i;
                    var _x = _centro_x + lengthdir_x(_raio_losango, _angulo);
                    var _y = _centro_y + lengthdir_y(_raio_losango, _angulo);
                    _posicoes[_unidade_atual_2] = [_x, _y];
                    _unidade_atual_2++;
                }
                _raio_losango += _espacamento;
            }
            break;
            
        case "circulo":
            // Formação em círculo
            for (var i = 0; i < _total_unidades; i++) {
                var _angulo = (360 / _total_unidades) * i;
                var _raio_circulo = _espacamento * 2;
                var _x = _pos_x + lengthdir_x(_raio_circulo, _angulo);
                var _y = _pos_y + lengthdir_y(_raio_circulo, _angulo);
                _posicoes[i] = [_x, _y];
            }
            break;
            
        default:
            show_debug_message("❌ Formação desconhecida: " + string(tipo_formacao));
            return false;
    }
    
    // Aplica rotação se especificada
    if (_direcao != 0) {
        for (var i = 0; i < _total_unidades; i++) {
            var _dx = _posicoes[i][0] - _pos_x;
            var _dy = _posicoes[i][1] - _pos_y;
            var _dist = point_distance(0, 0, _dx, _dy);
            var _angulo_atual = point_direction(0, 0, _dx, _dy);
            var _angulo_final = _angulo_atual + _direcao;
            
            _posicoes[i][0] = _pos_x + lengthdir_x(_dist, _angulo_final);
            _posicoes[i][1] = _pos_y + lengthdir_y(_dist, _angulo_final);
        }
    }
    
    // Move unidades para posições da formação
    var _sucessos = 0;
    for (var i = 0; i < _total_unidades; i++) {
        if (instance_exists(unidades_array[i])) {
            with (unidades_array[i]) {
                destino_x = _posicoes[i][0];
                destino_y = _posicoes[i][1];
                estado = "formacao";
                formacao_tipo = _tipo_formacao;
                formacao_indice = i;
                show_debug_message("📍 Unidade " + string(i) + " posicionada em formação");
            }
            _sucessos++;
        }
    }
    
    show_debug_message("📐 Formação " + string(tipo_formacao) + " aplicada: " + string(_sucessos) + "/" + string(_total_unidades) + " unidades");
    return _sucessos;
}

/// @function sc_mover_formacao(unidades_array, destino_x, destino_y);
/// @description Move toda a formação mantendo a estrutura
/// @param {array} unidades_array - Array com unidades da formação
/// @param {real} destino_x - Nova posição X da formação
/// @param {real} destino_y - Nova posição Y da formação

function sc_mover_formacao(unidades_array, destino_x, destino_y) {
    var _total_unidades = array_length(unidades_array);
    var _sucessos = 0;
    
    // Calcula offset médio da formação atual
    var _offset_x_total = 0;
    var _offset_y_total = 0;
    var _unidades_validas = 0;
    
    for (var i = 0; i < _total_unidades; i++) {
        if (instance_exists(unidades_array[i])) {
            with (unidades_array[i]) {
                _offset_x_total += x;
                _offset_y_total += y;
                _unidades_validas++;
            }
        }
    }
    
    if (_unidades_validas == 0) return false;
    
    var _centro_atual_x = _offset_x_total / _unidades_validas;
    var _centro_atual_y = _offset_y_total / _unidades_validas;
    
    // Move cada unidade mantendo offset relativo
    for (var i = 0; i < _total_unidades; i++) {
        if (instance_exists(unidades_array[i])) {
            with (unidades_array[i]) {
                var _offset_x = x - _centro_atual_x;
                var _offset_y = y - _centro_atual_y;
                destino_x = destino_x + _offset_x;
                destino_y = destino_y + _offset_y;
                estado = "movendo_formacao";
            }
            _sucessos++;
        }
    }
    
    show_debug_message("🚶 Formação movida: " + string(_sucessos) + " unidades");
    return _sucessos;
}

/// @function sc_manter_formacao(unidades_array);
/// @description Mantém unidades em formação durante movimento
/// @param {array} unidades_array - Array com unidades da formação

function sc_manter_formacao(unidades_array) {
    var _total_unidades = array_length(unidades_array);
    var _unidades_em_formacao = 0;
    
    for (var i = 0; i < _total_unidades; i++) {
        if (instance_exists(unidades_array[i])) {
            with (unidades_array[i]) {
                if (estado == "formacao" || estado == "movendo_formacao") {
                    // Verifica se unidade está na posição correta
                    var _dist = point_distance(x, y, destino_x, destino_y);
                    if (_dist > 10) {
                        // Reajusta velocidade para manter formação
                        velocidade_atual = min(velocidade_maxima, velocidade_atual + 0.02);
                    } else {
                        velocidade_atual = max(0, velocidade_atual - 0.01);
                    }
                    _unidades_em_formacao++;
                }
            }
        }
    }
    
    return _unidades_em_formacao;
}

/// @function sc_formacao_defensiva(unidades_array, pos_x, pos_y);
/// @description Organiza unidades em formação defensiva
/// @param {array} unidades_array - Array com unidades
/// @param {Real} pos_x - Posição X da defesa
/// @param {Real} pos_y - Posição Y da defesa

function sc_formacao_defensiva(unidades_array, pos_x, pos_y) {
    var _total_unidades = array_length(unidades_array);
    
    // Formação defensiva: linha com unidades espaçadas
    var _largura_total = (_total_unidades - 1) * 50;
    var _inicio_x = pos_x - _largura_total / 2;
    
    var _sucessos = 0;
    for (var i = 0; i < _total_unidades; i++) {
        if (instance_exists(unidades_array[i])) {
            with (unidades_array[i]) {
                destino_x = _inicio_x + (i * 50);
                destino_y = pos_y;
                estado = "defensivo";
                modo_ataque = true;
                formacao_tipo = "defensiva";
            }
            _sucessos++;
        }
    }
    
    show_debug_message("🛡️ Formação defensiva aplicada: " + string(_sucessos) + " unidades");
    return _sucessos;
}