/// @description Step Event 1 - Sistema de Combate PARADO
// ===============================================
// HEGEMONIA GLOBAL - RONALD REAGAN (PORTA-AVIÕES)
// Sistema de combate: Fica PARADO atirando, só persegue se inimigo sair do alcance
// ===============================================

// === SISTEMA DE COMBATE INTELIGENTE ===
// NÃO ATACAR SE ESTIVER EMBARCANDO
if (variable_instance_exists(id, "estado_embarque") && estado_embarque == "embarcando") {
    // Durante embarque, não atacar
    if (variable_instance_exists(id, "estado") && estado == LanchaState.ATACANDO) {
        if (variable_instance_exists(id, "estado_anterior")) {
            estado = estado_anterior;
        }
    }
} else if ((variable_instance_exists(id, "modo_combate") && modo_combate == LanchaMode.ATAQUE) || 
           (variable_instance_exists(id, "estado") && estado == LanchaState.ATACANDO)) {
    
    // Inicializar arrays de inimigos (NÃO usar var - precisa ser variável de instância)
    if (!variable_instance_exists(id, "_inimigos_navais")) var _inimigos_navais = [];
    if (!variable_instance_exists(id, "_inimigos_aereos")) var _inimigos_aereos = [];
    if (!variable_instance_exists(id, "_inimigos_terrestres")) var _inimigos_terrestres = [];
    
    // Limpar arrays a cada step (usar variáveis locais)
    var _inimigos_navais = [];
    var _inimigos_aereos = [];
    var _inimigos_terrestres = [];
    
    // PROCURAR TODOS OS INIMIGOS DENTRO DO RAIO
    // Navios inimigos
    with (obj_navio_base) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(other._inimigos_navais, id);
            }
        }
    }
    
    // Helicópteros inimigos
    with (obj_helicoptero_militar) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(other._inimigos_aereos, id);
            }
        }
    }
    
    // Caças inimigos
    with (obj_caca_f5) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(other._inimigos_aereos, id);
            }
        }
    }
    
    with (obj_f6) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(other._inimigos_aereos, id);
            }
        }
    }
    
    // Unidades terrestres inimigas
    with (obj_infantaria) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(other._inimigos_terrestres, id);
            }
        }
    }
    
    with (obj_inimigo) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(other._inimigos_terrestres, id);
            }
        }
    }
    
    var _total_alvos = array_length(_inimigos_navais) + array_length(_inimigos_aereos) + array_length(_inimigos_terrestres);
    
    if (_total_alvos > 0) {
        estado = LanchaState.ATACANDO;
        
        // === LÓGICA: FICAR PARADO ATIRANDO ===
        // Juntar todos os inimigos em uma lista
        var _todos_inimigos = [];
        for (var i = 0; i < array_length(_inimigos_navais); i++) {
            array_push(_todos_inimigos, _inimigos_navais[i]);
        }
        for (var i = 0; i < array_length(_inimigos_aereos); i++) {
            array_push(_todos_inimigos, _inimigos_aereos[i]);
        }
        for (var i = 0; i < array_length(_inimigos_terrestres); i++) {
            array_push(_todos_inimigos, _inimigos_terrestres[i]);
        }
        
        // Verificar o inimigo mais próximo
        var _inimigo_mais_proximo = noone;
        var _distancia_minima = 999999;
        
        for (var i = 0; i < array_length(_todos_inimigos); i++) {
            var _inimigo = _todos_inimigos[i];
            if (instance_exists(_inimigo)) {
                var _dist = point_distance(x, y, _inimigo.x, _inimigo.y);
                if (_dist < _distancia_minima) {
                    _distancia_minima = _dist;
                    _inimigo_mais_proximo = _inimigo;
                }
            }
        }
        
        // === DECISÃO: FICAR PARADO OU PERSEGUIR ===
        if (instance_exists(_inimigo_mais_proximo)) {
            var _distancia_inimigo = _distancia_minima;
            
            if (_distancia_inimigo > missil_max_alcance) {
                // Inimigo saiu do alcance - PERSEGUIR
                destino_x = _inimigo_mais_proximo.x;
                destino_y = _inimigo_mais_proximo.y;
                estado = LanchaState.ATACANDO;
                
                show_debug_message("🚢 Porta-Aviões: Inimigo fora do alcance! Perseguindo...");
            } else if (_distancia_inimigo > 0) {
                // === FICAR PARADO ATIRANDO ===
                // CANCELAR movimento - manter posição atual
                destino_x = x;
                destino_y = y;
                
                // Atirar mísseis em alvos aéreos
                var _num_alvos_aereos = array_length(_inimigos_aereos);
                if (_num_alvos_aereos > 0 && missil_timer <= 0) {
                    var _misseis_disparados = 0;
                    var _max_misseis_por_frame = 2;
                    
                    for (var i = 0; i < _num_alvos_aereos && _misseis_disparados < _max_misseis_por_frame; i++) {
                        var _alvo_aereo = _inimigos_aereos[i];
                        
                        if (instance_exists(_alvo_aereo)) {
                            var _missil = instance_create_layer(x, y, "Instances", obj_SkyFury_ar);
                            if (instance_exists(_missil)) {
                                _missil.target = _alvo_aereo;
                                _missil.dono = id;
                                _missil.direction = point_direction(x, y, _alvo_aereo.x, _alvo_aereo.y);
                                
                                _misseis_disparados++;
                            }
                        }
                    }
                    
                    if (_misseis_disparados > 0) {
                        missil_timer = missil_cooldown;
                        show_debug_message("🚀 Porta-Aviões disparou " + string(_misseis_disparados) + " SkyFury");
                    }
                }
                
                // Atirar mísseis em alvos terrestres/navais
                var _num_alvos_terrestres_navais = array_length(_inimigos_terrestres) + array_length(_inimigos_navais);
                if (_num_alvos_terrestres_navais > 0 && missil_timer <= 0) {
                    var _misseis_disparados = 0;
                    var _max_misseis_por_frame = 2;
                    
                    var _todos_terrestres_navais = [];
                    for (var i = 0; i < array_length(_inimigos_terrestres); i++) {
                        array_push(_todos_terrestres_navais, _inimigos_terrestres[i]);
                    }
                    for (var i = 0; i < array_length(_inimigos_navais); i++) {
                        array_push(_todos_terrestres_navais, _inimigos_navais[i]);
                    }
                    
                    for (var i = 0; i < _num_alvos_terrestres_navais && _misseis_disparados < _max_misseis_por_frame; i++) {
                        var _alvo = _todos_terrestres_navais[i];
                        
                        if (instance_exists(_alvo)) {
                            var _missil = instance_create_layer(x, y, "Instances", obj_Ironclad_terra);
                            if (instance_exists(_missil)) {
                                _missil.target = _alvo;
                                _missil.dono = id;
                                _missil.direction = point_direction(x, y, _alvo.x, _alvo.y);
                                
                                _misseis_disparados++;
                            }
                        }
                    }
                    
                    if (_misseis_disparados > 0) {
                        missil_timer = missil_cooldown;
                        show_debug_message("🚀 Porta-Aviões disparou " + string(_misseis_disparados) + " Ironclad");
                    }
                }
            }
        }
    } else {
        // Sem inimigos - voltar ao estado anterior
        if (estado == LanchaState.ATACANDO) {
            estado = estado_anterior;
        }
    }
}

