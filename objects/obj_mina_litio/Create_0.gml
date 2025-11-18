// =========================================================
// MINA DE LÍTIO - HERDA DE obj_estrutura_producao
// =========================================================

event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 3000;
custo_minerio = 600;

// === SISTEMA DE VIDA ===
hp_max = 650;
hp_atual = 650;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 4;
tipo_recurso = "litio";

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Minas só em terreno de campo

// === CICLO PERSONALIZADO ===
// Lítio tem ciclo de 18 segundos
alarm[0] = game_get_speed(gamespeed_fps) * 18;

show_debug_message("⛏️ Mina de Lítio criada - Produção: " + string(producao_por_ciclo) + " lítio a cada 18 segundos");
