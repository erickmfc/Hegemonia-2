// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-6 (ALVO DE TESTE)
// Create Event - Baseado no F-5 para testes de mísseis ar-ar
// ===============================================

// --- ATRIBUTOS DE VOO ---
velocidade_atual = 0;
velocidade_maxima = 3.5; // Ligeiramente mais lento que o F-5
aceleracao = 0.04;
desaceleracao = 0.025;
velocidade_rotacao = 1.5;

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 650; // HP inicial igual ao máximo
hp_max = 650;
nacao_proprietaria = 2; // ✅ Nação da IA (presidente) - F6 controlado pelo presidente
radar_alcance = 500; // Aumentado para melhor detecção
timer_ataque = 0;
intervalo_ataque = 90; // Reduzido para ataques mais frequentes
modo_ataque = true; // ✅ Ativar modo ataque para o presidente usar o F6
dano_missil_ar_ar = 95; // Dano do míssil ar-ar
dano_missil_ar_terra = 95; // Dano do míssil ar-terra
alcance_missil_ar_ar = 300; // Alcance míssil ar-ar
alcance_missil_ar_terra = 250; // Alcance míssil ar-terra

// --- MÁQUINA DE ESTADOS ---
estado = "pousado"; // Estados: "pousado", "decolando", "pousando", "movendo", "patrulhando", "definindo_patrulha"

// --- SISTEMA DE ALTITUDE ---
altura_voo = 0;
altura_maxima = 18;

// --- SISTEMA DE PATRULHA ---
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// --- CONTROLE ---
destino_x = x; // ✅ Garantir que destino inicial é a posição do mapa
destino_y = y; // ✅ Garantir que destino inicial é a posição do mapa
selecionado = false;
visible = true; // ✅ Garantir que está visível

// --- NOVAS VARIÁVEIS PARA ATAQUE AGRESSIVO ---
estado_anterior = "pousado"; // Guarda o que o avião estava fazendo antes de atacar
alvo_em_mira = noone;         // Guarda a ID do inimigo que está sendo caçado

// --- SISTEMA DE PATRULHA RETANGULAR ---
// Área de patrulha: dos soldados inimigos (400,300) até o meio do mapa (1600,960)
patrulha_x_min = 400;   // Posição dos soldados inimigos
patrulha_y_min = 300;
patrulha_x_max = 1600;  // Meio do mapa
patrulha_y_max = 960;
patrulha_ativa = true;  // Sistema de patrulha retangular ativo

// --- CONFIGURAÇÕES DE TESTE ---
modo_teste = false; // ✅ DESABILITADO: Presidente tem controle total sobre o F6
timer_decolagem_automatica = 0; // ✅ DESABILITADO: Não decola automaticamente
patrulha_automatica = false; // ✅ DESABILITADO: Não inicia patrulha automática
raio_patrulha_teste = 220; // Mantido para referência (não usado quando modo_teste = false)

show_debug_message("✈️ Caça F-6 criado - ALVO DE TESTE para mísseis ar-ar");
show_debug_message("🎯 Nação: " + string(nacao_proprietaria) + " | HP: " + string(hp_atual) + " | Modo: TESTE");