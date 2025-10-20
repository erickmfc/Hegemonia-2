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

// Criar explosão aérea
instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
audio_stop_sound(snd_foguete_voando);
instance_destroy();
