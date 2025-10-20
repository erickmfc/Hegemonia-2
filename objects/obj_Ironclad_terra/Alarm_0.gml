// Autodestruição após 2 segundos - criar explosão
audio_stop_sound(snd_foguete_voando);

// Criar explosão terrestre na posição atual
if (object_exists(obj_explosao_terra)) {
    instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
    show_debug_message("💥 Ironclad autodestruição - Explosão terrestre!");
}

instance_destroy();
