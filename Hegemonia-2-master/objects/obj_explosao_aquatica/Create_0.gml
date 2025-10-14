// Duração do efeito em frames (1 segundo para explosão)
timer_duracao = 60; // 60 frames = 1 segundo
timer_atual = 0;
image_alpha = 1; // Começa totalmente visível

// === CONFIGURAÇÕES VISUAIS MELHORADAS ===
image_xscale = 5.0; // Aumentar tamanho para melhor visibilidade
image_yscale = 5.0;
image_blend = make_color_rgb(100, 150, 255); // Azul claro
image_angle = random(360); // Rotação aleatória
