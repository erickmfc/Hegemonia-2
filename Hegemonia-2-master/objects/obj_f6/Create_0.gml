// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-6 (ALVO DE TESTE)
// Create Event - Baseado no F-5 para testes de mísseis ar-ar
// ===============================================

// --- ATRIBUTOS DE VOO ---
velocidade_atual = 0;
velocidade_maxima = 3.5; // Ligeiramente mais lento que o F-5
aceleracao = 0.04;
desaceleracao = 0.025;
velocidade_rotacao = 2.5;

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 850; // Menos HP que o F-5 para testes
hp_max = 150;
nacao_proprietaria = 2; // Nação inimiga para testes
radar_alcance = 400;
timer_ataque = 0;
intervalo_ataque = 120;
modo_ataque = false;

// --- MÁQUINA DE ESTADOS ---
estado = "pousado"; // Estados: "pousado", "decolando", "pousando", "movendo", "patrulhando", "definindo_patrulha"

// --- SISTEMA DE ALTITUDE ---
altura_voo = 0;
altura_maxima = 18;

// --- SISTEMA DE PATRULHA ---
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// --- CONTROLE ---
destino_x = x;
destino_y = y;
selecionado = false;

// --- NOVAS VARIÁVEIS PARA ATAQUE AGRESSIVO ---
estado_anterior = "pousado"; // Guarda o que o avião estava fazendo antes de atacar
alvo_em_mira = noone;         // Guarda a ID do inimigo que está sendo caçado

// --- CONFIGURAÇÕES DE TESTE ---
modo_teste = true; // Modo especial para testes
timer_decolagem_automatica = 300; // Decola automaticamente após 5 segundos
patrulha_automatica = true; // Inicia patrulha automática
raio_patrulha_teste = 200; // Raio da patrulha de teste

show_debug_message("✈️ Caça F-6 criado - ALVO DE TESTE para mísseis ar-ar");
show_debug_message("🎯 Nação: " + string(nacao_proprietaria) + " | HP: " + string(hp_atual) + " | Modo: TESTE");