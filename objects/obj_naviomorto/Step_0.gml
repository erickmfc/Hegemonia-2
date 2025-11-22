// ===============================================
// NAVIO MORTO - Step Event
// Desaparece após alguns segundos
// ===============================================

// ✅ Timer de vida
if (!variable_instance_exists(id, "timer_vida")) {
    timer_vida = 10.0 * game_get_speed(gamespeed_fps);  // 10 segundos
}

timer_vida--;

// ✅ Fade out gradual nos últimos 2 segundos
if (timer_vida <= 120) {  // Últimos 2 segundos
    image_alpha = timer_vida / 120.0;  // Fade de 1.0 para 0.0
}

// ✅ Destruir quando timer acabar
if (timer_vida <= 0) {
    instance_destroy();
}
