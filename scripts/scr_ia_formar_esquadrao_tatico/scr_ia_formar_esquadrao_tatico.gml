// ===============================================
// HEGEMONIA GLOBAL - FORMAÇÃO DE ESQUADRÃO TÁTICO
// Sistema para formar grupos táticos de unidades
// ===============================================

/// @function scr_ia_formar_esquadrao_tatico(_presidente_id, _tipo_esquadrao)
/// @description Forma um esquadrão tático de unidades
/// @param {id} _presidente_id - ID do presidente
/// @param {string} _tipo_esquadrao - Tipo de esquadrão ("ataque", "defesa", "reconhecimento")
/// @returns {array} Array de IDs das unidades do esquadrão

function scr_ia_formar_esquadrao_tatico(_presidente_id, _tipo_esquadrao = "ataque") {
    if (!instance_exists(_presidente_id)) return [];
    
    var _esquadrao = [];
    var _unidades_coletadas = 0;
    var _max_unidades = 5; // Tamanho máximo do esquadrão
    
    switch(_tipo_esquadrao) {
        case "ataque":
            // Esquadrão de ataque: tanques + aviões
            // Coletar tanques
            with (obj_tanque) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    if (_unidades_coletadas < _max_unidades) {
                        array_push(_esquadrao, id);
                        _unidades_coletadas++;
                    }
                }
            }
            // Coletar aviões
            with (obj_f15) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    if (_unidades_coletadas < _max_unidades) {
                        array_push(_esquadrao, id);
                        _unidades_coletadas++;
                    }
                }
            }
            break;
            
        case "defesa":
            // Esquadrão de defesa: defesa antiaérea + tanques
            with (obj_blindado_antiaereo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    if (_unidades_coletadas < _max_unidades) {
                        array_push(_esquadrao, id);
                        _unidades_coletadas++;
                    }
                }
            }
            with (obj_tanque) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    if (_unidades_coletadas < _max_unidades) {
                        array_push(_esquadrao, id);
                        _unidades_coletadas++;
                    }
                }
            }
            break;
            
        case "reconhecimento":
            // Esquadrão de reconhecimento: aviões rápidos
            with (obj_f6) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    if (_unidades_coletadas < _max_unidades) {
                        array_push(_esquadrao, id);
                        _unidades_coletadas++;
                    }
                }
            }
            break;
            
        default:
            // Esquadrão misto
            with (obj_tanque) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    if (_unidades_coletadas < _max_unidades) {
                        array_push(_esquadrao, id);
                        _unidades_coletadas++;
                    }
                }
            }
            break;
    }
    
    return _esquadrao;
}

/// @function scr_ia_comandar_esquadrao(_esquadrao, _alvo_id)
/// @description Comanda um esquadrão para atacar um alvo
/// @param {array} _esquadrao - Array de IDs das unidades
/// @param {id} _alvo_id - ID do alvo

function scr_ia_comandar_esquadrao(_esquadrao, _alvo_id) {
    if (!instance_exists(_alvo_id)) return;
    
    var _n = array_length(_esquadrao);
    for (var i = 0; i < _n; i++) {
        var _unidade = _esquadrao[i];
        if (instance_exists(_unidade)) {
            _unidade.alvo = _alvo_id;
            _unidade.x_destino = _alvo_id.x;
            _unidade.y_destino = _alvo_id.y;
            if (variable_instance_exists(_unidade, "em_movimento")) {
                _unidade.em_movimento = true;
            }
        }
    }
}

/// @function scr_ia_posicionar_esquadrao_formacao(_esquadrao, _ponto_x, _ponto_y, _formacao)
/// @description Posiciona esquadrão em formação
/// @param {array} _esquadrao - Array de IDs das unidades
/// @param {real} _ponto_x - Posição X central
/// @param {real} _ponto_y - Posição Y central
/// @param {string} _formacao - Tipo de formação ("linha", "circulo", "cunha")

function scr_ia_posicionar_esquadrao_formacao(_esquadrao, _ponto_x, _ponto_y, _formacao = "linha") {
    var _n = array_length(_esquadrao);
    if (_n == 0) return;
    
    var _espacamento = 100; // Espaçamento entre unidades
    
    switch(_formacao) {
        case "linha":
            // Formação em linha horizontal
            var _offset_x = -(_n - 1) * _espacamento / 2;
            for (var i = 0; i < _n; i++) {
                var _unidade = _esquadrao[i];
                if (instance_exists(_unidade)) {
                    _unidade.x_destino = _ponto_x + _offset_x + i * _espacamento;
                    _unidade.y_destino = _ponto_y;
                    if (variable_instance_exists(_unidade, "em_movimento")) {
                        _unidade.em_movimento = true;
                    }
                }
            }
            break;
            
        case "circulo":
            // Formação em círculo
            var _raio = _n * 30;
            for (var i = 0; i < _n; i++) {
                var _unidade = _esquadrao[i];
                if (instance_exists(_unidade)) {
                    var _angulo = (360 / _n) * i;
                    _unidade.x_destino = _ponto_x + lengthdir_x(_raio, _angulo);
                    _unidade.y_destino = _ponto_y + lengthdir_y(_raio, _angulo);
                    if (variable_instance_exists(_unidade, "em_movimento")) {
                        _unidade.em_movimento = true;
                    }
                }
            }
            break;
            
        case "cunha":
            // Formação em cunha (V)
            for (var i = 0; i < _n; i++) {
                var _unidade = _esquadrao[i];
                if (instance_exists(_unidade)) {
                    var _linha = floor(i / 3);
                    var _pos_linha = i mod 3;
                    _unidade.x_destino = _ponto_x + (_pos_linha - 1) * _espacamento;
                    _unidade.y_destino = _ponto_y + _linha * _espacamento;
                    if (variable_instance_exists(_unidade, "em_movimento")) {
                        _unidade.em_movimento = true;
                    }
                }
            }
            break;
    }
}
