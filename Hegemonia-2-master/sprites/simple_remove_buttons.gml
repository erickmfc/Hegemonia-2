// ========================================
// SOLUÇÃO SIMPLES PARA REMOVER BOTÕES DE SELEÇÃO
// ========================================

// PASSO 1: Adicione esta linha no evento Create do seu objeto principal:
global.hide_selection_buttons = true;

// PASSO 2: Encontre o objeto que desenha os botões PATRULHAR/SEGUIR
// (geralmente é um objeto de interface ou UI)

// PASSO 3: No evento Draw ou Draw GUI desse objeto, adicione esta linha no início:
if (global.hide_selection_buttons) return;

// PASSO 4: Execute o jogo - os botões não aparecerão mais!

// ========================================
// CONTROLE POR TECLADO (OPCIONAL):
// ========================================

// Adicione no evento Step do objeto principal:
if (keyboard_check_pressed(vk_f4)) {
    global.hide_selection_buttons = !global.hide_selection_buttons;
}

// ========================================
// EXEMPLO COMPLETO:
// ========================================

// No objeto que desenha os botões, o evento Draw ficaria assim:
/*
// Evento: Draw
if (global.hide_selection_buttons) return; // SAI SEM DESENHAR NADA

// Código original dos botões aqui (nunca será executado)
draw_set_color(c_gray);
draw_rectangle(10, 10, 150, 80, false);
draw_text(20, 20, "PATRULHAR");
draw_text(20, 50, "SEGUIR");
*/
