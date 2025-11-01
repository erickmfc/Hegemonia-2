// ====================
// ATRIBUTOS DO SOLDADO
// ====================
hp_atual = 100;
hp_max = 100;
// Compatibilidade com código antigo
vida = hp_atual;
vida_max = hp_max;
dano = 20;
velocidade = 2;

// Nação proprietária (1 = jogador, 2 = IA inimiga)
nacao_proprietaria = 1;

// Estado inicial
selecionado = false;
estado = "parado";

// Movimento
destino_x = x;
destino_y = y;

// Patrulha (sistema melhorado)
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false; // true quando está no modo de definir patrulha

// Ataque
alcance_visao = 200; // Maior que o alcance de tiro para detectar inimigos
alcance = 180; // Alcance de tiro padronizado
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