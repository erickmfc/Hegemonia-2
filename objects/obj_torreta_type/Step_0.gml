// ===============================================
// HEGEMONIA GLOBAL - TORRETA TYPE
// Step Event - Sistema de Metralhadora Anti-Terrestre
// ===============================================

// === VERIFICAÇÃO DE VIDA ===
if (vida_atual <= 0) {
    instance_destroy();
    exit;
}

// === DECREMENTAR COOLDOWNS ===
if (atq_cooldown > 0) atq_cooldown--;
if (metralhadora_cooldown > 0) metralhadora_cooldown--;

// === DETECÇÃO DE ALVOS TERRESTRES ===
// Só procura novo alvo se não estiver atacando ou se o alvo foi destruído
if (estado != "atacando" || alvo_inimigo == noone || !instance_exists(alvo_inimigo)) {
    alvo_inimigo = noone;
    
    // Buscar apenas alvos TERRESTRES (infantaria, tanques, etc)
    var _alvo_infantaria = noone;
    var _alvo_tanque = noone;
    var _alvo_abrams = noone;
    var _alvo_gepard = noone;
    
    // Buscar infantaria
    if (object_exists(obj_infantaria)) {
        _alvo_infantaria = instance_nearest(x, y, obj_infantaria);
    }
    
    // Buscar tanques
    if (object_exists(obj_tanque)) {
        _alvo_tanque = instance_nearest(x, y, obj_tanque);
    }
    
    // Buscar M1A Abrams
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        _alvo_abrams = instance_nearest(x, y, _obj_abrams);
    }
    
    // Buscar Gepard
    var _obj_gepard = asset_get_index("obj_gepard");
    if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
        _alvo_gepard = instance_nearest(x, y, _obj_gepard);
    }
    
    // Escolher o alvo mais próximo (prioridade: infantaria > tanques)
    var _menor_dist = metralhadora_alcance + 100;
    var _alvo_escolhido = noone;
    
    if (instance_exists(_alvo_infantaria)) {
        var _dist = point_distance(x, y, _alvo_infantaria.x, _alvo_infantaria.y);
        var _eh_inimigo = true;
        if (variable_instance_exists(_alvo_infantaria, "nacao_proprietaria") && 
            variable_instance_exists(id, "nacao_proprietaria")) {
            _eh_inimigo = (_alvo_infantaria.nacao_proprietaria != nacao_proprietaria);
        }
        if (_eh_inimigo && _dist < _menor_dist && _dist <= metralhadora_alcance) {
            _menor_dist = _dist;
            _alvo_escolhido = _alvo_infantaria;
        }
    }
    
    if (instance_exists(_alvo_tanque)) {
        var _dist = point_distance(x, y, _alvo_tanque.x, _alvo_tanque.y);
        var _eh_inimigo = true;
        if (variable_instance_exists(_alvo_tanque, "nacao_proprietaria") && 
            variable_instance_exists(id, "nacao_proprietaria")) {
            _eh_inimigo = (_alvo_tanque.nacao_proprietaria != nacao_proprietaria);
        }
        if (_eh_inimigo && _dist < _menor_dist && _dist <= metralhadora_alcance) {
            _menor_dist = _dist;
            _alvo_escolhido = _alvo_tanque;
        }
    }
    
    if (instance_exists(_alvo_abrams)) {
        var _dist = point_distance(x, y, _alvo_abrams.x, _alvo_abrams.y);
        var _eh_inimigo = true;
        if (variable_instance_exists(_alvo_abrams, "nacao_proprietaria") && 
            variable_instance_exists(id, "nacao_proprietaria")) {
            _eh_inimigo = (_alvo_abrams.nacao_proprietaria != nacao_proprietaria);
        }
        if (_eh_inimigo && _dist < _menor_dist && _dist <= metralhadora_alcance) {
            _menor_dist = _dist;
            _alvo_escolhido = _alvo_abrams;
        }
    }
    
    if (instance_exists(_alvo_gepard)) {
        var _dist = point_distance(x, y, _alvo_gepard.x, _alvo_gepard.y);
        var _eh_inimigo = true;
        if (variable_instance_exists(_alvo_gepard, "nacao_proprietaria") && 
            variable_instance_exists(id, "nacao_proprietaria")) {
            _eh_inimigo = (_alvo_gepard.nacao_proprietaria != nacao_proprietaria);
        }
        if (_eh_inimigo && _dist < _menor_dist && _dist <= metralhadora_alcance) {
            _menor_dist = _dist;
            _alvo_escolhido = _alvo_gepard;
        }
    }
    
    if (instance_exists(_alvo_escolhido)) {
        alvo_inimigo = _alvo_escolhido;
        estado = "atacando";
    } else {
        estado = "ocioso";
    }
}

