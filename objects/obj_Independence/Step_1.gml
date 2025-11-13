/// @description Step Event 1 - Ataque em TODOS os Inimigos Simultaneamente
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE
// Sistema que ataca TODOS os inimigos (ar + terra) dentro do raio ao mesmo tempo
// ===============================================

// === SISTEMA DE CANHÃO ===
// Criar canhão se não existir
if (!instance_exists(canhao_instancia)) {
    canhao_instancia = instance_create_layer(x + canhao_offset_x, y + canhao_offset_y, "Instances", obj_canhao);
    if (instance_exists(canhao_instancia)) {
        canhao_instancia.navio_pai = id;
        canhao_instancia.offset_x = canhao_offset_x;
        canhao_instancia.offset_y = canhao_offset_y;
    }
}

// === DECREMENTAR COOLDOWN ===
if (metralhadora_cooldown_timer > 0) {
    metralhadora_cooldown_timer--;
}

// === SISTEMA DE ATAQUE EM MÚLTIPLOS ALVOS ===
// Verificar se está em modo de ataque ou atacando
if ((modo_combate == LanchaMode.ATAQUE || estado == LanchaState.ATACANDO) && instance_exists(canhao_instancia)) {
    
    var _inimigos_terrestres = [];
    var _inimigos_aereos = [];
    var _total_alvos = 0;
    
    // PROCURAR TODOS OS INIMIGOS DENTRO DO RAIO
    var _lista_alvos = []; // Array para armazenar todos os inimigos encontrados
    
    // Verificar navios inimigos
    with (obj_navio_base) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != noone && 
            nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(_lista_alvos, {
                    id: id,
                    distancia: _dist,
                    tipo: "naval"
                });
            }
        }
    }
    
    // Verificar helicópteros inimigos
    with (obj_helicoptero_militar) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != noone && 
            nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(_lista_alvos, {
                    id: id,
                    distancia: _dist,
                    tipo: "aereo"
                });
            }
        }
    }
    
    // Verificar F-5 inimigos
    with (obj_caca_f5) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != noone && 
            nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(_lista_alvos, {
                    id: id,
                    distancia: _dist,
                    tipo: "aereo"
                });
            }
        }
    }
    
    // Verificar F-6 inimigos
    with (obj_f6) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != noone && 
            nacao_proprietaria != other.nacao_proprietaria) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(_lista_alvos, {
                    id: id,
                    distancia: _dist,
                    tipo: "aereo"
                });
            }
        }
    }
    
    // Verificar infantaria inimiga
    with (obj_infantaria) {
        if (nacao_proprietaria == 2) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(_lista_alvos, {
                    id: id,
                    distancia: _dist,
                    tipo: "terrestre"
                });
            }
        }
    }
    
    // Verificar inimigos terrestres
    // ✅ CORREÇÃO: obj_inimigo removido - buscar apenas obj_infantaria
    with (obj_infantaria) {
        if (nacao_proprietaria != 1 && nacao_proprietaria != noone) {
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.missil_max_alcance) {
                array_push(_lista_alvos, {
                    id: id,
                    distancia: _dist,
                    tipo: "terrestre"
                });
            }
        }
    }
    
    _total_alvos = array_length(_lista_alvos);
    
    // Separar alvos aéreos e terrestres
    for (var i = 0; i < _total_alvos; i++) {
        var _alvo_info = _lista_alvos[i];
        if (instance_exists(_alvo_info.id)) {
            if (_alvo_info.tipo == "aereo") {
                array_push(_inimigos_aereos, _alvo_info.id);
            } else {
                array_push(_inimigos_terrestres, _alvo_info.id);
            }
        }
    }
    
    // ====================================
    // ATIRAR EM TODOS OS ALVOS TERRESTRES (CANHÃO)
    // ====================================
    var _num_alvos_terrestres = array_length(_inimigos_terrestres);
    if (_num_alvos_terrestres > 0 && metralhadora_cooldown_timer <= 0) {
        // Ativar canhão
        if (!metralhadora_ativa) {
            metralhadora_ativa = true;
            metralhadora_timer = 0;
            metralhadora_tiros = 0;
            show_debug_message("🔫 Independence iniciou rajada em " + string(_num_alvos_terrestres) + " alvo(s) terrestre(s)!");
        }
        
        // Disparar projétil para CADA alvo terrestre
        if (metralhadora_ativa && metralhadora_timer >= metralhadora_intervalo && metralhadora_tiros < metralhadora_max_tiros) {
            
            // Para cada alvo terrestre, criar um projétil
            var _tiros_este_frame = 0;
            var _max_tiros_por_frame = 3; // Máximo de 3 tiros por frame para não sobrecarregar
            
            for (var i = 0; i < _num_alvos_terrestres && _tiros_este_frame < _max_tiros_por_frame; i++) {
                var _alvo = _inimigos_terrestres[i];
                
                if (instance_exists(_alvo)) {
                    var _tiro = scr_get_projectile_from_pool(obj_tiro_canhao, canhao_instancia.x, canhao_instancia.y, "Instances");
                    if (instance_exists(_tiro)) {
                        _tiro.alvo = _alvo;
                        _tiro.dono = id;
                        if (variable_instance_exists(_tiro, "timer_vida")) {
                            _tiro.timer_vida = 240;
                        }
                        _tiros_este_frame++;
                        
                        // ✅ CORREÇÃO: Som do canhão apenas se estiver visível na câmera (apenas no primeiro tiro)
                        // Verificação inline (sem depender de script)
                        if (_tiros_este_frame == 1) {
                            var _cam = view_camera[0];
                            var _visivel = true; // Fallback: considerar visível
                            if (_cam != -1 && _cam != noone) {
                                var _cam_x = camera_get_view_x(_cam);
                                var _cam_y = camera_get_view_y(_cam);
                                var _cam_w = camera_get_view_width(_cam);
                                var _cam_h = camera_get_view_height(_cam);
                                if (_cam_w > 0 && _cam_h > 0) {
                                    var _margin = 100;
                                    var _view_left = _cam_x - _margin;
                                    var _view_right = _cam_x + _cam_w + _margin;
                                    var _view_top = _cam_y - _margin;
                                    var _view_bottom = _cam_y + _cam_h + _margin;
                                    _visivel = (x >= _view_left && x <= _view_right && y >= _view_top && y <= _view_bottom);
                                }
                            }
                            if (_visivel) {
                                var _sound_index = asset_get_index("tiro_torreta");
                                if (_sound_index != -1) {
                                    audio_play_sound(tiro_torreta, 5, false);
                                }
                            }
                        }
                        
                        // Efeito visual
                        var _flash = instance_create_layer(canhao_instancia.x, canhao_instancia.y, "Efeitos", obj_fumaca_missil);
                        if (instance_exists(_flash)) {
                            _flash.image_xscale = 0.5;
                            _flash.image_yscale = 0.5;
                            _flash.image_alpha = 0.8;
                            _flash.image_blend = c_yellow;
                            _flash.image_angle = canhao_instancia.image_angle;
                        }
                    }
                }
            }
            
            metralhadora_tiros += _tiros_este_frame;
            metralhadora_timer = 0;
            
            if (_tiros_este_frame > 0) {
                show_debug_message("🔫 Independence disparou " + string(_tiros_este_frame) + " projétil(is) em " + string(_num_alvos_terrestres) + " alvo(s) terrestre(s)!");
            }
        }
        
        // Incrementar timer
        metralhadora_timer++;
        
        // Finalizar rajada
        if (metralhadora_tiros >= metralhadora_max_tiros) {
            metralhadora_ativa = false;
            metralhadora_timer = 0;
            metralhadora_tiros = 0;
            metralhadora_cooldown_timer = metralhadora_cooldown_duration;
            show_debug_message("🔫 Independence finalizou rajada! Pausa de " + string(metralhadora_cooldown_timer) + " frames");
        }
    } else if (_num_alvos_terrestres == 0) {
        // Sem alvos terrestres - parar canhão
        if (metralhadora_ativa) {
            metralhadora_ativa = false;
            metralhadora_timer = 0;
            metralhadora_tiros = 0;
        }
    }
    
    // ====================================
    // ATIRAR EM TODOS OS ALVOS AÉREOS (MÍSSEIS SKY)
    // ====================================
    var _num_alvos_aereos = array_length(_inimigos_aereos);
    
    // Criar timer de mísseis separado para o sistema múltiplo
    if (!variable_instance_exists(id, "missil_timer_multi")) {
        missil_timer_multi = 0;
        missil_cooldown_multi = 90; // Cooldown de mísseis para ataque múltiplo
    }
    
    if (_num_alvos_aereos > 0 && missil_timer_multi <= 0) {
        // Disparar míssil SkyFury (SKY) para CADA alvo aéreo
        var _misseis_disparados = 0;
        var _max_misseis_por_frame = 2; // Máximo de 2 mísseis por frame
        
        for (var i = 0; i < _num_alvos_aereos && _misseis_disparados < _max_misseis_por_frame; i++) {
            var _alvo_aereo = _inimigos_aereos[i];
            
            if (instance_exists(_alvo_aereo)) {
                // Criar míssil SkyFury via pool
                var _missil = scr_get_projectile_from_pool(obj_SkyFury_ar, x, y, "Instances");
                if (instance_exists(_missil)) {
                    _missil.target = _alvo_aereo;
                    _missil.dono = id;
                    _missil.direction = point_direction(x, y, _alvo_aereo.x, _alvo_aereo.y);
                    
                    _misseis_disparados++;
                    
                    show_debug_message("🚀 Independence disparou SkyFury (SKY) em " + object_get_name(_alvo_aereo.object_index) + "!");
                }
            }
        }
        
        // Resetar timer se disparou algum míssil
        if (_misseis_disparados > 0) {
            missil_timer_multi = missil_cooldown_multi;
            show_debug_message("🚀 Independence disparou " + string(_misseis_disparados) + " míssil(eis) SkyFury (SKY) em " + string(_num_alvos_aereos) + " alvo(s) aéreo(s)! Cooldown: " + string(missil_timer_multi));
        }
    }
    
    // Decrementar timer de mísseis
    if (missil_timer_multi > 0) {
        missil_timer_multi--;
    }
    
    // ====================================
    // ATIRAR EM ALVOS TERRESTRES PESADOS (MÍSSEIS HASH)
    // ====================================
    var _num_alvos_terrestres = array_length(_inimigos_terrestres);
    
    if (_num_alvos_terrestres > 0 && missil_timer_hash <= 0) {
        // Disparar míssil Hash para alvos terrestres pesados
        var _misseis_hash_disparados = 0;
        var _max_hash_por_frame = 1; // Máximo de 1 míssil Hash por frame (muito poderoso)
        
        for (var i = 0; i < _num_alvos_terrestres && _misseis_hash_disparados < _max_hash_por_frame; i++) {
            var _alvo_terrestre = _inimigos_terrestres[i];
            
            if (instance_exists(_alvo_terrestre)) {
                // Criar míssil Hash (muito poderoso)
                var _missil_hash = instance_create_layer(x, y, "Instances", obj_hash);
                if (instance_exists(_missil_hash)) {
                    _missil_hash.target = _alvo_terrestre;
                    _missil_hash.alvo = _alvo_terrestre;
                    _missil_hash.dono = id;
                    _missil_hash.direction = point_direction(x, y, _alvo_terrestre.x, _alvo_terrestre.y);
                    
                    _misseis_hash_disparados++;
                    
                    show_debug_message("💥 Independence disparou Hash (míssil pesado) em " + object_get_name(_alvo_terrestre.object_index) + "!");
                }
            }
        }
        
        // Resetar timer se disparou algum míssil Hash
        if (_misseis_hash_disparados > 0) {
            missil_timer_hash = 120;
            show_debug_message("💥 Independence disparou " + string(_misseis_hash_disparados) + " míssil(eis) Hash em " + string(_num_alvos_terrestres) + " alvo(s) terrestre(s)!");
        }
    }
    
    // Decrementar timer de mísseis Hash
    if (missil_timer_hash > 0) {
        missil_timer_hash--;
    }
    
    // ====================================
    // ATIRAR EM ALVOS TERRESTRES NORMAIS (MÍSSEIS IRON)
    // ====================================
    if (_num_alvos_terrestres > 0 && missil_timer_iron <= 0) {
        // Disparar míssil Ironclad (IRON) para alvos terrestres
        var _misseis_iron_disparados = 0;
        var _max_iron_por_frame = 2; // Máximo de 2 mísseis Iron por frame
        
        for (var i = 0; i < _num_alvos_terrestres && _misseis_iron_disparados < _max_iron_por_frame; i++) {
            var _alvo_terrestre = _inimigos_terrestres[i];
            
            if (instance_exists(_alvo_terrestre)) {
                // Criar míssil Ironclad via pool
                var _missil_iron = scr_get_projectile_from_pool(obj_Ironclad_terra, x, y, "Instances");
                if (instance_exists(_missil_iron)) {
                    _missil_iron.target = _alvo_terrestre;
                    _missil_iron.alvo = _alvo_terrestre;
                    _missil_iron.dono = id;
                    _missil_iron.direction = point_direction(x, y, _alvo_terrestre.x, _alvo_terrestre.y);
                    
                    _misseis_iron_disparados++;
                    
                    show_debug_message("🔥 Independence disparou Ironclad (IRON) em " + object_get_name(_alvo_terrestre.object_index) + "!");
                }
            }
        }
        
        // Resetar timer se disparou algum míssil Iron
        if (_misseis_iron_disparados > 0) {
            missil_timer_iron = 90;
            show_debug_message("🔥 Independence disparou " + string(_misseis_iron_disparados) + " míssil(eis) Ironclad (IRON) em " + string(_num_alvos_terrestres) + " alvo(s) terrestre(s)!");
        }
    }
    
    // Decrementar timer de mísseis Iron
    if (missil_timer_iron > 0) {
        missil_timer_iron--;
    }
    
    // Debug final
    if (selecionado && _total_alvos > 0) {
        show_debug_message("🎯 Independence: " + string(_total_alvos) + " inimigo(s) no raio | Terra: " + string(_num_alvos_terrestres) + " | Ar: " + string(_num_alvos_aereos));
    }
}
