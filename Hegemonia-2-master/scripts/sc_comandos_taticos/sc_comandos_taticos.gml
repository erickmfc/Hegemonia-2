// ===============================================
// HEGEMONIA GLOBAL - COMANDOS TÁTICOS AVANÇADOS
// Sistema de comandos estratégicos e táticos complexos
// ===============================================

/// @function sc_comandos_taticos(unidade_id, comando_tatico, _parametros_local);
/// @description Executa comandos táticos avançados em unidades
/// @param {Id.Instance} unidade_id - ID da unidade
/// @param {string} comando_tatico - Comando tático específico
/// @param {array} _parametros_local - Parâmetros táticos

function sc_comandos_taticos(unidade_id, comando_tatico, parametros = []) {
    if (!instance_exists(unidade_id)) {
        show_debug_message("❌ ERRO: Unidade não existe para comando tático");
        return false;
    }
    
    var _comando_tatico_local = comando_tatico;
    var _parametros_local = parametros;
    
    with (unidade_id) {
        switch (_comando_tatico_local) {
            case "flanquear":
                // Manobra de flanqueamento
                if (array_length(_parametros_local) >= 3) {
                    var _alvo = _parametros_local[0];
                    var _angulo_flanco = _parametros_local[1];
                    var _distancia = _parametros_local[2];
                    
                    if (instance_exists(_alvo)) {
                        var _angulo_final = _alvo.image_angle + _angulo_flanco;
                        destino_x = _alvo.x + lengthdir_x(_distancia, _angulo_final);
                        destino_y = _alvo.y + lengthdir_y(_distancia, _angulo_final);
                        estado = "flanqueando";
                        alvo_flanco = _alvo;
                        show_debug_message("🔄 " + object_get_name(object_index) + " executando FLANQUEAMENTO");
                    }
                }
                break;
                
            case "emboscada":
                // Preparar emboscada
                if (array_length(_parametros_local) >= 2) {
                    destino_x = _parametros_local[0];
                    destino_y = _parametros_local[1];
                    estado = "emboscada";
                    modo_ataque = false; // Fica oculto até o momento certo
                    timer_emboscada = 300; // 5 segundos para preparar
                    show_debug_message("🎭 " + object_get_name(object_index) + " preparando EMBOSCADA");
                }
                break;
                
            case "cobertura_fogo":
                // Fornecer cobertura de fogo
                if (array_length(_parametros_local) > 0) {
                    var _unidade_coberta = _parametros_local[0];
                    if (instance_exists(_unidade_coberta)) {
                        estado = "cobertura";
                        unidade_coberta = _unidade_coberta;
                        modo_ataque = true;
                        show_debug_message("🛡️ " + object_get_name(object_index) + " fornecendo COBERTURA DE FOGO");
                    }
                }
                break;
                
            case "reconhecimento":
                // Missão de reconhecimento
                if (array_length(_parametros_local) >= 2) {
                    destino_x = _parametros_local[0];
                    destino_y = _parametros_local[1];
                    estado = "reconhecimento";
                    modo_ataque = false;
                    alcance_reconhecimento = 200;
                    show_debug_message("🔍 " + object_get_name(object_index) + " em missão de RECONHECIMENTO");
                }
                break;
                
            case "perseguicao":
                // Perseguir inimigo em fuga
                if (array_length(_parametros_local) > 0) {
                    var _inimigo_fugindo = _parametros_local[0];
                    if (instance_exists(_inimigo_fugindo)) {
                        alvo_perseguicao = _inimigo_fugindo;
                        estado = "perseguindo";
                        velocidade_perseguicao = velocidade_maxima * 1.2; // 20% mais rápido
                        show_debug_message("🏃 " + object_get_name(object_index) + " PERSEGUINDO inimigo");
                    }
                }
                break;
                
            case "retirada_tatica":
                // Retirada tática ordenada
                if (array_length(_parametros_local) >= 2) {
                    destino_x = _parametros_local[0];
                    destino_y = _parametros_local[1];
                    estado = "retirada_tatica";
                    modo_ataque = false;
                    // Mantém cobertura durante retirada
                    timer_cobertura = 180; // 3 segundos de cobertura
                    show_debug_message("🚶 " + object_get_name(object_index) + " executando RETIRADA TÁTICA");
                }
                break;
                
            case "assalto_coordenado":
                // Assalto coordenado com múltiplas unidades
                if (array_length(_parametros_local) >= 3) {
                    var _alvo_assalto = _parametros_local[0];
                    var _unidades_coordenadas = _parametros_local[1];
                    var _formacao = _parametros_local[2];
                    
                    estado = "assalto_coordenado";
                    alvo_assalto = _alvo_assalto;
                    formacao_assalto = _formacao;
                    modo_ataque = true;
                    show_debug_message("⚔️ " + object_get_name(object_index) + " em ASSALTO COORDENADO");
                }
                break;
                
            case "defesa_elastica":
                // Defesa elástica - recua e contra-ataca
                estado = "defesa_elastica";
                modo_ataque = false;
                timer_defesa_elastica = 240; // 4 segundos de recuo
                show_debug_message("🔄 " + object_get_name(object_index) + " executando DEFESA ELÁSTICA");
                break;
                
            default:
                show_debug_message("❌ Comando tático desconhecido: " + string(_comando_tatico));
                return false;
        }
    }
    
    return true;
}

