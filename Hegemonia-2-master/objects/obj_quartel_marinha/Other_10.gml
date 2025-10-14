// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Recrutamento Independente
// ===============================================

// Verificar se há unidades na fila e não está produzindo
if (!ds_queue_empty(fila_producao) && !produzindo) {
    var _proxima_unidade = ds_queue_head(fila_producao);
    timer_producao = _proxima_unidade.tempo_treino;
    produzindo = true;
    show_debug_message("Iniciando produção de " + _proxima_unidade.nome);
}