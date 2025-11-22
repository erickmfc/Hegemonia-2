// =========================================================
// HEGEMONIA GLOBAL - QUARTEL
// Sistema de Recrutamento com Menu
// =========================================================

// Verificar se foi definida uma quantidade, senão usar 1 como padrão
if (!variable_instance_exists(id, "quantidade_recrutar")) {
    quantidade_recrutar = 1;
}

// === SISTEMA NOVO: USAR LISTA DE UNIDADES ===
// Obter dados da unidade selecionada
var _unidade_data = ds_list_find_value(unidades_disponiveis, unidade_selecionada);
if (_unidade_data == undefined) {
    show_debug_message("ERRO: Unidade selecionada não encontrada!");
    exit;
}

// Custos e tempo da unidade selecionada
var _custo_d = _unidade_data.custo_dinheiro;
var _custo_p = _unidade_data.custo_populacao;
var _tempo_treino = _unidade_data.tempo_treino;

// Calcular custo total baseado na quantidade
var _custo_total_d = _custo_d * quantidade_recrutar;
var _custo_total_p = _custo_p * quantidade_recrutar;

// Verifica se a nação tem recursos suficientes para a quantidade solicitada
if (global.dinheiro >= _custo_total_d && global.populacao >= _custo_total_p) {
    
    // Sucesso! Deduz os recursos.
    global.dinheiro -= _custo_total_d;
    global.populacao -= _custo_total_p;
    
    // === SISTEMA NOVO: ADICIONAR À FILA DE RECRUTAMENTO ===
    // ✅ CORREÇÃO CRÍTICA: Garantir que estamos usando a fila DESTE quartel específico
    // Se a fila não existe, criar uma nova (não deve acontecer, mas por segurança)
    if (!variable_instance_exists(id, "fila_recrutamento") || !ds_exists(fila_recrutamento, ds_type_queue)) {
        fila_recrutamento = ds_queue_create();
        show_debug_message("⚠️ Quartel ID: " + string(id) + " - Fila de recrutamento recriada (não existia)");
    }
    
    // ✅ VALIDAÇÃO: Confirmar que estamos usando a fila correta deste quartel
    var _fila_id_antes = ds_queue_size(fila_recrutamento);
    
    // Adicionar múltiplas unidades à fila (uma por vez)
    for (var i = 0; i < quantidade_recrutar; i++) {
        ds_queue_enqueue(fila_recrutamento, unidade_selecionada);
    }
    
    var _fila_id_depois = ds_queue_size(fila_recrutamento);
    
    show_debug_message("==== UNIDADES ADICIONADAS À FILA ====");
    show_debug_message("Quartel ID: " + string(id) + " (ID da instância)");
    show_debug_message("Fila ID: " + string(fila_recrutamento) + " (ID da estrutura de dados)");
    show_debug_message("Unidade: " + _unidade_data.nome);
    show_debug_message("Quantidade: " + string(quantidade_recrutar));
    show_debug_message("Tamanho da fila ANTES: " + string(_fila_id_antes));
    show_debug_message("Tamanho da fila DEPOIS: " + string(_fila_id_depois));
    show_debug_message("Custo total deduzido: $" + string(_custo_total_d) + " dinheiro, " + string(_custo_total_p) + " população");
    show_debug_message("Recursos restantes: $" + string(global.dinheiro) + " dinheiro, " + string(global.populacao) + " população");
    
    // O sistema Step_0.gml irá automaticamente processar a fila
    // e iniciar o treinamento quando apropriado
    
    // Resetar a quantidade para o próximo uso
    quantidade_recrutar = 1;
    recrutar_tanque = false;
    
} else {
    // Falha! Recursos insuficientes.
    show_debug_message("==== RECRUTAMENTO CANCELADO ====");
    show_debug_message("Recursos insuficientes para recrutar " + string(quantidade_recrutar) + " " + _unidade_data.nome + "(s)!");
    show_debug_message("Precisa: $" + string(_custo_total_d) + " dinheiro, " + string(_custo_total_p) + " população");
    show_debug_message("Tem: $" + string(global.dinheiro) + " dinheiro, " + string(global.populacao) + " população");
    
    // Resetar a quantidade
    quantidade_recrutar = 1;
}
