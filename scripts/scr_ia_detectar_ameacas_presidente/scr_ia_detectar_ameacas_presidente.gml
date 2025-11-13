// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
/// @description Detecta ameaças próximas ao presidente e classifica por zona de perigo
/// @param {real} _presidente_id ID da instância do presidente
/// @return {struct} Estrutura com ameaças detectadas e classificação

function scr_ia_detectar_ameacas_presidente(_presidente_id) {
    if (!instance_exists(_presidente_id)) {
        return {
            ameacas_criticas: [],
            ameacas_alerta: [],
            ameacas_monitoramento: [],
            total_ameacas: 0,
            unidade_mais_proxima: noone,
            distancia_mais_proxima: 999999
        };
    }
    
    var _presidente = _presidente_id;
    
    // Obter posição do presidente
    var _pres_x = variable_instance_exists(_presidente, "base_x") ? _presidente.base_x : _presidente.x;
    var _pres_y = variable_instance_exists(_presidente, "base_y") ? _presidente.base_y : _presidente.y;
    var _nacao_ia = variable_instance_exists(_presidente, "nacao_proprietaria") ? _presidente.nacao_proprietaria : 2;
    var _nacao_jogador = 1; // Jogador sempre é nação 1
    
    // Definir zonas de ameaça (baseado no enum ZonaAmeaca)
    var _raio_critico = 500;      // ZonaAmeaca.CRITICA
    var _raio_alerta = 1500;       // ZonaAmeaca.ALERTA
    var _raio_monitoramento = 3000; // ZonaAmeaca.MONITORAMENTO
    
    var _ameacas_criticas = [];
    var _ameacas_alerta = [];
    var _ameacas_monitoramento = [];
    var _total_ameacas = 0;
    var _unidade_mais_proxima = noone;
    var _distancia_mais_proxima = 999999;
    
    // === LISTA DE TIPOS DE UNIDADES INIMIGAS ===
    var _tipos_unidades = [
        obj_infantaria,
        obj_tanque,
        obj_soldado_antiaereo,
        obj_blindado_antiaereo,
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f6,
        obj_f15,
        obj_c100,
        obj_lancha_patrulha,
        obj_navio_base,
        obj_submarino_base,
        obj_navio_transporte,
        obj_Constellation,
        obj_Independence,
        obj_RonaldReagan
    ];
    
    // Verificar M1A Abrams
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        array_push(_tipos_unidades, _obj_abrams);
    }
    
    // === DETECTAR UNIDADES INIMIGAS ===
    for (var i = 0; i < array_length(_tipos_unidades); i++) {
        if (!object_exists(_tipos_unidades[i])) continue;
        
        with (_tipos_unidades[i]) {
            // Verificar se é unidade do jogador (inimiga)
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                var _dist = point_distance(x, y, _pres_x, _pres_y);
                
                // Classificar por zona
                if (_dist <= _raio_critico) {
                    // Zona CRÍTICA
                    array_push(_ameacas_criticas, {
                        id: id,
                        distancia: _dist,
                        tipo: object_get_name(object_index),
                        x: x,
                        y: y
                    });
                    _total_ameacas++;
                    
                    if (_dist < _distancia_mais_proxima) {
                        _distancia_mais_proxima = _dist;
                        _unidade_mais_proxima = id;
                    }
                } else if (_dist <= _raio_alerta) {
                    // Zona ALERTA
                    array_push(_ameacas_alerta, {
                        id: id,
                        distancia: _dist,
                        tipo: object_get_name(object_index),
                        x: x,
                        y: y
                    });
                    _total_ameacas++;
                    
                    if (_dist < _distancia_mais_proxima) {
                        _distancia_mais_proxima = _dist;
                        _unidade_mais_proxima = id;
                    }
                } else if (_dist <= _raio_monitoramento) {
                    // Zona MONITORAMENTO
                    array_push(_ameacas_monitoramento, {
                        id: id,
                        distancia: _dist,
                        tipo: object_get_name(object_index),
                        x: x,
                        y: y
                    });
                    _total_ameacas++;
                    
                    if (_dist < _distancia_mais_proxima) {
                        _distancia_mais_proxima = _dist;
                        _unidade_mais_proxima = id;
                    }
                }
            }
        }
    }
    
    // === DETECTAR ESTRUTURAS INIMIGAS PRÓXIMAS (menos crítico, mas ainda ameaça) ===
    var _tipos_estruturas = [
        obj_quartel,
        obj_aeroporto_militar,
        obj_quartel_marinha
    ];
    
    for (var i = 0; i < array_length(_tipos_estruturas); i++) {
        if (!object_exists(_tipos_estruturas[i])) continue;
        
        with (_tipos_estruturas[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                var _dist = point_distance(x, y, _pres_x, _pres_y);
                
                // Estruturas só são ameaça se muito próximas (zona crítica)
                if (_dist <= _raio_critico) {
                    array_push(_ameacas_criticas, {
                        id: id,
                        distancia: _dist,
                        tipo: object_get_name(object_index),
                        x: x,
                        y: y,
                        eh_estrutura: true
                    });
                    _total_ameacas++;
                }
            }
        }
    }
    
    // Retornar estrutura com ameaças detectadas
    return {
        ameacas_criticas: _ameacas_criticas,
        ameacas_alerta: _ameacas_alerta,
        ameacas_monitoramento: _ameacas_monitoramento,
        total_ameacas: _total_ameacas,
        unidade_mais_proxima: _unidade_mais_proxima,
        distancia_mais_proxima: _distancia_mais_proxima,
        posicao_presidente: {x: _pres_x, y: _pres_y}
    };
}
