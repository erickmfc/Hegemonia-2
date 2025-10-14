// =========================================================
// HEGEMONIA GLOBAL - QUARTEL
// Bloco 4, Fase 3: Início do Recrutamento MÚTIPLO (CORRIGIDO)
// =========================================================

// Se o quartel já estiver ocupado, não faz nada.
if (esta_treinando) {
    show_debug_message("Quartel ID " + string(id) + " já está em treinamento.");
    exit; // Sai do script
}

// Verificar se foi definida uma quantidade, senão usar 1 como padrão
if (!variable_instance_exists(id, "quantidade_recrutar")) {
    quantidade_recrutar = 1;
}

// Definir tipo alvo (infantaria por padrão)
var _recrutar_tanque = false;
if (variable_instance_exists(id, "recrutar_tanque") && recrutar_tanque) {
    _recrutar_tanque = true;
}

// Custos e tempo conforme a unidade
var _custo_d = _recrutar_tanque ? 500 : 100;
var _custo_p = _recrutar_tanque ? 3 : 1;
var _tempo_treino = _recrutar_tanque ? 900 : 300;

// Calcular custo total baseado na quantidade
var _custo_total_d = _custo_d * quantidade_recrutar;
var _custo_total_p = _custo_p * quantidade_recrutar;

// Verifica se a nação tem recursos suficientes para a quantidade solicitada
if (global.dinheiro >= _custo_total_d && global.populacao >= _custo_total_p) {
    
    // Sucesso! Deduz os recursos.
    global.dinheiro -= _custo_total_d;
    global.populacao -= _custo_total_p;
    
    // Marca o quartel como ocupado
    esta_treinando = true;
    
    // Armazenar informações do recrutamento
    unidades_para_criar = quantidade_recrutar;
    unidades_criadas = 0;
    ultimo_recrutamento_tanque = _recrutar_tanque;
    
    // Ativa o alarme com o tempo de treino obtido da infantaria
    alarm[0] = _tempo_treino;
    
    show_debug_message("==== RECRUTAMENTO INICIADO ====");
    show_debug_message("Quartel ID: " + string(id));
    show_debug_message("Quantidade a recrutar: " + string(quantidade_recrutar));
    show_debug_message("Custo total deduzido: $" + string(_custo_total_d) + " dinheiro, " + string(_custo_total_p) + " população");
    show_debug_message("Primeira unidade pronta em " + string(alarm[0]) + " frames (" + string(alarm[0]/60) + " segundos)");
    show_debug_message("Recursos restantes: $" + string(global.dinheiro) + " dinheiro, " + string(global.populacao) + " população");
    
    // Resetar a quantidade para o próximo uso
    quantidade_recrutar = 1;
    recrutar_tanque = false;
    
} else {
    // Falha! Recursos insuficientes.
    show_debug_message("==== RECRUTAMENTO CANCELADO ====");
    show_debug_message("Recursos insuficientes para recrutar " + string(quantidade_recrutar) + " unidade(s)!");
    show_debug_message("Precisa: $" + string(_custo_total_d) + " dinheiro, " + string(_custo_total_p) + " população");
    show_debug_message("Tem: $" + string(global.dinheiro) + " dinheiro, " + string(global.populacao) + " população");
    
    // Resetar a quantidade
    quantidade_recrutar = 1;
}