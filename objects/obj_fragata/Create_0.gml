// ===============================================
// HEGEMONIA GLOBAL - FRAGATA CREATE EVENT
// Configurações otimizadas para sistema unificado
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
hp_max = 200;
hp_atual = 200;
velocidade = 1.8;
dano = 40;
alcance = 400;                 // Alcance de detecção
alcance_tiro = 300;            // Alcance de ataque
nacao_proprietaria = 1;

// === SISTEMA DE ATAQUE OTIMIZADO ===
atq_cooldown = 0;
atq_rate = 180;                // 3 segundos entre mísseis

// === SISTEMA DE SELEÇÃO ===
selecionado = false;
raio_selecao = 25;

// === SISTEMA DE MODOS DE COMBATE ===
modo_combate = "passivo";      // Começa passivo
alvo = noone;

// === SISTEMA DE MOVIMENTO ===
destino_x = x;
destino_y = y;
estado = "parado";
movendo = false;

// === CONFIGURAÇÕES VISUAIS ===
image_blend = make_color_rgb(90, 130, 180); // Azul médio

show_debug_message("🚢 Fragata criada - Sistema de ataque direto ativo");