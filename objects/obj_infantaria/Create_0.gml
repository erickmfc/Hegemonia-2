// ====================
// ATRIBUTOS DO SOLDADO
// ====================
hp_atual = 100;
hp_max = 100;
// Compatibilidade com código antigo
vida = hp_atual;
vida_max = hp_max;
dano = 15;
velocidade = 0.8;

// Nação proprietária (1 = jogador, 2 = IA inimiga)
nacao_proprietaria = 1;

// Estado inicial
selecionado = false;
estado = "parado";

// Movimento
destino_x = x;
destino_y = y;
destino_original_x = undefined; // Para sistema de desvio de obstáculos
destino_original_y = undefined; // Para sistema de desvio de obstáculos

// Patrulha (sistema melhorado)
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false; // true quando está no modo de definir patrulha

// ✅ NOVO: Sistema de patrulha igual navios/aviões
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// === TERRENOS PERMITIDOS ===
terrenos_permitidos = [TERRAIN.CAMPO, TERRAIN.FLORESTA, TERRAIN.DESERTO]; // Terra, floresta, deserto

// Ataque
alcance_visao = 300; // Maior que o alcance de tiro para detectar inimigos (aumentado proporcionalmente)
alcance = 270; // Alcance de tiro padronizado - AUMENTADO 50% (era 180, agora 270)
// Compatibilidade com código antigo
alcance_tiro = alcance;
atq_cooldown = 0;
atq_rate = 30; // frames (meio segundo se FPS=60)

// Alvo inimigo
alvo = noone;

// Para seguir
seguir_alvo = noone;

// Modo de combate
modo_ataque = true; // Por padrão, ataca automaticamente

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;                    // Nível de detalhe inicial (0-3)
force_always_active = false;      // true = nunca pula frames
lod_process_index = irandom(99);  // Índice único para distribuir processamento
skip_frames_enabled = true;       // Habilitar frame skip