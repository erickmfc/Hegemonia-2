// ===============================================
// HEGEMONIA GLOBAL - F-15 EAGLE
// 4ª GERAÇÃO (anos 70-80) - Superioridade aérea
// ===============================================

// === SISTEMA DE GERAÇÕES ===
geracao_caca = FighterGeneration.GEN_4;

// --- ATRIBUTOS DE VOO ---
velocidade_atual = 0;
velocidade_maxima = 4.2;  // ✅ 4ª geração - velocidade superior
aceleracao = 0.06;
desaceleracao = 0.03;
velocidade_rotacao = 3.5;

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 400;  // ✅ 4ª geração - HP robusto
hp_max = 400;
nacao_proprietaria = 1;
radar_alcance = 700;  // ✅ 4ª geração - radar avançado
alcance_ataque = 650;  // ✅ Alcance de ataque superior
timer_ataque = 0;
intervalo_ataque = 85;
modo_ataque = true; // Modo ataque ativo por padrão

// --- SISTEMA DE MÍSSEIS MÚLTIPLOS ---
timer_sky = 0;
intervalo_sky = 300;  // ✅ 5 segundos
timer_iron = 0;
intervalo_iron = 420;  // ✅ 7 segundos
timer_hash = 0;
intervalo_hash = 540;  // ✅ 9 segundos
dano_multiplier = 1.0;  // ✅ Dano padrão

// --- TECNOLOGIA ---
stealth_ativo = false;  // ✅ Sem stealth
sensores_avancados = true;  // ✅ Radar avançado

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
// F-15 pode usar: Sky, Iron, Hash, Conducao
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
        show_debug_message("✈️ F-15: DECOLANDO para (" + string(destino_x) + ", " + string(destino_y) + ")");
    } else {
        estado = "movendo";
        show_debug_message("✈️ F-15: Movendo para (" + string(destino_x) + ", " + string(destino_y) + ")");
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

show_debug_message("✈️ Caça F-15 criado - Sistema de mísseis avançado");
show_debug_message("HP: " + string(hp_atual) + " | Velocidade: " + string(velocidade_maxima));
show_debug_message("📏 Tamanho: " + string(image_xscale) + "x" + string(image_yscale));
