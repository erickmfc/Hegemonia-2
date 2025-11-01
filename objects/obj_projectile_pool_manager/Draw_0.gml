// =============================================
// DRAW - Estatísticas do Pool (opcional)
// =============================================

// Apenas desenhar se debug ativado
if (!variable_global_exists("debug_enabled") || !global.debug_enabled) exit;

draw_set_color(make_color_rgb(255, 255, 255));
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _y = 10;
draw_text(10, _y, "=== POOL MANAGER STATS ===");
_y += 20;
draw_text(10, _y, "Criados: " + string(objetos_criados));
_y += 15;
draw_text(10, _y, "Reutilizados: " + string(objetos_reutilizados));
_y += 15;
draw_text(10, _y, "No Pool: " + string(objetos_no_pool));
_y += 15;
var _total = objetos_criados + objetos_reutilizados;
var _economia = (_total > 0) ? round((objetos_reutilizados / _total) * 100) : 0;
draw_text(10, _y, "Economia: " + string(_economia) + "%");
_y += 20;
draw_text(10, _y, "Pool Tiro Simples: " + string(ds_list_size(pool_tiro_simples)));
_y += 15;
draw_text(10, _y, "Pool Tiro Infantaria: " + string(ds_list_size(pool_tiro_infantaria)));
_y += 15;
draw_text(10, _y, "Pool Tiro Tanque: " + string(ds_list_size(pool_tiro_tanque)));
_y += 15;
draw_text(10, _y, "Pool Tiro Canhão: " + string(ds_list_size(pool_tiro_canhao)));

// Resetar configurações
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(255, 255, 255));
