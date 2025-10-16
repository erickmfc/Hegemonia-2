// ===============================================
// HEGEMONIA GLOBAL - MENU NAVAL MODERNO
// Sistema Grid com Todos os Navios Visíveis
// ===============================================

show_debug_message("🚀 MENU NAVAL MODERNO - CREATE EVENT");

// === VARIÁVEIS DE CONEXÃO ===
meu_quartel_id = noone;

// === VARIÁVEIS DE SELEÇÃO ===
navio_hover = -1; // Índice do navio com hover (-1 = nenhum)
navio_selecionado = -1; // Índice do navio clicado

// === ANIMAÇÕES ===
animation_timer = 0;
card_animations = [];

// Inicializar animação para 6 navios
for (var i = 0; i < 6; i++) {
    card_animations[i] = {
        alpha: 0,
        scale: 0.8,
        hover_intensity: 0,
        pulse: 0
    };
}

// === CONFIGURAÇÕES VISUAIS ===
scroll_offset = 0;
scroll_max = 0;

show_debug_message("✅ Menu Naval Moderno criado!");