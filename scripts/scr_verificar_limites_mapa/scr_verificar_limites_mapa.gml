/// @function scr_verificar_limites_mapa(_pos_x, _pos_y, _largura, _altura)
/// @description Verifica se a estrutura está completamente dentro dos limites do mapa
/// @param {Real} _pos_x Posição X no mundo
/// @param {Real} _pos_y Posição Y no mundo
/// @param {Real} _largura Largura da estrutura
/// @param {Real} _altura Altura da estrutura
/// @return {Bool} true se está dentro dos limites, false caso contrário

function scr_verificar_limites_mapa(_pos_x, _pos_y, _largura, _altura) {
    
    // === VERIFICAÇÕES DE SEGURANÇA ===
    if (!variable_global_exists("map_width") || !variable_global_exists("map_height")) {
        show_debug_message("❌ ERRO: Dimensões do mapa não definidas!");
        return false;
    }
    
    if (!variable_global_exists("tile_size")) {
        show_debug_message("❌ ERRO: global.tile_size não existe!");
        return false;
    }
    
    // === CALCULAR LIMITES DO MAPA EM PIXELS ===
    var _tile_size = global.tile_size;
    var _mapa_largura_pixels = global.map_width * _tile_size;
    var _mapa_altura_pixels = global.map_height * _tile_size;
    
    // === CALCULAR ÁREA DA ESTRUTURA ===
    var _area_x1 = _pos_x - _largura / 2;
    var _area_y1 = _pos_y - _altura / 2;
    var _area_x2 = _pos_x + _largura / 2;
    var _area_y2 = _pos_y + _altura / 2;
    
    // === VERIFICAR SE TODA A ÁREA ESTÁ DENTRO DOS LIMITES ===
    // Adicionar margem de segurança (10 pixels)
    var _margem = 10;
    
    if (_area_x1 < _margem || _area_x2 > _mapa_largura_pixels - _margem) {
        show_debug_message("❌ Estrutura fora dos limites horizontais: X1=" + string(_area_x1) + ", X2=" + string(_area_x2) + ", Limite=" + string(_mapa_largura_pixels));
        return false;
    }
    
    if (_area_y1 < _margem || _area_y2 > _mapa_altura_pixels - _margem) {
        show_debug_message("❌ Estrutura fora dos limites verticais: Y1=" + string(_area_y1) + ", Y2=" + string(_area_y2) + ", Limite=" + string(_mapa_altura_pixels));
        return false;
    }
    
    // === SUCESSO: ESTÁ DENTRO DOS LIMITES ===
    return true;
}