// Decrementar timer de mísseis
if (missil_timer > 0) {
    missil_timer--;
}

// === SISTEMA DE ESTADOS DE EMBARQUE (TECLA P) ===
if (variable_instance_exists(id, "selecionado") && selecionado) {
    if (keyboard_check_pressed(ord("P"))) {
        var _estado_atual = variable_instance_exists(id, "estado_embarque") ? estado_embarque : "navegando";
        
        if (_estado_atual == "navegando") {
            // NAVEGANDO → EMBARCANDO
            if (!variable_instance_exists(id, "estado_embarque")) { estado_embarque = "navegando"; }
            estado_embarque = "embarcando";
            // ✅ NAVIO CONTINUA NAVEGANDO normalmente (sem forçar parar)
            show_debug_message("🟢 Porta-Aviões: PORTAS ABERTAS - Aceitando embarque (Pressione P novamente para fechar)");
        } else if (_estado_atual == "embarcando") {
            // EMBARCANDO → EMBARCADO
            if (!variable_instance_exists(id, "estado_embarque")) { estado_embarque = "navegando"; }
            estado_embarque = "embarcado";
            show_debug_message("🔴 Porta-Aviões: PORTAS FECHADAS - Navegando");
        } else if (_estado_atual == "embarcado") {
            // EMBARCADO → NAVEGANDO (se sem unidades) ou EMBARCANDO
            var _total = avioes_count + unidades_count + soldados_count;
            if (!variable_instance_exists(id, "estado_embarque")) { estado_embarque = "navegando"; }
            
            if (_total > 0) {
                estado_embarque = "embarcando";
                // ✅ NAVIO CONTINUA NAVEGANDO normalmente (sem forçar parar)
                show_debug_message("🟢 Porta-Aviões: PORTAS ABERTAS - Desembarcar unidades");
            } else {
                estado_embarque = "navegando";
                show_debug_message("⚪ Porta-Aviões: Vazio - Volta a navegar normalmente");
            }
        }
    }
}

