/// @description Comandar unidades da IA para atacar inimigos
/// @param _ia_id ID da IA

function scr_ia_atacar(_ia_id) {
    var _ia = _ia_id;
    
    if (!variable_global_exists("ia_dinheiro")) {
        show_debug_message("❌ ERRO: Recursos da IA não inicializados!");
        return;
    }
    
    // 1. Encontrar inimigos próximos do jogador (nacao_proprietaria == 1)
    var _inimigos_proximos = ds_list_create();
    
    // Procurar infantaria inimiga
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            if (_dist <= _ia.raio_expansao) {
                ds_list_add(_inimigos_proximos, id);
            }
        }
    }
    
    // Procurar tanques inimigos
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            if (_dist <= _ia.raio_expansao) {
                ds_list_add(_inimigos_proximos, id);
            }
        }
    }
    
    // Procurar soldados anti-aéreo inimigos
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            if (_dist <= _ia.raio_expansao) {
                ds_list_add(_inimigos_proximos, id);
            }
        }
    }
    
    // 2. Escolher o inimigo mais próximo
    var _inimigo_alvo = noone;
    var _menor_distancia = 999999;
    
    for (var i = 0; i < ds_list_size(_inimigos_proximos); i++) {
        var _inimigo = ds_list_find_value(_inimigos_proximos, i);
        if (instance_exists(_inimigo)) {
            var _dist = point_distance(_inimigo.x, _inimigo.y, _ia.base_x, _ia.base_y);
            if (_dist < _menor_distancia) {
                _menor_distancia = _dist;
                _inimigo_alvo = _inimigo;
            }
        }
    }
    
    // 3. Comandar unidades da IA para atacar
    if (instance_exists(_inimigo_alvo)) {
        var _num_comandos = 0;
        
        // Comandar infantaria da IA
        with (obj_infantaria) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                // Definir alvo de ataque
                if (variable_instance_exists(id, "destino_x")) {
                    destino_x = _inimigo_alvo.x;
                    destino_y = _inimigo_alvo.y;
                }
                
                // Definir alvo inimigo se a variável existir
                if (variable_instance_exists(id, "alvo_inimigo")) {
                    alvo_inimigo = _inimigo_alvo;
                }
                
                // Atualizar estado para atacar
                if (variable_instance_exists(id, "estado")) {
                    estado = "atacando";
                }
                
                _num_comandos++;
            }
        }
        
        // Comandar tanques da IA
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                // Definir destino de ataque
                if (variable_instance_exists(id, "destino_x")) {
                    destino_x = _inimigo_alvo.x;
                    destino_y = _inimigo_alvo.y;
                }
                
                // Definir alvo inimigo se a variável existir
                if (variable_instance_exists(id, "alvo_inimigo")) {
                    alvo_inimigo = _inimigo_alvo;
                }
                
                // Atualizar estado para atacar
                if (variable_instance_exists(id, "estado")) {
                    estado = "atacando";
                }
                
                _num_comandos++;
            }
        }
        
        show_debug_message("⚔️ IA ATACANDO INIMIGO! Unidades comandadas: " + string(_num_comandos) + " | Distância: " + string(round(_menor_distancia)));
        show_debug_message("🎯 Alvo ID: " + string(_inimigo_alvo) + " em (" + string(round(_inimigo_alvo.x)) + ", " + string(round(_inimigo_alvo.y)) + ")");
        
    } else {
        show_debug_message("⚠️ IA não encontrou inimigos para atacar no raio de expansão");
    }
    
    ds_list_destroy(_inimigos_proximos);
}
