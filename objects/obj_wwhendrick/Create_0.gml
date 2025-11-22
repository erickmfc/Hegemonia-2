/// @description Ww-Hendrick - Submarino rápido
// ===============================================
// HEGEMONIA GLOBAL - WW-HENDRICK
// Sistema limpo baseado na Lancha Patrulha
// ===============================================

// ✅ CORREÇÃO GM2040: Chamar o Create do objeto pai PRIMEIRO
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === CONFIGURAÇÕES ESPECÍFICAS DO WW-HENDRICK ===
nome_unidade = "Ww-Hendrick";

// Atributos de combate
hp_atual = 800;
hp_max = 800;
dano_ataque = 60;

// Navegação (mais rápido que outros navios)
velocidade_movimento = 2.0;
velocidade = 2.0;
velocidade_rotacao = 3.0;

// Física de movimento (novo sistema - mais rápido)
moveSpeed = 4.0;
acceleration = 0.18;
friction_water = 0.08;
turnSpeed = 3.0;
usar_novo_sistema = true; // Usar sistema de física da Lancha

// Alcances
radar_alcance = 600;
missil_alcance = 600;
missil_max_alcance = 600;
alcance_ataque = 600;
alcance_visao = 600;

// Sistema de ataque
reload_time = 90; // 1.5 segundos
reload_timer = 0;

// Sistema de patrulha (da Lancha)
if (!variable_instance_exists(id, "pontos_patrulha")) {
    pontos_patrulha = ds_list_create();
}
if (!variable_instance_exists(id, "indice_patrulha_atual")) {
    indice_patrulha_atual = 0;
}

// === SISTEMA DE MÍSSEIS ===
pode_disparar_missil = true;
missil_timer = 0;
missil_cooldown = 90;

// Estado e modo
estado = LanchaState.PARADO;
modo_combate = LanchaMode.PASSIVO;
modo_ataque = false;

// Destinos
destino_x = x;
destino_y = y;
target_x = x;
target_y = y;
alvo_unidade = noone;
estado_anterior = LanchaState.PARADO;

// === FUNÇÃO DE MOVIMENTO (DA LANCHA) ===
ordem_mover = function(dest_x, dest_y) {
    destino_x = dest_x;
    destino_y = dest_y;
    target_x = dest_x;
    target_y = dest_y;
    is_moving = true;
    estado = LanchaState.MOVENDO;
    distancia_anterior = 0;
    timer_presa = 0;
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🌊 Ww-Hendrick: Movendo para (" + string(dest_x) + ", " + string(dest_y) + ")");
    }
}

// === VARIÁVEIS DE FEEDBACK ===
ultima_acao = "nenhuma";
cor_feedback = c_white;
feedback_timer = 0;

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("🌊 Ww-Hendrick criado - Sistema limpo baseado na Lancha");
show_debug_message("💰 HP: " + string(hp_atual) + " | Velocidade: " + string(velocidade_movimento) + " | Radar: " + string(radar_alcance));
