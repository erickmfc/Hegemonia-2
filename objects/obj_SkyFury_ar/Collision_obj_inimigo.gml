// Verificar se o alvo é aéreo antes de aplicar dano
var _alvo_aereo = false;
if (object_get_name(other.object_index) == "obj_f6" ||
    object_get_name(other.object_index) == "obj_caca_f5" ||
    object_get_name(other.object_index) == "obj_helicoptero_militar") {
    _alvo_aereo = true;
}

if (_alvo_aereo && instance_exists(other)) {
    // Aplicar dano seguro
    var _dano_aplicado = false;
    
    if (variable_instance_exists(other, "vida")) {
        other.vida -= dano;
        _dano_aplicado = true;
    } else if (variable_instance_exists(other, "hp_atual")) {
        other.hp_atual -= dano;
        _dano_aplicado = true;
    } else if (variable_instance_exists(other, "hp")) {
        other.hp -= dano;
        _dano_aplicado = true;
    } else {
        other.vida = 100;
        other.vida -= dano;
        _dano_aplicado = true;
    }
    
    if (_dano_aplicado) {
        show_debug_message("💥 SkyFury atingiu alvo aéreo! Dano: " + string(dano));
    }
}

// ✅ CORREÇÃO: Verificar se explosão já foi criada para evitar múltiplas criações
if (!variable_instance_exists(id, "explosao_criada")) {
    explosao_criada = false;
}
if (!explosao_criada && object_exists(obj_explosao_ar)) {
    explosao_criada = true; // Marcar como criada
    var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
    if (instance_exists(_explosao)) {
        if (variable_instance_exists(id, "sem_som")) {
            _explosao.sem_som = sem_som; // Passa flag para explosão
        }
        _explosao.image_blend = make_color_rgb(255,150,0);
        _explosao.image_xscale = 1.2;
        _explosao.image_yscale = 1.2;
        _explosao.alarm[0] = 90; // ✅ CORREÇÃO: 1.5 segundos (90 frames)
    }
}
// ✅ Som removido - sem som de impacto
instance_destroy();
