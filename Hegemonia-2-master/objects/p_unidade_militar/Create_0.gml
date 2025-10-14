// ===============================================
// HEGEMONIA GLOBAL - OBJETO PAI: UNIDADE MILITAR
// Sistema Padronizado P, O, L, K
// ===============================================

// --- Atributos Básicos (serão sobrescritos pelas unidades filhas) ---
hp_atual = 100;
hp_max = 100;
velocidade = 2;
alcance_visao = 200;
alcance_tiro = 180;
intervalo_ataque = 60; // 1 segundo a 60 FPS
projetil_objeto = obj_tiro_simples;

// --- Estados e Modos ---
estado = "parado";
modo_combate = "passivo"; // "passivo" ou "atacando"
selecionado = false;
alvo = noone;

// --- Movimento ---
destino_x = x;
destino_y = y;

// --- Patrulha ---
pontos_patrulha = ds_list_create();
indice_patrulha = 0;
modo_definicao_patrulha = false;
patrulhando = false;

// --- Timers ---
timer_ataque = 0;

// --- Visual ---
image_blend = c_white;
