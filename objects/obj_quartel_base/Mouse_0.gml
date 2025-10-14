// ===============================================
// HEGEMONIA GLOBAL - QUARTEL BASE MOUSE EVENT
// Interface simplificada e intuitiva
// ===============================================

if (mouse_check_button_pressed(mb_left)) {
    // Verificar se clicou no quartel
    if (point_in_circle(mouse_x, mouse_y, x, y, 50)) {
        // Alternar menu
        mostrar_menu = !mostrar_menu;
        
        if (mostrar_menu) {
            show_debug_message("📋 Menu de produção aberto");
            show_debug_message("💡 Use teclas 1-4 para produção rápida");
            show_debug_message("💡 Use C para cancelar, M para menu");
        } else {
            show_debug_message("📋 Menu de produção fechado");
        }
    }
}
