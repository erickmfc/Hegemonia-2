// =============================================
// DRAW - Estatísticas do Cache (opcional)
// =============================================

// Apenas desenhar se debug ativado
if (!variable_global_exists("debug_enabled") || !global.debug_enabled) exit;

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _y = 200; // Posição Y (abaixo das stats do pool manager)
draw_text(10, _y, "=== CACHE ENEMY SEARCH STATS ===");
_y += 20;
draw_text(10, _y, "Entradas: " + string(cache_entries) + "/" + string(max_cache_size));
_y += 15;
draw_text(10, _y, "Hits: " + string(cache_hits));
_y += 15;
draw_text(10, _y, "Misses: " + string(cache_misses));
_y += 15;
var _total = cache_hits + cache_misses;
var _hit_rate = (_total > 0) ? round((cache_hits / _total) * 100) : 0;
draw_text(10, _y, "Hit Rate: " + string(_hit_rate) + "%");
_y += 15;
draw_text(10, _y, "Invalidados: " + string(cache_invalidated));

