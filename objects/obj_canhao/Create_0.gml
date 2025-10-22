/// @description Inicialização do Canhão
// ===============================================
// HEGEMONIA GLOBAL - CANHÃO DA INDEPENDENCE
// Sistema de Canhão Centralizado
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
navio_pai = noone; // Navio que possui este canhão
offset_x = 0; // Offset X do canhão
offset_y = 0; // Offset Y do canhão

// === CONFIGURAÇÕES VISUAIS ===
image_xscale = 1.0;
image_yscale = 1.0;
image_angle = 0;
image_blend = c_white;
image_alpha = 1.0;

// === SISTEMA DE ROTAÇÃO ===
angulo_alvo = 0;
velocidade_rotacao = 0.1; // Velocidade de rotação do canhão

show_debug_message("🔫 Canhão criado para navio: " + string(navio_pai));