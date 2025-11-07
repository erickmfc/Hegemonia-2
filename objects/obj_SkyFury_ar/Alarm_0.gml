// Autodestruição após 2 segundos - criar explosão
// ✅ Som removido - sem som de impacto

// Criar explosão aérea na posição atual
if (object_exists(obj_explosao_ar)) {
    var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
    if (instance_exists(_explosao) && variable_instance_exists(id, "sem_som")) {
        _explosao.sem_som = sem_som; // Passa flag para explosão
    }
    show_debug_message("💥 SkyFury autodestruição - Explosão aérea!");
}

instance_destroy();
