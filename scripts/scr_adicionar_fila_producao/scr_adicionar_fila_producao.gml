/// @description Adicionar unidade à fila de produção
/// @param {real} _indice Índice da unidade na lista de unidades disponíveis
/// @return {undefined}

function scr_adicionar_fila_producao(_indice) {
    // Verificar se índice é válido
    if (_indice < 0 || _indice >= ds_list_size(unidades_disponiveis)) {
        show_debug_message("❌ Índice inválido: " + string(_indice));
        return;
    }
    
    // Obter dados da unidade
    var _unidade_data = unidades_disponiveis[| _indice];
    
    // Verificar se o objeto é válido
    if (_unidade_data.objeto == noone) {
        show_debug_message("❌ Objeto não disponível para " + _unidade_data.nome);
        return;
    }
    
    // Verificar recursos antes de adicionar à fila
    if (!scr_verificar_recursos_unificados(_unidade_data)) {
        show_debug_message("❌ Recursos insuficientes para " + _unidade_data.nome);
        return;
    }
    
    // Adicionar à fila
    ds_queue_enqueue(fila_producao, _unidade_data);
    
    show_debug_message("📋 " + _unidade_data.nome + " adicionada à fila de produção");
    show_debug_message("⏱️ Tempo de produção: " + string(_unidade_data.tempo_treino) + " frames");
}