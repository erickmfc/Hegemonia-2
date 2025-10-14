// ========================================
// DESABILITAR BOTÕES DE SELEÇÃO (PATRULHAR/SEGUIR)
// ========================================
// Use este código para desabilitar os botões que aparecem quando você seleciona navios/soldados

// Adicione esta variável global no evento Create do seu objeto principal:
global.show_selection_buttons = false; // Mude para true se quiser mostrar os botões novamente

// ========================================
// COMO USAR:
// ========================================

// 1. No objeto que desenha os botões de seleção, envolva todo o código de desenho com:
/*
if (global.show_selection_buttons) {
    // Todo o código de desenho dos botões PATRULHAR e SEGUIR aqui
    // Exemplo:
    draw_set_color(c_gray);
    draw_rectangle(10, 10, 150, 80, false);
    draw_text(20, 20, "PATRULHAR");
    draw_text(20, 50, "SEGUIR");
    // ... resto do código dos botões
}
*/

// 2. Para alternar os botões durante o jogo, adicione no evento Step:
/*
if (keyboard_check_pressed(vk_f2)) {
    global.show_selection_buttons = !global.show_selection_buttons;
    if (global.show_selection_buttons) {
        show_message("Botões de seleção ativados");
    } else {
        show_message("Botões de seleção desativados");
    }
}
*/

// ========================================
// INSTRUÇÕES DE IMPLEMENTAÇÃO:
// ========================================

/*
PASSO 1: Encontrar o objeto que desenha os botões de seleção
- Procure por um objeto que tenha evento Draw ou Draw GUI
- Procure por código que desenha botões quando um navio/soldado é selecionado
- Procure por código que desenha "PATRULHAR" e "SEGUIR"
- Geralmente está em um objeto como obj_ui_manager, obj_selection_manager, etc.

PASSO 2: Modificar o código de desenho
- Envolva todo o código de desenho dos botões com: if (global.show_selection_buttons) { ... }

PASSO 3: Adicionar controle por teclado (opcional)
- Adicione o código de alternância com F2 no evento Step

PASSO 4: Testar
- Execute o jogo
- Selecione um navio ou soldado
- Os botões PATRULHAR/SEGUIR não devem aparecer
- Pressione F2 para alternar se necessário
*/

// ========================================
// ALTERNATIVA: DESABILITAR PERMANENTEMENTE
// ========================================

// Se você quiser desabilitar permanentemente, simplesmente:
// 1. Encontre o objeto que desenha os botões
// 2. Comente ou remova todo o código de desenho dos botões
// 3. Ou adicione uma condição que sempre seja false:
/*
if (false) { // Nunca vai executar
    // Código dos botões aqui
}
*/
