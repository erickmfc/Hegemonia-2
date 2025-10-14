// ===============================================
// HEGEMONIA GLOBAL - PORTA-AVIÕES
// Unidade Naval Gigante
// ===============================================

// === CONFIGURACOES BASICAS ===
hp_max = 500; // Muito resistente
hp_atual = 500;
velocidade = 1.0; // Mais lento que outros navios
dano = 40; // Dano moderado (depende dos aviões)
alcance = 600; // Alcance máximo para aviões
alcance_tiro = 550;
nacao_proprietaria = 1;

show_debug_message("🚢 Porta-aviões criado - Velocidade: " + string(velocidade));

// === SISTEMA DE SELECAO ===
selecionado = false;
raio_selecao = 35; // Maior que outros navios

// === SISTEMA DE MODOS DE COMBATE ===
modo_combate = "passivo";
alvo = noone;

// === SISTEMA DE MOVIMENTO ===
destino_x = x;
destino_y = y;
estado = "parado";
movendo = false;

// === SISTEMA DE MOVIMENTO PARA NAVEGAÇÃO ===
moving_to_target = false;
target_x = x;
target_y = y;
movement_speed = velocidade;

// === SISTEMA DE TIMER ===
frame_count = 0;

// === SISTEMA PORTA-AVIÕES ESPECÍFICO ===
capacidade_avioes = 6; // Máximo de aviões que pode carregar
avioes_embarcados = 0; // Quantidade atual de aviões
tempo_lancamento = 0; // Timer para lançamento de aviões
cooldown_lancamento = 300; // 5 segundos entre lançamentos
max_alcance_avioes = 800; // Alcance máximo dos aviões

// === CONFIGURACOES VISUAIS ===
image_blend = make_color_rgb(70, 100, 150); // Azul porta-aviões

show_debug_message("Porta-aviões criado e pronto para acao!");
