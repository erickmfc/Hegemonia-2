/// @description Analisa e prioriza alvos táticos inteligentemente
/// @param {real} _ia_id ID da IA
/// @return {struct} Estrutura com alvos priorizados e estratégia recomendada

function scr_ia_analisar_alvos(_ia_id) {
    var _ia = _ia_id;
    
    var _alvos_criticos = ds_list_create(); // Estruturas militares (prioridade máxima)
    var _alvos_importantes = ds_list_create(); // Estruturas econômicas
    var _alvos_unidades = ds_list_create(); // Unidades do jogador
    var _alvos_fracos = ds_list_create(); // Unidades com HP baixo (fácil eliminar)
    
    // === 1. PRIORIDADE MÁXIMA: ESTRUTURAS MILITARES ===
    // Quartéis, quartéis navais e aeroportos são ALVO PRIMÁRIO
    with (obj_quartel) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            var _hp_percent = (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max")) ? 
                (hp_atual / hp_max) : 1.0;
            
            ds_list_add(_alvos_criticos, {
                id: id,
                tipo: "quartel",
                prioridade: 10,
                distancia: _dist,
                hp_percent: _hp_percent,
                valor: "critico" // Eliminar impede criação de novas unidades
            });
        }
    }
    
    with (obj_quartel_marinha) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            var _hp_percent = (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max")) ? 
                (hp_atual / hp_max) : 1.0;
            
            ds_list_add(_alvos_criticos, {
                id: id,
                tipo: "quartel_naval",
                prioridade: 10,
                distancia: _dist,
                hp_percent: _hp_percent,
                valor: "critico"
            });
        }
    }
    
    with (obj_aeroporto_militar) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            var _hp_percent = (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max")) ? 
                (hp_atual / hp_max) : 1.0;
            
            ds_list_add(_alvos_criticos, {
                id: id,
                tipo: "aeroporto",
                prioridade: 10,
                distancia: _dist,
                hp_percent: _hp_percent,
                valor: "critico"
            });
        }
    }
    
    // === 2. PRIORIDADE ALTA: ESTRUTURAS ECONÔMICAS ===
    // Fazendas e minas (cortar recursos do jogador)
    with (obj_fazenda) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            ds_list_add(_alvos_importantes, {
                id: id,
                tipo: "fazenda",
                prioridade: 7,
                distancia: _dist,
                valor: "economico"
            });
        }
    }
    
    with (obj_mina) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            ds_list_add(_alvos_importantes, {
                id: id,
                tipo: "mina",
                prioridade: 7,
                distancia: _dist,
                valor: "economico"
            });
        }
    }
    
    // === 3. PRIORIDADE MÉDIA: UNIDADES DO JOGADOR ===
    var _tipos_unidades = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
    for (var i = 0; i < array_length(_tipos_unidades); i++) {
        if (!object_exists(_tipos_unidades[i])) continue;
        
        with (_tipos_unidades[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                var _hp_percent = 1.0;
                
                // Calcular HP percentual
                if (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max")) {
                    if (hp_max > 0) {
                        _hp_percent = hp_atual / hp_max;
                    }
                }
                
                // Priorizar unidades fracas (HP < 50%)
                if (_hp_percent < 0.5) {
                    ds_list_add(_alvos_fracos, {
                        id: id,
                        tipo: object_get_name(object_index),
                        prioridade: 6,
                        distancia: _dist,
                        hp_percent: _hp_percent,
                        valor: "facil_eliminar"
                    });
                } else {
                    ds_list_add(_alvos_unidades, {
                        id: id,
                        tipo: object_get_name(object_index),
                        prioridade: 5,
                        distancia: _dist,
                        hp_percent: _hp_percent,
                        valor: "unidade_normal"
                    });
                }
            }
        }
    }
    
    // === ORDENAR ALVOS POR PRIORIDADE E DISTÂNCIA ===
    var _alvos_finais = ds_list_create();
    
    // 1. Alvos críticos ordenados por distância
    for (var i = 0; i < ds_list_size(_alvos_criticos); i++) {
        var _alvo = ds_list_find_value(_alvos_criticos, i);
        if (instance_exists(_alvo.id)) {
            ds_list_add(_alvos_finais, _alvo);
        }
    }
    
    // 2. Alvos fracos (eliminar primeiro)
    for (var i = 0; i < ds_list_size(_alvos_fracos); i++) {
        var _alvo = ds_list_find_value(_alvos_fracos, i);
        if (instance_exists(_alvo.id)) {
            ds_list_add(_alvos_finais, _alvo);
        }
    }
    
    // 3. Alvos importantes (estruturas econômicas)
    for (var i = 0; i < ds_list_size(_alvos_importantes); i++) {
        var _alvo = ds_list_find_value(_alvos_importantes, i);
        if (instance_exists(_alvo.id)) {
            ds_list_add(_alvos_finais, _alvo);
        }
    }
    
    // 4. Unidades normais
    for (var i = 0; i < ds_list_size(_alvos_unidades); i++) {
        var _alvo = ds_list_find_value(_alvos_unidades, i);
        if (instance_exists(_alvo.id)) {
            ds_list_add(_alvos_finais, _alvo);
        }
    }
    
    // === DETERMINAR MELHOR ESTRATÉGIA ===
    var _estrategia = "ataque_direto"; // Padrão
    
    var _num_criticos = ds_list_size(_alvos_criticos);
    var _num_unidades_inimigas = ds_list_size(_alvos_unidades) + ds_list_size(_alvos_fracos);
    
    // Estratégia baseada na situação
    if (_num_criticos >= 2 && _num_unidades_inimigas >= 10) {
        _estrategia = "ataque_multi_frontal"; // Dividir tropas em grupos
    } else if (_num_criticos >= 1) {
        _estrategia = "foco_estruturas"; // Concentrar no quartel
    } else if (_num_unidades_inimigas >= 8) {
        _estrategia = "cerco"; // Cercar unidades
    } else if (_num_unidades_inimigas >= 5) {
        _estrategia = "emboscada"; // Emboscada tática
    }
    
    // Limpar listas temporárias
    ds_list_destroy(_alvos_criticos);
    ds_list_destroy(_alvos_importantes);
    ds_list_destroy(_alvos_unidades);
    ds_list_destroy(_alvos_fracos);
    
    return {
        alvos: _alvos_finais,
        estrategia: _estrategia,
        num_criticos: _num_criticos,
        num_unidades: _num_unidades_inimigas
    };
}
