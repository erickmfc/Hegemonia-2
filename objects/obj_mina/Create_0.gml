// =========================================================
// MINA BASE - HERDA DE obj_estrutura_producao
// Configura as propriedades específicas desta estrutura
// =========================================================

// Executar o código do objeto pai primeiro
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 1000;
custo_minerio = 200;

// === SISTEMA DE VIDA ===
hp_max = 500;
hp_atual = 500;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 10;        // Produz 10 unidades de minério por ciclo
tipo_recurso = "minerio";       // Tipo de recurso produzido

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Minas só em terreno de campo

// ✅ NOVO: Triplicar produção se for da IA
if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
    // ✅ IA produz 3x mais
    producao_por_ciclo = producao_por_ciclo * 3;
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("⛏️ Mina da IA - Produção triplicada: " + string(producao_por_ciclo));
    }
}

show_debug_message("⛏️ Mina criada - Produção: " + string(producao_por_ciclo) + " minério a cada 10 segundos");
