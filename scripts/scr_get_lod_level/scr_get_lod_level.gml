/// @description Determina nível de detalhe baseado no zoom
/// @return {real} LOD level (0-3)

function scr_get_lod_level() {
    var zoom = 0.95; // Default
    if (instance_exists(obj_input_manager)) {
        zoom = obj_input_manager.zoom_level;
    }
    
    // LOD baseado em zoom
    if (zoom >= 2.0) return 3;      // Máximo detalhe (zoom muito próximo)
    else if (zoom >= 0.8) return 2;  // Detalhe normal
    else if (zoom >= 0.4) return 1;  // Detalhe reduzido
    else return 0;                        // Mínimo detalhe (zoom muito afastado)
}