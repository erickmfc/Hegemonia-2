// ===============================================
// NAVIO MORTO - Create Event
// Restos de navio destruído
// ===============================================

// ✅ Timer de vida (desaparecer após alguns segundos)
tempo_vida = 10.0;  // 10 segundos
timer_vida = tempo_vida * game_get_speed(gamespeed_fps);

// ✅ Alpha inicial
image_alpha = 1.0;

show_debug_message("💀 Navio morto criado - desaparecerá em " + string(tempo_vida) + " segundos");
