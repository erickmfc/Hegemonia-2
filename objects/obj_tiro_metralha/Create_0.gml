// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO METRALHADORA
// Create Event - Sistema de Projétil de Metralhadora
// ================================================

// === PROPRIEDADES DO TIRO ===
speed = 10;                        // Velocidade rápida do projétil de metralhadora
dano = 5;                          // ✅ Dano baixo por tiro (metralhadora)
alvo = noone;                      // Unidade alvo
dono = noone;                      // Unidade que atirou (torreta)
timer_vida = 120;                   // Tempo de vida menor (1.5 segundos a 60 FPS)

// === SPRITE E VISUAL ===
image_speed = 0.5;                 // Velocidade da animação
image_alpha = 0.9;                 // Transparência

// === SISTEMA DE POOLING ===
pooled = false; // false = disponível no pool, true = em uso
