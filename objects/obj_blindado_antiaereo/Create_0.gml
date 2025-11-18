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
velocidade_movimento = 1.5; // Velocidade especificada: 1.5
velocidade_atual = velocidade_movimento; // Velocidade atual (inicia igual à base)
velocidade = velocidade_movimento; // Compatibilidade com código antigo

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
alcance_ataque = 600;  // Alcance de tiro longo para defesa aérea
alcance_tiro = alcance_ataque; // Compatibilidade com código antigo
atq_cooldown = 0;
atq_rate = 180; // 3 segundos (60 FPS * 3 = 180 frames)
velocidade_ataque = atq_rate; // Compatibilidade com documentação

// === ALVO E VIDA ===
alvo = noone;
hp_max = 200; // Vida especificada: 200 HP
hp_atual = hp_max; // Vida atual inicia cheia
hp = hp_atual; // Compatibilidade com código antigo

// Modo de combate
modo_ataque = true; // Por padrão, ataca automaticamente

// === ESPECIALIZAÇÃO ANTI-AÉREA ===
dano_base = 150; // Dano aumentado
dano = dano_base; // Compatibilidade com código antigo
especializacao = "antiaerea"; // Tipo de especialização

// === OBJETOS ESPECÍFICOS DO BLINDADO ===
// Voltando ao sistema de tiro original

show_debug_message("Blindado Anti-Aéreo criado - HP: " + string(hp_atual) + "/" + string(hp_max) + ", Dano: " + string(dano_base) + ", Velocidade: " + string(velocidade_movimento));

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;                    // Nível de detalhe inicial (0-3)
force_always_active = false;      // true = nunca pula frames
lod_process_index = irandom(99);  // Índice único para distribuir processamento
skip_frames_enabled = true;       // Habilitar frame skip