/// @function sc_coordenar_ataque_multiplo(unidades_array, alvo, estrategia);
/// @description Coordena ataque múltiplo com estratégia específica
/// @param {array} unidades_array - Array com unidades participantes
/// @param {Id.Instance} alvo - Alvo do ataque coordenado
/// @param {string} estrategia - Estratégia de ataque ("frontal", "flanco", "cerco")

function sc_coordenar_ataque_multiplo(_unidades_array, _alvo, _estrategia) {
    if (!instance_exists(_alvo)) {
        show_debug_message("❌ ERRO: Alvo não existe para ataque coordenado");
        return false;
    }
    
    var _total_unidades = array_length(_unidades_array);
    var _sucessos = 0;
    
    for (var i = 0; i < _total_unidades; i++) {
        var _unidade = _unidades_array[i];
        if (instance_exists(_unidade)) {
            var _parametros_local = [];
            
            switch (_estrategia) {
                case "frontal":
                    // Ataque frontal direto
                    _parametros_local = [_alvo, 0, 100]; // alvo, ângulo, distância
                    break;
                    
                case "flanco":
                    // Ataque pelos flancos
                    var _angulo_flanco = (i % 2 == 0) ? 90 : -90;
                    _parametros_local = [_alvo, _angulo_flanco, 120];
                    break;
                    
                case "cerco":
                    // Cerco completo
                    var _angulo_cerco = (360 / _total_unidades) * i;
                    _parametros_local = [_alvo, _angulo_cerco, 150];
                    break;
            }
            
            if (sc_comandos_taticos(_unidade, "flanquear", _parametros_local)) {
                _sucessos++;
            }
        }
    }
    
    show_debug_message("🎯 Ataque coordenado: " + string(_sucessos) + "/" + string(_total_unidades) + " unidades");
    return _sucessos;
}

/// @function sc_avaliar_situacao_tatica(pos_x, pos_y, raio);
/// @description Avalia situação tática em uma área
/// @param {real} pos_x - Posição X da área
/// @param {real} pos_y - Posição Y da área
/// @param {real} raio - Raio de análise
/// @return {struct} Análise tática da área

function sc_avaliar_situacao_tatica(_pos_x, _pos_y, _raio) {
    var _analise = {
        unidades_aliadas: 0,
        unidades_inimigas: 0,
        unidades_neutras: 0,
        cobertura_disponivel: false,
        terreno_favoravel: "neutro",
        nivel_ameaca: "baixo"
    };
    
    // Conta unidades na área
    with (obj_infantaria) {
        if (point_distance(x, y, _pos_x, _pos_y) <= _raio) {
            if (nacao_proprietaria == 1) {
                _analise.unidades_aliadas++;
            } else {
                _analise.unidades_inimigas++;
            }
        }
    }
    
    // Avalia nível de ameaça
    if (_analise.unidades_inimigas > _analise.unidades_aliadas) {
        _analise.nivel_ameaca = "alto";
    } else if (_analise.unidades_inimigas > 0) {
        _analise.nivel_ameaca = "medio";
    }
    
    return _analise;
}