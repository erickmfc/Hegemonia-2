// Evento Alarm 0 de obj_economic_dashboard - Sistema Simplificado
// Mantém funcionalidades essenciais em background sem dashboard visual

// Atualizar data do jogo (sistema simples)
global.game_day += 1;
if (global.game_day > 30) {
    global.game_day = 1;
    global.game_month += 1;
}
if (global.game_month > 12) {
    global.game_month = 1;
    global.game_year += 1;
}

// Crescimento básico da população
global.pop_growth = floor(global.estoque_recursos[? "População"] * 0.005); // 0.5% crescimento
global.estoque_recursos[? "População"] += global.pop_growth;

// Atualizar variáveis militares e ranking (valores básicos)
global.military_total = 0; // Resetar e recalcular se necessário
global.ranking_position = 1; // Valor padrão

// Reativar alarme a cada 3 segundos (menos processamento)
alarm[0] = room_speed * 3;