// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO MODERNIZADO
// Sistema de Animações e Transições Avançadas
// ===============================================

// Evento Create de obj_menu_recrutamento
id_do_quartel = noone; // Variável que guardará o ID do quartel
unidade_hover = -1; // Índice da unidade com hover

// === GARANTIR QUE O MENU ESTEJA NA FRENTE ===
depth = -10000; // Menu sempre visível e interativo

// Variável para evitar fechamento imediato (previne bug de duplo clique)
delay_abertura = 10; // 10 frames de delay antes de permitir fechamento

// === SISTEMA DE DEBOUNCE PARA NAVEGAÇÃO ===
// Evita cliques múltiplos nas setas de navegação
debounce_navegacao = 0; // Timer de debounce para navegação
debounce_delay = 15; // 15 frames de delay entre navegações (0.25 segundos)

// === SISTEMA DE ANIMAÇÕES ===
animation_timer = 0;
card_animations = [];

// Inicializar animação para 6 unidades (militar)
for (var i = 0; i < 6; i++) {
    card_animations[i] = {
        alpha: 0,
        scale: 0.8,
        hover_intensity: 0,
        pulse: 0
    };
}

// === SISTEMA DE CONFIRMAÇÃO DE RECRUTAMENTO ===
recruitment_confirmation = false;
confirmation_timer = 0;
confirmation_text = "";
confirmation_color = c_white;

// === SISTEMA DE FILA DE RECRUTAMENTO ===
recruitment_queue = ds_list_create();
queue_display_timer = 0;

// === SISTEMA DE FEEDBACK VISUAL ===
resource_update_flash = false;
resource_flash_timer = 0;

show_debug_message("Menu de recrutamento modernizado criado. Sistema de animações e feedback inicializado.");
