/// @description Ronald Reagan - Porta-Aviões (Simplificado)
// ===============================================
// HEGEMONIA GLOBAL - RONALD REAGAN
// ===============================================

if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === OVERRIDE - ESTATÍSTICAS ESPECÍFICAS ===
nome_unidade = "Ronald Reagan";
hp_atual = 4000;
hp_max = 4000;

// Velocidade (muito lento)
velocidade = 0.7;
velocidade_rotacao = 1.0;

// Alcances
radar_alcance = 1000;
missil_alcance = 1000;
alcance_ataque = 1000;

// Ataque
reload_time = 300;
dano_ataque = 70;

// ========================================================================
// === SISTEMA DE TRANSPORTE (PRESERVADO) ===
// ========================================================================

// Capacidades
avioes_max = 35;
unidades_max = 20;
soldados_max = 100;

// Contadores
avioes_count = 0;
unidades_count = 0;
soldados_count = 0;

// Listas
avioes_embarcados = ds_list_create();
unidades_embarcadas = ds_list_create();
soldados_embarcados = ds_list_create();

// Desembarque
desembarque_fila = ds_queue_create();
desembarque_timer = 0;
desembarque_intervalo = 150;
desembarque_ativo = false;
desembarque_offset_angulo = 0;

// === MENU DE DESEMBARQUE ===
menu_desembarque_aberto = false;
menu_desembarque_selecionado = -1;
menu_desembarque_scroll = 0;

show_debug_message("🚢 Ronald Reagan criado - HP: " + string(hp_atual));
show_debug_message("📦 Capacidade: " + string(avioes_max) + " aviões + " + string(unidades_max) + " veículos + " + string(soldados_max) + " soldados");
