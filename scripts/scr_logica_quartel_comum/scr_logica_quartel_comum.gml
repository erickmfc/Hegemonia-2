// ===============================================
// HEGEMONIA GLOBAL - LÓGICA COMUM DE QUARTÉIS
// Script Compartilhado para Todos os Quartéis
// ===============================================

/// @description Lógica comum de quartel (para uso em Other_10)
/// @param {Id.Instance} quartel_id ID do quartel
function scr_logica_quartel_comum(quartel_id) {
    // Esta função é chamada pelo evento Other_10 dos quartéis
    // Implementa a lógica comum de recrutamento
    
    if (!instance_exists(quartel_id)) {
        return;
    }
    
    // Verificar se há unidades na fila e não está produzindo
    if (variable_instance_exists(quartel_id, "fila_producao") && 
        variable_instance_exists(quartel_id, "produzindo") &&
        !ds_queue_empty(quartel_id.fila_producao) && 
        !quartel_id.produzindo) {
        
        var _proxima_unidade = ds_queue_head(quartel_id.fila_producao);
        
        if (is_struct(_proxima_unidade)) {
            quartel_id.timer_producao = _proxima_unidade.tempo_treino;
            quartel_id.produzindo = true;
            show_debug_message("Iniciando produção de " + _proxima_unidade.nome);
        }
    }
}
