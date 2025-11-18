// ================================================
// HEGEMONIA GLOBAL - M1A ABRAMS
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
velocidade_movimento = 1.5; // M1A Abrams é mais rápido que tanque comum
velocidade_atual = velocidade_movimento; // Velocidade atual (inicia igual à base)
velocidade = velocidade_movimento; // Compatibilidade com código antigo

// Patrulha
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false;
seguir_alvo = noone;

// Sistema de patrulha igual navios/aviões
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// Ataque
alcance_visao = 700;  // Alcance de visão maior que tanque comum
alcance_ataque = 650;  // Alcance de tiro maior
alcance_tiro = alcance_ataque; // Compatibilidade com código antigo
atq_cooldown = 0;
atq_rate = 150; // 2.5 segundos (60 FPS * 2.5 = 150 frames) - mais rápido que tanque comum
velocidade_ataque = atq_rate; // Compatibilidade com documentação

// Alvo inimigo
alvo = noone;

// Vida
hp_max = 450; // M1A Abrams é mais resistente que tanque comum
hp_atual = hp_max; // Vida atual inicia cheia
hp = hp_atual; // Compatibilidade com código antigo

// Modo de combate
modo_ataque = true; // Por padrão, ataca automaticamente

// Dano
dano_base = 75; // Dano base do M1A Abrams (maior que tanque comum)
dano = dano_base; // Compatibilidade com código antigo

// =============================================
// SISTEMA DE TORRE MODULAR (NOVO)
// =============================================
angulo_torre = 0; // Ângulo atual da torre (graus)
angulo_torre_alvo = 0; // Ângulo alvo da torre
velocidade_rotacao_torre = 1.3; // Velocidade de rotação da torre (graus por frame)
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
// Sprites modulares (já existem)
// spr_abrams_casco - casco (sem rotação)
// spr_abrams_torre - torre (com rotação)
// spr_abrams_cano - cano (com rotação)
// spr_abrams_destruido - sprite quando destruído

// =============================================
// CONFIGURAÇÕES DE SOM
// =============================================
// snd_tiro_abrams - som do disparo (já existe)

// =============================================
// CONFIGURAÇÕES DE PROJÉTIL
// =============================================
// Usar obj_tiro_tanque com sprite spr_projetil_sabot

show_debug_message("🚀 M1A Abrams criado - HP: " + string(hp_atual) + "/" + string(hp_max) + ", Dano: " + string(dano_base) + ", Velocidade: " + string(velocidade_movimento));
