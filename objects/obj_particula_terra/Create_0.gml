// ===============================================
// HEGEMONIA GLOBAL - PARTÍCULA DE TERRA
// Efeito Visual Simples para Explosões Terrestres
// ===============================================

// === CONFIGURAÇÕES ===
tempo_vida = 0;
tempo_vida_maximo = 40;         // 0.67 segundos
velocidade_decaimento = 0.92;   // Redução de velocidade

// === INICIALIZAÇÃO ===
image_alpha = 1.0;
image_blend = make_color_rgb(139, 69, 19); // Marrom
image_scale = random_range(0.3, 0.8);

// === MOVIMENTO ===
if (variable_instance_exists(self, "speed")) {
    // Se tem velocidade definida, usa ela
} else {
    speed = random_range(3, 8);
}

if (variable_instance_exists(self, "direction")) {
    // Se tem direção definida, usa ela
} else {
    direction = random(360);
}

show_debug_message("🌍 Partícula de terra criada");
