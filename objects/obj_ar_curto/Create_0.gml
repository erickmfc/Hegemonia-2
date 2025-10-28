// ================================================
// HEGEMONIA GLOBAL - OBJETO: AR-CURTO (Míssil Ar-Ar)
// Create Event - Sistema de Projétil para Unidades Aéreas
// ================================================

// === PROPRIEDADES DO MÍSSIL AR-AR ===
speed = 5;                         // Velocidade maior para interceptação aérea
dano = 120;                        // Dano maior para unidades aéreas
alvo = noone;                      // Unidade aérea alvo
dono = noone;                      // Unidade que atirou (F-5)
timer_vida = 1180;                  // Tempo de vida menor (3 segundos) - mísseis rápidos

// === CONFIGURAÇÕES VISUAIS PARA MÍSSIL AR-AR ===
image_xscale = 0.1;                // Escala pequena para mísseis ar-ar
image_yscale = 0.1;                // Escala pequena para mísseis ar-ar
image_blend = c_red;              // COR VERMELHA para mísseis ar-ar
image_alpha = 1.0;                 // OPACIDADE TOTAL
image_speed = 0.5;                 // Velocidade da animação normal
image_angle = 0;                   // Ângulo inicial

// === CONFIGURAÇÕES DE VISIBILIDADE ===
visible = true;                    // GARANTIR QUE ESTÁ VISÍVEL
depth = -1000;                     // PROFUNDIDADE PARA FICAR NA FRENTE

// === PROPRIEDADES ESPECÍFICAS AR-AR ===
alcance_maximo = 600;              // Alcance máximo do míssil
precisao = 0.97;                   // Precisão do míssil (97% para alvos aéreos)
altura_voo = 0;                    // Altura de voo do míssil

show_debug_message("🚀 Míssil AR-CURTO criado - Sistema Ar-Ar!");
show_debug_message("📏 Sprite: air (44x11 pixels)");
show_debug_message("📏 Escala: " + string(image_xscale) + "x" + string(image_yscale));
show_debug_message("⏱️ Tempo de vida: " + string(timer_vida) + " frames (" + string(timer_vida/60) + " segundos)");
show_debug_message("🎯 Alvo: " + string(alvo) + " | Velocidade: " + string(speed) + " | Dano: " + string(dano));
show_debug_message("🎯 Alcance: " + string(alcance_maximo) + " | Precisão: " + string(precisao * 100) + "%");