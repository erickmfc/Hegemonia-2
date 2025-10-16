// Colisão com alvo aéreo ou parede
instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
audio_stop_sound(snd_foguete_voando);
instance_destroy();
