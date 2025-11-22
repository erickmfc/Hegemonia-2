// ===============================================
// FORMAÇÃO EM ESQUADRÃO - NAVIOS PIRATAS
// ===============================================

function scr_formacao_esquadrao_pirata(_navio_lider, _navio_seguidor, _offset_angulo, _distancia_formacao) {
    if (!instance_exists(_navio_lider) || !instance_exists(_navio_seguidor)) {
        return [0, 0];
    }
    
    // ✅ CORREÇÃO: Distância mínima de segurança
    var _distancia_minima = 150;  // Mínimo 150px entre navios
    if (_distancia_formacao < _distancia_minima) {
        _distancia_formacao = _distancia_minima;
    }
    
    var _dir_lider = _navio_lider.image_angle;
    var _angulo_offset = _dir_lider + _offset_angulo;
    
    var _x_alvo = _navio_lider.x + lengthdir_x(_distancia_formacao, _angulo_offset);
    var _y_alvo = _navio_lider.y + lengthdir_y(_distancia_formacao, _angulo_offset);
    
    // ✅ CORREÇÃO: Verificar se está muito perto do líder
    var _dist_atual = point_distance(_navio_seguidor.x, _navio_seguidor.y, _navio_lider.x, _navio_lider.y);
    if (_dist_atual < _distancia_minima) {
        // Muito perto - afastar mais
        var _dir_afastar = point_direction(_navio_lider.x, _navio_lider.y, _navio_seguidor.x, _navio_seguidor.y);
        _x_alvo = _navio_lider.x + lengthdir_x(_distancia_formacao * 1.5, _dir_afastar);
        _y_alvo = _navio_lider.y + lengthdir_y(_distancia_formacao * 1.5, _dir_afastar);
    }
    
    return [_x_alvo, _y_alvo];
}
