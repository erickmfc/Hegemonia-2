// ===============================================
// HEGEMONIA GLOBAL - OBJETO CARREGAMENTO
// Sistema de Tela de Carregamento
// ===============================================

// Duração do carregamento (5 segundos)
tempo_total = 10.0; // segundos
tempo_atual = 0.0; // segundos decorridos

// Progresso da barra (0.0 a 1.0)
progresso = 0.0;

// Room destino (teste)
room_destino = "teste";

// Cores da barra
cor_fundo = c_black;
cor_barra = c_blue;
cor_borda = c_white;

// Dimensões da barra
largura_barra = 800;
altura_barra = 70;
pos_x = room_width / 2;
pos_y = room_height / 2 + 100;

// Texto de carregamento
texto_carregamento = "Carregando porra...";

show_debug_message("🔄 Tela de carregamento iniciada - " + string(tempo_total) + " segundos");
