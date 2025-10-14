// ===============================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA (Sistema Baseado no F-5)
// ===============================================

// --- ATRIBUTOS DE NAVEGAÇÃO ---
velocidade_atual = 0;
velocidade_maxima = 3.5; // Mais rápido que o F-5 para compensar a água
aceleracao = 0.08; // Aceleração mais suave na água
desaceleracao = 0.04; // Desaceleração mais gradual
velocidade_rotacao = 2.5; // Rotação mais lenta na água

// --- ATRIBUTOS DE COMBATE ---
hp_atual = 300;
hp_max = 300;
nacao_proprietaria = 1;
radar_alcance = 500; // Alcance de detecção
alcance_ataque = 400; // ✅ NOVO: Alcance de ataque (menor que radar)
timer_ataque = 0;
intervalo_ataque = 120; // Intervalo entre ataques
modo_ataque = false;

// --- MÁQUINA DE ESTADOS ---
estado = "parado"; // Estados: "parado", "movendo", "patrulhando", "atacando"

// --- SISTEMA DE PATRULHA ---
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// --- CONTROLE ---
destino_x = x;
destino_y = y;
selecionado = false; // Variável de seleção
movendo = false; // Compatibilidade com sistema antigo

// --- VARIÁVEIS PARA ATAQUE AGRESSIVO ---
estado_anterior = "parado"; // Guarda o que a lancha estava fazendo antes de atacar
alvo_em_mira = noone; // Guarda a ID do inimigo que está sendo atacado
seguindo_alvo = false; // ✅ NOVO: Se está seguindo um alvo em movimento

// --- COMPATIBILIDADE COM SISTEMA ANTIGO ---
destino_x = x;
destino_y = y;
movendo = false;

// --- VERIFICAÇÃO DE SEGURANÇA PARA DEBUG ---
if (!variable_global_exists("game_frame")) {
    global.game_frame = 0;
}

// --- MÉTODO PARA RECEBER ORDENS DO CONTROLADOR ---
// Função será chamada externamente: scr_ordem_mover_lancha(id, novo_destino_x, novo_destino_y)

// --- VARIÁVEIS DE CONTROLE DE PATRULHA ---
pode_iniciar_patrulha = true;
pode_adicionar_ponto = true;
pode_limpar_patrulha = true;

show_debug_message("🚢 Lancha Patrulha criada - Sistema baseado no F-5 adaptado para navegação");