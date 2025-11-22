// ===============================================
// HEGEMONIA GLOBAL - F-5 TIGER
// 2ª GERAÇÃO (anos 60-70) - Tecnologia básica
// ===============================================

// === SISTEMA DE GERAÇÕES ===
geracao_caca = FighterGeneration.GEN_2;

// --- ATRIBUTOS DE VOO ---
velocidade_atual = 0;
velocidade_maxima = 2.8;  // ✅ 2ª geração - velocidade básica
aceleracao = 0.05;
desaceleracao = 0.03;
velocidade_rotacao = 3;

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 150;  // ✅ 2ª geração - HP básico
hp_max = 150;
nacao_proprietaria = 1;
radar_alcance = 450;  // ✅ 2ª geração - radar limitado
alcance_ataque = 400;  // ✅ Alcance de ataque menor
timer_ataque = 0;
intervalo_ataque = 60;
modo_ataque = false;
timer_busca_alvo = 0;
intervalo_busca_alvo = 15;

// --- SISTEMA DE MÍSSEIS (APENAS LIT - tecnologia antiga) ---
timer_lit = 0;
intervalo_lit = 480;  // ✅ 8 segundos (lento - tecnologia antiga)
dano_multiplier = 0.7;  // ✅ 30% menos dano

// --- TECNOLOGIA ---
stealth_ativo = false;  // ✅ Sem stealth
sensores_avancados = false;  // ✅ Sensores básicos

// --- MÁQUINA DE ESTADOS ---
estado = "pousado"; // Estados: "pousado", "decolando", "pousando", "movendo", "patrulhando", "definindo_patrulha"

// --- SISTEMA DE ALTITUDE ---
altura_voo = 0;
altura_maxima = 20;

// --- SISTEMA DE PATRULHA ---
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// --- CONTROLE ---
destino_x = x;
destino_y = y;
selecionado = false;

// --- NOVAS VARIÁVEIS PARA ATAQUE AGRESSIVO ---
estado_anterior = "pousado"; // Guarda o que o avião estava fazendo antes de atacar
alvo_em_mira = noone;         // Guarda a ID do inimigo que está sendo caçado

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("✈️ Caça F-5 criado - Sistema refatorado com comandos avançados e ataque agressivo");