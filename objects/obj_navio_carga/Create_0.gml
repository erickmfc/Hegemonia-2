// ===============================================
// HEGEMONIA GLOBAL - NAVIO DE CARGA
// Lento, frágil mas com muito valor
// ===============================================

// ✅ CORREÇÃO: Verificar se tem parent antes de herdar
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === TERRENOS PERMITIDOS (CRÍTICO) ===
terrenos_permitidos = [TERRAIN.AGUA];  // ✅ Só navega em água

// === IDENTIFICAÇÃO ===
tipo_unidade = "navio_carga";
nacao_proprietaria = 1;  // ✅ Nação 1 = Jogador
nome_unidade = "Navio de Carga";

// === ATRIBUTOS (LENTO E FRÁGIL) ===
hp_atual = 40;   // ✅ MUITO FRÁGIL
hp_max = 40;
velocidade_movimento = 0.8;  // ✅ MUITO LENTO: Mais lento que todos
moveSpeed = 1.6;
acceleration = 0.08;
turnSpeed = 1.5;  // ✅ Gira muito devagar

// === VARIÁVEIS DE NAVEGAÇÃO (CRÍTICO) ===
// ✅ GARANTIR que todas as variáveis existem
if (!variable_instance_exists(id, "target_x")) target_x = x;
if (!variable_instance_exists(id, "target_y")) target_y = y;
if (!variable_instance_exists(id, "usar_novo_sistema")) usar_novo_sistema = true;
if (!variable_instance_exists(id, "is_moving")) is_moving = false;
if (!variable_instance_exists(id, "destino_x")) destino_x = x;
if (!variable_instance_exists(id, "destino_y")) destino_y = y;

// === SISTEMA DE CARGA ===
carga_atual = 0;  // Quantidade de carga transportada
carga_maxima = 100;  // Capacidade máxima
valor_carga = 5000;  // Valor em dinheiro

// === ESTADOS ===
estado = LanchaState.PARADO;
modo_combate = LanchaMode.PASSIVO;  // ✅ PASSIVO: Não ataca

// === SEM SISTEMA DE COMBATE ===
// Navios de carga não atacam
dano_base = 0;
alcance_ataque = 0;
reload_time = 0;
reload_timer = 0;

// === ROTA DE TRANSPORTE ===
rota_waypoints = ds_list_create();
indice_waypoint_atual = 0;
tempo_espera_waypoint = 60;  // 1 segundo
timer_espera = 0;

// === GARANTIR VISIBILIDADE ===
visible = true;
image_alpha = 1.0;

show_debug_message("🚢 Navio de Carga criado em (" + string(x) + ", " + string(y) + ")");
show_debug_message("   HP: " + string(hp_atual) + " | Velocidade: " + string(velocidade_movimento) + " (LENTO)");
show_debug_message("   Valor: " + string(valor_carga) + " 💰");
