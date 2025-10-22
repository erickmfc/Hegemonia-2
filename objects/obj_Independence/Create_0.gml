/// @description Inicialização da Fragata Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE (HERDA DE NAVIO_BASE)
// Fragata com Dobro de Vida e 0.9x Velocidade da Constellation
// ===============================================

// Chamar o Create do objeto pai PRIMEIRO
event_inherited();

// === CONFIGURAÇÕES ESPECÍFICAS DA INDEPENDENCE ===

// Atributos únicos da Independence
hp_atual = 1600; // Dobro da Constellation (800 * 2)
hp_max = 1600;
velocidade_movimento = 0.95; // 0.9x da Constellation (2.5 * 0.9)
radar_alcance = 1000;
missil_alcance = 800;
alcance_ataque = missil_alcance;
dano_ataque = 100;
reload_time = 120;

// Nome da unidade
nome_unidade = "Independence"; // Sobrescreve o nome do pai

// === VARIÁVEIS DE FEEDBACK ===
ultima_acao = "nenhuma";
cor_feedback = c_white;
feedback_timer = 0;

// === SISTEMA DE CANHÃO ===
canhao_instancia = noone; // Instância do canhão
canhao_offset_x = 0; // Offset X do canhão (centro do navio)
canhao_offset_y = 0; // Offset Y do canhão (centro do navio)

// === SISTEMA DE METRALHADORA ===
metralhadora_ativa = false;
metralhadora_timer = 0;
metralhadora_intervalo = 5; // 5 frames entre tiros da metralhadora
metralhadora_duracao = 60; // 1 segundo de metralhadora
metralhadora_tiros = 0;
metralhadora_max_tiros = 12; // 12 tiros por rajada

// === SISTEMA DE DEBUG ===
debug_timer = 0;

show_debug_message("🚢 Independence configurado - HP: " + string(hp_atual) + ", Velocidade: " + string(velocidade_movimento));
show_debug_message("🚢 Sistema de canhão e metralhadora inicializado");
show_debug_message("🚢 Estado inicial: " + string(estado));
show_debug_message("🚢 Tem ordem_mover: " + string(variable_instance_exists(id, "ordem_mover")));