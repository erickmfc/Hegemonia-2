/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// ===============================================
// HEGEMONIA GLOBAL - QUARTEL BASE
// Interface Simplificada
// ===============================================

if (mouse_check_button_pressed(mb_left)) {
    // Verificar se clicou no quartel
    if (point_in_circle(mouse_x, mouse_y, x, y, 50)) {
        // Selecionar quartel
        selecionado = true;
        
        // Alternar menu
        mostrar_menu = !mostrar_menu;
        
        if (mostrar_menu) {
            show_debug_message("📋 Menu de produção aberto - Quartel ID: " + string(id));
            show_debug_message("🎮 Use teclas numéricas (1-4) para produção rápida");
        } else {
            show_debug_message("📋 Menu de produção fechado");
        }
    } else {
        // Deselecionar se clicou em outro lugar
        selecionado = false;
        mostrar_menu = false;
    }
}
