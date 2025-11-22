// ===============================================
// HEGEMONIA GLOBAL - MÍSSIL LIT
// Step Event - Sistema de Rastreamento Inteligente
// ===============================================

// === VERIFICAÇÃO DE SEGURANÇA ===
if (!visible || image_alpha <= 0 || speed <= 0) {
    scr_return_projectile_to_pool(id);
    exit;
}

// ✅ CORREÇÃO CRÍTICA: Validação completa do alvo
if (!instance_exists(alvo) || alvo == noone || is_undefined(alvo.x) || is_undefined(alvo.y)) {
    scr_return_projectile_to_pool(id);
    exit;
}

// ✅ Verificar se coordenadas do alvo são válidas
if (alvo.x < 0 || alvo.y < 0 || is_nan(alvo.x) || is_nan(alvo.y)) {
    scr_return_projectile_to_pool(id);
    exit;
}

// === GUARDAR POSIÇÃO ANTERIOR (para detecção de colisão) ===
var _x_anterior = x;
var _y_anterior = y;

// === SISTEMA DE PREDIÇÃO (ESPECIAL DO LIT) ===
var _pos_alvo_x = alvo.x;
var _pos_alvo_y = alvo.y;

// Se alvo está se movendo, prever posição futura
if (velocidade_adaptativa && predicao_ativa) {
    if (variable_instance_exists(alvo, "vspeed") && variable_instance_exists(alvo, "hspeed")) {
        var _velocidade_alvo = sqrt(power(alvo.hspeed, 2) + power(alvo.vspeed, 2));
        if (_velocidade_alvo > 0) {
            // Prever posição em 0.5 segundos (30 frames)
            _pos_alvo_x += alvo.hspeed * 30 * 0.5;
            _pos_alvo_y += alvo.vspeed * 30 * 0.5;
        }
    }
}

// === MOVIMENTO E ROTAÇÃO ===
var _dir = point_direction(x, y, _pos_alvo_x, _pos_alvo_y);

if (is_undefined(_dir) || is_nan(_dir)) {
    scr_return_projectile_to_pool(id);
    exit;
}

image_angle = _dir;
direction = _dir;

// Aplicar movimento do projétil
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// ✅ CORREÇÃO: Verificar se passou muito longe do alvo
var _distancia_muito_longe = point_distance(x, y, alvo.x, alvo.y);
if (_distancia_muito_longe > 2500) {
    scr_return_projectile_to_pool(id);
    exit;
}

// === COLISÃO E DANO ===
// Ativar alvo temporariamente se estiver desativado
instance_activate_object(alvo.object_index);

// ✅ VERIFICAÇÃO MELHORADA: Múltiplos pontos de verificação
var _distancia_atual = point_distance(x, y, alvo.x, alvo.y);
var _distancia_anterior = point_distance(_x_anterior, _y_anterior, alvo.x, alvo.y);

// Raio adaptativo: maior para o LIT que outros mísseis
var _raio_colisao = max(150, speed * 3);  // ✅ AUMENTADO: LIT tem raio MAIOR

if (instance_exists(alvo) && variable_instance_exists(alvo, "sprite_index") && sprite_exists(alvo.sprite_index)) {
    var _largura_alvo = sprite_get_width(alvo.sprite_index);
    var _altura_alvo = sprite_get_height(alvo.sprite_index);
    var _raio_alvo = max(_largura_alvo, _altura_alvo) / 2;
    _raio_colisao = max(_raio_colisao, _raio_alvo + 80); // ✅ Margem MAIOR para LIT
}

// ✅ Verificação em múltiplos pontos
var _acertou = false;
var _pontos_verificar = max(4, ceil(speed / 2));
for (var i = 0; i <= _pontos_verificar; i++) {
    var _t = i / _pontos_verificar;
    var _check_x = lerp(_x_anterior, x, _t);
    var _check_y = lerp(_y_anterior, y, _t);
    var _dist_check = point_distance(_check_x, _check_y, alvo.x, alvo.y);
    
    if (_dist_check <= _raio_colisao) {
        _acertou = true;
        if (i < _pontos_verificar) {
            x = _check_x;
            y = _check_y;
        }
        break;
    }
}

