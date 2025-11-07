/// @description Executa ataque tático coordenado com estratégia
/// @param {real} _ia_id ID da IA
/// @param {struct} _analise Alvos analisados de scr_ia_analisar_alvos

function scr_ia_ataque_tatico(_ia_id, _analise) {
    var _ia = _ia_id;
    
    if (ds_list_size(_analise.alvos) == 0) {
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚠️ IA não encontrou alvos para ataque tático");
        }
        return;
    }
    
    // Obter alvo prioritário
    var _alvo_principal = noone;
    var _menor_dist = 999999;
    
    for (var i = 0; i < min(ds_list_size(_analise.alvos), 5); i++) {
        var _alvo_data = ds_list_find_value(_analise.alvos, i);
        if (instance_exists(_alvo_data.id)) {
            var _dist = point_distance(_alvo_data.id.x, _alvo_data.id.y, _ia.base_x, _ia.base_y);
            if (_dist < _menor_dist) {
                _menor_dist = _dist;
                _alvo_principal = _alvo_data.id;
            }
        }
    }
    
    if (!instance_exists(_alvo_principal)) return;
    
    // === ESCOLHER FORMAÇÃO BASEADO NA ESTRATÉGIA ===
    var _formacao = _analise.estrategia;
    
    // ✅ NOVO: Mapeamento expandido de estratégias para formações
    var _tipo_formacao = "linha"; // Padrão
    
    switch (_formacao) {
        case "ataque_total":
            _tipo_formacao = "assalto_massivo"; // Todos os tipos de unidades em formação densa
            break;
        case "foco_estruturas":
            _tipo_formacao = "cerco"; // Cercar estrutura
            break;
        case "guerra_economica":
            _tipo_formacao = "dispersao_tatica"; // Espalhar para atingir múltiplos alvos econômicos
            break;
        case "cerco":
            _tipo_formacao = "cerco_completo"; // Círculo completo ao redor
            break;
        case "emboscada":
            _tipo_formacao = "emboscada_em_V"; // Formação em V para emboscada
            break;
        case "ataque_multi_frontal":
            _tipo_formacao = "avanco_coordenado"; // Múltiplos grupos
            break;
        case "ataque_limitado":
            _tipo_formacao = "pincer_basico"; // Ataque limitado em pinça
            break;
        case "defesa_reforcos":
            _tipo_formacao = "defensiva"; // Formação defensiva esperando reforços
            break;
        default:
            _tipo_formacao = "linha"; // Formação básica em linha
    }
    
    // === APLICAR FORMAÇÃO TÁTICA ===
    var _formacao_dados = scr_ia_formacao_tatica(_ia, _alvo_principal.x, _alvo_principal.y, _tipo_formacao);
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🎯 ATAQUE TÁTICO: Estratégia=" + _formacao + " | Formação=" + _tipo_formacao + " | Alvos=" + string(ds_list_size(_analise.alvos)));
    }
    
    // === COMANDAR UNIDADES NA FORMAÇÃO ===
    var _comandos_enviados = 0;
    
    for (var i = 0; i < array_length(_formacao_dados); i++) {
        var _formacao_item = _formacao_dados[i];
        
        if (!instance_exists(_formacao_item.unidade)) continue;
        
        // Comandar unidade para posição tática
        with (_formacao_item.unidade) {
            // Primeiro: mover para posição de formação
            if (variable_instance_exists(id, "destino_x")) {
                destino_x = _formacao_item.destino_x;
                destino_y = _formacao_item.destino_y;
            }
            
            // Depois: atacar alvo principal
            if (variable_instance_exists(id, "alvo")) {
                alvo = _alvo_principal;
            }
            
            // Ativar modo ataque
            if (variable_instance_exists(id, "estado")) {
                estado = "movendo"; // Primeiro mover, depois atacar
            }
            
            if (variable_instance_exists(id, "modo_ataque")) {
                modo_ataque = true;
            }
        }
        
        _comandos_enviados++;
    }
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("⚔️ IA COMANDOU " + string(_comandos_enviados) + " UNIDADES EM FORMAÇÃO " + string(_tipo_formacao).to_upper());
    }
    
    // === ATAQUE MULTI-FRONTAL: DIVIDIR EM GRUPOS ===
    if (_formacao == "ataque_multi_frontal" && ds_list_size(_analise.alvos) >= 2) {
        // Dividir tropas em 2 grupos para atacar diferentes alvos
        var _grupo1_alvos = [];
        var _grupo2_alvos = [];
        
        for (var i = 0; i < min(ds_list_size(_analise.alvos), 4); i++) {
            var _alvo_data = ds_list_find_value(_analise.alvos, i);
            if (instance_exists(_alvo_data.id)) {
                if (i mod 2 == 0) {
                    array_push(_grupo1_alvos, _alvo_data.id);
                } else {
                    array_push(_grupo2_alvos, _alvo_data.id);
                }
            }
        }
        
        // Comandar metade das unidades para grupo 1
        var _contador = 0;
        var _total_unidades = array_length(_formacao_dados);
        
        for (var i = 0; i < array_length(_formacao_dados); i++) {
            if (_contador >= _total_unidades / 2) break;
            
            var _formacao_item = _formacao_dados[i];
            if (!instance_exists(_formacao_item.unidade)) continue;
            
            if (array_length(_grupo1_alvos) > 0) {
                var _alvo_grupo = _grupo1_alvos[_contador mod array_length(_grupo1_alvos)];
                
                with (_formacao_item.unidade) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_grupo.x;
                        destino_y = _alvo_grupo.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_grupo;
                    }
                }
            }
            _contador++;
        }
        
        // Comandar outra metade para grupo 2
        for (var i = _contador; i < array_length(_formacao_dados); i++) {
            var _formacao_item = _formacao_dados[i];
            if (!instance_exists(_formacao_item.unidade)) continue;
            
            if (array_length(_grupo2_alvos) > 0) {
                var _alvo_grupo = _grupo2_alvos[(i - _contador) mod array_length(_grupo2_alvos)];
                
                with (_formacao_item.unidade) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_grupo.x;
                        destino_y = _alvo_grupo.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_grupo;
                    }
                }
            }
        }
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🔀 ATAQUE MULTI-FRONTAL: " + string(_contador) + " unidades Grupo 1 | " + string(_total_unidades - _contador) + " unidades Grupo 2");
        }
    }
}
