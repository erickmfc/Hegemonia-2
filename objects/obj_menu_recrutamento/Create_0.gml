// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO MODERNIZADO
// Sistema de Animações e Transições Avançadas
// ===============================================

// Evento Create de obj_menu_recrutamento
id_do_quartel = noone; // Variável que guardará o ID do quartel

// Variável para evitar fechamento imediato (previne bug de duplo clique)
delay_abertura = 10; // 10 frames de delay antes de permitir fechamento

// === SISTEMA DE DEBOUNCE PARA NAVEGAÇÃO ===
// Evita cliques múltiplos nas setas de navegação
debounce_navegacao = 0; // Timer de debounce para navegação
debounce_delay = 15; // 15 frames de delay entre navegações (0.25 segundos)

// === SISTEMA DE ANIMAÇÕES E TRANSIÇÕES ===
// Timer geral de animação
animation_timer = 0;
animation_duration = 30; // 30 frames para animação completa

// Alpha do menu (para fade in)
menu_alpha = 0;
menu_alpha_target = 1;
menu_alpha_speed = 0.05;

// Scale do menu (para efeito de entrada)
menu_scale = 0.95;
menu_scale_target = 1.0;
menu_scale_speed = 0.02;

// Alpha do overlay de fundo
overlay_alpha = 0;
overlay_alpha_target = 0.9;
overlay_alpha_speed = 0.03;

// Animações dos cards (staggered entrance)
card_animations = [];
for (var i = 0; i < 4; i++) {
    card_animations[i] = {
        alpha: 0,
        alpha_target: 1,
        scale: 0.8,
        scale_target: 1.0,
        offset_y: 20,
        offset_y_target: 0,
        delay: i * 5, // Delay escalonado
        timer: 0
    };
}

// Animações de hover para cards
card_hover_effects = [];
for (var i = 0; i < 4; i++) {
    card_hover_effects[i] = {
        hover_alpha: 0,
        pulse_alpha: 0,
        glow_intensity: 0
    };
}

// Animações do painel lateral
info_panel_alpha = 0;
info_panel_offset_x = 50;
info_panel_alpha_target = 1;
info_panel_offset_x_target = 0;

// Animações do cabeçalho
header_glow_intensity = 0;
header_glow_target = 1;
header_line_alpha = 0;

// Animações do rodapé
footer_alpha = 0;
footer_alpha_target = 1;

// === SISTEMA DE CONFIRMAÇÃO DE RECRUTAMENTO ===
recruitment_confirmation = false;
confirmation_timer = 0;
confirmation_text = "";
confirmation_color = c_white;

// === SISTEMA DE FILA DE RECRUTAMENTO ===
recruitment_queue = [];
queue_display_timer = 0;

// === SISTEMA DE FEEDBACK VISUAL ===
resource_update_flash = false;
resource_flash_timer = 0;

show_debug_message("Menu de recrutamento modernizado criado. Sistema de animações e feedback inicializado.");
