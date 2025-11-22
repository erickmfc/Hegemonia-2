/// @description Dispara o míssil LIT inteligente
/// @param argument0 - atirador_id: Unidade que está disparando
/// @param argument1 - alvo_id: Alvo do míssil
/// @returns ID do míssil criado ou noone se falhar

var atirador_id = argument0;
var alvo_id = argument1;

if (!instance_exists(atirador_id) || !instance_exists(alvo_id)) {
    show_debug_message("❌ ERRO: Atirador ou alvo não existe para LIT");
    return noone;
}

// ✅ Tentar usar pool se disponível
var _lit = scr_get_projectile_from_pool(obj_lit, atirador_id.x, atirador_id.y, "Instances");

if (!instance_exists(_lit)) {
    // Fallback: criar diretamente
    _lit = instance_create_layer(atirador_id.x, atirador_id.y, "Projectiles", obj_lit);
}

if (instance_exists(_lit)) {
    // Configurar míssil LIT
    _lit.alvo = alvo_id;
    _lit.dono = atirador_id;
    
    // Calcular direção inicial
    var _angulo = point_direction(_lit.x, _lit.y, alvo_id.x, alvo_id.y);
    _lit.direction = _angulo;
    _lit.image_angle = _angulo;
    
    // Detectar tipo de alvo e ajustar propriedades
    _lit.tipo_alvo = _lit.func_detectar_tipo_alvo();
    _lit.func_ajustar_velocidade();
    
    show_debug_message("🔥 LIT DISPARADO!");
    show_debug_message("   Atirador: " + object_get_name(atirador_id.object_index));
    show_debug_message("   Alvo: " + object_get_name(alvo_id.object_index) + " (" + _lit.tipo_alvo + ")");
    show_debug_message("   Velocidade: " + string(_lit.speed) + "px/frame");
    show_debug_message("   Dano: " + string(_lit.dano) + " | Dano em Área: " + string(_lit.dano_area));
    
    return _lit;
} else {
    show_debug_message("❌ ERRO: Falha ao criar míssil LIT");
    return noone;
}