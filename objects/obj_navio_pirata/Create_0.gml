// ===============================================
// HEGEMONIA GLOBAL - NAVIO PIRATA TIPO 1
// Rápido e Frágil - Especializado em perseguição
// ===============================================

// ✅ CORREÇÃO: Verificar se tem parent antes de herdar
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === TERRENOS PERMITIDOS (CRÍTICO) ===
terrenos_permitidos = [TERRAIN.AGUA];  // ✅ Só navega em água

// === IDENTIFICAÇÃO ===
tipo_unidade = "pirata_tipo1";
nacao_proprietaria = 3;  // ✅ Nação 3 = Piratas
nome_unidade = "Navio Pirata Rápido";

// === ATRIBUTOS (RÁPIDO E FRÁGIL) ===
hp_atual = 120;   // ✅ AUMENTADO: Aguentar 2 mísseis (era 60)
hp_max = 120;     // ✅ AUMENTADO: Aguentar 2 mísseis (era 60)
velocidade_movimento = 2.0;  // ✅ RÁPIDO: Mais rápido que todos
moveSpeed = 4.0;
acceleration = 0.18;
turnSpeed = 3.0;  // ✅ MANOBRÁVEL: Gira rápido

// === VARIÁVEIS DE NAVEGAÇÃO (CRÍTICO) ===
// ✅ GARANTIR que todas as variáveis existem
if (!variable_instance_exists(id, "target_x")) target_x = x;
if (!variable_instance_exists(id, "target_y")) target_y = y;
if (!variable_instance_exists(id, "usar_novo_sistema")) usar_novo_sistema = true;
if (!variable_instance_exists(id, "is_moving")) is_moving = false;
if (!variable_instance_exists(id, "destino_x")) destino_x = x;
if (!variable_instance_exists(id, "destino_y")) destino_y = y;

// === SISTEMA DE PATRULHA ENTRE PILARES ===
pilares_patrulha = ds_list_create();
indice_pilar_atual = 0;
tempo_espera_pilar = 120;  // 2 segundos (mais rápido)
timer_espera = 0;
estado_patrulha = "navegando";  // "navegando" ou "esperando"

// === SISTEMA DE DETECÇÃO E ATAQUE ===
raio_deteccao = 500;  // ✅ BOM ALCANCE: Detecta de longe
alvo_atual = noone;
modo_cacando = false;

// === SISTEMA DE COMBATE ===
dano_base = 12;  // ✅ DANO MÉDIO
alcance_ataque = 400;
reload_time = 75;  // 1.25 segundos (rápido)
reload_timer = 0;

// === MULTIPLICADORES DE DANO ===
multiplicador_vs_militar = 0.4;  // ✅ MUITO FRACO vs militares
multiplicador_vs_carga = 2.5;    // ✅ MUITO FORTE vs carga

// === ESTADOS ===
estado = LanchaState.MOVENDO;  // ✅ CORREÇÃO: Começar se movendo
modo_combate = LanchaMode.ATAQUE;
is_moving = true;  // ✅ GARANTIR: Começar em movimento
usar_novo_sistema = true;  // ✅ GARANTIR: Usar sistema de física

// === VINCULAÇÃO AUTOMÁTICA AOS PILARES ===
// Será feito no Step_0 após criar o navio
vinculado = false;

// === GARANTIR VISIBILIDADE ===
visible = true;
image_alpha = 1.0;

// === REDUÇÃO DE TAMANHO DA IMAGEM ===
image_xscale = 0.2;  // ✅ Reduzir para 70% do tamanho original
image_yscale = 0.2;

show_debug_message("🏴‍☠️ Navio Pirata Tipo 1 criado em (" + string(x) + ", " + string(y) + ")");
show_debug_message("   HP: " + string(hp_atual) + " | Velocidade: " + string(velocidade_movimento) + " (RÁPIDO)");