// === PROCESSO DE EMBARQUE POR ORDEM DE CLIQUE ===
var _embarcando_ativo = variable_instance_exists(id, "estado_embarque") && estado_embarque == "embarcando";
if (_embarcando_ativo) {
    // Verificar unidades próximas
    with (all) {
        // Verificar se é embarcável
        if (other.eh_embarcavel(id) && 
            instance_exists(id) && 
            id != other.id) {
            
            var _dist = point_distance(other.x, other.y, id.x, id.y);
            
            // ✅ SE ESTÁ MUITO PERTO (20px), EMBARCAR IMEDIATAMENTE
            if (_dist <= 20) {
                // ✅ Verificar se está vindo para embarcar (flag TRUE)
                var _vindo_para_embarcar = false;
                
                // Verificar flag de embarque
                if (variable_instance_exists(id, "indo_embarcar")) {
                    if (id.indo_embarcar == true) {
                        _vindo_para_embarcar = true;
                    }
                }
                
                // ✅ SE ESTÁ VINDO PARA EMBARCAR, EMBARCAR
                if (_vindo_para_embarcar) {
                    // Mostrar feedback visual
                    draw_set_halign(fa_center);
                    draw_set_color(c_lime);
                    draw_text(id.x, id.y - 25, "EMBARCANDO...");
                    
                    // Forçar parada completa
                    if (variable_instance_exists(id, "velocidade_atual")) {
                        id.velocidade_atual = 0;
                    }
                    if (variable_instance_exists(id, "destino_x")) {
                        id.destino_x = id.x;
                        id.destino_y = id.y;
                    }
                    
                    // ✅ EMBARCAR IMEDIATAMENTE
                    // ✅ CORREÇÃO GM1041: Verificar se é um objeto válido antes de usar object_get_name
                    var _nome_obj = noone;
                    if (instance_exists(id)) {
                        _nome_obj = object_get_name(id.object_index);
                    }
                    if (other.embarcar_unidade(id)) {
                        show_debug_message("✅ " + string(_nome_obj) + " embarcou no Porta-Aviões!");
                        
                        // Limpar flag
                        id.indo_embarcar = false;
                    }
                }
            }
            // Se está no raio de detecção maior, mostrar feedback
            else if (_dist <= 100) {
                // ✅ Verificar flag de embarque para mostrar feedback
                if (variable_instance_exists(id, "indo_embarcar") && id.indo_embarcar == true) {
                    // Mostrar feedback visual
                    draw_set_halign(fa_center);
                    draw_set_color(c_yellow);
                    draw_text(id.x, id.y - 25, "APROXIMANDO...");
                    draw_text(id.x, id.y - 40, string(round(_dist)) + "px");
                }
            }
        }
    }
}

