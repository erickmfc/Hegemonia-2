// ===============================================
// HEGEMONIA GLOBAL - COMANDOS MILITARES GERAIS
// Sistema unificado de comandos para todas as unidades militares
// ===============================================

/// @function sc_comandos_militares(unidade_id, comando, _parametros_local);
/// @description Executa comandos militares em qualquer tipo de unidade
/// @param {Id.Instance} unidade_id - ID da unidade militar
/// @param {string} comando - Tipo de comando militar
/// @param {array} _parametros_local - Parâmetros específicos do comando

function sc_comandos_militares(unidade_id, comando, parametros = []) {
    if (!instance_exists(unidade_id)) {
        show_debug_message("❌ ERRO: Unidade militar não existe");
        return false;
    }
    
    var _tipo_unidade = unidade_id.object_index;
    var _comando_local = comando;
    var _parametros_local = parametros;
    
    with (unidade_id) {
        switch (_comando_local) {
            case "atacar_alvo":
                // Comando de ataque a alvo específico
                if (array_length(_parametros_local) > 0) {
                    alvo = _parametros_local[0];
                    estado = "atacando";
                    modo_ataque = true;
                    show_debug_message("🎯 " + object_get_name(_tipo_unidade) + " atacando alvo específico");
                }
                break;
                
            case "modo_passivo":
                // Coloca unidade em modo passivo
                modo_ataque = false;
                estado = "passivo";
                alvo = noone;
                show_debug_message("🛡️ " + object_get_name(_tipo_unidade) + " em modo PASSIVO");
                break;
                
            case "modo_agressivo":
                // Coloca unidade em modo agressivo
                modo_ataque = true;
                estado = "atacando";
                alvo = instance_nearest(x, y, obj_inimigo);
                show_debug_message("⚔️ " + object_get_name(_tipo_unidade) + " em modo AGRESSIVO");
                break;
                
            case "movimento_coordenado":
                // Movimento coordenado para múltiplas unidades
                if (array_length(_parametros_local) >= 2) {
                    destino_x = _parametros_local[0];
                    destino_y = _parametros_local[1];
                    estado = "movendo";
                    show_debug_message("🚶 " + object_get_name(_tipo_unidade) + " movendo para coordenadas");
                }
                break;
                
            case "retirar":
                // Comando de retirada
                estado = "retirando";
                modo_ataque = false;
                alvo = noone;
                // Move para posição segura (base mais próxima)
                var _base_proxima = instance_nearest(x, y, obj_quartel);
                if (instance_exists(_base_proxima)) {
                    destino_x = _base_proxima.x;
                    destino_y = _base_proxima.y;
                }
                show_debug_message("🏃 " + object_get_name(_tipo_unidade) + " RETIRANDO");
                break;
                
            case "aguardar_ordens":
                // Para unidade e aguarda novas ordens
                estado = "parado";
                velocidade_atual = 0;
                alvo = noone;
                show_debug_message("⏸️ " + object_get_name(_tipo_unidade) + " aguardando ordens");
                break;
                
            case "defender_posicao":
                // Defende posição específica
                estado = "defendendo";
                if (array_length(_parametros_local) >= 2) {
                    destino_x = _parametros_local[0];
                    destino_y = _parametros_local[1];
                }
                modo_ataque = true;
                show_debug_message("🛡️ " + object_get_name(_tipo_unidade) + " defendendo posição");
                break;
                
            default:
                show_debug_message("❌ Comando militar desconhecido: " + string(_comando_local));
                return false;
        }
    }
    
    return true;
}

/// @function sc_comando_grupo_militar(unidades_array, comando, _parametros_local);
/// @description Aplica comando militar a um grupo de unidades
/// @param {array} unidades_array - Array com IDs das unidades
/// @param {string} comando - Comando militar
/// @param {array} _parametros_local - Parâmetros do comando

function sc_comando_grupo_militar(unidades_array, comando, _parametros_local = []) {
    var _sucessos = 0;
    var _total = array_length(unidades_array);
    
    for (var i = 0; i < _total; i++) {
        if (sc_comandos_militares(unidades_array[i], comando, _parametros_local)) {
            _sucessos++;
        }
    }
    
    show_debug_message("📊 Comando militar aplicado: " + string(_sucessos) + "/" + string(_total) + " unidades");
    return _sucessos;
}

/// @function sc_verificar_capacidade_militar(unidade_id);
/// @description Verifica capacidades militares de uma unidade
/// @param {Id.Instance} unidade_id - ID da unidade
/// @return {struct} Estrutura com informações da unidade

function sc_verificar_capacidade_militar(unidade_id) {
    if (!instance_exists(unidade_id)) {
        return {capacidade: "inexistente"};
    }
    
    with (unidade_id) {
        var _info = {
            tipo: object_get_name(object_index),
            hp_atual: hp_atual,
            hp_max: hp_max,
            estado: estado,
            modo_ataque: modo_ataque,
            capacidade: "operacional"
        };
        
        // Adiciona informações específicas por tipo
        if (object_index == obj_infantaria) {
            _info[? "modo_combate"] = modo_combate;
            _info[? "alcance_tiro"] = 150;
        } else if (object_index == obj_tanque) {
            _info[? "alcance_tiro"] = 300;
            _info[? "dano"] = 50;
        } else if (object_index == obj_caca_f5) {
            _info[? "altura_voo"] = altura_voo;
            _info[? "radar_alcance"] = radar_alcance;
        } else if (object_index == obj_helicoptero_militar) {
            _info[? "altura_voo"] = altura_voo;
            _info[? "radar_alcance"] = radar_alcance;
        }
        
        return _info;
    }
}