// Autodestruição após 2 segundos - criar explosão
// ✅ Som removido - sem som de impacto

// Criar explosão terrestre na posição atual
if (object_exists(obj_explosao_terra)) {
    var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
    if (instance_exists(_explosao) && variable_instance_exists(id, "sem_som")) {
        _explosao.sem_som = sem_som; // Passa flag para explosão
    }
    show_debug_message("💥 Ironclad autodestruição - Explosão terrestre!");
}

instance_destroy();