// === MANTER AVIÕES VISÍVEIS NA POSIÇÃO CORRETA ===
for (var i = 0; i < ds_list_size(avioes_visiveis); i++) {
    var _aviao_id = avioes_visiveis[| i];
    
    if (instance_exists(_aviao_id)) {
        // Posicionar sobre o navio
        _aviao_id.x = x;
        _aviao_id.y = y - 80 + (i * 8);
        
        // Seguir rotação do navio
        _aviao_id.image_angle = image_angle;
        
        // Desabilitar movimento
        if (variable_instance_exists(_aviao_id, "velocidade_atual")) {
            _aviao_id.velocidade_atual = 0;
        }
        if (variable_instance_exists(_aviao_id, "velocidade_maxima")) {
            _aviao_id.velocidade_maxima = 0;
        }
    }
}

// === PROCESSAR DESEMBARQUE AUTOMÁTICO ===
if (desembarque_ativo && ds_queue_size(desembarque_fila) > 0) {
    desembarque_timer++;
    
    if (desembarque_timer >= desembarque_intervalo) {
        // Desembarcar próxima unidade
        var _unidade_id = ds_queue_dequeue(desembarque_fila);
        
        if (instance_exists(_unidade_id)) {
            // Calcular posição de desembarque (à frente do navio)
            var _dir_desembarque = image_angle + 90; // Perpendicular
            var _dist_desembarque = 120;
            
            var _x_novo = x + lengthdir_x(_dist_desembarque, _dir_desembarque);
            var _y_novo = y + lengthdir_y(_dist_desembarque, _dir_desembarque);
            
            _unidade_id.x = _x_novo;
            _unidade_id.y = _y_novo;
            
            // Se for avião, lançar para frente
            if (object_is_ancestor(_unidade_id.object_index, obj_caca_f5) || 
                object_is_ancestor(_unidade_id.object_index, obj_f6)) {
                _unidade_id.direction = image_angle;
                _unidade_id.estado = "decolando";
            }
            
            // Decrementar contadores
            if (object_is_ancestor(_unidade_id.object_index, obj_caca_f5) || 
                object_is_ancestor(_unidade_id.object_index, obj_f6)) {
                avioes_count--;
            } else if (object_is_ancestor(_unidade_id.object_index, obj_infantaria) ||
                      object_is_ancestor(_unidade_id.object_index, obj_inimigo) ||
                      object_is_ancestor(_unidade_id.object_index, obj_tanque)) {
                unidades_count--;
            } else if (object_is_ancestor(_unidade_id.object_index, obj_soldado_antiaereo)) {
                soldados_count--;
            }
            
            desembarque_timer = 0;
        }
    }
}

// === EXIBIR DEBUG PERIÓDICO ===
debug_timer++;
if (debug_timer >= 120) { // A cada 2 segundos
    debug_timer = 0;
    
    var _avioes = variable_instance_exists(id, "avioes_count") ? avioes_count : 0;
    var _unidades = variable_instance_exists(id, "unidades_count") ? unidades_count : 0;
    var _soldados = variable_instance_exists(id, "soldados_count") ? soldados_count : 0;
    var _total_unidades = _avioes + _unidades + _soldados;
    
    if (_total_unidades > 0) {
        show_debug_message("🚢 Porta-Aviões: " + string(_total_unidades) + " unidades armazenadas (A:" + string(_avioes) + "/U:" + string(_unidades) + "/S:" + string(_soldados) + ")");
    }
}

// Chamar Step do pai (herda lógica de movimento, ataque, etc)
// ✅ CORREÇÃO GM2040: Verificar se o objeto tem parent antes de chamar event_inherited
if (variable_instance_exists(id, "parent") || object_index != -1) {
    event_inherited();
}
