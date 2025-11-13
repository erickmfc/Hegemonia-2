/// @description Normaliza velocidade de unidade para manter velocidade visual constante independente do zoom
/// @param {real} base_speed Velocidade base da unidade
/// @return {real} Velocidade normalizada baseada no zoom atual

function scr_normalize_unit_speed(base_speed) {
    // Obter zoom atual
    var current_zoom = 3.5; // Default (zoom mínimo)
    if (instance_exists(obj_input_manager)) {
        current_zoom = obj_input_manager.zoom_level;
    }
    
    // Zoom de referência (zoom médio onde a velocidade visual é "correta")
    // Use um valor médio entre min (3.5) e max (25.0) = ~14.0
    // Ajuste este valor conforme necessário para calibrar a velocidade
    var zoom_reference = 10.0; // Ajuste este valor conforme necessário
    
    // Normalizar: zoom alto = mover mais devagar no mundo, zoom baixo = mover mais rápido
    // Isso mantém a velocidade visual (pixels/segundo na tela) constante
    var normalized_speed = base_speed * (zoom_reference / current_zoom);
    
    return normalized_speed;
}

