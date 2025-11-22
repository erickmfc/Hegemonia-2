/// @description Cria restos de unidade destruída (genérico para todas as unidades)
/// @param {instance} _unidade Unidade que foi destruída
/// @return {instance} ID da instância criada ou noone

function scr_criar_restos_unidade(_unidade) {
    if (!instance_exists(_unidade)) {
        return noone;
    }
    
    // Guardar informações da unidade antes de destruir
    var _pos_x = _unidade.x;
    var _pos_y = _unidade.y;
    var _angulo = _unidade.image_angle;
    var _sprite_unidade = _unidade.sprite_index;
    var _sprite_scale_x = _unidade.image_xscale;
    var _sprite_scale_y = _unidade.image_yscale;
    
    // ✅ NOVO: Verificar se é um avião (TODOS os tipos de aviões)
    var _eh_aviao = false;
    var _tipos_avioes = [
        obj_f15,
        obj_su35,
        obj_c100,
        obj_caca_f5,
        obj_helicoptero_militar,
        obj_f6,
        obj_SkyFury_ar
    ];
    
    // Verificar se o objeto está na lista de aviões
    for (var i = 0; i < array_length(_tipos_avioes); i++) {
        if (_unidade.object_index == _tipos_avioes[i]) {
            _eh_aviao = true;
            break;
        }
    }
    
    // ✅ APENAS AVIÕES: Se for avião, usar sistema específico de avião morto
    if (_eh_aviao) {
        // Verificar se obj_aviao_morto existe
        if (!object_exists(obj_aviao_morto)) {
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚠️ obj_aviao_morto não existe! Não é possível criar avião morto.");
            }
            return noone;
        }
        
        // ✅ NOVO: Ajustar posição Y para o chão (remover altitude se existir)
        var _pos_y_chao = _pos_y;
        if (variable_instance_exists(_unidade, "altitude_voo")) {
            _pos_y_chao = _pos_y - _unidade.altitude_voo; // Ajustar para o chão
        } else if (variable_instance_exists(_unidade, "altura_voo")) {
            _pos_y_chao = _pos_y - _unidade.altura_voo; // Ajustar para o chão
        }
        
        // Criar instância do avião morto no chão
        var _aviao_morto = instance_create_layer(_pos_x, _pos_y_chao, "Instances", obj_aviao_morto);
        
        if (instance_exists(_aviao_morto)) {
            // Configurar posição e ângulo
            _aviao_morto.x = _pos_x;
            _aviao_morto.y = _pos_y_chao;
            _aviao_morto.image_angle = _angulo;
            
            // Usar sprite do avião destruído
            if (sprite_exists(_sprite_unidade)) {
                _aviao_morto.sprite_index = _sprite_unidade;
                _aviao_morto.image_xscale = _sprite_scale_x;
                _aviao_morto.image_yscale = _sprite_scale_y;
            }
            
            // ✅ NOVO: Tempo de vida para "alguns poucos segundos" (3-5 segundos)
            _aviao_morto.tempo_vida = 4.0; // 4 segundos
            _aviao_morto.tempo_restante = _aviao_morto.tempo_vida * game_get_speed(gamespeed_fps);
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("💀 Avião morto criado: " + object_get_name(_unidade.object_index) + " em (" + string(_pos_x) + ", " + string(_pos_y_chao) + ") - no chão");
            }
            
            return _aviao_morto;
        }
        
        return noone;
    }
    
    // ✅ OUTRAS UNIDADES: Não criar nada (apenas aviões criam avião morto)
    // Retornar noone para unidades terrestres, navais, etc.
    return noone;
}

