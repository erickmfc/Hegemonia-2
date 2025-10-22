/// @description Ciclo de Produção da Fazenda - 1 Mês
// =============================================
// HEGEMONIA GLOBAL - PRODUÇÃO DE ALIMENTO SIMPLIFICADA
// =============================================

// === PRODUÇÃO SIMPLES ===
producao_final = producao_base; // Sem bônus de terreno

// === ADICIONAR AO RECURSO GLOBAL ===
global.alimento += producao_final;
global.estoque_recursos[? "Alimento"] = global.alimento;

// === DEBUG DA PRODUÇÃO ===
show_debug_message("🌾 Fazenda produziu: " + string(producao_final) + " Alimento");
show_debug_message("🌾 Total de Alimento: " + string(global.alimento));

// === REINICIAR CICLO PARA PRÓXIMO MÊS ===
alarm[0] = game_get_speed(gamespeed_fps) * 1800; // 30 minutos para próximo ciclo