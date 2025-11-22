// ===============================================
// HEGEMONIA GLOBAL - NAVIO PIRATA TIPO 3
// Lento e Resistente - Especializado em combate
// ===============================================

if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === TERRENOS PERMITIDOS ===
terrenos_permitidos = [TERRAIN.AGUA];

// === IDENTIFICAÇÃO ===
tipo_unidade = "pirata_tipo3";
nacao_proprietaria = 3;
nome_unidade = "Navio Pirata Pesado";

// === ATRIBUTOS (LENTO E RESISTENTE) ===
hp_atual = 180;  // ✅ AUMENTADO: Aguentar 3-4 mísseis (era 120)
hp_max = 180;
velocidade_movimento = 1.2;  // ✅ LENTO: Mais lento que outros
moveSpeed = 2.4;
acceleration = 0.12;
turnSpeed = 2.0;  // ✅ LENTO: Gira devagar

// === VARIÁVEIS DE NAVEGAÇÃO ===
if (!variable_instance_exists(id, "target_x")) target_x = x;
if (!variable_instance_exists(id, "target_y")) target_y = y;
if (!variable_instance_exists(id, "usar_novo_sistema")) usar_novo_sistema = true;
if (!variable_instance_exists(id, "is_moving")) is_moving = false;
if (!variable_instance_exists(id, "destino_x")) destino_x = x;
if (!variable_instance_exists(id, "destino_y")) destino_y = y;

// === SISTEMA DE PATRULHA ===
pilares_patrulha = ds_list_create();
indice_pilar_atual = 0;
tempo_espera_pilar = 240;  // 4 segundos (mais tempo)
timer_espera = 0;
estado_patrulha = "navegando";

// === SISTEMA DE DETECÇÃO ===
raio_deteccao = 350;  // ✅ ALCANCE MENOR
alvo_atual = noone;
modo_cacando = false;

// === SISTEMA DE COMBATE ===
dano_base = 20;  // ✅ DANO ALTO
alcance_ataque = 300;
reload_time = 120;  // 2 segundos (mais lento)
reload_timer = 0;

// === MULTIPLICADORES ===
multiplicador_vs_militar = 0.6;  // ✅ MENOS FRACO vs militares
multiplicador_vs_carga = 2.5;    // ✅ MUITO FORTE vs carga

// === ESTADOS ===
estado = LanchaState.MOVENDO;  // ✅ CORREÇÃO: Começar se movendo
modo_combate = LanchaMode.ATAQUE;
is_moving = true;  // ✅ GARANTIR: Começar em movimento
usar_novo_sistema = true;  // ✅ GARANTIR: Usar sistema de física
vinculado = false;

// === GARANTIR VISIBILIDADE ===
visible = true;
image_alpha = 1.0;

// === REDUÇÃO DE TAMANHO DA IMAGEM ===
image_xscale = 0.10;  // ✅ Reduzir para 70% do tamanho original
image_yscale = 0.10;

show_debug_message("🏴‍☠️ Navio Pirata Tipo 3 criado em (" + string(x) + ", " + string(y) + ")");
show_debug_message("   HP: " + string(hp_atual) + " | Velocidade: " + string(velocidade_movimento) + " (LENTO E RESISTENTE)");
