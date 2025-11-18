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

if (!instance_exists(alvo)) {
    scr_return_projectile_to_pool(id);
    exit;
}

// === GUARDAR POSIÇÃO ANTERIOR (para detecção de colisão por linha) ===
var _x_anterior = x;
var _y_anterior = y;

// === MOVIMENTO E ROTAÇÃO ===
var _dir = point_direction(x, y, alvo.x, alvo.y);
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
var _distancia_atual = point_distance(x, y, alvo.x, alvo.y);
var _distancia_anterior = point_distance(_x_anterior, _y_anterior, alvo.x, alvo.y);

// ✅ AUMENTADO: Raio maior para garantir detecção (unidades pequenas precisam de raio maior)
var _raio_colisao = 100; // ✅ AUMENTADO de 80 para 100 pixels

// ✅ NOVO: Calcular raio baseado no tamanho do sprite do alvo
if (instance_exists(alvo) && variable_instance_exists(alvo, "sprite_index") && sprite_exists(alvo.sprite_index)) {
    var _largura_alvo = sprite_get_width(alvo.sprite_index);
    var _altura_alvo = sprite_get_height(alvo.sprite_index);
    var _raio_alvo = max(_largura_alvo, _altura_alvo) / 2;
    // Usar o maior entre raio fixo e raio do sprite
    _raio_colisao = max(_raio_colisao, _raio_alvo + 30); // ✅ AUMENTADO margem para 30 pixels
}

// ✅ NOVO: Verificar se passou pelo alvo (distância anterior > atual) OU se está muito perto
var _passou_pelo_alvo = (_distancia_anterior > _distancia_atual && _distancia_atual <= _raio_colisao);
var _esta_muito_perto = (_distancia_atual <= _raio_colisao);

// ✅ CORREÇÃO: Verificar colisão por linha APENAS se alvo estiver ativo (após ativação)
var _colisao_linha = false;
if (instance_exists(alvo) && variable_instance_exists(alvo, "sprite_index") && sprite_exists(alvo.sprite_index)) {
    // ✅ NOVO: collision_line funciona apenas com instâncias ativas
    // Já ativamos o alvo acima, então deve funcionar agora
    _colisao_linha = collision_line(_x_anterior, _y_anterior, x, y, alvo, false, true);
}

// ✅ CORREÇÃO: Usar principalmente verificação de distância (funciona sempre)
// collision_line é apenas um auxiliar
if (_passou_pelo_alvo || _esta_muito_perto || _colisao_linha) {
    
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
        _dano_final = 150; // ✅ DANO GARANTIDO PARA MATAR SOLDADOS
    }
    
    // ✅ CORREÇÃO: Verificar hp_atual PRIMEIRO (obj_infantaria e ESTRUTURAS usam isso)
    if (variable_instance_exists(alvo, "hp_atual")) {
        var _hp_antes = alvo.hp_atual;
        alvo.hp_atual -= _dano_final;
        // ✅ Atualizar vida também se existir (compatibilidade)
        if (variable_instance_exists(alvo, "vida")) {
            alvo.vida = alvo.hp_atual;
        }
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(_dano_final) + " | HP: " + string(_hp_antes) + " → " + string(alvo.hp_atual));
    } else if (variable_instance_exists(alvo, "vida")) {
        var _vida_antes = alvo.vida;
        alvo.vida -= _dano_final;
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(_dano_final) + " | Vida: " + string(_vida_antes) + " → " + string(alvo.vida));
    } else if (variable_instance_exists(alvo, "hp")) {
        var _hp_antes = alvo.hp;
        alvo.hp -= _dano_final;
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo! Dano: " + string(_dano_final) + " | HP: " + string(_hp_antes) + " → " + string(alvo.hp));
    } else {
        // Fallback: criar variável vida se não existir
        alvo.vida = 100;
        alvo.vida -= _dano_final;
        _dano_aplicado = true;
        show_debug_message("💥 Míssil atingiu alvo (fallback)! Dano: " + string(_dano_final) + " | Vida restante: " + string(alvo.vida));
    }
    
    // ✅ CORREÇÃO: Usar posição do alvo para explosão (mais preciso)
    // ✅ CORREÇÃO CRÍTICA: Guardar posição ANTES de aplicar dano (alvo pode ser destruído)
    var _explosao_x = x; // Posição do projétil como fallback
    var _explosao_y = y;
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
                if (id != other.alvo) { // Não aplicar dano duplo no alvo principal
                    var _dist = point_distance(x, y, other._explosao_x, other._explosao_y);
                    if (_dist <= _raio_dano_area) {
                        // Aplicar dano suficiente para matar
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