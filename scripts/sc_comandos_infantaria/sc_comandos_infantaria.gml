// ===============================================
// HEGEMONIA GLOBAL - COMANDOS DE INFANTARIA
// Sistema de comandos táticos para unidades terrestres
// ===============================================

/// @function sc_comandos_infantaria(unidade_id, comando, parametros);
/// @description Executa comandos táticos em unidades de infantaria
/// @param {instance} unidade_id - ID da unidade de infantaria
/// @param {string} comando - Tipo de comando ("atacar", "defender", "patrulhar", "seguir")
/// @param {array} parametros - Parâmetros específicos do comando

function sc_comandos_infantaria(_unidade_id, _comando, _parametros = []) {
    if (!instance_exists(_unidade_id)) {
        show_debug_message("❌ ERRO: Unidade de infantaria não existe");
        return false;
    }
    
    with (_unidade_id) {
        switch (_comando) {
            case "atacar":
                // Comando de ataque agressivo
                estado = "atacando";
                modo_combate = "agressivo";
                if (array_length(_parametros) > 0) {
                    alvo = _parametros[0]; // ID do alvo específico
                } else {
                    alvo = instance_nearest(x, y, obj_inimigo);
                }
                show_debug_message("⚔️ Infantaria em modo ATAQUE AGRESSIVO");
                break;
                
            case "defender":
                // Comando de defesa
                estado = "defendendo";
                modo_combate = "defensivo";
                alvo = noone;
                show_debug_message("🛡️ Infantaria em modo DEFESA");
                break;
                
            case "patrulhar":
                // Comando de patrulha
                estado = "patrulhando";
                modo_combate = "vigilante";
                if (array_length(_parametros) >= 2) {
                    // _parametros[0] = ponto inicial, _parametros[1] = ponto final
                    var _ponto_inicial = _parametros[0];
                    var _ponto_final = _parametros[1];
                    ds_list_clear(patrulha);
                    ds_list_add(patrulha, _ponto_inicial);
                    ds_list_add(patrulha, _ponto_final);
                    patrulha_indice = 0;
                    destino_x = _ponto_inicial[0];
                    destino_y = _ponto_inicial[1];
                }
                show_debug_message("🚶 Infantaria em modo PATRULHA");
                break;
                
            case "seguir":
                // Comando de seguir unidade
                estado = "seguindo";
                modo_combate = "passivo";
                if (array_length(_parametros) > 0) {
                    alvo_seguir = _parametros[0]; // ID da unidade para seguir
                }
                show_debug_message("👥 Infantaria SEGUINDO unidade");
                break;
                
            case "parar":
                // Comando de parada
                estado = "parado";
                modo_combate = "passivo";
                alvo = noone;
                alvo_seguir = noone;
                velocidade_atual = 0;
                show_debug_message("⏹️ Infantaria PARADA");
                break;
                
            default:
                show_debug_message("❌ Comando desconhecido: " + string(_comando));
                return false;
        }
    }
    
    return true;
}

/// @function sc_aplicar_comando_multiplas_unidades(unidades_array, comando, parametros);
/// @description Aplica o mesmo comando a múltiplas unidades de infantaria
/// @param {array} unidades_array - Array com IDs das unidades
/// @param {string} comando - Comando a ser aplicado
/// @param {array} parametros - Parâmetros do comando

function sc_aplicar_comando_multiplas_unidades(_unidades_array, _comando, _parametros = []) {
    var _sucessos = 0;
    var _total = array_length(_unidades_array);
    
    for (var i = 0; i < _total; i++) {
        if (sc_comandos_infantaria(_unidades_array[i], _comando, _parametros)) {
            _sucessos++;
        }
    }
    
    show_debug_message("📊 Comando aplicado: " + string(_sucessos) + "/" + string(_total) + " unidades");
    return _sucessos;
}

/// @function sc_verificar_estado_infantaria(unidade_id);
/// @description Verifica o estado atual de uma unidade de infantaria
/// @param {instance} unidade_id - ID da unidade
/// @return {string} Estado atual da unidade

function sc_verificar_estado_infantaria(_unidade_id) {
    if (!instance_exists(_unidade_id)) {
        return "inexistente";
    }
    
    with (_unidade_id) {
        return estado + " (" + modo_combate + ")";
    }
}