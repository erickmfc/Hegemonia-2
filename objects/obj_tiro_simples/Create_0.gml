// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Create Event - Sistema de Projétil VISÍVEL
// ================================================

// === PROPRIEDADES DO TIRO ===
speed = 5;                         // Velocidade do projétil
dano = 70;                         // Dano causado
alvo = noone;                      // Unidade alvo
dono = noone;                      // Unidade que atirou
timer_vida = 300;                  // Tempo de vida MAIOR (5 segundos)

// === CONFIGURAÇÕES VISUAIS OTIMIZADAS ===
image_xscale = 0.5;                // ESCALA OTIMIZADA (era 5.0 - muito grande)
image_yscale = 0.5;                // ESCALA OTIMIZADA (era 5.0 - muito grande)
image_blend = c_blue;              // COR AZUL BRILHANTE
image_alpha = 1.0;                 // OPACIDADE TOTAL
image_speed = 0.5;                 // Velocidade da animação
image_angle = 0;                   // Ângulo inicial

// === CONFIGURAÇÕES DE VISIBILIDADE ===
visible = true;                    // GARANTIR QUE ESTÁ VISÍVEL
depth = -1000;                     // PROFUNDIDADE PARA FICAR NA FRENTE

show_debug_message("🚀 Tiro simples criado - CONFIGURAÇÃO CORRIGIDA!");
show_debug_message("📏 Sprite: air (44x11 pixels)");
show_debug_message("📏 Escala: " + string(image_xscale) + "x" + string(image_yscale));
show_debug_message("⏱️ Tempo de vida: " + string(timer_vida) + " frames (" + string(timer_vida/60) + " segundos)");
show_debug_message("🎯 Alvo: " + string(alvo) + " | Velocidade: " + string(speed) + " | Dano: " + string(dano));