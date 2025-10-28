/// @description Colisão com Infantaria - Aeroporto Militar
// =============================================
// HEGEMONIA GLOBAL - SISTEMA DE COLISÃO FÍSICA
// =============================================

// === COLISÃO COM INFANTARIA ===
// Verificar se função existe antes de usar
if (instance_exists(other)) {
    var _deve_respeitar = true;
    
    // Chamar função se existir, senão usar padrão
    try {
        _deve_respeitar = scr_unidade_deve_respeitar_colisao_edificios(other);
    } catch (e) {
        _deve_respeitar = true; // Padrão: sempre respeitar
    }
    
    if (_deve_respeitar) {
        show_debug_message("🚫 Colisão detectada: Infantaria vs Aeroporto Militar");
        
        // Calcular direção oposta para empurrar a unidade
        var _angulo = point_direction(other.x, other.y, x, y);
        var _distancia = point_distance(other.x, other.y, x, y);
        
        // Se muito próximo, empurrar para longe
        if (_distancia < 32) {
            var _novo_x = other.x + lengthdir_x(16, _angulo);
            var _novo_y = other.y + lengthdir_y(16, _angulo);
            
            // Verificar se a nova posição é válida
            if (!position_meeting(_novo_x, _novo_y, obj_aeroporto_militar)) {
                other.x = _novo_x;
                other.y = _novo_y;
                show_debug_message("📍 Infantaria empurrada para: (" + string(_novo_x) + ", " + string(_novo_y) + ")");
            }
        }
    }
}
