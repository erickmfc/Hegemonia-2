/// @description Calcula escala da UI baseada na resolução de referência
/// @return {real} Escala da UI (1.0 = resolução padrão, >1.0 = tela maior, <1.0 = tela menor)

function scr_calcular_escala_ui() {
    // Resolução de referência (resolução para a qual o jogo foi projetado)
    var _ref_width = 1920;  // Largura de referência
    var _ref_height = 1080; // Altura de referência
    
    // Resolução atual da tela
    var _current_width = display_get_gui_width();
    var _current_height = display_get_gui_height();
    
    // Calcular escala baseada na menor dimensão (para manter proporção)
    var _scale_x = _current_width / _ref_width;
    var _scale_y = _current_height / _ref_height;
    
    // Usar a menor escala para garantir que tudo caiba na tela
    var _scale = min(_scale_x, _scale_y);
    
    // Limitar escala entre 0.5 e 2.0 para evitar extremos
    _scale = clamp(_scale, 0.5, 2.0);
    
    return _scale;
}
