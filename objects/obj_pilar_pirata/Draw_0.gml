// ===============================================
// PILAR PIRATA - DRAW (INVISÍVEL)
// ===============================================

// ✅ NÃO DESENHAR NADA - Pilar é invisível
// Apenas para debug (se necessário)
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    // Mostrar apenas em modo debug
    draw_set_color(c_yellow);
    draw_set_alpha(0.2);
    draw_circle(x, y, 20, false);  // Círculo pequeno para debug
    draw_set_alpha(1.0);
}
