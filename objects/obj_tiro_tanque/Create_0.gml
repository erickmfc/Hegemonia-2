// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO TANQUE
// Create Event - Sistema de Projétil com Pooling
// ================================================

// === PROPRIEDADES DO TIRO ===
speed = 6;
dano = 50;
alvo = noone;
dono = noone;
timer_vida = 180;

// === CONFIGURAÇÕES VISUAIS ===
image_xscale = 1.0;
image_yscale = 1.0;
image_blend = c_yellow; // Cor amarela para diferenciar de tanque
image_alpha = 1.0;
image_speed = 0.5;
image_angle = 0;

// === CONFIGURAÇÕES DE VISIBILIDADE ===
visible = true;
depth = -1000; // Profundidade para ficar na frente

// === SISTEMA DE POOLING ===
pooled = false; // false = disponível no pool, true = em uso

show_debug_message("🚀 Tiro tanque criado - Velocidade: " + string(speed) + ", Dano: " + string(dano));

