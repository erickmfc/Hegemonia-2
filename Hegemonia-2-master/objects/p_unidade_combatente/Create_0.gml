// ===============================================
// HEGEMONIA GLOBAL - OBJETO PAI: UNIDADE COMBATENTE
// Sistema de Herança para Unidades Militares
// ===============================================

// --- Atributos Básicos (serão sobrescritos pelas unidades filhas) ---
vida_maxima = 100;
vida_atual = vida_maxima;
ataque = 20;
alcance = 1;
velocidade = 2;

// --- Atributos de Custo e Informação ---
custo_dinheiro = 100;
custo_minerio = 0;
custo_populacao = 1;
tempo_de_treino = 60;
nacao_proprietaria = 1;

// --- IA e Estados ---
estado = "parado";
alvo_inimigo = noone;
selecionado = false;

// --- Movimento ---
destino_x = x;
destino_y = y;

// --- Detecção (Radar) ---
raio_de_visao = 150;
alcance_em_pixels = alcance * 64;

// --- Ataque ---
velocidade_de_ataque = 30;
atq_cooldown = 0;

// --- Patrulha ---
rota_de_patrulha = ds_list_create();
ponto_da_patrulha_atual = 0;
modo_patrulha = false;

// --- Seguir ---
seguir_alvo = noone;

// --- Visual ---
image_blend = c_white;
