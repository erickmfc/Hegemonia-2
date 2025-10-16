// ===============================================
// HEGEMONIA GLOBAL - CRATERA TEMPORÁRIA
// Efeito Visual Simples para Explosões Terrestres
// ===============================================

// === CONFIGURAÇÕES ===
tempo_vida = 0;
tempo_vida_maximo = 300;        // 5 segundos
alpha_decaimento = 0.01;        // Redução de alpha por frame

// === INICIALIZAÇÃO ===
image_alpha = 0.8;
image_blend = make_color_rgb(80, 40, 20); // Marrom escuro
image_scale = random_range(0.8, 1.2);

show_debug_message("🕳️ Cratera temporária criada");
