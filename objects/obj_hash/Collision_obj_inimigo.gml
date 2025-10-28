// Aplicar dano ao inimigo
if (instance_exists(other)) {
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
        show_debug_message("💥💥💥 MÍSSIL HASH ATINGIU INIMIGO! Dano: " + string(dano) + " (MÁXIMO)");
    }
}

// Criar explosão terrestre
instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
audio_stop_sound(snd_foguete_voando);
instance_destroy();
