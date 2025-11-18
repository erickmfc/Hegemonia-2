// ===============================================
// HEGEMONIA GLOBAL - SOLDADO ANTI-AÉREO
// Sistema Especializado em Combate Aéreo
// ===============================================

// ====================
// ATRIBUTOS DO SOLDADO ANTI-AÉREO
// ====================

// Nação proprietária (1 = jogador, 2 = IA inimiga)
nacao_proprietaria = 1;

// Vida (padronizado)
hp_max = 100;
hp_atual = hp_max; // Vida atual inicia cheia
vida = hp_atual; // Compatibilidade com código antigo
vida_max = hp_max; // Compatibilidade com código antigo

// Dano (padronizado)
dano_base = 100; // Dano aumentado contra alvos aéreos
dano = dano_base; // Compatibilidade com código antigo

// Velocidade (padronizado)
velocidade_movimento = 2; // Mesma velocidade da infantaria
velocidade_atual = velocidade_movimento; // Velocidade atual (inicia igual à base)
velocidade = velocidade_movimento; // Compatibilidade com código antigo

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
alcance_ataque = 400; // Alcance maior que infantaria normal
alcance_tiro = alcance_ataque; // Compatibilidade com código antigo
atq_cooldown = 0;
atq_rate = 60; // Mais lento que infantaria (míssil demora mais para carregar)
velocidade_ataque = atq_rate; // Compatibilidade com documentação

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