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
        show_debug_message("💥 Ironclad atingiu inimigo terrestre! Dano: " + string(dano));
    }
}

// Criar explosão terrestre
var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
if (instance_exists(_explosao) && variable_instance_exists(id, "sem_som")) {
    _explosao.sem_som = sem_som; // Passa flag para explosão
}
// ✅ Som removido - sem som de impacto
instance_destroy();
