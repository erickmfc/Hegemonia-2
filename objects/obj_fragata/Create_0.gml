// ===============================================
// HEGEMONIA GLOBAL - FRAGATA CREATE EVENT
// Configurações otimizadas para sistema unificado
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
hp_max = 200;
hp_atual = hp_max; // Vida atual inicia cheia
velocidade_movimento = 1.8;
velocidade_atual = velocidade_movimento; // Velocidade atual (inicia igual à base)
velocidade = velocidade_movimento; // Compatibilidade com código antigo
dano_base = 40;
dano = dano_base; // Compatibilidade com código antigo
alcance_visao = 400;                 // Alcance de detecção
alcance_ataque = 300;            // Alcance de ataque
alcance = alcance_ataque; // Compatibilidade com código antigo
alcance_tiro = alcance_ataque; // Compatibilidade com código antigo
nacao_proprietaria = 1;

// === SISTEMA DE ATAQUE OTIMIZADO ===
atq_cooldown = 0;
atq_rate = 180;                // 3 segundos entre mísseis
velocidade_ataque = atq_rate; // Compatibilidade com documentação

// === SISTEMA DE SELEÇÃO ===
selecionado = false;
raio_selecao = 25;

// === SISTEMA DE MODOS DE COMBATE ===
modo_combate = "passivo";      // Começa passivo
alvo = noone;

// ✅ OTIMIZAÇÃO: Timer para verificação periódica de inimigos (a cada 30 frames = ~0.5s a 60 FPS)
timer_verificacao_inimigos = 0;
intervalo_verificacao_inimigos = 30; // Verificar inimigos a cada 30 frames

// === SISTEMA DE MOVIMENTO ===
destino_x = x;
destino_y = y;
estado = "parado";
movendo = false;

// Sistema de rotação
velocidade_rotacao = 0.8; // Velocidade de rotação em graus por frame

// === CONFIGURAÇÕES VISUAIS ===
image_blend = make_color_rgb(90, 130, 180); // Azul médio

show_debug_message("🚢 Fragata criada - HP: " + string(hp_atual) + "/" + string(hp_max) + ", Sistema de ataque direto ativo");