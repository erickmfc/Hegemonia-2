// ===============================================
// HEGEMONIA GLOBAL - C-100 Transporte (Create)
// ===============================================

// Herdar a configuração do F-5
event_inherited();

// Identidade
nome_unidade = "C-100";

// Ajustes de performance (mais lento que F-5)
velocidade_maxima *= 0.7;
velocidade_rotacao *= 0.6;

// Carga
capacidade_total = 8;
carga_usada = 0;
lista_carga = ds_list_create();
pesos_inf = 1; pesos_aa = 2; pesos_tanque = 3; pesos_blindado = 3;

// Estados/flags
modo_receber_carga = false;
modo_evadindo = false;
penalidade_carga_aplicada = false;

// Flares
flare_cooldown_max = 15 * room_speed;
flare_cooldown = 0;
flare_duracao = 4 * room_speed;
flare_timer_ativo = 0;

show_debug_message("✈️ C-100 criado - Transporte pronto para carga e flares");