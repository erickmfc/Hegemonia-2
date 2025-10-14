// ===============================================
// HEGEMONIA GLOBAL - SISTEMA DE PRODUÇÃO UNIFICADO
// Script Principal de Produção
// ===============================================

/// @description Sistema de produção unificado para quartéis
function scr_producao_unificada() {
    if (!produzindo || ds_queue_empty(fila_producao)) return;
    
    // Obter dados da próxima unidade
    var _unidade_data = ds_queue_head(fila_producao);
    
    // Verificar recursos (apenas uma vez)
    if (!scr_verificar_recursos_unificados(_unidade_data)) {
        show_debug_message("❌ Recursos insuficientes para: " + _unidade_data.nome);
        return;
    }
    
    // Incrementar timer
    timer_producao++;
    
    // Verificar se produção concluída
    if (timer_producao >= _unidade_data.tempo_treino) {
        // Criar unidade
        var _unidade_criada = scr_criar_unidade_segura(_unidade_data);
        
        if (_unidade_criada != noone) {
            // Deduzir recursos
            scr_deduzir_recursos_unificados(_unidade_data);
            
            // Remover da fila
            ds_queue_dequeue(fila_producao);
            
            // Resetar timer
            timer_producao = 0;
            
            show_debug_message("✅ " + _unidade_data.nome + " produzida!");
            
            // Verificar se há mais unidades na fila
            if (ds_queue_empty(fila_producao)) {
                produzindo = false;
                show_debug_message("🏁 Quartel ocioso - fila vazia");
            }
        }
    }
}

/// @description Adicionar unidade à fila de produção
/// @param unidade_index Índice da unidade na lista
function scr_adicionar_fila_producao(unidade_index) {
    // Verificar se índice é válido
    if (unidade_index < 0 || unidade_index >= ds_list_size(unidades_disponiveis)) {
        show_debug_message("❌ Índice de unidade inválido: " + string(unidade_index));
        return false;
    }
    
    // Obter dados da unidade
    var _unidade_data = ds_list_find_value(unidades_disponiveis, unidade_index);
    
    // Verificar recursos antes de adicionar à fila
    if (!scr_verificar_recursos_unificados(_unidade_data)) {
        show_debug_message("❌ Recursos insuficientes para: " + _unidade_data.nome);
        return false;
    }
    
    // Adicionar à fila
    ds_queue_enqueue(fila_producao, _unidade_data);
    
    // Iniciar produção se não estiver produzindo
    if (!produzindo) {
        produzindo = true;
        timer_producao = 0;
        show_debug_message("🚀 Iniciando produção: " + _unidade_data.nome);
    } else {
        show_debug_message("📋 Adicionado à fila: " + _unidade_data.nome);
    }
    
    return true;
}
