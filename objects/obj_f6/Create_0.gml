// ===============================================
// HEGEMONIA GLOBAL - F-6
// 2ª/3ª GERAÇÃO (anos 70) - Tecnologia básica melhorada
// ===============================================

// === SISTEMA DE GERAÇÕES ===
geracao_caca = FighterGeneration.GEN_2;  // 2ª/3ª geração

// --- ATRIBUTOS DE VOO ---
velocidade_atual = 0;
velocidade_maxima = 3.0;  // ✅ 2ª/3ª geração - ligeiramente melhor que F-5
aceleracao = 0.04;
desaceleracao = 0.025;
velocidade_rotacao = 1.5;

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 200;  // ✅ 2ª/3ª geração - HP melhorado
hp_max = 200;
nacao_proprietaria = 2; // ✅ Nação da IA (presidente) - F6 controlado pelo presidente
radar_alcance = 500;  // ✅ 2ª/3ª geração - radar melhorado
alcance_ataque = 450;  // ✅ Alcance de ataque
timer_ataque = 0;
intervalo_ataque = 90;
modo_ataque = true; // ✅ Ativar modo ataque para o presidente usar o F6
dano_missil_ar_ar = 95;
dano_missil_ar_terra = 95;
alcance_missil_ar_ar = 300;
alcance_missil_ar_terra = 250;

// --- SISTEMA DE MÍSSEIS (APENAS LIT) ---
timer_lit = 0;
intervalo_lit = 420;  // ✅ 7 segundos (um pouco mais rápido que F-5)
dano_multiplier = 0.8;  // ✅ 20% menos dano (melhor que F-5)

// --- TECNOLOGIA ---
stealth_ativo = false;  // ✅ Sem stealth
sensores_avancados = false;  // ✅ Sensores básicos

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