// ===============================================
// HEGEMONIA GLOBAL - SU-35 FLANKER
// 4.5ª GERAÇÃO (anos 90-2000) - Manobrabilidade superior
// ===============================================

// === SISTEMA DE GERAÇÕES ===
geracao_caca = FighterGeneration.GEN_4_PLUS;

// --- ATRIBUTOS DE VOO ---
velocidade_atual = 0;
velocidade_maxima = 4.0;  // ✅ 4.5ª geração - velocidade alta
aceleracao = 0.06;
desaceleracao = 0.03;
velocidade_rotacao = 3.5;

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 500;  // ✅ 4.5ª geração - HP superior ao F-15
hp_max = 500;
nacao_proprietaria = 1;
radar_alcance = 850;  // ✅ 4.5ª geração - radar melhorado
alcance_ataque = 800;  // ✅ Alcance de ataque superior
timer_ataque = 0;
intervalo_ataque = 85;
modo_ataque = true; // Modo ataque ativo por padrão

// --- SISTEMA DE MÍSSEIS MÚLTIPLOS (mais rápido que F-15) ---
timer_sky = 0;
intervalo_sky = 240;  // ✅ 4 segundos (mais rápido que F-15)
timer_iron = 0;
intervalo_iron = 360;  // ✅ 6 segundos
timer_hash = 0;
intervalo_hash = 480;  // ✅ 8 segundos
dano_multiplier = 1.1;  // ✅ 10% mais dano que F-15

// --- TECNOLOGIA ---
stealth_ativo = false;  // ✅ Sem stealth
sensores_avancados = true;  // ✅ Radar melhorado
manobrabilidade_superior = true;  // ✅ Manobrabilidade superior

// --- MÁQUINA DE ESTADOS ---
estado = "pousado"; // Estados: "pousado", "decolando", "pousando", "movendo", "patrulhando", "definindo_patrulha", "atacando"

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

// --- SISTEMA DE PATRULHA AUTOMÁTICA ---
patrulha_automatica = false; // Modo de patrulha automática desativado por padrão

// --- SISTEMA DE MÍSSEIS ---
// SU-35 pode usar: Sky, Iron, Hash, Conducao
missil_tipos = [obj_SkyFury_ar, obj_Ironclad_terra, obj_hash, obj_ar_curto]; // Condução usa ar_curto
missil_atual = 0; // 0=Sky, 1=Iron, 2=Hash, 3=Condução

// === CONTROLE DE TAMANHO DO SPRITE ===
// Você pode ajustar essas variáveis para diminuir o tamanho do avião
image_xscale = 0.28;  // Escala horizontal (1.0 = tamanho original, 0.5 = metade)
image_yscale = 0.28;  // Escala vertical (1.0 = tamanho original, 0.5 = metade)

// === FUNÇÃO DE ORDEM DE MOVIMENTO ===
ordem_mover = function(dest_x, dest_y) {
    var _dx = clamp(dest_x, 8, room_width - 8);
    var _dy = clamp(dest_y, 8, room_height - 8);
    
    destino_x = _dx;
    destino_y = _dy;
    
    // ✅ Se está pousado, começa decolando
    if (estado == "pousado") {
        estado = "decolando";
        show_debug_message("✈️ SU-35: DECOLANDO para (" + string(destino_x) + ", " + string(destino_y) + ")");
    } else {
        estado = "movendo";
        show_debug_message("✈️ SU-35: Movendo para (" + string(destino_x) + ", " + string(destino_y) + ")");
    }
    
    // Cancelar ataque e patrulha se estiverem ativas
    alvo_em_mira = noone;
    estado_anterior = "pousado";
}

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("✈️ Caça SU-35 criado - Sistema de mísseis avançado");
show_debug_message("HP: " + string(hp_atual) + " | Velocidade: " + string(velocidade_maxima));
show_debug_message("📏 Tamanho: " + string(image_xscale) + "x" + string(image_yscale));
