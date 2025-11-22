// ===============================================
// HEGEMONIA GLOBAL - F-35 LIGHTNING II
// 5ª GERAÇÃO (anos 2000+) - SUPERIORIDADE TECNOLÓGICA ABSOLUTA
// STEALTH, SENSORES AVANÇADOS, FUSÃO DE DADOS
// ===============================================

// === SISTEMA DE GERAÇÕES ===
geracao_caca = FighterGeneration.GEN_5;

// --- ATRIBUTOS DE VOO ---
velocidade_atual = 0;
velocidade_maxima = 5.8;  // ✅ 5ª geração - 45% mais rápido que F-15
aceleracao = 0.06;
desaceleracao = 0.03;
velocidade_rotacao = 3.5;

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 800;  // ✅ 5ª geração - DOBRO do SU-35
hp_max = 800;
nacao_proprietaria = 1;
radar_alcance = 1500;  // ✅ 5ª geração - 76% mais alcance que SU-35
alcance_ataque = 1400;  // ✅ Alcance de ataque superior
modo_ataque = true; // Modo ataque ativo por padrão
timer_busca_alvo = 0;
intervalo_busca_alvo = 15;

// --- SISTEMA DE MÍSSEIS MÚLTIPLOS (RECARGAS ULTRA-RÁPIDAS) ---
// Sky: 1.5 segundos (90 frames) - ✅ 3.3x mais rápido que SU-35
timer_sky = 0;
intervalo_sky = 90;  // ✅ 1.5 segundos

// Iron: 2 segundos (120 frames)
timer_iron = 0;
intervalo_iron = 120;  // ✅ 2 segundos

// Hash: 2.5 segundos (150 frames)
timer_hash = 0;
intervalo_hash = 150;  // ✅ 2.5 segundos

// Lit: 3 segundos (180 frames)
timer_lit = 0;
intervalo_lit = 180;  // ✅ 3 segundos

// --- MULTIPLICADOR DE DANO ---
dano_multiplier = 1.8;  // ✅ 80% mais dano que SU-35

// --- TECNOLOGIA 5ª GERAÇÃO ---
stealth_ativo = true;  // ✅ STEALTH - invisível para radares antigos
sensores_avancados = true;  // ✅ Sensores de última geração
fusao_dados = true;  // ✅ Fusão de dados de múltiplos sensores
consciencia_situacional = true;  // ✅ Consciência situacional superior

// --- MÁQUINA DE ESTADOS ---
estado = "pousado"; // Estados: "pousado", "decolando", "pousando", "movendo", "patrulhando", "atacando"

// --- SISTEMA DE ALTITUDE ---
altura_voo = 0;
altura_maxima = 25;

// --- SISTEMA DE PATRULHA ---
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// --- CONTROLE ---
destino_x = x;
destino_y = y;
selecionado = false;

// --- VARIÁVEIS PARA ATAQUE AGRESSIVO ---
estado_anterior = "pousado";
alvo_em_mira = noone;

// === CONTROLE DE TAMANHO DO SPRITE ===
// ✅ Aumentado em 4x (12% do tamanho original)
image_xscale = 0.12;
image_yscale = 0.12;

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("✈️ F-35 LIGHTNING II criado - 5ª GERAÇÃO (STEALTH)");
show_debug_message("🚀 HP: " + string(hp_max) + " | Velocidade: " + string(velocidade_maxima) + " | Radar: " + string(radar_alcance) + "px");
show_debug_message("⚔️ Sky: 1.5s | Iron: 2s | Hash: 2.5s | Lit: 3s | Dano: " + string(dano_multiplier) + "x");
show_debug_message("🛡️ STEALTH ATIVO - Reduz detecção por caças de gerações anteriores");