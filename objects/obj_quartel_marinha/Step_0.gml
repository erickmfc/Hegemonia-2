// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Produção Naval - STEP EVENT ATIVO
// ===============================================

// ✅ STEP EVENT OTIMIZADO - Debug reduzido
// Debug apenas quando necessário (a cada 10 segundos)
if (!variable_instance_exists(id, "step_debug_count")) {
    step_debug_count = 0;
}
step_debug_count++;
if (step_debug_count % 600 == 0) { // A cada 10 segundos (reduzido)
    show_debug_message("🔄 Quartel Marinha ID: " + string(id) + " - Produzindo: " + string(produzindo) + " | Fila: " + string(ds_queue_size(fila_producao)));
}

// =========================================================================
// LÓGICA DE PRODUÇÃO REMOVIDA DO STEP EVENT
// A produção agora é controlada exclusivamente pelo Alarm[0] para evitar conflitos.
// O Step Event agora serve apenas para debug e futuras lógicas que não sejam de produção.
// =========================================================================