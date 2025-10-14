// ===============================================
// HEGEMONIA GLOBAL - SOLDADO ANTI-AÉREO
// Sistema Especializado em Combate Aéreo
// ===============================================

// ====================
// ATRIBUTOS DO SOLDADO ANTI-AÉREO
// ====================
vida = 100;
vida_max = 100;
dano = 35; // Mais dano contra alvos aéreos
velocidade = 2; // Mesma velocidade da infantaria

// Estado inicial
selecionado = false;
estado = "parado";

// Movimento (idêntico à infantaria)
destino_x = x;
destino_y = y;

// Patrulha (sistema idêntico à infantaria)
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false;

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

// === COR E VISUAL ===
// Usar cor diferente para diferenciar do soldado normal
image_blend = make_color_rgb(100, 150, 255); // Azul claro para diferenciar
image_xscale = 1.0;
image_yscale = 1.0;

// Sistema de mísseis
missil_em_voo = false;
missil_criado = noone;
