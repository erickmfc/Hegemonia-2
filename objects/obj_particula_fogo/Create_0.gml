// ===============================================
// HEGEMONIA GLOBAL - PARTÍCULA DE FOGO
// Efeito Visual Simples para Explosões
// ===============================================

// === CONFIGURAÇÕES ===
tempo_vida = 0;
tempo_vida_maximo = 30;         // 0.5 segundos
velocidade_decaimento = 0.95;   // Redução de velocidade

// === INICIALIZAÇÃO ===
image_alpha = 1.0;
image_blend = make_color_rgb(255, 150, 50); // Laranja
image_scale = random_range(0.5, 1.0);

// === MOVIMENTO ===
if (variable_instance_exists(self, "speed")) {
    // Se tem velocidade definida, usa ela
} else {
    speed = random_range(2, 6);
}

if (variable_instance_exists(self, "direction")) {
    // Se tem direção definida, usa ela
} else {
    direction = random(360);
}

show_debug_message("🔥 Partícula de fogo criada");
