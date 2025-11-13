// Nação proprietária (1 = jogador, 2 = IA inimiga)
nacao_proprietaria = 1;

// Seleção
selecionado = false;
estado = "parado";

// Movimento
destino_x = x;
destino_y = y;
destino_original_x = undefined; // Para sistema de desvio de obstáculos
destino_original_y = undefined; // Para sistema de desvio de obstáculos
velocidade = 1.2; // mais lento que a infantaria

// Patrulha
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false;
seguir_alvo = noone;

// ✅ NOVO: Sistema de patrulha igual navios/aviões
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// === TERRENOS PERMITIDOS ===
terrenos_permitidos = [TERRAIN.CAMPO, TERRAIN.DESERTO]; // Terra e deserto (não floresta)

// Ataque
alcance_visao = 600;  // bem maior
alcance_tiro  = 540;  // ~3x infantaria (180 * 3)
atq_cooldown = 0;
atq_rate = 180; // 3 segundos (60 FPS * 3 = 180 frames)

// Alvo inimigo
alvo = noone;

// Vida
hp = 100; // bem mais resistente

// Modo de combate
modo_ataque = true; // Por padrão, ataca automaticamente

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;