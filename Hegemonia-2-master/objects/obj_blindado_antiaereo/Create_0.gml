// ================================================
// HEGEMONIA GLOBAL - BLINDADO ANTI-AÉREO
// Veículo Militar Especializado em Defesa Aérea
// ================================================

// === ATRIBUTOS BÁSICOS ===
selecionado = false;
estado = "parado";

// === MOVIMENTO ===
destino_x = x;
destino_y = y;
velocidade = 1.5; // Velocidade especificada: 1.5

// === PATRULHA ===
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false;
seguir_alvo = noone;

// === ATAQUE ANTI-AÉREO ===
alcance_visao = 700;  // Alcance de detecção amplo
alcance_tiro  = 600;  // Alcance de tiro longo para defesa aérea
atq_cooldown = 0;
atq_rate = 60; // Cadência de tiro rápida para defesa aérea

// === ALVO E VIDA ===
alvo = noone;
hp = 200; // Vida especificada: 200 HP

// === ESPECIALIZAÇÃO ANTI-AÉREA ===
dano = 60; // Dano 20% maior que o soldado (50 * 1.2 = 60)
especializacao = "antiaerea"; // Tipo de especialização

// === OBJETOS ESPECÍFICOS DO BLINDADO ===
// Voltando ao sistema de tiro original

show_debug_message("Blindado Anti-Aéreo criado - HP: " + string(hp) + ", Dano: " + string(dano) + ", Velocidade: " + string(velocidade));
