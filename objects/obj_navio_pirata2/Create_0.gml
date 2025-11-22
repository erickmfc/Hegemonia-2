// ===============================================
// HEGEMONIA GLOBAL - NAVIO PIRATA TIPO 2
// Balanceado - Versátil
// ===============================================

if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === TERRENOS PERMITIDOS ===
terrenos_permitidos = [TERRAIN.AGUA];

// === IDENTIFICAÇÃO ===
tipo_unidade = "pirata_tipo2";
nacao_proprietaria = 3;
nome_unidade = "Navio Pirata";

// === ATRIBUTOS (BALANCEADO) ===
hp_atual = 150;   // ✅ AUMENTADO: Aguentar 2-3 mísseis (era 80)
hp_max = 150;
velocidade_movimento = 1.6;  // ✅ MÉDIO
moveSpeed = 3.2;
acceleration = 0.15;
turnSpeed = 2.5;

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
tempo_espera_pilar = 180;  // 3 segundos
timer_espera = 0;
estado_patrulha = "navegando";

// === SISTEMA DE DETECÇÃO ===
raio_deteccao = 400;  // ✅ MÉDIO
alvo_atual = noone;
modo_cacando = false;

// === SISTEMA DE COMBATE ===
dano_base = 15;  // ✅ DANO MÉDIO-ALTO
alcance_ataque = 350;
reload_time = 90;  // 1.5 segundos
reload_timer = 0;

// === MULTIPLICADORES ===
multiplicador_vs_militar = 0.5;  // ✅ FRACO vs militares
multiplicador_vs_carga = 2.0;    // ✅ FORTE vs carga

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
image_xscale = 0.16;  // ✅ Reduzir para 70% do tamanho original
image_yscale = 0.16;

show_debug_message("🏴‍☠️ Navio Pirata Tipo 2 criado em (" + string(x) + ", " + string(y) + ")");
show_debug_message("   HP: " + string(hp_atual) + " | Velocidade: " + string(velocidade_movimento) + " (BALANCEADO)");
