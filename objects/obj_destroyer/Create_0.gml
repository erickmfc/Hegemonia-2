// ===============================================
// HEGEMONIA GLOBAL - DESTROYER
// Unidade Naval Pesada
// ===============================================

// === CONFIGURACOES BASICAS ===
hp_max = 300;
hp_atual = hp_max; // Vida atual inicia cheia
velocidade_movimento = 1.5;
velocidade_atual = velocidade_movimento; // Velocidade atual (inicia igual à base)
velocidade = velocidade_movimento; // Compatibilidade com código antigo
dano_base = 50;
dano = dano_base; // Compatibilidade com código antigo
alcance_visao = 400; // Alcance de detecção
alcance_ataque = 350; // Alcance de ataque
alcance = alcance_ataque; // Compatibilidade com código antigo
alcance_tiro = alcance_ataque; // Compatibilidade com código antigo
nacao_proprietaria = 1;

show_debug_message("🚢 Destroyer criado - HP: " + string(hp_atual) + "/" + string(hp_max) + ", Velocidade: " + string(velocidade_movimento));

// === SISTEMA DE SELECAO ===
selecionado = false;
raio_selecao = 25;

// === SISTEMA DE MODOS DE COMBATE ===
modo_combate = "passivo";
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

// === SISTEMA DE MOVIMENTO PARA NAVEGAÇÃO ===
moving_to_target = false;
target_x = x;
target_y = y;
movement_speed = velocidade;

// === SISTEMA DE TIMER ===
frame_count = 0;

// === CONFIGURACOES VISUAIS ===
image_blend = make_color_rgb(80, 120, 200); // Azul escuro

show_debug_message("Destroyer criado e pronto para acao!");
