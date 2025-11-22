/// @description Comandante Tático - Obriga unidades paradas a atacar constantemente.
/// @param {instance} _presidente_id ID da instância do presidente IA
/// Este script NÃO constrói nada. Ele pega as unidades que já existem e *obriga* elas a atacar.
/// Resolve o problema de "ficar esperando" - transforma a IA em um General de Guerra Agressivo.

function scr_ia_comandante_agressivo(_presidente_id) {
    // Executa essa lógica a cada 60 frames (1 segundo) para não pesar
    if (!variable_global_exists("game_frame")) {
        return;
    }
    if (global.game_frame % 60 != 0) return;
    
    var _presidente = _presidente_id;
    if (!instance_exists(_presidente)) return;
    
    // Encontrar alvo principal usando o script existente que funciona corretamente
    var _raio_busca = 5000; // Buscar em um raio grande
    if (variable_instance_exists(_presidente, "raio_expansao")) {
        _raio_busca = _presidente.raio_expansao;
    }
    
    var alvo_principal = scr_buscar_inimigo(_presidente.x, _presidente.y, _raio_busca, _presidente.nacao_proprietaria);
    
    if (!instance_exists(alvo_principal)) {
        // Sem alvos, não fazer nada
        return;
    }
    
    // Listas para organizar o exército
    var unidades_ociosas = ds_list_create();
    var transportes_disponiveis = ds_list_create();
    
    // 1. RECENSEAMENTO MILITAR - Varre todas as unidades da IA
    // Buscar por tipos específicos de unidades (não há objeto pai único)
    var _tipos_unidades = [
        obj_infantaria,
        obj_tanque,
        obj_blindado_antiaereo,
        obj_soldado_antiaereo,
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f15,
        obj_f6,
        obj_su35,
        obj_c100,
        obj_lancha_patrulha,
        obj_RonaldReagan,
        obj_Constellation,
        obj_Independence,
        obj_navio_transporte,
        obj_wwhendrick,
        obj_submarino_base,
        obj_navio_base
    ];
    
    // Verificar se obj_M1A_Abrams existe
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        array_push(_tipos_unidades, _obj_abrams);
    }
    
    // Verificar se obj_destroyer existe
    var _obj_destroyer = asset_get_index("obj_destroyer");
    if (_obj_destroyer != -1 && asset_get_type(_obj_destroyer) == asset_object) {
        array_push(_tipos_unidades, _obj_destroyer);
    }
    
    // Verificar se obj_fragata existe
    var _obj_fragata = asset_get_index("obj_fragata");
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
        array_push(_tipos_unidades, _obj_fragata);
    }
    
    // Buscar unidades da IA em todos os tipos
    for (var _tipo_idx = 0; _tipo_idx < array_length(_tipos_unidades); _tipo_idx++) {
        var _tipo_unidade = _tipos_unidades[_tipo_idx];
        if (!object_exists(_tipo_unidade)) continue;
        
        with (_tipo_unidade) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _presidente.nacao_proprietaria) {
            
            // Se for transporte e tiver espaço
            if (variable_instance_exists(id, "espaco_livre") && espaco_livre > 0) {
                // Verificar se é transporte aéreo ou naval
                if (object_index == obj_c100 || object_index == obj_navio_transporte) {
                    ds_list_add(transportes_disponiveis, id);
                }
            }
            
            // Se for unidade de combate e estiver PARADA
            var _esta_parada = false;
            
            // Verificar diferentes sistemas de estado
            if (variable_instance_exists(id, "estado")) {
                // Sistema de estados naval (LanchaState)
                if (estado == LanchaState.PARADO) {
                    _esta_parada = true;
                }
                // Sistema de estados string
                else if (variable_instance_exists(id, "estado_string") && estado_string == "parado") {
                    _esta_parada = true;
                }
            }
            // Sistema antigo de estados
            else if (variable_instance_exists(id, "state") && (state == "idle" || state == "guard" || state == "parado")) {
                _esta_parada = true;
            }
            // Verificar se não está se movendo (velocidade muito baixa)
            else if (variable_instance_exists(id, "speed") && speed < 0.1) {
                _esta_parada = true;
            }
            
            if (_esta_parada && !ds_list_find_index(transportes_disponiveis, id) >= 0) {
                ds_list_add(unidades_ociosas, id);
            }
            }
        }
    }
    
    // 2. LÓGICA DE ATAQUE GLOBAL - Forçar todas as unidades ociosas a atacar
    for (var i = 0; i < ds_list_size(unidades_ociosas); i++) {
        var unidade = unidades_ociosas[| i];
        if (!instance_exists(unidade)) continue;
        
        var dist_alvo = point_distance(unidade.x, unidade.y, alvo_principal.x, alvo_principal.y);
        
        // A. SE FOR AVIÃO OU NAVIO: ATAQUE DIRETO
        // Eles não ligam para terreno, então mande atacar sempre.
        var _tipo_unidade_local = "";
        if (variable_instance_exists(unidade, "tipo")) {
            _tipo_unidade_local = unidade.tipo;
        } else {
            // Detectar tipo pelo objeto
            if (object_is_ancestor(unidade.object_index, obj_navio_base)) {
                _tipo_unidade_local = "naval";
            } else if (object_is_ancestor(unidade.object_index, obj_caca_f5) || object_is_ancestor(unidade.object_index, obj_helicoptero_militar)) {
                _tipo_unidade_local = "aereo";
            }
        }
        
        if (_tipo_unidade_local == "aereo" || _tipo_unidade_local == "naval") {
            // Sistema novo (LanchaState)
            if (variable_instance_exists(unidade, "estado")) {
                unidade.estado = LanchaState.MOVENDO;
                if (variable_instance_exists(unidade, "estado_string")) {
                    unidade.estado_string = "movendo";
                }
            }
            // Sistema antigo
            else if (variable_instance_exists(unidade, "state")) {
                unidade.state = "attack_move";
            }
            
            // Definir destino com pequeno espalhamento para não ficarem todos juntos
            var _target_x = alvo_principal.x + irandom_range(-200, 200);
            var _target_y = alvo_principal.y + irandom_range(-200, 200);
            
            if (variable_instance_exists(unidade, "target_x")) {
                unidade.target_x = _target_x;
                unidade.target_y = _target_y;
            }
            if (variable_instance_exists(unidade, "destino_x")) {
                unidade.destino_x = _target_x;
                unidade.destino_y = _target_y;
            }
            if (variable_instance_exists(unidade, "is_moving")) {
                unidade.is_moving = true;
            }
            if (variable_instance_exists(unidade, "usar_novo_sistema")) {
                unidade.usar_novo_sistema = true;
            }
            
            continue;
        }
        
        // B. SE FOR TERRESTRE: VERIFICAR ACESSO E USAR TRANSPORTE SE NECESSÁRIO
        // Aqui está o segredo para ele "vir até você" em ilhas.
        
        var caminho_possivel = true; 
        if (dist_alvo > 2500) caminho_possivel = false; // Longe demais precisa de transporte
        
        if (caminho_possivel) {
            // ATAQUE NORMAL - Pode chegar a pé
            if (variable_instance_exists(unidade, "estado")) {
                unidade.estado = LanchaState.MOVENDO;
                if (variable_instance_exists(unidade, "estado_string")) {
                    unidade.estado_string = "movendo";
                }
            } else if (variable_instance_exists(unidade, "state")) {
                unidade.state = "attack_move";
            }
            
            if (variable_instance_exists(unidade, "target_x")) {
                unidade.target_x = alvo_principal.x;
                unidade.target_y = alvo_principal.y;
            }
            if (variable_instance_exists(unidade, "destino_x")) {
                unidade.destino_x = alvo_principal.x;
                unidade.destino_y = alvo_principal.y;
            }
            if (variable_instance_exists(unidade, "is_moving")) {
                unidade.is_moving = true;
            }
        } else {
            // MODO INVASÃO (Precisa de Transporte)
            if (ds_list_size(transportes_disponiveis) > 0) {
                var transporte = transportes_disponiveis[| 0]; // Pega o primeiro disponível
                
                if (instance_exists(transporte)) {
                    // Ordem: Mover em direção ao transporte
                    if (variable_instance_exists(unidade, "target_x")) {
                        unidade.target_x = transporte.x;
                        unidade.target_y = transporte.y;
                    }
                    if (variable_instance_exists(unidade, "destino_x")) {
                        unidade.destino_x = transporte.x;
                        unidade.destino_y = transporte.y;
                    }
                    if (variable_instance_exists(unidade, "estado")) {
                        unidade.estado = LanchaState.MOVENDO;
                    }
                    
                    // Lógica do Transporte: Se encheu, vai pro ataque
                    if (variable_instance_exists(transporte, "espaco_livre") && transporte.espaco_livre <= 2) {
                        // Transporte quase cheio - mandar para o ataque
                        if (variable_instance_exists(transporte, "estado")) {
                            transporte.estado = LanchaState.MOVENDO;
                        }
                        if (variable_instance_exists(transporte, "target_x")) {
                            transporte.target_x = alvo_principal.x;
                            transporte.target_y = alvo_principal.y;
                        }
                        if (variable_instance_exists(transporte, "destino_x")) {
                            transporte.destino_x = alvo_principal.x;
                            transporte.destino_y = alvo_principal.y;
                        }
                        ds_list_delete(transportes_disponiveis, 0); // Tira da lista pra não lotar mais
                    }
                }
            } else {
                // Sem transporte? Avance na direção do alvo mesmo assim (pode encontrar transporte no caminho)
                if (variable_instance_exists(unidade, "estado")) {
                    unidade.estado = LanchaState.MOVENDO;
                }
                if (variable_instance_exists(unidade, "target_x")) {
                    unidade.target_x = alvo_principal.x;
                    unidade.target_y = alvo_principal.y;
                }
            }
        }
    }
    
    ds_list_destroy(unidades_ociosas);
    ds_list_destroy(transportes_disponiveis);
}
