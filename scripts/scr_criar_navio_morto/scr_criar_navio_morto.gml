// ===============================================
// CRIAR NAVIO MORTO (obj_naviomorto)
// Quando qualquer navio é destruído
// ===============================================

/// @function scr_criar_navio_morto(_navio)
/// @description Cria obj_naviomorto quando navio é destruído
/// @param {id} _navio - Navio que foi destruído

function scr_criar_navio_morto(_navio) {
    if (!instance_exists(_navio)) {
        return noone;
    }
    
    // Verificar se obj_naviomorto existe
    var _obj_naviomorto = asset_get_index("obj_naviomorto");
    if (_obj_naviomorto == -1 || !object_exists(_obj_naviomorto)) {
        show_debug_message("⚠️ obj_naviomorto não encontrado!");
        return noone;
    }
    
    // Guardar posição e ângulo do navio antes de destruir
    var _pos_x = _navio.x;
    var _pos_y = _navio.y;
    var _angulo = _navio.image_angle;
    
    // Criar navio morto
    var _navio_morto = instance_create_layer(_pos_x, _pos_y, "Instances", _obj_naviomorto);
    
    if (instance_exists(_navio_morto)) {
        // Configurar posição e ângulo
        _navio_morto.x = _pos_x;
        _navio_morto.y = _pos_y;
        _navio_morto.image_angle = _angulo;
        
        // ✅ Tempo de vida (desaparecer após alguns segundos)
        if (!variable_instance_exists(_navio_morto, "tempo_vida")) {
            _navio_morto.tempo_vida = 10.0;  // 10 segundos
            _navio_morto.timer_vida = _navio_morto.tempo_vida * game_get_speed(gamespeed_fps);
        }
        
        show_debug_message("💀 Navio morto criado: " + object_get_name(_navio.object_index) + " em (" + string(_pos_x) + ", " + string(_pos_y) + ")");
        
        return _navio_morto;
    }
    
    return noone;
}
