// =============================================
// DRAW - Estatísticas de Otimização (opcional)
// =============================================

// Apenas desenhar se debug ativado
if (!variable_global_exists("debug_enabled") || !global.debug_enabled) exit;

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _y = 350; // Posição Y (abaixo de outras stats)
draw_text(10, _y, "=== DRAW OPTIMIZER STATS ===");
_y += 20;
draw_text(10, _y, "Draw Calls Saved: " + string(draw_calls_saved));
_y += 15;
draw_text(10, _y, "Objects Skipped: " + string(objects_skipped));
_y += 15;
var _save_percent = (draw_calls_saved > 0) ? round((objects_skipped / max(1, objects_skipped + draw_calls_saved)) * 100) : 0;
draw_text(10, _y, "Optimization Rate: " + string(_save_percent) + "%");
