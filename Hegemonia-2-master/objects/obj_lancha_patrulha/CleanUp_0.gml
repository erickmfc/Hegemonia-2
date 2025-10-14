// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA CLEANUP EVENT
// Limpeza de Memória e Recursos
// =========================================================

// --- LIMPEZA DE LISTAS DE PATRULHA ---
if (variable_instance_exists(id, "pontos_patrulha")) {
    if (ds_exists(pontos_patrulha, ds_type_list)) {
        ds_list_destroy(pontos_patrulha);
        show_debug_message("🗑️ Lista de patrulha da lancha destruída");
    }
}

// --- LIMPEZA DE VARIÁVEIS DE ESTADO ---
if (variable_instance_exists(id, "alvo_em_mira")) {
    alvo_em_mira = noone;
}

if (variable_instance_exists(id, "estado_anterior")) {
    estado_anterior = "parado";
}

// --- DESELEÇÃO SE FOR A UNIDADE SELECIONADA ---
if (variable_global_exists("unidade_selecionada")) {
    if (global.unidade_selecionada == id) {
        global.unidade_selecionada = noone;
        show_debug_message("🚢 Lancha foi deselecionada (destruição)");
    }
}

// --- LIMPEZA DE TIMERS ---
if (variable_instance_exists(id, "timer_ataque")) {
    timer_ataque = 0;
}

// --- RESETAR ESTADO ---
estado = "parado";
velocidade_atual = 0;
selecionado = false;

show_debug_message("🧹 Lancha Patrulha - Limpeza de memória concluída");
