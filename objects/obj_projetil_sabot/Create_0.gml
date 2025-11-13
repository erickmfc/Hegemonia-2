// ================================================
// HEGEMONIA GLOBAL - OBJETO: PROJÉTIL SABOT (M1A Abrams)
// Create Event - Sistema de Projétil com Pooling
// ================================================

// === PROPRIEDADES DO TIRO ===
speed = 5; // Projétil SABOT é mais rápido que tiro comum
dano = 120; // Dano maior que tanque comum
dano_area = 70; // Dano de área para explosão
raio_area = 90; // Raio de explosão maior
alvo = noone;
dono = noone;
timer_vida = 350; // Timer de vida (2.5 segundos)
eh_tiro_tanque = true; // Flag para identificar tiro de tanque

// === CONFIGURAÇÕES VISUAIS ===
image_xscale = 1.0;
image_yscale = 1.0;
image_blend = c_yellow; // Cor amarela para diferenciar
image_alpha = 1.0;
image_speed = 0.5;
image_angle = 0;

// === CONFIGURAÇÕES DE VISIBILIDADE ===
visible = true;
depth = -1000; // Profundidade para ficar na frente

// === SISTEMA DE POOLING ===
pooled = false; // false = disponível no pool, true = em uso

show_debug_message("🚀 Projétil SABOT criado - Velocidade: " + string(speed) + ", Dano: " + string(dano));
