// ===============================================
// HEGEMONIA GLOBAL - MENU AÉREO MODERNO
// Sistema Grid com Todas as Aeronaves Visíveis
// ===============================================

show_debug_message("🚀 MENU AÉREO MODERNO - CREATE EVENT");

// === VARIÁVEIS DE CONEXÃO ===
id_do_aeroporto = noone;

// === VARIÁVEIS DE SELEÇÃO ===
aeronave_hover = -1; // Índice da aeronave com hover (-1 = nenhum)
aeronave_selecionada = -1; // Índice da aeronave clicada

// === PROTEÇÃO CONTRA CLIQUE AUTOMÁTICO ===
menu_aberto_frames = 0; // Contador de frames desde que o menu abriu
frames_minimos_antes_clique = 10; // ✅ AUMENTADO para 10 frames (≈0.17s a 60fps) para evitar cliques acidentais

// === ANIMAÇÕES ===
animation_timer = 0;
card_animations = [];

// Inicializar animação para 6 aeronaves (ou quantas tiver)
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

show_debug_message("✅ Menu Aéreo Moderno criado!");
