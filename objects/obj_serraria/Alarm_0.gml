global.estoque_recursos[? "Madeira Nobre"] += producao_por_ciclo;
show_debug_message("Produzido +" + string(producao_por_ciclo) + " de Madeira Nobre.");
alarm[0] = game_get_speed(gamespeed_fps) * tempo_do_ciclo_em_segundos;
