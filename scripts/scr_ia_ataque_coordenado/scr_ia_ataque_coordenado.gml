// ===============================================
// HEGEMONIA GLOBAL - ATAQUE COORDENADO
// Sistema de Coordenação de Unidades para Ataque
// ===============================================

/// @function scr_ia_ataque_coordenado(_presidente_id)
/// @description Coordena ataque de unidades em grupo
/// @param {id} _presidente_id - ID do objeto presidente
/// @returns {bool} True se ataque foi coordenado com sucesso

function scr_ia_ataque_coordenado(_presidente_id) {
    with (_presidente_id) {
        
        // === 1. ENCONTRAR ALVO ESTRATÉGICO ===
        var _alvo = scr_ia_encontrar_alvo_prioritario();
        if (_alvo == noone) {
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚠️ Ataque Coordenado: Nenhum alvo encontrado");
            }
            return false;
        }
        
        // === 2. SELECIONAR UNIDADES DE ATAQUE ===
        var _unidades_ataque = ds_list_create();
        
        // Coletar aviões
        with (obj_f15) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                ds_list_add(_unidades_ataque, id);
            }
        }
        with (obj_f6) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                ds_list_add(_unidades_ataque, id);
            }
        }
        
        // Coletar tanques
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                ds_list_add(_unidades_ataque, id);
            }
        }
        
        // Coletar defesa aérea para apoio
        with (obj_blindado_antiaereo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                ds_list_add(_unidades_ataque, id);
            }
        }
        
        // Precisamos de pelo menos 2 unidades para coordenação
        if (ds_list_size(_unidades_ataque) < 2) {
            ds_list_destroy(_unidades_ataque);
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚠️ Ataque Coordenado: Unidades insuficientes (" + string(ds_list_size(_unidades_ataque)) + ")");
            }
            return false;
        }
        
        // === 3. DEFINIR PONTO DE REUNIÃO ===
        // Ponto 300 pixels antes do alvo para se organizar
        var _ponto_reuniao_x = _alvo.x - 300;
        var _ponto_reuniao_y = _alvo.y - 300;
        
        // === 4. ENVIAR UNIDADES PARA PONTO DE REUNIÃO ===
        var _unidades_enviadas = 0;
        for (var i = 0; i < ds_list_size(_unidades_ataque); i++) {
            var _unidade = _unidades_ataque[| i];
            if (instance_exists(_unidade)) {
                // Variar ponto de reunião para não ficar tudo no mesmo lugar
                var _var_x = random(-150, 150);
                var _var_y = random(-150, 150);
                
                _unidade.alvo = noone;
                _unidade.x_destino = _ponto_reuniao_x + _var_x;
                _unidade.y_destino = _ponto_reuniao_y + _var_y;
                
                // Se tem variável de movimento, ativar
                if (variable_instance_exists(_unidade, "em_movimento")) {
                    _unidade.em_movimento = true;
                }
                
                _unidades_enviadas++;
            }
        }
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🎯 Ataque Coordenado: " + string(_unidades_enviadas) + " unidades para reunião em (" + 
                             string(round(_ponto_reuniao_x)) + ", " + string(round(_ponto_reuniao_y)) + ")");
        }
        
        // === 5. ARMAZENAR INFO DO ATAQUE COORDENADO ===
        if (!variable_instance_exists(id, "timer_ataque_coordenado")) {
            timer_ataque_coordenado = 0;
        }
        if (!variable_instance_exists(id, "alvo_coordenado")) {
            alvo_coordenado = noone;
        }
        if (!variable_instance_exists(id, "unidades_ataque_coordenado")) {
            unidades_ataque_coordenado = noone;
        }
        
        timer_ataque_coordenado = 300; // 5 segundos em 60 FPS
        alvo_coordenado = _alvo;
        
        // Destruir lista antiga se existir
        if (ds_list_exists(unidades_ataque_coordenado)) {
            ds_list_destroy(unidades_ataque_coordenado);
        }
        unidades_ataque_coordenado = _unidades_ataque;
        
        return true;
    }
}

/// @function scr_ia_executar_ataque_coordenado(_presidente_id)
/// @description Executa o ataque após unidades se reunirem
/// @param {id} _presidente_id - ID do objeto presidente

function scr_ia_executar_ataque_coordenado(_presidente_id) {
    with (_presidente_id) {
        if (!variable_instance_exists(id, "timer_ataque_coordenado") ||
            !variable_instance_exists(id, "alvo_coordenado") ||
            !variable_instance_exists(id, "unidades_ataque_coordenado")) {
            return;
        }
        
        // Contar unidades perto do ponto de reunião
        var _unidades_reunidas = 0;
        var _ponto_x = alvo_coordenado.x - 300;
        var _ponto_y = alvo_coordenado.y - 300;
        
        if (ds_list_exists(unidades_ataque_coordenado)) {
            for (var i = 0; i < ds_list_size(unidades_ataque_coordenado); i++) {
                var _unidade = unidades_ataque_coordenado[| i];
                if (instance_exists(_unidade)) {
                    // ✅ CORREÇÃO: Usar point_distance() nativo do GameMaker em vez de função duplicada
                    var _dist = point_distance(_unidade.x, _unidade.y, _ponto_x, _ponto_y);
                    if (_dist < 300) { // Raio de reunião
                        _unidades_reunidas++;
                    }
                }
            }
        }
        
        // Se maioria reunida OU timer expirou, começar ataque
        if (_unidades_reunidas >= ds_list_size(unidades_ataque_coordenado) * 0.6 || 
            timer_ataque_coordenado <= 0) {
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚔️ ATAQUE COORDENADO INICIADO! " + string(_unidades_reunidas) + " unidades atacando!");
            }
            
            // Enviar todas as unidades para atacar o alvo
            if (ds_list_exists(unidades_ataque_coordenado)) {
                for (var i = 0; i < ds_list_size(unidades_ataque_coordenado); i++) {
                    var _unidade = unidades_ataque_coordenado[| i];
                    if (instance_exists(_unidade)) {
                        _unidade.alvo = alvo_coordenado;
                        _unidade.x_destino = alvo_coordenado.x;
                        _unidade.y_destino = alvo_coordenado.y;
                        if (variable_instance_exists(_unidade, "em_movimento")) {
                            _unidade.em_movimento = true;
                        }
                    }
                }
            }
            
            // Resetar variáveis
            timer_ataque_coordenado = 0;
            alvo_coordenado = noone;
            if (ds_list_exists(unidades_ataque_coordenado)) {
                ds_list_destroy(unidades_ataque_coordenado);
            }
            unidades_ataque_coordenado = noone;
        } else {
            // Decrementar timer
            timer_ataque_coordenado--;
        }
    }
}

