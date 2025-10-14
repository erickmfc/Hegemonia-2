// ========================================
// SCRIPT PARA DESABILITAR BOTÕES DE SELEÇÃO
// ========================================
// Use este script para desabilitar os botões PATRULHAR/SEGUIR

// Adicione este código no evento Create do seu objeto principal do jogo:
global.disable_selection_ui = true; // true = desabilitado, false = habilitado

// ========================================
// SCRIPT PRINCIPAL - COLE EM QUALQUER OBJETO QUE DESENHA INTERFACE
// ========================================

// Cole este código no evento Draw ou Draw GUI de qualquer objeto que desenha interface:
if (global.disable_selection_ui) {
    // Não desenha nada - botões ficam invisíveis
    exit;
}

// Se chegou aqui, os botões estão habilitados
// (coloque o código original de desenho dos botões aqui)

// ========================================
// CONTROLE POR TECLADO (OPCIONAL)
// ========================================

// Cole este código no evento Step do objeto principal:
if (keyboard_check_pressed(vk_f3)) {
    global.disable_selection_ui = !global.disable_selection_ui;
    if (global.disable_selection_ui) {
        show_message("Botões de seleção DESABILITADOS");
    } else {
        show_message("Botões de seleção HABILITADOS");
    }
}

// ========================================
// INSTRUÇÕES RÁPIDAS:
// ========================================

/*
1. Encontre o objeto que desenha os botões PATRULHAR/SEGUIR
2. No evento Draw ou Draw GUI desse objeto, adicione no início:
   if (global.disable_selection_ui) exit;
3. Execute o jogo - os botões não aparecerão mais
4. Pressione F3 para alternar se necessário
*/
