/// @description Sistema de defesa da IA - contra-ataca quando atacada
/// @param {real} _ia_id ID da IA
/// @param {real} _dados_ataque Dados do ataque detectado (de scr_ia_detectar_ataque)

function scr_ia_defender(_ia_id, _dados_ataque) {
    var _ia = _ia_id;
    
    if (!_dados_ataque.sendo_atacada) return false;
    
    var _alvo_atacante = _dados_ataque.alvo_atacante;
    if (!instance_exists(_alvo_atacante)) return false;
    
    // ✅ CORREÇÃO: Ativar todas as unidades inimigas antes de defender
    scr_activate_enemy_squad(_alvo_atacante.x, _alvo_atacante.y, 1500);
    
    var _contra_atacou = false;
    var _unidades_defensoras = 0;
    
    // === DEFESA TERRESTRE ===
    if (_dados_ataque.unidades_terrestres_atacadas > 0) {
        // Comandar unidades terrestres próximas para defender
        var _raio_defesa = 600; // Raio de defesa
        
        with (obj_infantaria) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                var _dist_alvo = point_distance(x, y, _alvo_atacante.x, _alvo_atacante.y);
                if (_dist_alvo <= _raio_defesa) {
                    // Defender contra-atacando o atacante
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_atacante.x;
                        destino_y = _alvo_atacante.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_atacante;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _unidades_defensoras++;
                    _contra_atacou = true;
                }
            }
        }
        
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                var _dist_alvo = point_distance(x, y, _alvo_atacante.x, _alvo_atacante.y);
                if (_dist_alvo <= _raio_defesa) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_atacante.x;
                        destino_y = _alvo_atacante.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_atacante;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _unidades_defensoras++;
                    _contra_atacou = true;
                }
            }
        }
    }
    
    // === DEFESA NAVAL ===
    if (_dados_ataque.unidades_navais_atacadas > 0) {
        // ✅ CORRIGIDO: Implementação direta (sem depender de função externa)
        var _navios_defensores = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte, obj_Constellation, obj_Independence, obj_RonaldReagan];
        var _obj_fragata_defender = asset_get_index("obj_fragata");
        if (_obj_fragata_defender != -1 && asset_get_type(_obj_fragata_defender) == asset_object) {
            array_push(_navios_defensores, _obj_fragata_defender);
        }
        
        var _raio_defesa_naval = 800;
        
        for (var i = 0; i < array_length(_navios_defensores); i++) {
            var _navio_tipo = _navios_defensores[i];
            if (!object_exists(_navio_tipo)) continue;
            
            with (_navio_tipo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    var _dist_alvo = point_distance(x, y, _alvo_atacante.x, _alvo_atacante.y);
                    if (_dist_alvo <= _raio_defesa_naval) {
                        // Navio defender contra-atacando
                        if (variable_instance_exists(id, "destino_x")) {
                            destino_x = _alvo_atacante.x;
                            destino_y = _alvo_atacante.y;
                        }
                        if (variable_instance_exists(id, "alvo")) {
                            alvo = _alvo_atacante;
                        }
                        if (variable_instance_exists(id, "estado")) {
                            estado = "atacando";
                        }
                        if (variable_instance_exists(id, "modo_combate")) {
                            modo_combate = "atacando"; // Modo de combate ativo
                        }
                        _unidades_defensoras++;
                        _contra_atacou = true;
                    }
                }
            }
        }
    }
    
    // === DEFESA AÉREA ===
    if (_dados_ataque.unidades_aereas_atacadas > 0) {
        var _aeronaves_defensoras = [
            obj_helicoptero_militar,
            obj_caca_f5,
            obj_f6,
            obj_f15
        ];
        
        var _raio_defesa_aerea = 1000;
        
        for (var i = 0; i < array_length(_aeronaves_defensoras); i++) {
            var _aereo_tipo = _aeronaves_defensoras[i];
            if (!object_exists(_aereo_tipo)) continue;
            
            with (_aereo_tipo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    var _dist_alvo = point_distance(x, y, _alvo_atacante.x, _alvo_atacante.y);
                    if (_dist_alvo <= _raio_defesa_aerea) {
                        // Aeronave defender contra-atacando
                        if (variable_instance_exists(id, "alvo_em_mira")) {
                            alvo_em_mira = _alvo_atacante;
                        }
                        if (variable_instance_exists(id, "alvo")) {
                            alvo = _alvo_atacante;
                        }
                        if (variable_instance_exists(id, "estado")) {
                            estado = "atacando";
                        }
                        _unidades_defensoras++;
                        _contra_atacou = true;
                    }
                }
            }
        }
    }
    
    if (_contra_atacou) {
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🛡️ IA DEFENDENDO! Tipo: " + _dados_ataque.tipo_guerra + " | " + string(_unidades_defensoras) + " unidades contra-atacando");
        }
    }
    
    return _contra_atacou;
}
