// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
/// @description Sistema de defesa do presidente - coordena detecção e retorna estado de alerta
/// @param {real} _presidente_id ID da instância do presidente
/// @return {struct} Estrutura com estado de alerta e informações de defesa

function scr_ia_defesa_presidente(_presidente_id) {
    if (!instance_exists(_presidente_id)) {
        return {
            estado_alerta: EstadoAlerta.NORMAL,
            precisa_reforcos: false,
            ameacas_detectadas: 0
        };
    }
    
    var _presidente = _presidente_id;
    
    // === DETECTAR GUERRA E AMEAÇAS ===
    var _dados_guerra = scr_ia_detectar_guerra(_presidente_id);
    var _dados_ataque = scr_ia_detectar_ataque(_presidente_id);
    var _ameacas = scr_ia_detectar_ameacas_presidente(_presidente_id);
    
    // === DETERMINAR ESTADO DE ALERTA ===
    var _estado_alerta = EstadoAlerta.NORMAL;
    var _precisa_reforcos = false;
    
    // Integrar com sistema de guerra
    if (_dados_guerra.estado_guerra == EstadoGuerra.GUERRA_TOTAL) {
        _estado_alerta = EstadoAlerta.EMERGENCIA;
        _precisa_reforcos = true;
    } else if (_dados_guerra.estado_guerra == EstadoGuerra.GUERRA_ATIVA) {
        _estado_alerta = EstadoAlerta.CRITICO;
        _precisa_reforcos = true;
    } else if (_dados_guerra.estado_guerra == EstadoGuerra.ALERTA) {
        _estado_alerta = EstadoAlerta.ALERTA;
    }
    
    // Contar ameaças por zona
    var _total_criticas = array_length(_ameacas.ameacas_criticas);
    var _total_alerta = array_length(_ameacas.ameacas_alerta);
    var _total_monitoramento = array_length(_ameacas.ameacas_monitoramento);
    
    // === LÓGICA DE CLASSIFICAÇÃO DE ALERTA (combinar guerra e ameaças) ===
    // Se já está em guerra, usar estado de guerra como base
    if (!_dados_guerra.em_guerra) {
        // Se não está em guerra, usar lógica de ameaças
        if (_total_criticas >= 3 || (_total_criticas >= 1 && _total_alerta >= 5)) {
            // EMERGÊNCIA: Múltiplas unidades muito próximas
            _estado_alerta = EstadoAlerta.EMERGENCIA;
            _precisa_reforcos = true;
        } else if (_total_criticas >= 1 || _total_alerta >= 3) {
            // CRÍTICO: Pelo menos uma unidade muito próxima ou várias em alerta
            _estado_alerta = EstadoAlerta.CRITICO;
            _precisa_reforcos = (_total_criticas >= 1);
        } else if (_total_alerta >= 1 || _total_monitoramento >= 5) {
            // ALERTA: Unidades se aproximando
            _estado_alerta = EstadoAlerta.ALERTA;
            _precisa_reforcos = false;
        }
    }
    
    // Verificar se precisa reforços baseado em combate
    if (_dados_guerra.unidades_em_combate > 5 && _dados_guerra.unidades_atacando < 3) {
        _precisa_reforcos = true;
    }
    
    // === ATUALIZAR HISTÓRICO DE AMEAÇAS ===
    if (!variable_instance_exists(_presidente, "historico_ameacas")) {
        _presidente.historico_ameacas = ds_map_create();
    }
    
    var _tempo_atual = current_time;
    ds_map_add(_presidente.historico_ameacas, string(_tempo_atual), {
        estado: _estado_alerta,
        total_ameacas: _ameacas.total_ameacas,
        criticas: _total_criticas,
        alerta: _total_alerta,
        monitoramento: _total_monitoramento
    });
    
    // Limitar histórico (manter apenas últimos 20 registros)
    var _chaves = ds_map_keys_to_array(_presidente.historico_ameacas);
    if (array_length(_chaves) > 20) {
        // Ordenar por tempo (mais antigos primeiro)
        array_sort(_chaves, true);
        // Remover os 10 mais antigos
        for (var i = 0; i < 10; i++) {
            ds_map_delete(_presidente.historico_ameacas, _chaves[i]);
        }
    }
    
    // === ATUALIZAR LISTA DE AMEAÇAS DETECTADAS ===
    if (!variable_instance_exists(_presidente, "ameacas_detectadas")) {
        _presidente.ameacas_detectadas = ds_list_create();
    }
    
    // Limpar lista anterior
    ds_list_clear(_presidente.ameacas_detectadas);
    
    // Adicionar ameaças críticas
    for (var i = 0; i < array_length(_ameacas.ameacas_criticas); i++) {
        var _ameaca = _ameacas.ameacas_criticas[i];
        if (instance_exists(_ameaca.id)) {
            ds_list_add(_presidente.ameacas_detectadas, _ameaca);
        }
    }
    
    // Adicionar ameaças em alerta
    for (var i = 0; i < array_length(_ameacas.ameacas_alerta); i++) {
        var _ameaca = _ameacas.ameacas_alerta[i];
        if (instance_exists(_ameaca.id)) {
            ds_list_add(_presidente.ameacas_detectadas, _ameaca);
        }
    }
    
    // === DEBUG ===
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        if (_estado_alerta != EstadoAlerta.NORMAL) {
            show_debug_message("🛡️ DEFESA PRESIDENTE: Estado " + string(_estado_alerta) + " | Críticas: " + string(_total_criticas) + " | Alerta: " + string(_total_alerta) + " | Monitoramento: " + string(_total_monitoramento));
        }
    }
    
    // Contar unidades em defesa
    var _unidades_defesa = 0;
    var _pres_x = variable_instance_exists(_presidente, "base_x") ? _presidente.base_x : _presidente.x;
    var _pres_y = variable_instance_exists(_presidente, "base_y") ? _presidente.base_y : _presidente.y;
    
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _presidente.nacao_proprietaria) {
            var _dist = point_distance(x, y, _pres_x, _pres_y);
            if (_dist <= 500) {
                _unidades_defesa++;
            }
        }
    }
    
    // Retornar estrutura com estado de alerta
    return {
        estado_alerta: _estado_alerta,
        precisa_reforcos: _precisa_reforcos,
        unidades_defesa: _unidades_defesa,
        ameacas_detectadas: _ameacas.total_ameacas,
        ameacas_criticas: _total_criticas,
        ameacas_alerta: _total_alerta,
        ameacas_monitoramento: _total_monitoramento,
        unidade_mais_proxima: _ameacas.unidade_mais_proxima,
        distancia_mais_proxima: _ameacas.distancia_mais_proxima,
        em_guerra: _dados_guerra.em_guerra,
        estado_guerra: _dados_guerra.estado_guerra
    };
}