var _passou_pelo_alvo = (_distancia_anterior > _distancia_atual && _distancia_atual <= _raio_colisao);
var _esta_muito_perto = (_distancia_atual <= _raio_colisao);

// ✅ DANO E EXPLOSÃO
if (_acertou || _passou_pelo_alvo || _esta_muito_perto) {
    
    // ✅ APLICAR DANO DIRETO
    var _dano_final = dano;
    
    // Ajustar dano por tipo de alvo
    switch(tipo_alvo) {
        case "aereo":
            _dano_final = 120;  // Maior contra aéreos
            break;
        case "maritimo":
            _dano_final = 100;  // Bom contra marítimos
            break;
        case "submarino":
            _dano_final = 140;  // MUITO MAIOR contra submarinos
            break;
        case "terrestre":
            _dano_final = 90;   // Normal contra terrestres
            break;
    }
    
    // ✅ NOVO: Verificar se é o primeiro dano antes de aplicar
    var _primeiro_dano = false;
    var _hp_max_alvo = 1;
    if (variable_instance_exists(alvo, "hp_atual") && variable_instance_exists(alvo, "hp_max")) {
        _primeiro_dano = (alvo.hp_atual >= alvo.hp_max);
        _hp_max_alvo = alvo.hp_max;
    } else if (variable_instance_exists(alvo, "vida") && variable_instance_exists(alvo, "vida_max")) {
        _primeiro_dano = (alvo.vida >= alvo.vida_max);
        _hp_max_alvo = alvo.vida_max;
    } else if (variable_instance_exists(alvo, "hp") && variable_instance_exists(alvo, "hp_max")) {
        _primeiro_dano = (alvo.hp >= alvo.hp_max);
        _hp_max_alvo = alvo.hp_max;
    }
    
    // Aplicar dano ao alvo principal
    if (variable_instance_exists(alvo, "hp_atual")) {
        alvo.hp_atual -= _dano_final;
        
        // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
        if (_primeiro_dano && alvo.hp_atual < alvo.hp_max && alvo.hp_atual > 0) {
            alvo.mostrar_vida = true;
            alvo.timer_vida_visivel = 0;
            var _porcentagem = round((alvo.hp_atual / alvo.hp_max) * 100);
            show_debug_message("💥 " + object_get_name(alvo.object_index) + " atingido pela primeira vez! HP: " + string(alvo.hp_atual) + "/" + string(alvo.hp_max) + " (" + string(_porcentagem) + "%)");
        } else if (alvo.hp_atual < alvo.hp_max && alvo.hp_atual > 0) {
            if (!variable_instance_exists(alvo, "mostrar_vida")) {
                alvo.mostrar_vida = true;
            }
            alvo.timer_vida_visivel = 0;
        }
        
        if (alvo.hp_atual <= 0) {
            if (instance_exists(alvo)) {
                // ✅ CORREÇÃO: Verificar se script existe antes de chamar
                var _script_id = asset_get_index("scr_criar_restos_unidade");
                if (_script_id != -1) {
                    scr_criar_restos_unidade(alvo);
                }
            }
            instance_destroy(alvo);
        }
    } else if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= _dano_final;
        
        // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
        if (_primeiro_dano && alvo.vida < alvo.vida_max && alvo.vida > 0) {
            alvo.mostrar_vida = true;
            alvo.timer_vida_visivel = 0;
            var _porcentagem = round((alvo.vida / alvo.vida_max) * 100);
            show_debug_message("💥 " + object_get_name(alvo.object_index) + " atingido pela primeira vez! Vida: " + string(alvo.vida) + "/" + string(alvo.vida_max) + " (" + string(_porcentagem) + "%)");
        } else if (alvo.vida < alvo.vida_max && alvo.vida > 0) {
            if (!variable_instance_exists(alvo, "mostrar_vida")) {
                alvo.mostrar_vida = true;
            }
            alvo.timer_vida_visivel = 0;
        }
        
        if (alvo.vida <= 0) {
            if (instance_exists(alvo)) {
                // ✅ CORREÇÃO: Verificar se script existe antes de chamar
                var _script_id = asset_get_index("scr_criar_restos_unidade");
                if (_script_id != -1) {
                    scr_criar_restos_unidade(alvo);
                }
            }
            instance_destroy(alvo);
        }
    } else if (variable_instance_exists(alvo, "hp")) {
        alvo.hp -= _dano_final;
        
        // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
        if (_primeiro_dano && alvo.hp < alvo.hp_max && alvo.hp > 0) {
            alvo.mostrar_vida = true;
            alvo.timer_vida_visivel = 0;
            var _porcentagem = round((alvo.hp / alvo.hp_max) * 100);
            show_debug_message("💥 " + object_get_name(alvo.object_index) + " atingido pela primeira vez! HP: " + string(alvo.hp) + "/" + string(alvo.hp_max) + " (" + string(_porcentagem) + "%)");
        } else if (alvo.hp < alvo.hp_max && alvo.hp > 0) {
            if (!variable_instance_exists(alvo, "mostrar_vida")) {
                alvo.mostrar_vida = true;
            }
            alvo.timer_vida_visivel = 0;
        }
        
        if (alvo.hp <= 0) {
            if (instance_exists(alvo)) {
                // ✅ CORREÇÃO: Verificar se script existe antes de chamar
                var _script_id = asset_get_index("scr_criar_restos_unidade");
                if (_script_id != -1) {
                    scr_criar_restos_unidade(alvo);
                }
            }
            instance_destroy(alvo);
        }
    }
    
    show_debug_message("💥 LIT acertou " + tipo_alvo + "! Dano: " + string(_dano_final));
    
    // ✅ DANO EM ÁREA (ESPECIAL DO LIT - MUITO MAIOR)
    var _tipos_unidades = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
    
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        array_push(_tipos_unidades, _obj_abrams);
    }
    var _obj_gepard = asset_get_index("obj_gepard");
    if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
        array_push(_tipos_unidades, _obj_gepard);
    }
    
    var _unidades_atingidas = 0;
    for (var i = 0; i < array_length(_tipos_unidades); i++) {
        with (_tipos_unidades[i]) {
            var _dist = point_distance(x, y, other.x, other.y);
            if (_dist <= other.raio_dano_area && id != other.alvo) {
                // ✅ NOVO: Verificar se é o primeiro dano antes de aplicar
                var _primeiro_dano_area = false;
                var _hp_max_area = 1;
                if (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max")) {
                    _primeiro_dano_area = (hp_atual >= hp_max);
                    _hp_max_area = hp_max;
                } else if (variable_instance_exists(id, "vida") && variable_instance_exists(id, "vida_max")) {
                    _primeiro_dano_area = (vida >= vida_max);
                    _hp_max_area = vida_max;
                }
                
                if (variable_instance_exists(id, "hp_atual")) {
                    hp_atual -= other.dano_area;
                    
                    // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
                    if (_primeiro_dano_area && hp_atual < hp_max && hp_atual > 0) {
                        mostrar_vida = true;
                        timer_vida_visivel = 0;
                        var _porcentagem = round((hp_atual / hp_max) * 100);
                        show_debug_message("💥 " + object_get_name(object_index) + " atingido pela primeira vez (área)! HP: " + string(hp_atual) + "/" + string(hp_max) + " (" + string(_porcentagem) + "%)");
                    } else if (hp_atual < hp_max && hp_atual > 0) {
                        if (!variable_instance_exists(id, "mostrar_vida")) {
                            mostrar_vida = true;
                        }
                        timer_vida_visivel = 0;
                    }
                    
                    if (hp_atual <= 0) {
                        if (instance_exists(id)) {
                            // ✅ CORREÇÃO: Verificar se script existe antes de chamar
                            var _script_id = asset_get_index("scr_criar_restos_unidade");
                            if (_script_id != -1) {
                                scr_criar_restos_unidade(id);
                            }
                        }
                        instance_destroy(id);
                    }
                    _unidades_atingidas++;
                } else if (variable_instance_exists(id, "vida")) {
                    vida -= other.dano_area;
                    
                    // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
                    if (_primeiro_dano_area && vida < vida_max && vida > 0) {
                        mostrar_vida = true;
                        timer_vida_visivel = 0;
                        var _porcentagem = round((vida / vida_max) * 100);
                        show_debug_message("💥 " + object_get_name(object_index) + " atingido pela primeira vez (área)! Vida: " + string(vida) + "/" + string(vida_max) + " (" + string(_porcentagem) + "%)");
                    } else if (vida < vida_max && vida > 0) {
                        if (!variable_instance_exists(id, "mostrar_vida")) {
                            mostrar_vida = true;
                        }
                        timer_vida_visivel = 0;
                    }
                    
                    if (vida <= 0) {
                        if (instance_exists(id)) {
                            // ✅ CORREÇÃO: Verificar se script existe antes de chamar
                            var _script_id = asset_get_index("scr_criar_restos_unidade");
                            if (_script_id != -1) {
                                scr_criar_restos_unidade(id);
                            }
                        }
                        instance_destroy(id);
                    }
                    _unidades_atingidas++;
                } else if (variable_instance_exists(id, "hp")) {
                    hp -= other.dano_area;
                    
                    // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
                    if (_primeiro_dano_area && hp < hp_max && hp > 0) {
                        mostrar_vida = true;
                        timer_vida_visivel = 0;
                        var _porcentagem = round((hp / hp_max) * 100);
                        show_debug_message("💥 " + object_get_name(object_index) + " atingido pela primeira vez (área)! HP: " + string(hp) + "/" + string(hp_max) + " (" + string(_porcentagem) + "%)");
                    } else if (hp < hp_max && hp > 0) {
                        if (!variable_instance_exists(id, "mostrar_vida")) {
                            mostrar_vida = true;
                        }
                        timer_vida_visivel = 0;
                    }
                    
                    if (hp <= 0) {
                        if (instance_exists(id)) {
                            // ✅ CORREÇÃO: Verificar se script existe antes de chamar
                            var _script_id = asset_get_index("scr_criar_restos_unidade");
                            if (_script_id != -1) {
                                scr_criar_restos_unidade(id);
                            }
                        }
                        instance_destroy(id);
                    }
                    _unidades_atingidas++;
                }
            }
        }
    }
    
    if (_unidades_atingidas > 0) {
        show_debug_message("💥💥 LIT EXPLOSÃO! " + string(_unidades_atingidas) + " unidades atingidas em " + string(raio_dano_area) + "px!");
    }
    
    // ✅ CRIAR EXPLOSÃO
    var _explosao_x = x;
    var _explosao_y = y;
    if (instance_exists(alvo)) {
        _explosao_x = alvo.x;
        _explosao_y = alvo.y;
    }
    
    var _alvo_aereo = (tipo_alvo == "aereo");
    
    if (_alvo_aereo && object_exists(obj_explosao_ar)) {
        var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_ar);
        if (instance_exists(_explosao)) {
            _explosao.image_xscale = 2.0;  // ✅ MAIOR para LIT
            _explosao.image_yscale = 2.0;
            _explosao.image_blend = make_color_rgb(255, 200, 0);  // Amarelo ouro
            _explosao.alarm[0] = 90;
        }
    } else if (object_exists(obj_explosao_terra)) {
        var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_terra);
        if (instance_exists(_explosao)) {
            _explosao.image_xscale = 2.5;  // ✅ MUITO MAIOR para LIT
            _explosao.image_yscale = 2.5;
            _explosao.image_blend = make_color_rgb(255, 200, 0);  // Amarelo ouro
            _explosao.alarm[0] = 60;
        }
    }
    
    // ✅ DESTRUIR MÍSSIL
    visible = false;
    image_alpha = 0;
    speed = 0;
    instance_deactivate_object(id);
    scr_return_projectile_to_pool(id);
    exit;
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    if (object_exists(obj_explosao_terra)) {
        var _explosao = instance_create_depth(x, y, 0, obj_explosao_terra);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 100, 100);
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
        }
    }
    
    visible = false;
    image_alpha = 0;
    speed = 0;
    instance_deactivate_object(id);
    scr_return_projectile_to_pool(id);
    exit;
}