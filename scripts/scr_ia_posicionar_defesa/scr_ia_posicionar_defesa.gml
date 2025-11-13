// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
/// @description Posiciona unidades em defesa baseado no estado de alerta
/// @param {real} _presidente_id ID da instância do presidente

function scr_ia_posicionar_defesa(_presidente_id) {
    if (!instance_exists(_presidente_id)) return;
    
    var _presidente = _presidente_id;
    
    // Obter estado de alerta atual
    var _estado_alerta = variable_instance_exists(_presidente, "estado_alerta") ? _presidente.estado_alerta : EstadoAlerta.NORMAL;
    
    // Obter posição do presidente
    var _pres_x = variable_instance_exists(_presidente, "base_x") ? _presidente.base_x : _presidente.x;
    var _pres_y = variable_instance_exists(_presidente, "base_y") ? _presidente.base_y : _presidente.y;
    var _nacao_ia = variable_instance_exists(_presidente, "nacao_proprietaria") ? _presidente.nacao_proprietaria : 2;
    
    // === DETERMINAR PERCENTUAL DE UNIDADES EM DEFESA ===
    var _percentual_defesa = 0.1; // Padrão: 10% (NORMAL)
    var _raio_defesa = 800; // Raio padrão de defesa
    
    switch (_estado_alerta) {
        case EstadoAlerta.EMERGENCIA:
            _percentual_defesa = 1.0; // 100% em defesa
            _raio_defesa = 1500;
            break;
        case EstadoAlerta.CRITICO:
            _percentual_defesa = 0.7; // 70% em defesa
            _raio_defesa = 1200;
            break;
        case EstadoAlerta.ALERTA:
            _percentual_defesa = 0.3; // 30% em defesa
            _raio_defesa = 1000;
            break;
        case EstadoAlerta.NORMAL:
        default:
            _percentual_defesa = 0.1; // 10% em defesa
            _raio_defesa = 800;
            break;
    }
    
    // === CONTAR TOTAL DE UNIDADES DISPONÍVEIS ===
    var _total_unidades = 0;
    var _unidades_disponiveis = [];
    var _idx = 0;
    
    // Contar e coletar unidades terrestres
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
            _unidades_disponiveis[_idx] = {id: id, tipo: "infantaria"};
            _idx++;
            _total_unidades++;
        }
    }
    
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
            _unidades_disponiveis[_idx] = {id: id, tipo: "tanque"};
            _idx++;
            _total_unidades++;
        }
    }
    
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
            _unidades_disponiveis[_idx] = {id: id, tipo: "soldado_aa"};
            _idx++;
            _total_unidades++;
        }
    }
    
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
            _unidades_disponiveis[_idx] = {id: id, tipo: "blindado_aa"};
            _idx++;
            _total_unidades++;
        }
    }
    
    // M1A Abrams
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        with (_obj_abrams) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _unidades_disponiveis[_idx] = {id: id, tipo: "abrams"};
                _idx++;
                _total_unidades++;
            }
        }
    }
    
    if (_total_unidades == 0) return; // Nenhuma unidade disponível
    
    // === CALCULAR QUANTIDADE DE UNIDADES PARA DEFESA ===
    var _unidades_defesa = floor(_total_unidades * _percentual_defesa);
    if (_unidades_defesa < 1 && _estado_alerta != EstadoAlerta.NORMAL) {
        _unidades_defesa = 1; // Mínimo 1 unidade em defesa se não estiver normal
    }
    
    // === OBTER AMEAÇAS PARA POSICIONAMENTO ===
    var _ameacas = scr_ia_detectar_ameacas_presidente(_presidente_id);
    var _alvo_defesa = noone;
    
    // Priorizar ameaça mais próxima
    if (_ameacas.unidade_mais_proxima != noone && instance_exists(_ameacas.unidade_mais_proxima)) {
        _alvo_defesa = _ameacas.unidade_mais_proxima;
    }
    
    // === POSICIONAR UNIDADES EM FORMAÇÃO DE DEFESA ===
    var _unidades_posicionadas = 0;
    var _angulo_base = 0;
    
    if (_alvo_defesa != noone) {
        // Se há alvo, posicionar em direção a ele
        _angulo_base = point_direction(_pres_x, _pres_y, _alvo_defesa.x, _alvo_defesa.y);
    } else {
        // Se não há alvo, formar círculo ao redor do presidente
        _angulo_base = random(360);
    }
    
    // Posicionar unidades em formação
    for (var i = 0; i < min(_unidades_defesa, array_length(_unidades_disponiveis)); i++) {
        var _unidade_data = _unidades_disponiveis[i];
        if (!instance_exists(_unidade_data.id)) continue;
        
        // Calcular posição em formação circular
        var _angulo = _angulo_base + (i * (360 / _unidades_defesa));
        var _dist_formacao = _raio_defesa * 0.6; // 60% do raio para formação
        var _pos_x = _pres_x + lengthdir_x(_dist_formacao, _angulo);
        var _pos_y = _pres_y + lengthdir_y(_dist_formacao, _angulo);
        
        with (_unidade_data.id) {
            // Mover para posição de defesa
            if (variable_instance_exists(id, "destino_x")) {
                destino_x = _pos_x;
                destino_y = _pos_y;
            }
            
            // Se há alvo, mirar nele
            if (_alvo_defesa != noone && instance_exists(_alvo_defesa)) {
                if (variable_instance_exists(id, "alvo")) {
                    alvo = _alvo_defesa;
                }
            } else {
                // Limpar alvo se não há ameaça imediata
                if (variable_instance_exists(id, "alvo")) {
                    alvo = noone;
                }
            }
            
            // Definir estado como defesa
            if (variable_instance_exists(id, "estado")) {
                estado = "defendendo";
            }
            
            // Ativar modo de ataque se há alvo
            if (_alvo_defesa != noone && variable_instance_exists(id, "modo_ataque")) {
                modo_ataque = true;
            }
        }
        
        _unidades_posicionadas++;
    }
    
    // === ATUALIZAR LISTA DE UNIDADES EM DEFESA ===
    if (!variable_instance_exists(_presidente, "unidades_defesa")) {
        _presidente.unidades_defesa = ds_list_create();
    }
    
    ds_list_clear(_presidente.unidades_defesa);
    for (var i = 0; i < _unidades_posicionadas; i++) {
        if (i < array_length(_unidades_disponiveis) && instance_exists(_unidades_disponiveis[i].id)) {
            ds_list_add(_presidente.unidades_defesa, _unidades_disponiveis[i].id);
        }
    }
    
    // === DEBUG ===
    if (variable_global_exists("debug_enabled") && global.debug_enabled && _estado_alerta != EstadoAlerta.NORMAL) {
        show_debug_message("🛡️ POSICIONAMENTO DEFESA: " + string(_unidades_posicionadas) + "/" + string(_total_unidades) + " unidades (" + string(round(_percentual_defesa * 100)) + "%) | Estado: " + string(_estado_alerta));
    }
}
