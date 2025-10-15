/// @description Lança míssil ar-terra do F6 contra alvo terrestre
/// @param {Id.Instance} atacante_id ID do F6 atacante
/// @param {Id.Instance} alvo_id ID do alvo terrestre
/// @param {Real} dano Dano do míssil

function scr_lancar_missil_ar_terra(atacante_id, alvo_id, dano) {
    // Verificar se ambas as instâncias existem
    if (!instance_exists(atacante_id) || !instance_exists(alvo_id)) {
        show_debug_message("❌ ERRO: Atacante ou alvo não existe para míssil ar-terra");
        return false;
    }
    
    var atacante = atacante_id;
    var alvo = alvo_id;
    
    // Calcular direção do míssil
    var _angulo = point_direction(atacante.x, atacante.y, alvo.x, alvo.y);
    
    // Criar míssil usando obj_tiro_simples (sistema funcionando)
    var _missil = instance_create(atacante.x, atacante.y, obj_tiro_simples);
    
    if (instance_exists(_missil)) {
        // Configurar míssil ar-terra
        _missil.alvo = alvo;
        _missil.dano = dano;
        _missil.speed = 10; // Velocidade média para míssil ar-terra
        _missil.timer_vida = 150; // Tempo de vida maior
        _missil.direction = _angulo;
        
        // Configurações visuais para míssil ar-terra
        _missil.image_xscale = 2.0;
        _missil.image_yscale = 2.0;
        _missil.image_blend = c_yellow; // Amarelo para ar-terra
        
        show_debug_message("🚀 F-6 lançou míssil ar-terra! Dano: " + string(dano) + " | Velocidade: " + string(_missil.speed));
        return true;
    } else {
        show_debug_message("❌ ERRO: Falha ao criar míssil ar-terra");
        return false;
    }
}
