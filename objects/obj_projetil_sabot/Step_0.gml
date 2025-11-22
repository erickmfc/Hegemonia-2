// ================================================
// HEGEMONIA GLOBAL - OBJETO: PROJÉTIL SABOT (M1A Abrams)
// Step Event - Sistema de Projétil com Pooling
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

// Movimento em direção ao alvo
x += lengthdir_x(speed, _dir);
y += lengthdir_y(speed, _dir);

// === COLISÃO E DANO ===
// ✅ CORREÇÃO CRÍTICA: Verificar colisão usando linha (detecta se passou pelo alvo)
var _distancia_atual = point_distance(x, y, alvo.x, alvo.y);
var _distancia_anterior = point_distance(_x_anterior, _y_anterior, alvo.x, alvo.y);

// ✅ NOVO: Verificar se passou pelo alvo (distância anterior > atual) OU se está muito perto
var _raio_colisao = 25; // Raio fixo maior para garantir detecção
var _passou_pelo_alvo = (_distancia_anterior > _distancia_atual && _distancia_atual <= _raio_colisao);
var _esta_muito_perto = (_distancia_atual <= _raio_colisao);

// ✅ CORREÇÃO: Também verificar colisão por linha (mais preciso para projéteis rápidos)
var _colisao_linha = false;
if (variable_instance_exists(alvo, "sprite_index") && sprite_exists(alvo.sprite_index)) {
    _colisao_linha = collision_line(_x_anterior, _y_anterior, x, y, alvo, false, true);
}

if (_passou_pelo_alvo || _esta_muito_perto || _colisao_linha) {
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
    
    // Aplicar dano
    var _dano_aplicado = false;
    
    if (variable_instance_exists(alvo, "hp_atual")) {
        alvo.hp_atual -= dano;
        _dano_aplicado = true;
        
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
    } else if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= dano;
        _dano_aplicado = true;
        
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
    } else if (variable_instance_exists(alvo, "hp")) {
        alvo.hp -= dano;
        _dano_aplicado = true;
        
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
    }
    
    // ✅ NOVO: Aplicar dano de área se configurado
    if (_dano_aplicado && variable_instance_exists(id, "dano_area") && variable_instance_exists(id, "raio_area")) {
        var _dano_area_val = dano_area;
        var _raio_area_val = raio_area;
        if (_dano_area_val > 0 && _raio_area_val > 0) {
            // Aplicar dano de área em unidades próximas
            var _explosao_x = x;
            var _explosao_y = y;
            if (instance_exists(alvo)) {
                _explosao_x = alvo.x;
                _explosao_y = alvo.y;
            }
            
            // Buscar unidades no raio de explosão
            with (obj_infantaria) {
                if (point_distance(_explosao_x, _explosao_y, x, y) <= _raio_area_val) {
                    if (variable_instance_exists(id, "hp")) hp -= _dano_area_val;
                    else if (variable_instance_exists(id, "hp_atual")) hp_atual -= _dano_area_val;
                }
            }
            with (obj_tanque) {
                if (point_distance(_explosao_x, _explosao_y, x, y) <= _raio_area_val) {
                    if (variable_instance_exists(id, "hp")) hp -= _dano_area_val;
                    else if (variable_instance_exists(id, "hp_atual")) hp_atual -= _dano_area_val;
                }
            }
            // ✅ NOVO: Verificar M1A Abrams também
            var _obj_abrams = asset_get_index("obj_M1A_Abrams");
            if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                with (_obj_abrams) {
                    if (point_distance(_explosao_x, _explosao_y, x, y) <= _raio_area_val) {
                        if (variable_instance_exists(id, "hp")) hp -= _dano_area_val;
                        else if (variable_instance_exists(id, "hp_atual")) hp_atual -= _dano_area_val;
                    }
                }
            }
        }
    }
    
    if (_dano_aplicado) {
        // ✅ CORREÇÃO: Usar posição do alvo para explosão (mais preciso)
        // ✅ CORREÇÃO CRÍTICA: Guardar posição ANTES de aplicar dano (alvo pode ser destruído)
        var _explosao_x = x; // Posição do projétil como fallback
        var _explosao_y = y;
        if (instance_exists(alvo)) {
            _explosao_x = alvo.x;
            _explosao_y = alvo.y;
        }
        
        // === EXPLOSÃO VISUAL ===
        if (object_exists(obj_explosao_pequena)) {
            var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_pequena);
            if (instance_exists(_explosao)) {
                _explosao.image_blend = make_color_rgb(255, 200, 50);
                _explosao.image_xscale = 1.2;
                _explosao.image_yscale = 1.2;
            }
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
