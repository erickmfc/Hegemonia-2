// ================================================
// HEGEMONIA GLOBAL - BLINDADO ANTI-AÉREO
// Veículo Militar Especializado em Defesa Aérea
// ================================================

// === NAÇÃO PROPRIETÁRIA ===
nacao_proprietaria = 1; // 1 = jogador, 2 = IA inimiga

// === ATRIBUTOS BÁSICOS ===
selecionado = false;
estado = "parado";

// === MOVIMENTO ===
destino_x = x;
destino_y = y;
destino_original_x = undefined; // Para sistema de desvio de obstáculos
destino_original_y = undefined; // Para sistema de desvio de obstáculos
velocidade = 1.5; // Velocidade especificada: 1.5

// === PATRULHA ===
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false;
seguir_alvo = noone;

// ✅ NOVO: Sistema de patrulha igual navios/aviões
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// === ATAQUE ANTI-AÉREO ===
alcance_visao = 700;  // Alcance de detecção amplo
alcance_tiro  = 600;  // Alcance de tiro longo para defesa aérea
atq_cooldown = 0;
atq_rate = 180; // 3 segundos (60 FPS * 3 = 180 frames)

// === ALVO E VIDA ===
alvo = noone;
hp = 200; // Vida especificada: 200 HP

// Modo de combate
modo_ataque = true; // Por padrão, ataca automaticamente

// === ESPECIALIZAÇÃO ANTI-AÉREA ===
dano = 150; // Dano aumentado
especializacao = "antiaerea"; // Tipo de especialização

// === OBJETOS ESPECÍFICOS DO BLINDADO ===
// Voltando ao sistema de tiro original

show_debug_message("Blindado Anti-Aéreo criado - HP: " + string(hp) + ", Dano: " + string(dano) + ", Velocidade: " + string(velocidade));

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;                    // Nível de detalhe inicial (0-3)
force_always_active = false;      // true = nunca pula frames
lod_process_index = irandom(99);  // Índice único para distribuir processamento
skip_frames_enabled = true;       // Habilitar frame skip