// === SISTEMA DE TIRO (METRALHADORA) ===
if (estado == "atacando" && instance_exists(alvo_inimigo)) {
    var _dist_alvo = point_distance(x, y, alvo_inimigo.x, alvo_inimigo.y);
    
    // Verificar se alvo ainda está no alcance
    if (_dist_alvo > metralhadora_alcance) {
        estado = "ocioso";
        alvo_inimigo = noone;
    } else {
        // ✅ ATIRAR COM METRALHADORA (CONTÍNUO - sem pausa)
        // Remover verificação de cooldown para tiro contínuo
        if (true) { // Sempre atirar quando tiver alvo
            // Criar tiro de metralhadora
            var _obj_tiro_metralha = asset_get_index("obj_tiro_metralha");
            if (_obj_tiro_metralha != -1 && asset_get_type(_obj_tiro_metralha) == asset_object) {
                // Determinar layer (com fallback)
                var _layer_tiro = "Instances";
                if (variable_instance_exists(id, "layer") && !is_undefined(layer)) {
                    _layer_tiro = layer;
                }
                
                // Tentar usar pool primeiro
                var _tiro = scr_get_projectile_from_pool(_obj_tiro_metralha, x, y, _layer_tiro);
                
                // Se pool não retornou, criar diretamente
                if (!instance_exists(_tiro)) {
                    _tiro = instance_create_layer(x, y, _layer_tiro, _obj_tiro_metralha);
                }
                
                if (instance_exists(_tiro)) {
                    // Configurar tiro
                    var _angulo = point_direction(x, y, alvo_inimigo.x, alvo_inimigo.y);
                    _tiro.direction = _angulo;
                    _tiro.image_angle = _angulo;
                    _tiro.alvo = alvo_inimigo;
                    _tiro.dono = id;
                    _tiro.dano = dano_por_tiro; // Dano de 5
                    _tiro.visible = true;
                    _tiro.image_alpha = 1.0;
                    
                    // Configurar velocidade do tiro
                    if (variable_instance_exists(_tiro, "speed")) {
                        _tiro.speed = 10; // Velocidade rápida para metralhadora
                    }
                    
                    // ✅ TOCAR SOM DE METRALHADORA A CADA TIRO (apenas a cada 3 tiros para não sobrecarregar)
                    if (metralhadora_cooldown <= 0) {
                        var _som_metralhadora = asset_get_index("som_metralhadora");
                        if (_som_metralhadora != -1) {
                            audio_play_sound(_som_metralhadora, 3, false);
                        }
                        metralhadora_cooldown = 6; // Som a cada 6 frames (10 vezes por segundo)
                    }
                    
                    // Resetar cooldown da metralhadora (para controle de taxa de tiro)
                    metralhadora_cooldown = metralhadora_intervalo;
                }
            }
        }
        
        // Rotacionar torreta em direção ao alvo
        var _angulo_alvo = point_direction(x, y, alvo_inimigo.x, alvo_inimigo.y);
        image_angle = lerp(image_angle, _angulo_alvo, 0.2); // Rotação suave
    }
} else {
    estado = "ocioso";
}
