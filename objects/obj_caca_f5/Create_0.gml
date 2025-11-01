// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-5 (Create Refatorado)
// ===============================================

// --- ATRIBUTOS DE VOO ---
velocidade_atual = 0;
velocidade_maxima = 4.0;
aceleracao = 0.05;
desaceleracao = 0.03;
velocidade_rotacao = 3;

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 200;
hp_max = 200;
nacao_proprietaria = 1;
radar_alcance = 450;
timer_ataque = 0;
intervalo_ataque = 90;
modo_ataque = false;

// --- MÁQUINA DE ESTADOS ---
estado = "pousado"; // Estados: "pousado", "decolando", "pousando", "movendo", "patrulhando", "definindo_patrulha"

// --- SISTEMA DE ALTITUDE ---
altura_voo = 0;
altura_maxima = 20;

// --- SISTEMA DE PATRULHA ---
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// --- CONTROLE ---
destino_x = x;
destino_y = y;
selecionado = false;

// --- NOVAS VARIÁVEIS PARA ATAQUE AGRESSIVO ---
estado_anterior = "pousado"; // Guarda o que o avião estava fazendo antes de atacar
alvo_em_mira = noone;         // Guarda a ID do inimigo que está sendo caçado

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("✈️ Caça F-5 criado - Sistema refatorado com comandos avançados e ataque agressivo");