// ================================================
// HEGEMONIA GLOBAL - GEPARD ANTI-AÉREO
// Create Event - Inicialização Completa
// ================================================

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
velocidade = 0.8; // M1A Abrams é mais rápido que tanque comum

// Patrulha
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false;
seguir_alvo = noone;

// Sistema de patrulha igual navios/aviões
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// Ataque
alcance_visao = 1500;  // Alcance de visão maior que tanque comum
alcance_tiro  = 1500;  // Alcance de tiro maior
atq_cooldown = 0;
atq_rate = 150; // 2.5 segundos (60 FPS * 2.5 = 150 frames) - mais rápido que tanque comum
atq_cooldown_aereo = 0; // ✅ NOVO: Cooldown separado para mísseis aéreos
atq_cooldown_terrestre = 0; // ✅ NOVO: Cooldown separado para projéteis terrestres
metralhadora_cooldown = 0; // ✅ NOVO: Cooldown específico para metralhadora (muito rápido)
metralhadora_rate = 2; // ✅ NOVO: 2 frames entre tiros = ~30 tiros/segundo (metralhadora automática)

// Alvo inimigo
alvo = noone; // Alvo principal (prioridade)
alvo_aereo = noone; // ✅ NOVO: Alvo aéreo separado
alvo_terrestre = noone; // ✅ NOVO: Alvo terrestre separado

// Vida
hp = 450; // M1A Abrams é mais resistente que tanque comum
hp_max = 450;

// Modo de combate
modo_ataque = true; // Por padrão, ataca automaticamente

// =============================================
// SISTEMA DE TORRE MODULAR (NOVO)
// =============================================
angulo_torre = 0; // Ângulo atual da torre (graus)
angulo_torre_alvo = 0; // Ângulo alvo da torre
velocidade_rotacao_torre = 1.5; // Velocidade de rotação da torre (graus por frame)
offset_torre_x = 0; // Offset X da torre em relação ao casco
offset_torre_y = 0; // Offset Y da torre em relação ao casco

// =============================================
// SISTEMA DE ESTADO DESTRUÍDO
// =============================================
destruido = false; // Flag para estado destruído

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

// =============================================
// CONFIGURAÇÕES DE SPRITES
// =============================================
// Sprites modulares do Gepard (não usados no Abrams)
// TYPE_39_SAM_HULL - casco (sem rotação)
// Type_39_SAM - torre/lançador (com rotação)
// Gepard_dead - sprite quando destruído

// =============================================
// CONFIGURAÇÕES DE SOM
// =============================================
// snd_tiro_abrams - som do disparo terrestre (já existe)

// =============================================
// CONFIGURAÇÕES DE PROJÉTIL
// =============================================
// Tiro terrestre: obj_projetil_sabot (igual Abrams)
// Tiro anti-aéreo: obj_missil_aereo (míssil com rastreamento)

show_debug_message("🚀 Gepard Anti-Aéreo criado - HP: " + string(hp) + ", Velocidade: " + string(velocidade));
