// ===============================================
// HEGEMONIA GLOBAL - NAVIO PIRATA TIPO 2 (Step)
// Sistema de Patrulha Circular, Esquadrão e Ataque
// ===============================================

// Herdar lógica básica de navegação
event_inherited();

// === 1. VINCULAÇÃO AUTOMÁTICA AOS PILARES (APENAS UMA VEZ) ===
if (!vinculado) {
    var _script_vincular = asset_get_index("scr_vincular_pirata_pilares");
    if (_script_vincular != -1) {
        scr_vincular_pirata_pilares(id, 1000);
    }
    vinculado = true;
    
    // ✅ NOVO: Identificar qual navio é o líder do esquadrão
    if (!variable_instance_exists(id, "eh_lider")) {
        eh_lider = false;
        var _outros_piratas = [];
        with (obj_navio_pirata) {
            if (id != other.id) {
                array_push(_outros_piratas, id);
            }
        }
        with (obj_navio_pirata2) {
            if (id != other.id) {
                array_push(_outros_piratas, id);
            }
        }
        with (obj_navio_pirata3) {
            if (id != other.id) {
                array_push(_outros_piratas, id);
            }
        }
        
        if (array_length(_outros_piratas) == 0 || point_distance(0, 0, x, y) < point_distance(0, 0, _outros_piratas[0].x, _outros_piratas[0].y)) {
            eh_lider = true;
            show_debug_message("🏴‍☠️ Navio Pirata Tipo 2 é o LÍDER do esquadrão");
        }
    }
}

// === 2. SISTEMA DE FORMAÇÃO EM ESQUADRÃO ===
if (!eh_lider) {
    var _lider = noone;
    var _menor_dist = 9999;
    
    with (obj_navio_pirata) {
        if (other.id != id && variable_instance_exists(id, "eh_lider") && eh_lider) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist < _menor_dist) {
                _menor_dist = _dist;
                _lider = id;
            }
        }
    }
    with (obj_navio_pirata2) {
        if (other.id != id && variable_instance_exists(id, "eh_lider") && eh_lider) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist < _menor_dist) {
                _menor_dist = _dist;
                _lider = id;
            }
        }
    }
    with (obj_navio_pirata3) {
        if (other.id != id && variable_instance_exists(id, "eh_lider") && eh_lider) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist < _menor_dist) {
                _menor_dist = _dist;
                _lider = id;
            }
        }
    }
    
    if (instance_exists(_lider)) {
        var _offset_angulo = 120;  // ✅ Tipo 2: 120 graus à direita
        var _distancia_formacao = 200;  // ✅ AUMENTADO: Era 80, agora 200px
        var _script_formacao = asset_get_index("scr_formacao_esquadrao_pirata");
        if (_script_formacao != -1) {
            var _pos_formacao = scr_formacao_esquadrao_pirata(_lider, id, _offset_angulo, _distancia_formacao);
            
            // ✅ CORREÇÃO: Verificar distância mínima para evitar colisão
            var _dist_lider = point_distance(x, y, _lider.x, _lider.y);
            if (_dist_lider < 150) {
                var _dir_afastar = point_direction(_lider.x, _lider.y, x, y);
                _pos_formacao[0] = x + lengthdir_x(50, _dir_afastar);
                _pos_formacao[1] = y + lengthdir_y(50, _dir_afastar);
            }
            
            if (!modo_cacando) {
                destino_x = _pos_formacao[0];
                destino_y = _pos_formacao[1];
                target_x = _pos_formacao[0];
                target_y = _pos_formacao[1];
                estado = LanchaState.MOVENDO;
                is_moving = true;
                usar_novo_sistema = true;
            }
        }
    }
}

// === 3. SISTEMA DE PATRULHA CIRCULAR ===
// ✅ CORREÇÃO: Garantir movimento contínuo
if (!modo_cacando) {
    if (ds_list_size(pilares_patrulha) > 0) {
        var _pilar_atual = pilares_patrulha[| indice_pilar_atual];
        
        if (instance_exists(_pilar_atual)) {
            var _dist_pilar = point_distance(x, y, _pilar_atual.x, _pilar_atual.y);
            var _raio_patrulha = 150;
            
            if (!variable_instance_exists(id, "angulo_patrulha")) {
                angulo_patrulha = 0;
            }
            if (!variable_instance_exists(id, "tempo_patrulha_pilar")) {
                tempo_patrulha_pilar = 300;  // ✅ REDUZIDO: 5 segundos
            }
            if (!variable_instance_exists(id, "timer_patrulha_pilar")) {
                timer_patrulha_pilar = tempo_patrulha_pilar;
            }
            
            if (_dist_pilar <= _raio_patrulha + 50 && eh_lider) {
                angulo_patrulha += 1;  // ✅ REDUZIDO: Rotação de 1 grau por frame (mais suave, era 3)
                if (angulo_patrulha >= 360) angulo_patrulha = 0;
                
                var _x_circulo = _pilar_atual.x + lengthdir_x(_raio_patrulha, angulo_patrulha);
                var _y_circulo = _pilar_atual.y + lengthdir_y(_raio_patrulha, angulo_patrulha);
                
                destino_x = _x_circulo;
                destino_y = _y_circulo;
                target_x = _x_circulo;
                target_y = _y_circulo;
                estado = LanchaState.MOVENDO;
                is_moving = true;
                usar_novo_sistema = true;
                
                timer_patrulha_pilar--;
                if (timer_patrulha_pilar <= 0) {
                    indice_pilar_atual = (indice_pilar_atual + 1) % ds_list_size(pilares_patrulha);
                    timer_patrulha_pilar = tempo_patrulha_pilar;
                    angulo_patrulha = 0;
                }
            } else {
                // ✅ CORREÇÃO: Sempre navegar para o pilar
                destino_x = _pilar_atual.x;
                destino_y = _pilar_atual.y;
                target_x = _pilar_atual.x;
                target_y = _pilar_atual.y;
                estado = LanchaState.MOVENDO;
                is_moving = true;
                usar_novo_sistema = true;
            }
        } else {
            ds_list_delete(pilares_patrulha, indice_pilar_atual);
            if (ds_list_size(pilares_patrulha) == 0) {
                // ✅ CORREÇÃO: Sem pilares, criar movimento imediatamente
                var _novo_x = x + random_range(-400, 400);
                var _novo_y = y + random_range(-400, 400);
                destino_x = _novo_x;
                destino_y = _novo_y;
                target_x = _novo_x;
                target_y = _novo_y;
                estado = LanchaState.MOVENDO;
                is_moving = true;
                usar_novo_sistema = true;
            }
        }
    } else {
        // ✅ CORREÇÃO: Sem pilares - movimento aleatório mais agressivo
        var _dist_atual = point_distance(x, y, destino_x, destino_y);
        if (_dist_atual < 80 || estado == LanchaState.PARADO || estado == LanchaState.PATRULHANDO) {
            var _novo_x = x + random_range(-400, 400);
            var _novo_y = y + random_range(-400, 400);
            destino_x = _novo_x;
            destino_y = _novo_y;
            target_x = _novo_x;
            target_y = _novo_y;
            estado = LanchaState.MOVENDO;
            is_moving = true;
            usar_novo_sistema = true;
        } else if (estado == LanchaState.PATRULHANDO) {
            estado = LanchaState.MOVENDO;
            is_moving = true;
            usar_novo_sistema = true;
        }
    }
}

