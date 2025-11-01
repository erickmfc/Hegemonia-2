// ===============================================
// HEGEMONIA GLOBAL - HELICÓPTERO (Create Simplificado)
// ===============================================

// --- ATRIBUTOS DE VOO ---
velocidade_atual = 0;
velocidade_maxima = 3.0;
aceleracao = 0.04;
desaceleracao = 0.05;
velocidade_rotacao = 2.5;

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 150;
hp_max = 150;
nacao_proprietaria = 1;
radar_alcance = 1500;
timer_ataque = 0;
intervalo_ataque = 90;
modo_ataque = false; // Começa passivo

// --- MÁQUINA DE ESTADOS ---
estado = "pousado"; // Estados: "pousado", "movendo", "patrulhando"

// --- SISTEMA DE ALTITUDE VISUAL ---
altura_voo = 0; // Altura visual do helicóptero (0 = pousado)
altura_maxima = 15; // Altura máxima de voo
voando = false; // Estado de voo simples

// --- CONTROLE SIMPLES ---
destino_x = x;
destino_y = y;
selecionado = false;

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("🚁 Helicóptero militar criado - Sistema simples ativo");