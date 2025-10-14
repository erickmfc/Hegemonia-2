// ========================================
// DESABILITAR GUI PRINCIPAL
// ========================================
// Use este código para desabilitar o GUI principal do jogo

// Adicione esta variável global no evento Create do seu objeto principal:
global.show_gui = false; // Mude para true se quiser mostrar o GUI novamente

// ========================================
// COMO USAR:
// ========================================

// 1. No objeto que desenha o GUI principal, envolva todo o código de desenho com:
/*
if (global.show_gui) {
    // Todo o código de desenho do GUI aqui
    // Exemplo:
    draw_set_color(c_blue);
    draw_rectangle(100, 100, 500, 400, false);
    draw_text(120, 120, "CENTRO DE COMANDO NACIONAL");
    // ... resto do código do GUI
}
*/

// 2. Para alternar o GUI durante o jogo, adicione no evento Step:
/*
if (keyboard_check_pressed(vk_f1)) {
    global.show_gui = !global.show_gui;
    if (global.show_gui) {
        show_message("GUI ativado");
    } else {
        show_message("GUI desativado");
    }
}
*/

// ========================================
// INSTRUÇÕES DE IMPLEMENTAÇÃO:
// ========================================

/*
PASSO 1: Encontrar o objeto que desenha o GUI
- Procure por um objeto que tenha evento Draw ou Draw GUI
- Procure por código que desenha "CENTRO DE COMANDO NACIONAL"
- Procure por código que desenha os painéis de economia, recursos, etc.

PASSO 2: Modificar o código de desenho
- Envolva todo o código de desenho do GUI com: if (global.show_gui) { ... }

PASSO 3: Adicionar controle por teclado (opcional)
- Adicione o código de alternância com F1 no evento Step

PASSO 4: Testar
- Execute o jogo
- Pressione F1 para alternar o GUI
- Ou mude global.show_gui = false para desabilitar permanentemente
*/
