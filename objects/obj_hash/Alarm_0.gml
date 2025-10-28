// Autodestruição após 3 segundos - criar explosão
// ✅ CORREÇÃO: Verificar se sound existe usando asset_get_index()
var _sound_index = asset_get_index("snd_foguete_voando");
if (_sound_index != -1) {
    audio_stop_sound(snd_foguete_voando);
}

// Criar explosão terrestre na posição atual
if (object_exists(obj_explosao_terra)) {
    instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
    show_debug_message("💥💥 MÍSSIL HASH AUTODESTRUIÇÃO - Explosão Terrestre!");
}

instance_destroy();
