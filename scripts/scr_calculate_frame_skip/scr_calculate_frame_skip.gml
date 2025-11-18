/// @description Calcula quantos frames pular baseado no LOD (OTIMIZADO)
/// @param {real} lod_level Nível de detalhe (0-3)
/// @param {real} instance_id ID da instância (para distribuir processamento)
/// @return {bool} true se deve processar neste frame, false para pular

function scr_calculate_frame_skip(lod_level, instance_id = 0) {
    // ✅ OTIMIZAÇÃO: Cache global de game_frame (atualizado pelo obj_game_manager)
    // Evita verificar variable_global_exists a cada chamada
    var frame = 0;
    if (variable_global_exists("game_frame")) {
        frame = global.game_frame;
    } else {
        // Inicializar apenas uma vez se não existir
        global.game_frame = 0;
        frame = 0;
    }
    
    // ✅ OTIMIZAÇÃO: Early return para LOD 3 (zoom próximo - sempre processar)
    if (lod_level >= 3) {
        return true;
    }
    
    // Distribuir processamento (evitar todos pularem no mesmo frame)
    var offset = instance_id mod 10; // Offset baseado no ID
    var frame_mod = (frame + offset);
    
    // ✅ OTIMIZAÇÃO: Usar switch-like com early returns
    // LOD 0 (zoom muito afastado) - Processar 1 a cada 10 frames (90% skip)
    if (lod_level == 0) {
        return (frame_mod mod 10) == 0;
    }
    
    // LOD 1 (zoom afastado) - Processar 1 a cada 5 frames (80% skip)
    if (lod_level == 1) {
        return (frame_mod mod 5) == 0;
    }
    
    // LOD 2 (zoom normal) - Processar 1 a cada 2 frames (50% skip)
    // lod_level == 2 (implícito)
    return (frame_mod mod 2) == 0;
}

/// @description Calcula frames a pular para movimento simplificado
/// @param {real} lod_level Nível de detalhe
/// @param {real} instance_id ID da instância
/// @return {real} Multiplicador de velocidade para compensar frames pulados

function scr_get_speed_multiplier(lod_level, instance_id = 0) {
    
    // Calcular quantos frames pular
    var skip_ratio = 1;
    
    if (lod_level == 0) {
        skip_ratio = 10; // Processar 1 a cada 10 = multiplicar por 10
    } else if (lod_level == 1) {
        skip_ratio = 5; // Processar 1 a cada 5 = multiplicar por 5
    } else if (lod_level == 2) {
        skip_ratio = 2; // Processar 1 a cada 2 = multiplicar por 2
    }
    
    return skip_ratio;
}