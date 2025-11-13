// Fumaça básica do míssil
image_alpha = 0.8;
image_scale = random_range(0.21, 0.35); // ✅ REDUZIDO 50%: 0.42*0.5=0.21, 0.7*0.5=0.35
vspeed = -0.2;
hspeed = random_range(-0.1, 0.1);
alarm[0] = game_get_speed(gamespeed_fps) * 0.8; // Dura 0.8 segundos
