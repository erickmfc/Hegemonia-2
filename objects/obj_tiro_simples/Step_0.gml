// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Step Event - Sistema ROBUSTO E SEM ERROS
// ================================================

// === VERIFICAÇÃO DE SEGURANÇA ===
// ✅ VERIFICAÇÃO DE SEGURANÇA: Se está invisível ou desativado, não processar
if (!visible || image_alpha <= 0 || speed <= 0) {
    // Projétil já foi acertado ou está sendo desativado
    exit;
}

// ✅ CORREÇÃO CRÍTICA: Validação completa do alvo
if (!instance_exists(alvo) || alvo == noone || is_undefined(alvo.x) || is_undefined(alvo.y)) {
    scr_return_projectile_to_pool(id);
    exit;
}

// ✅ NOVO: Verificar se coordenadas do alvo são válidas
if (alvo.x < 0 || alvo.y < 0 || is_nan(alvo.x) || is_nan(alvo.y)) {
    scr_return_projectile_to_pool(id);
    exit;
}

// === GUARDAR POSIÇÃO ANTERIOR (para detecção de colisão por linha) ===
var _x_anterior = x;
var _y_anterior = y;

// === MOVIMENTO E ROTAÇÃO ===
// ✅ CORREÇÃO: Calcular direção apenas se alvo é válido
var _dir = point_direction(x, y, alvo.x, alvo.y);

// ✅ NOVO: Verificar se direção é válida
if (is_undefined(_dir) || is_nan(_dir)) {
    scr_return_projectile_to_pool(id);
    exit;
}

image_angle = _dir;
direction = _dir;

// Aplicar movimento do projétil
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// ✅ CORREÇÃO: Verificar se passou muito longe do alvo (projétil perdido)
var _distancia_muito_longe = point_distance(x, y, alvo.x, alvo.y);
if (_distancia_muito_longe > 2000) { // Se está a mais de 2000 pixels, destruir
    scr_return_projectile_to_pool(id);
    exit;
}

// === COLISÃO E DANO ===
// ✅ CORREÇÃO CRÍTICA: Ativar alvo temporariamente se estiver desativado
var _alvo_estava_desativado = false;
if (instance_exists(alvo)) {
    // ✅ NOVO: Tentar ativar alvo se estiver desativado (para collision_line funcionar)
    // Nota: instance_exists retorna true mesmo para instâncias desativadas
    // Mas collision_line só funciona com instâncias ativas
    // Vamos ativar temporariamente se necessário
    instance_activate_object(alvo.object_index);
    // Verificar se alvo agora está acessível (pode ter sido ativado)
    if (instance_exists(alvo)) {
        // Alvo está acessível agora
    }
}

// ✅ CORREÇÃO: Verificar colisão usando distância (funciona mesmo com unidades desativadas)
// ✅ NOVO: Verificar se alvo ainda é válido antes de calcular distância
if (!instance_exists(alvo) || is_undefined(alvo.x) || is_undefined(alvo.y)) {
    scr_return_projectile_to_pool(id);
    exit;
}

var _distancia_atual = point_distance(x, y, alvo.x, alvo.y);
var _distancia_anterior = point_distance(_x_anterior, _y_anterior, alvo.x, alvo.y);

// ✅ CORREÇÃO 1: Raio baseado na velocidade (pelo menos 2x a velocidade)
var _raio_colisao_base = max(120, speed * 2.5); // Mínimo 120px ou 2.5x a velocidade

// ✅ CORREÇÃO 2: Calcular raio baseado no tamanho do sprite do alvo
if (instance_exists(alvo) && variable_instance_exists(alvo, "sprite_index") && sprite_exists(alvo.sprite_index)) {
    var _largura_alvo = sprite_get_width(alvo.sprite_index);
    var _altura_alvo = sprite_get_height(alvo.sprite_index);
    var _raio_alvo = max(_largura_alvo, _altura_alvo) / 2;
    // Usar o maior entre raio base (velocidade) e raio do sprite + margem maior
    _raio_colisao_base = max(_raio_colisao_base, _raio_alvo + 60); // ✅ AUMENTADO margem para 60 pixels
}

var _raio_colisao = _raio_colisao_base;

// ✅ CORREÇÃO 3: Verificar colisão ANTES de mover (previsão)
var _distancia_antes_mover = point_distance(_x_anterior, _y_anterior, alvo.x, alvo.y);
var _ja_esta_dentro = (_distancia_antes_mover <= _raio_colisao);

