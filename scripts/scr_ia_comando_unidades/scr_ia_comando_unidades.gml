// ===============================================
// HEGEMONIA GLOBAL - COMANDO DE UNIDADES
// Sistema para Garantir Que Unidades Recebem Ordens
// ===============================================

/// @function scr_ia_comando_unidade_criada(_unidade_id, _presidente_id)
/// @description Envia comando para unidade recém-criada
/// @param {id} _unidade_id - ID da unidade criada
/// @param {id} _presidente_id - ID do presidente (IA)

function scr_ia_comando_unidade_criada(_unidade_id, _presidente_id) {
    if (!instance_exists(_unidade_id)) return false;
    
    with (_presidente_id) {
        
        // === INICIALIZAR VARIÁVEIS DE MOVIMENTO SE NÃO EXISTIREM ===
        if (!variable_instance_exists(_unidade_id, "x_destino")) {
            _unidade_id.x_destino = _unidade_id.x;
        }
        if (!variable_instance_exists(_unidade_id, "y_destino")) {
            _unidade_id.y_destino = _unidade_id.y;
        }
        if (!variable_instance_exists(_unidade_id, "em_movimento")) {
            _unidade_id.em_movimento = false;
        }
        if (!variable_instance_exists(_unidade_id, "alvo")) {
            _unidade_id.alvo = noone;
        }
        if (!variable_instance_exists(_unidade_id, "nacao_proprietaria")) {
            _unidade_id.nacao_proprietaria = 2; // IA
        }
        
        // === VERIFICAR TIPO DE UNIDADE ===
        var _tipo_unidade = _unidade_id.object_index;
        
        // === ESTRATÉGIA 1: Unidades de Ataque (Aviões, Tanques) ===
        if (_tipo_unidade == obj_f15 || _tipo_unidade == obj_f6 || 
            _tipo_unidade == obj_tanque || _tipo_unidade == obj_helicoptero_militar) {
            
            // Procurar alvo para atacar
            var _alvo = scr_ia_encontrar_alvo_prioritario();
            if (_alvo != noone) {
                _unidade_id.alvo = _alvo;
                _unidade_id.x_destino = _alvo.x;
                _unidade_id.y_destino = _alvo.y;
                _unidade_id.em_movimento = true;
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🎯 Unidade de Ataque criada: enviada para alvo em (" + 
                                     string(round(_alvo.x)) + ", " + string(round(_alvo.y)) + ")");
                }
                return true;
            } else {
                // Sem alvo, ir para ponto de defesa perto da base
                _unidade_id.x_destino = base_x + random(-400, 400);
                _unidade_id.y_destino = base_y + random(-400, 400);
                _unidade_id.em_movimento = true;
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🛡️ Unidade de Ataque criada: sem alvo, posicionada em defesa");
                }
                return true;
            }
        }
        
        // === ESTRATÉGIA 2: Unidades de Defesa (Defesa Aérea) ===
        else if (_tipo_unidade == obj_blindado_antiaereo || _tipo_unidade == obj_soldado_antiaereo) {
            // Posicionar em ponto estratégico perto da base
            _unidade_id.x_destino = base_x + random(-600, 600);
            _unidade_id.y_destino = base_y + random(-600, 600);
            _unidade_id.em_movimento = true;
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("🛡️ Unidade de Defesa criada: posicionada perto da base");
            }
            return true;
        }
        
        // === ESTRATÉGIA 3: Unidades Navais ===
        else if (_tipo_unidade == obj_lancha_patrulha || _tipo_unidade == obj_submarino_base ||
                 _tipo_unidade == obj_RonaldReagan || _tipo_unidade == obj_Independence ||
                 _tipo_unidade == obj_Constellation) {
            
            // Se tem posições de costa definidas, ir para lá
            if (variable_instance_exists(id, "posicoes_costa") && ds_list_size(posicoes_costa) > 0) {
                var _pos_costa = posicoes_costa[| irandom(ds_list_size(posicoes_costa) - 1)];
                _unidade_id.x_destino = _pos_costa[0];
                _unidade_id.y_destino = _pos_costa[1];
                _unidade_id.em_movimento = true;
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("⚓ Unidade Naval criada: enviada para costa");
                }
                return true;
            } else {
                // Sem costa definida, ir para posição aleatória
                _unidade_id.x_destino = base_x + random(-1000, 1000);
                _unidade_id.y_destino = base_y + random(-1000, 1000);
                _unidade_id.em_movimento = true;
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("⚓ Unidade Naval criada: posição aleatória");
                }
                return true;
            }
        }
        
        // === ESTRATÉGIA 4: Infantaria (Padrão) ===
        else {
            _unidade_id.x_destino = base_x + random(-400, 400);
            _unidade_id.y_destino = base_y + random(-400, 400);
            _unidade_id.em_movimento = true;
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("👷 Infantaria criada: posicionada perto da base");
            }
            return true;
        }
    }
}

