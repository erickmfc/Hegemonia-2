/// @description Inicialização do Tiro do Canhão
// ===============================================
// HEGEMONIA GLOBAL - TIRO DO CANHÃO
// Projétil de Metralhadora
// ===============================================

// === PROPRIEDADES DO TIRO ===
speed = 12; // Velocidade ajustada para melhor precisão
dano = 15; // Dano menor por tiro (compensa pela quantidade)
alvo = noone; // Unidade alvo
dono = noone; // Unidade que atirou
timer_vida = 240; // 4 segundos de vida (distância máxima ~1440px a 12pixels/frame)

// === CONFIGURAÇÕES VISUAIS ===
image_xscale = 0.8; // Tamanho médio
image_yscale = 0.8;
image_blend = c_orange; // Cor laranja para diferenciar
image_alpha = 1.0;
image_speed = 0.8; // Animação rápida
image_angle = 0;

// === CONFIGURAÇÕES DE VISIBILIDADE ===
visible = true;
depth = -1000; // Profundidade para ficar na frente

// === SISTEMA DE POOLING ===
pooled = false; // false = disponível no pool, true = em uso

show_debug_message("🔫 Tiro do canhão criado - Velocidade: " + string(speed) + ", Dano: " + string(dano));
