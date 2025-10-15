/// @description Lança míssil ar-ar do F6 contra alvo aéreo
/// @param {Id.Instance} atacante_id ID do F6 atacante
/// @param {Id.Instance} alvo_id ID do alvo aéreo
/// @param {Real} dano Dano do míssil

function scr_lancar_missil_ar_ar(atacante_id, alvo_id, dano) {
    // Verificar se ambas as instâncias existem
    if (!instance_exists(atacante_id) || !instance_exists(alvo_id)) {
        show_debug_message("❌ ERRO: Atacante ou alvo não existe para míssil ar-ar");
        return false;
    }
    
    var atacante = atacante_id;
    var alvo = alvo_id;
    
    // Calcular direção do míssil
    var _angulo = point_direction(atacante.x, atacante.y, alvo.x, alvo.y);
    
    // Criar míssil usando obj_tiro_simples (sistema funcionando)
    var _missil = instance_create(atacante.x, atacante.y, obj_tiro_simples);
    
    if (instance_exists(_missil)) {
        // Configurar míssil ar-ar
        _missil.alvo = alvo;
        _missil.dano = dano;
        _missil.speed = 12; // Velocidade alta para míssil ar-ar
        _missil.timer_vida = 120; // Tempo de vida curto
        _missil.direction = _angulo;
        
        // Configurações visuais para míssil ar-ar
        _missil.image_xscale = 2.5;
        _missil.image_yscale = 2.5;
        _missil.image_blend = c_red; // Vermelho para ar-ar
        
        show_debug_message("🚀 F-6 lançou míssil ar-ar! Dano: " + string(dano) + " | Velocidade: " + string(_missil.speed));
        return true;
    } else {
        show_debug_message("❌ ERRO: Falha ao criar míssil ar-ar");
        return false;
    }
}