/// @function scr_ia_processar_ataques_coordenados(_presidente_id)
/// @description Processa ataques coordenados em andamento
/// @param {id} _presidente_id - ID do presidente

function scr_ia_processar_ataques_coordenados(_presidente_id) {
    with (_presidente_id) {
        
        // Verificar se há ataque coordenado em andamento
        if (!variable_instance_exists(id, "timer_ataque_coordenado")) {
            timer_ataque_coordenado = 0;
        }
        
        if (timer_ataque_coordenado > 0) {
            // Executar ataque coordenado
            scr_ia_executar_ataque_coordenado(id);
        }
    }
}

/// @function scr_ia_reposicionar_unidades_orphas(_presidente_id)
/// @description Reposiciona unidades da IA que estão sem comando
/// @param {id} _presidente_id - ID do presidente

function scr_ia_reposicionar_unidades_orphas(_presidente_id) {
    with (_presidente_id) {
        
        // === REPOSICIONAR AVIÕES SEM COMANDO ===
        with (obj_f15) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                    // Aviões parados → procurar alvo ou ir para defesa
                    var _alvo = scr_ia_encontrar_alvo_prioritario();
                    if (_alvo != noone) {
                        alvo = _alvo;
                        x_destino = _alvo.x;
                        y_destino = _alvo.y;
                        em_movimento = true;
                    }
                }
            }
        }
        
        // === REPOSICIONAR TANQUES SEM COMANDO ===
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                    var _alvo = scr_ia_encontrar_alvo_prioritario();
                    if (_alvo != noone) {
                        alvo = _alvo;
                        x_destino = _alvo.x;
                        y_destino = _alvo.y;
                        em_movimento = true;
                    }
                }
            }
        }
        
        // === REPOSICIONAR DEFESA AÉREA SEM COMANDO ===
        with (obj_blindado_antiaereo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                if (!variable_instance_exists(id, "x_destino")) {
                    x_destino = x;
                }
                if (!variable_instance_exists(id, "y_destino")) {
                    y_destino = y;
                }
                // Manter posição defensiva perto da base
            }
        }
    }
}

/// @function scr_ia_verificar_unidades_bloqueadas(_presidente_id)
/// @description Verifica se unidades estão travadas/bloqueadas
/// @param {id} _presidente_id - ID do presidente

function scr_ia_verificar_unidades_bloqueadas(_presidente_id) {
    with (_presidente_id) {
        
        var _unidades_bloqueadas = 0;
        
        // === VERIFICAR TANQUES BLOQUEADOS ===
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                if (variable_instance_exists(id, "x") && variable_instance_exists(id, "y") &&
                    variable_instance_exists(id, "x_destino") && variable_instance_exists(id, "y_destino")) {
                    
                    var _dist = point_distance(x, y, x_destino, y_destino);
                    
                    // Se está muito perto do destino mas ainda com ordem de movimento
                    if (_dist < 50 && variable_instance_exists(id, "em_movimento") && em_movimento) {
                        // ✅ CORREÇÃO: Usar random_range() em vez de random() com dois argumentos
                        // Pode estar bloqueado por colisão - tentar se desviar
                        x = x + random_range(-30, 30);
                        y = y + random_range(-30, 30);
                    }
                }
            }
        }
    }
}

// ✅ FUNÇÃO REMOVIDA: scr_ia_encontrar_alvo_prioritario() agora está centralizada em scr_ia_detectar_alvos_estrategicos.gml
// Esta função foi removida para evitar duplicação. Use scr_ia_encontrar_alvo_prioritario() de scr_ia_detectar_alvos_estrategicos.gml

