// ================================================
// HEGEMONIA GLOBAL - OBJETO: INIMIGO TESTE NOVO
// Create Event - OBJETO COMPLETAMENTE NOVO
// ================================================

// === PROPRIEDADES BÁSICAS ===
hp_atual = 100;
hp_max = 100;
nacao_proprietaria = 2;
estado = "livre";
comando_atual = "LIVRE";

// === PROPRIEDADES DE MOVIMENTO ===
velocidade = 2;
raio_selecao = 30;

// === PROPRIEDADES DE TESTE ===
selecionado = false;
pode_ser_arrastado = true;
posicao_original_x = x;
posicao_original_y = y;
timer_verificacao = 0;
timer_draw = 0;

// === COR E VISUAL ===
image_blend = make_color_rgb(255, 0, 0);

// === VERIFICAÇÕES ===
visible = true;
image_alpha = 1.0;

// === DEBUG ===
show_debug_message("🎯 OBJETO NOVO criado - ID: " + string(id));
show_debug_message("🎯 HP: " + string(hp_atual) + "/" + string(hp_max));
show_debug_message("🎯 Posição: " + string(x) + ", " + string(y));
show_debug_message("🎯 Nome do objeto: obj_inimigo_teste");
