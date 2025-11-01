/// @description Decide se objeto deve desenhar (otimização)
/// @param {Id.Instance} _obj ID da instância
/// @return {bool} true se deve desenhar, false para pular

function scr_should_draw(_obj) {
    
    if (!instance_exists(_obj)) return false;
    
    // ✅ SEMPRE desenhar se selecionado
    if (variable_instance_exists(_obj, "selecionado") && _obj.selecionado) {
        return true;
    }
    
    // ✅ Verificar se está visível na tela
    var _on_screen = scr_is_on_screen(_obj, 64); // Margem de 64 pixels
    
    if (!_on_screen) {
        return false; // Fora da tela - não desenhar
    }
    
    // ✅ Verificar LOD - objetos muito longe podem pular alguns draws
    var _lod = scr_get_lod_level();
    
    // LOD 0 (muito afastado) - desenhar apenas a cada 2 frames (opcional)
    // Nota: Sistema de frame skip de desenho pode ser adicionado no futuro
    // Por enquanto, apenas verificar visibilidade na tela
    
    return true; // Desenhar normalmente
}