// ✅ CORREÇÃO 4: Verificar múltiplos pontos ao longo do caminho
var _acertou = false;
var _pontos_verificar = max(3, ceil(speed / 2)); // Verificar mais pontos se velocidade alta
for (var i = 0; i <= _pontos_verificar; i++) {
    var _t = i / _pontos_verificar;
    var _check_x = lerp(_x_anterior, x, _t);
    var _check_y = lerp(_y_anterior, y, _t);
    var _dist_check = point_distance(_check_x, _check_y, alvo.x, alvo.y);
    
    if (_dist_check <= _raio_colisao) {
        _acertou = true;
        // Ajustar posição do míssil para o ponto de impacto
        if (i < _pontos_verificar) {
            x = _check_x;
            y = _check_y;
        }
        break;
    }
}

// ✅ CORREÇÃO 5: Verificar se passou pelo alvo (melhorado)
var _passou_pelo_alvo = (_distancia_anterior > _distancia_atual && _distancia_atual <= _raio_colisao);
var _esta_muito_perto = (_distancia_atual <= _raio_colisao);
var _passou_ao_lado = (_distancia_anterior > _raio_colisao && _distancia_atual <= _raio_colisao * 1.2); // Verificar se passou "ao lado"

// ✅ CORREÇÃO: Verificar colisão por linha APENAS se alvo estiver ativo (após ativação)
var _colisao_linha = false;
if (instance_exists(alvo) && variable_instance_exists(alvo, "sprite_index") && sprite_exists(alvo.sprite_index)) {
    // ✅ NOVO: Ativar alvo temporariamente para collision_line funcionar
    instance_activate_object(alvo.object_index);
    // ✅ NOVO: collision_line funciona apenas com instâncias ativas
    // Já ativamos o alvo acima, então deve funcionar agora
    _colisao_linha = collision_line(_x_anterior, _y_anterior, x, y, alvo, false, true);
}

