// ===============================================
// HEGEMONIA GLOBAL - BOTÃO DE CONSTRUÇÃO
// Bloco 3, Fase 1: Inicialização do Botão
// ===============================================

// Posicionamento fixo na interface
x = display_get_gui_width() - 80;  // 80 pixels da borda direita
y = display_get_gui_height() - 80; // 80 pixels da borda inferior

// Dimensões do botão para desenho customizado
button_width = 64;
button_height = 64;

// Configurações visuais
hover_effect = false;
button_alpha = 1.0;

show_debug_message("Botão de construção inicializado na posição: " + string(x) + ", " + string(y));
