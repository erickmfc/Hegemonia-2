// Evento Alarm 0 de obj_poco_petroleo (VERSÃO CORRIGIDA)

// CORREÇÃO: Usando "Petróleo" com acento para corresponder ao cofre.
global.estoque_recursos[? "Petróleo"] += producao_por_ciclo;

// A mensagem de debug também foi corrigida para consistência.
show_debug_message("Produzido +" + string(producao_por_ciclo) + " de Petróleo.");

// Reativa o alarme para o próximo ciclo.
alarm[0] = game_get_speed(gamespeed_fps) * tempo_do_ciclo_em_segundos;