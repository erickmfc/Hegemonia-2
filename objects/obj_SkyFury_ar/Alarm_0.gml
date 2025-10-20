// Autodestruição após 2 segundos - criar explosão
audio_stop_sound(snd_foguete_voando);

// Criar explosão aérea na posição atual
if (object_exists(obj_explosao_ar)) {
    instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
    show_debug_message("💥 SkyFury autodestruição - Explosão aérea!");
}

instance_destroy();
