global.estoque_recursos[? "Madeira Nobre"] += producao_por_ciclo;
show_debug_message("Produzido +" + string(producao_por_ciclo) + " de Madeira Nobre.");
alarm[0] = room_speed * tempo_do_ciclo_em_segundos;