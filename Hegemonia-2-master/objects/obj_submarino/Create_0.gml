// ===============================================
// HEGEMONIA GLOBAL - SUBMARINO
// Unidade Naval Submarina
// ===============================================

// === CONFIGURACOES BASICAS ===
hp_max = 180;
hp_atual = 180;
velocidade = 1.2; // Mais lento que navios de superfície
dano = 60; // Alto dano para compensar baixa velocidade
alcance = 500; // Maior alcance para torpedos
alcance_tiro = 450;
nacao_proprietaria = 1;

show_debug_message("🚢 Submarino criado - Velocidade: " + string(velocidade));

// === SISTEMA DE SELECAO ===
selecionado = false;
raio_selecao = 18; // Menor que navios de superfície

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

// === SISTEMA SUBMARINO ESPECÍFICO ===
submerso = false; // Estado de submersão
tempo_submersao = 0; // Timer para submersão
max_tempo_submersao = 600; // 10 segundos submerso
cooldown_submersao = 0; // Cooldown para próxima submersão

// === CONFIGURACOES VISUAIS ===
image_blend = make_color_rgb(60, 80, 120); // Azul escuro submarino

show_debug_message("Submarino criado e pronto para acao!");
