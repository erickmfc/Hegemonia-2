// Fumaça básica do míssil
image_alpha = 0.8;
image_scale = random_range(0.42, 0.7); // ✅ REDUZIDO 30%: 0.6*0.7=0.42, 1.0*0.7=0.7
vspeed = -0.2;
hspeed = random_range(-0.1, 0.1);
alarm[0] = game_get_speed(gamespeed_fps) * 0.8; // Dura 0.8 segundos