// ✅ CORREÇÃO: Usar verificação melhorada (múltiplos pontos + distância + linha)
// collision_line é apenas um auxiliar
if (_acertou || _ja_esta_dentro || _passou_pelo_alvo || _esta_muito_perto || _passou_ao_lado || _colisao_linha) {
    
    // ✅ VERIFICAR SE É SOLDADO/INIMIGO PARA APLICAR DANO CORRETO
    // ✅ CORREÇÃO: obj_inimigo removido
    var _is_soldado = false;
    if (instance_exists(alvo)) {
        _is_soldado = (alvo.object_index == obj_infantaria);
        
        // ✅ CORREÇÃO: Verificar obj_inimigo_soldado de forma segura
        // Usar asset_get_index para verificar se o objeto existe sem causar erro
        if (!_is_soldado) {
            var _obj_inimigo_soldado_index = asset_get_index("obj_inimigo_soldado");
            if (_obj_inimigo_soldado_index != -1 && object_exists(_obj_inimigo_soldado_index)) {
                if (alvo.object_index == _obj_inimigo_soldado_index) {
                    _is_soldado = true;
                }
            }
        }
    }
    
    // APLICAR DANO SEGURO
    var _dano_aplicado = false;
    var _dano_final = dano;
    
    // ✅ SOLDADOS PRECISAM DE DANO MAIOR
    if (_is_soldado) {
        _dano_final = 200; // ✅ AUMENTADO de 150 para 200 - garantir morte instantânea
    }
    
    // ✅ CORREÇÃO: Verificar hp_atual PRIMEIRO (obj_infantaria e ESTRUTURAS usam isso)
    if (variable_instance_exists(alvo, "hp_atual")) {
        var _hp_antes = alvo.hp_atual;
        
        // ✅ NOVO: Garantir que o alvo está ativo antes de aplicar dano
        instance_activate_object(alvo.object_index);
        
        // ✅ NOVO: Verificar se é o primeiro dano antes de aplicar
        var _primeiro_dano = (alvo.hp_atual >= alvo.hp_max);
        
        // ✅ CORREÇÃO CRÍTICA: Aplicar dano garantindo que seja suficiente para matar
        alvo.hp_atual -= _dano_final;
        
        // ✅ NOVO: Garantir que HP não fique negativo (ajustar para 0 ou menos para destruir)
        if (alvo.hp_atual > 0 && _is_soldado) {
            // Se ainda está vivo mas é soldado, garantir morte
            alvo.hp_atual = -1; // Forçar destruição
        }
        
        // ✅ Atualizar vida também se existir (compatibilidade)
        if (variable_instance_exists(alvo, "vida")) {
            alvo.vida = alvo.hp_atual;
        }
        
        // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
        if (_primeiro_dano && alvo.hp_atual < alvo.hp_max && alvo.hp_atual > 0) {
            alvo.mostrar_vida = true;
            alvo.timer_vida_visivel = 0;
            var _porcentagem = round((alvo.hp_atual / alvo.hp_max) * 100);
            show_debug_message("💥 " + object_get_name(alvo.object_index) + " atingido pela primeira vez! HP: " + string(alvo.hp_atual) + "/" + string(alvo.hp_max) + " (" + string(_porcentagem) + "%)");
        } else if (alvo.hp_atual < alvo.hp_max && alvo.hp_atual > 0) {
            // Continuar mostrando vida se já foi atingida
            if (!variable_instance_exists(alvo, "mostrar_vida")) {
                alvo.mostrar_vida = true;
            }
            alvo.timer_vida_visivel = 0;
        }
        
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo PRINCIPAL! Dano: " + string(_dano_final) + " | HP: " + string(_hp_antes) + " → " + string(alvo.hp_atual));
        
        // ✅ NOVO: Verificar se alvo morreu e criar restos antes de destruir
        if (alvo.hp_atual <= 0 && instance_exists(alvo)) {
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("💀 Alvo principal MORTO! HP: " + string(alvo.hp_atual));
            }
            // ✅ NOVO: Criar restos da unidade antes de destruir
            // ✅ CORREÇÃO: Verificar se função existe antes de chamar
            var _script_restos = asset_get_index("scr_criar_restos_unidade");
            if (_script_restos != -1) {
                scr_criar_restos_unidade(alvo);
            }
            // ✅ CRÍTICO: Destruir alvo imediatamente se HP <= 0
            instance_destroy(alvo);
        }
    } else if (variable_instance_exists(alvo, "vida")) {
        var _vida_antes = alvo.vida;
        
        // ✅ NOVO: Garantir que o alvo está ativo antes de aplicar dano
        instance_activate_object(alvo.object_index);
        
        alvo.vida -= _dano_final;
        
        // ✅ NOVO: Garantir que vida não fique positiva se é soldado
        if (alvo.vida > 0 && _is_soldado) {
            alvo.vida = -1; // Forçar destruição
        }
        
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(_dano_final) + " | Vida: " + string(_vida_antes) + " → " + string(alvo.vida));
        
        // ✅ NOVO: Verificar se alvo morreu e destruir imediatamente
        if (alvo.vida <= 0 && instance_exists(alvo)) {
            // ✅ CORREÇÃO: Verificar se função existe antes de chamar
            var _script_restos = asset_get_index("scr_criar_restos_unidade");
            if (_script_restos != -1) {
                scr_criar_restos_unidade(alvo);
            }
            instance_destroy(alvo);
        }
    } else if (variable_instance_exists(alvo, "hp")) {
        var _hp_antes = alvo.hp;
        
        // ✅ NOVO: Garantir que o alvo está ativo antes de aplicar dano
        instance_activate_object(alvo.object_index);
        
        alvo.hp -= _dano_final;
        
        // ✅ NOVO: Garantir que HP não fique positivo se é soldado
        if (alvo.hp > 0 && _is_soldado) {
            alvo.hp = -1; // Forçar destruição
        }
        
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(_dano_final) + " | HP: " + string(_hp_antes) + " → " + string(alvo.hp));
        
        // ✅ NOVO: Verificar se alvo morreu e destruir imediatamente
        if (alvo.hp <= 0 && instance_exists(alvo)) {
            // ✅ CORREÇÃO: Verificar se função existe antes de chamar
            var _script_restos = asset_get_index("scr_criar_restos_unidade");
            if (_script_restos != -1) {
                scr_criar_restos_unidade(alvo);
            }
            instance_destroy(alvo);
        }
    } else {
        // Fallback: criar variável vida se não existir
        instance_activate_object(alvo.object_index);
        alvo.vida = 100;
        alvo.vida -= _dano_final;
        
        // ✅ NOVO: Garantir que vida não fique positiva se é soldado
        if (alvo.vida > 0 && _is_soldado) {
            alvo.vida = -1; // Forçar destruição
        }
        
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo (fallback)! Dano: " + string(_dano_final) + " | Vida restante: " + string(alvo.vida));
        
        // ✅ NOVO: Verificar se alvo morreu e destruir imediatamente
        if (alvo.vida <= 0 && instance_exists(alvo)) {
            // ✅ CORREÇÃO: Verificar se função existe antes de chamar
            var _script_restos = asset_get_index("scr_criar_restos_unidade");
            if (_script_restos != -1) {
                scr_criar_restos_unidade(alvo);
            }
            instance_destroy(alvo);
        }
    }
    
    // ✅ CORREÇÃO: Usar posição do alvo para explosão (mais preciso)
    // ✅ CORREÇÃO CRÍTICA: Guardar posição ANTES de aplicar dano (alvo pode ser destruído)
    // ✅ CORREÇÃO: Remover 'var' para tornar propriedade da instância (acessível via 'other.' em 'with')
    _explosao_x = x; // Posição do projétil como fallback
    _explosao_y = y;
    if (instance_exists(alvo)) {
        _explosao_x = alvo.x;
        _explosao_y = alvo.y;
    }
    
    // Verificar se o alvo é aéreo ou terrestre
    var _alvo_aereo = false;
    if (instance_exists(alvo)) {
        _alvo_aereo = (alvo.object_index == obj_helicoptero_militar || 
                      alvo.object_index == obj_caca_f5 || 
                      alvo.object_index == obj_f6 ||
                      alvo.object_index == obj_f15 ||
                      alvo.object_index == obj_c100);
    }
    
    // ✅ NOVO: DANO EM ÁREA para mísseis terrestres (Constellation, navios, etc.)
    if (!_alvo_aereo && _dano_aplicado) {
        var _raio_dano_area = (variable_instance_exists(id, "raio_dano_area") ? raio_dano_area : 300);
        var _dano_area_valor = (variable_instance_exists(id, "dano_area") ? dano_area : 1000);
        
        // Lista de objetos terrestres para verificar
        var _tipos_unidades_terrestres = [
            obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo
        ];
        
        // ✅ NOVO: Adicionar M1A Abrams e Gepard se existirem
        var _obj_abrams = asset_get_index("obj_M1A_Abrams");
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            array_push(_tipos_unidades_terrestres, _obj_abrams);
        }
        var _obj_gepard = asset_get_index("obj_gepard");
        if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
            array_push(_tipos_unidades_terrestres, _obj_gepard);
        }
        
        var _unidades_atingidas = 0;
        for (var i = 0; i < array_length(_tipos_unidades_terrestres); i++) {
            with (_tipos_unidades_terrestres[i]) {
                // ✅ CORREÇÃO: Aplicar dano em área a TODAS as unidades, incluindo o alvo principal se ainda estiver vivo
                // (O alvo principal já recebeu dano direto acima, mas se ainda estiver vivo, aplicar dano em área também)
                var _eh_alvo_principal = (id == other.alvo);
                var _dist = point_distance(x, y, other._explosao_x, other._explosao_y);
                
                if (_dist <= _raio_dano_area) {
                    // ✅ NOVO: Se é o alvo principal e ainda está vivo, aplicar dano em área também
                    // (Isso garante que mesmo que o dano direto não tenha matado, o dano em área vai matar)
                    if (_eh_alvo_principal && instance_exists(id)) {
                        // Verificar se ainda está vivo
                        var _ainda_vivo = false;
                        if (variable_instance_exists(id, "hp_atual")) {
                            _ainda_vivo = (hp_atual > 0);
                        } else if (variable_instance_exists(id, "vida")) {
                            _ainda_vivo = (vida > 0);
                        } else if (variable_instance_exists(id, "hp")) {
                            _ainda_vivo = (hp > 0);
                        }
                        
                        // Se ainda está vivo, aplicar dano em área
                        if (_ainda_vivo) {
                            if (variable_instance_exists(id, "hp_atual")) {
                                hp_atual -= _dano_area_valor;
                                if (hp_atual <= 0) {
                                    instance_destroy(id);
                                }
                            } else if (variable_instance_exists(id, "vida")) {
                                vida -= _dano_area_valor;
                                if (vida <= 0) {
                                    // ✅ CORREÇÃO: Verificar se função existe antes de chamar
                                    var _script_restos = asset_get_index("scr_criar_restos_unidade");
                                    if (_script_restos != -1) {
                                        // ✅ CORREÇÃO: Verificar se função existe antes de chamar
                                    var _script_restos = asset_get_index("scr_criar_restos_unidade");
                                    if (_script_restos != -1) {
                                        scr_criar_restos_unidade(id);
                                    }
                                    }
                                    instance_destroy(id);
                                }
                            } else if (variable_instance_exists(id, "hp")) {
                                hp -= _dano_area_valor;
                                if (hp <= 0) {
                                    // ✅ CORREÇÃO: Verificar se função existe antes de chamar
                                    var _script_restos = asset_get_index("scr_criar_restos_unidade");
                                    if (_script_restos != -1) {
                                        // ✅ CORREÇÃO: Verificar se função existe antes de chamar
                                    var _script_restos = asset_get_index("scr_criar_restos_unidade");
                                    if (_script_restos != -1) {
                                        scr_criar_restos_unidade(id);
                                    }
                                    }
                                    instance_destroy(id);
                                }
                            }
                            _unidades_atingidas++;
                            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                                show_debug_message("💥💥 Alvo principal também atingido por dano em área!");
                            }
                        }
                    } else if (!_eh_alvo_principal) {
                        // Aplicar dano a outras unidades (como antes)
                        if (variable_instance_exists(id, "hp_atual")) {
                            hp_atual -= _dano_area_valor;
                            _unidades_atingidas++;
                        } else if (variable_instance_exists(id, "vida")) {
                            vida -= _dano_area_valor;
                            _unidades_atingidas++;
                        } else if (variable_instance_exists(id, "hp")) {
                            hp -= _dano_area_valor;
                            _unidades_atingidas++;
                        }
                    }
                }
            }
        }
        
        if (_unidades_atingidas > 0) {
            show_debug_message("💥💥 TIRO SIMPLES - DANO EM ÁREA! " + string(_unidades_atingidas) + " unidades atingidas no raio de " + string(_raio_dano_area) + "px!");
        }
    }
    
    // ✅ CRÍTICO: Criar explosão e definir sem_som = true imediatamente
    // O Step Event da explosão verificará sem_som antes de tocar som
    if (_alvo_aereo && object_exists(obj_explosao_ar)) {
        var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_ar);
        if (instance_exists(_explosao)) {
            _explosao.sem_som = true; // ✅ SEM SOM - DEFINIDO IMEDIATAMENTE
            _explosao.image_blend = make_color_rgb(255, 150, 0);
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
            _explosao.alarm[0] = 90; // ✅ CORREÇÃO: 1.5 segundos (90 frames)
        }
    } else if (object_exists(obj_explosao_terra)) {
        var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_terra);
        if (instance_exists(_explosao)) {
            _explosao.sem_som = true; // ✅ SEM SOM - DEFINIDO IMEDIATAMENTE
            _explosao.image_blend = make_color_rgb(255, 100, 0);
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
            _explosao.alarm[0] = 36; // ✅ REDUZIDO: 0.6 segundos (era 90)
        }
    } else if (object_exists(obj_explosao_aquatica)) {
        var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_aquatica);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(150, 200, 255);
            _explosao.image_xscale = 2.0;
            _explosao.image_yscale = 2.0;
            _explosao.image_angle = random(360);
            _explosao.timer_duracao = 24; // ✅ REDUZIDO: 0.4 segundos (era 60)
            _explosao.timer_atual = 0; // ✅ RESETAR TIMER
        }
    }
    
    // ✅ CRÍTICO: Destruir projétil IMEDIATAMENTE após acertar
    // ✅ FORÇAR: Tornar invisível e desativar ANTES de retornar ao pool
    visible = false;
    image_alpha = 0;
    image_xscale = 0;
    image_yscale = 0;
    speed = 0;
    
    // ✅ DESATIVAR IMEDIATAMENTE
    instance_deactivate_object(id);
    
    // ✅ TENTAR RETORNAR AO POOL, MAS SE FALHAR, DESTRUIR DIRETAMENTE
    var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
    if (!instance_exists(_pool_mgr) || !_pool_mgr.pool_enabled) {
        // Pool não disponível - destruir diretamente
        instance_destroy(id);
    } else {
        // Tentar retornar ao pool
        scr_return_projectile_to_pool(id);
    }
    
    exit;
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    // Explosão automática quando o projétil "expira"
    if (object_exists(obj_explosao_aquatica)) {
        var _explosao = instance_create_depth(x, y, 0, obj_explosao_aquatica);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 100, 100); // Vermelho para indicar que errou
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
            _explosao.image_angle = random(360);
            _explosao.timer_duracao = 24; // ✅ REDUZIDO: 0.4 segundos (era 60)
            _explosao.timer_atual = 0; // ✅ RESETAR TIMER
        }
    }
    
    // ✅ CRÍTICO: Destruir projétil IMEDIATAMENTE quando timer expira
    visible = false;
    image_alpha = 0;
    image_xscale = 0;
    image_yscale = 0;
    speed = 0;
    
    // ✅ DESATIVAR IMEDIATAMENTE
    instance_deactivate_object(id);
    
    // ✅ TENTAR RETORNAR AO POOL, MAS SE FALHAR, DESTRUIR DIRETAMENTE
    var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
    if (!instance_exists(_pool_mgr) || !_pool_mgr.pool_enabled) {
        // Pool não disponível - destruir diretamente
        instance_destroy(id);
    } else {
        // Tentar retornar ao pool
        scr_return_projectile_to_pool(id);
    }
    
    exit;
}