/// @description Independence - Destroyer com canhão
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE
// Sistema limpo baseado na Lancha Patrulha
// ===============================================

// ✅ CORREÇÃO GM2040: Chamar o Create do objeto pai PRIMEIRO
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === CONFIGURAÇÕES ESPECÍFICAS DO INDEPENDENCE ===
nome_unidade = "Independence";

// Atributos de combate
hp_atual = 1500;
hp_max = 1500;
dano_ataque = 80;

// Navegação (baseado na Lancha)
velocidade_movimento = 1.5;
velocidade = 0.95;
velocidade_rotacao = 2.0;

// Física de movimento (novo sistema)
moveSpeed = 3.0;
acceleration = 0.12;
friction_water = 0.08;
turnSpeed = 2.0;
usar_novo_sistema = true; // Usar sistema de física da Lancha

// Alcances
radar_alcance = 800;
missil_alcance = 800;
missil_max_alcance = 800;
alcance_ataque = 800;
alcance_visao = 800;

// Sistema de ataque
reload_time = 120; // 2 segundos
reload_timer = 0;

// Sistema de patrulha (da Lancha)
if (!variable_instance_exists(id, "pontos_patrulha")) {
    pontos_patrulha = ds_list_create();
}
if (!variable_instance_exists(id, "indice_patrulha_atual")) {
    indice_patrulha_atual = 0;
}

// === SISTEMA DE MÍSSEIS MÚLTIPLOS (Hash, Sky, Lit) ===
pode_disparar_missil = true; // Independence usa Hash, Sky, Lit + Canhão

// Timers para mísseis múltiplos (similar ao F-35)
timer_sky = 0;
intervalo_sky = 180; // 3 segundos

timer_iron = 0;
intervalo_iron = 300; // 5 segundos

timer_hash = 0;
intervalo_hash = 360; // 6 segundos

timer_lit = 0;
intervalo_lit = 420; // 7 segundos

// Sistema antigo (mantido para compatibilidade)
missil_timer = 0;
missil_cooldown = 120;

// === SISTEMA DE CANHÃO (PRESERVADO) ===
metralhadora_ativa = false;
metralhadora_timer = 0;
metralhadora_intervalo = 3;
metralhadora_duracao = 180; // 3 segundos
metralhadora_tiros = 0;
metralhadora_max_tiros = 60;
metralhadora_cooldown_timer = 0;
metralhadora_cooldown_duration = 180; // 3 segundos de pausa

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
    distancia_anterior = 0; // Resetar detecção de presa
    timer_presa = 0;
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🚢 Independence: Movendo para (" + string(dest_x) + ", " + string(dest_y) + ")");
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

show_debug_message("🚢 Independence criado - Sistema limpo baseado na Lancha");
show_debug_message("💰 HP: " + string(hp_atual) + " | Velocidade: " + string(velocidade_movimento) + " | Radar: " + string(radar_alcance));
show_debug_message("🔫 Sistema de Canhão + Mísseis ativo");
