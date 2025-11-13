// ===============================================
// HEGEMONIA GLOBAL - SOLDADO ANTI-AÉREO
// Sistema Especializado em Combate Aéreo
// ===============================================

// ====================
// ATRIBUTOS DO SOLDADO ANTI-AÉREO
// ====================

// Nação proprietária (1 = jogador, 2 = IA inimiga)
nacao_proprietaria = 1;

vida = 100;
vida_max = 100;
dano = 100; // Dano aumentado contra alvos aéreos
velocidade = 2; // Mesma velocidade da infantaria

// Estado inicial
selecionado = false;
estado = "parado";

// Movimento (idêntico à infantaria)
destino_x = x;
destino_y = y;
destino_original_x = undefined; // Para sistema de desvio de obstáculos
destino_original_y = undefined; // Para sistema de desvio de obstáculos

// Patrulha (sistema idêntico à infantaria)
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false;

// ✅ NOVO: Sistema de patrulha igual navios/aviões
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// Ataque especializado contra alvos aéreos e terrestres
alcance_visao = 500; // Maior alcance para detectar alvos
alcance_tiro = 400; // Alcance maior que infantaria normal
atq_cooldown = 0;
atq_rate = 60; // Mais lento que infantaria (míssil demora mais para carregar)

// Alvo inimigo (aéreos e terrestres)
alvo = noone;
categoria_alvo = "mista"; // Especifica que ataca alvos aéreos e terrestres

// Para seguir (idêntico à infantaria)
seguir_alvo = noone;

// Modo de combate
modo_ataque = true; // Por padrão, ataca automaticamente

// === COR E VISUAL ===
// Usar cor diferente para diferenciar do soldado normal
image_blend = make_color_rgb(100, 150, 255); // Azul claro para diferenciar
image_xscale = 1.0;
image_yscale = 1.0;

// Sistema de mísseis
missil_em_voo = false;
missil_criado = noone;

// Contador para debug
step_counter = 0;

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;