// === 4. SISTEMA DE DETECÇÃO DE INIMIGOS (USANDO scr_buscar_inimigo) ===
// ✅ CORREÇÃO: Usar função global de detecção
if (!modo_cacando || !instance_exists(alvo_atual)) {
    var _script_buscar = asset_get_index("scr_buscar_inimigo");
    if (_script_buscar != -1) {
        var _inimigo = scr_buscar_inimigo(x, y, raio_deteccao, nacao_proprietaria);
        
        if (instance_exists(_inimigo)) {
            alvo_atual = _inimigo;
            modo_cacando = true;
            estado = LanchaState.ATACANDO;
            is_moving = true;
            usar_novo_sistema = true;
        }
    }
}

// === 5. SISTEMA DE ATAQUE COM TIRO ===
if (modo_cacando && instance_exists(alvo_atual)) {
    var _dist_alvo = point_distance(x, y, alvo_atual.x, alvo_atual.y);
    
    destino_x = alvo_atual.x;
    destino_y = alvo_atual.y;
    target_x = alvo_atual.x;
    target_y = alvo_atual.y;
    estado = LanchaState.ATACANDO;
    is_moving = true;
    usar_novo_sistema = true;
    
    if (_dist_alvo <= alcance_ataque) {
        reload_timer--;
        if (reload_timer <= 0) {
            var _script_pool = asset_get_index("scr_get_projectile_from_pool");
            var _tiro = noone;
            if (_script_pool != -1) {
                _tiro = scr_get_projectile_from_pool(obj_tiro_simples, x, y, "Instances");
            }
            if (!instance_exists(_tiro)) {
                _tiro = instance_create_layer(x, y, "Instances", obj_tiro_simples);
            }
            
            if (instance_exists(_tiro) && instance_exists(alvo_atual)) {
                _tiro.alvo = alvo_atual;
                _tiro.target = alvo_atual;
                _tiro.dono = id;
                
                var _dano_final = dano_base;
                var _eh_carga = (variable_instance_exists(alvo_atual, "tipo_unidade") && alvo_atual.tipo_unidade == "navio_carga");
                var _eh_militar = (alvo_atual.object_index == obj_lancha_patrulha || 
                                  alvo_atual.object_index == obj_Constellation ||
                                  alvo_atual.object_index == obj_Independence);
                
                if (_eh_carga) {
                    _dano_final = dano_base * multiplicador_vs_carga;
                } else if (_eh_militar) {
                    _dano_final = dano_base * multiplicador_vs_militar;
                }
                
                _tiro.dano = _dano_final;
                _tiro.speed = 8;
                _tiro.image_blend = make_color_rgb(255, 150, 0);
                _tiro.image_xscale = 1.5;
                _tiro.image_yscale = 1.5;
                
                // ✅ Calcular direção do tiro
                var _dir_tiro = point_direction(x, y, alvo_atual.x, alvo_atual.y);
                _tiro.direction = _dir_tiro;
                _tiro.image_angle = _dir_tiro;
                
                reload_timer = reload_time;
            }
        }
    }
    
    if (_dist_alvo > raio_deteccao * 1.5) {
        modo_cacando = false;
        alvo_atual = noone;
        estado = LanchaState.PATRULHANDO;
        is_moving = true;
        usar_novo_sistema = true;
    }
} else if (modo_cacando) {
    modo_cacando = false;
    estado = LanchaState.PATRULHANDO;
    is_moving = true;
    usar_novo_sistema = true;
}

// === 6. VERIFICAR DESTRUIÇÃO ===
if (hp_atual <= 0) {
    // ✅ CRIAR NAVIO MORTO antes de destruir
    var _script_navio_morto = asset_get_index("scr_criar_navio_morto");
    if (_script_navio_morto != -1) {
        scr_criar_navio_morto(id);
    }
    instance_destroy();
}
