// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE CONSTRUÇÃO
// Bloco 3, Fase 5: Lógica de Construção Final
// =========================================================

// Se não tivermos um edifício selecionado, o código para aqui imediatamente.
if (global.construindo_agora == noone) {
    exit;
}

// --- PASSO 1: VERIFICAR RECURSOS ---
// Pega o custo do edifício que estamos tentando construir.
// NOTA: Usando approach alternativo devido a limitações de acesso direto em GameMaker
var _custo_d = 0;
var _custo_m = 0;
var _nome_edificio = "";

// Identifica o tipo de edifício e obtém os custos
if (global.construindo_agora == asset_get_index("obj_casa")) {
    _custo_d = 150; // Equivalente a obj_casa.custo_dinheiro
    _custo_m = 25;  // Equivalente a obj_casa.custo_minerio
    _nome_edificio = "Casa";
} else if (global.construindo_agora == asset_get_index("obj_banco")) {
    _custo_d = 500; // Equivalente a obj_banco.custo_dinheiro
    _custo_m = 100; // Equivalente a obj_banco.custo_minerio
    _nome_edificio = "Banco";
} else if (global.construindo_agora == asset_get_index("obj_quartel")) {
    _custo_d = 400; // Equivalente a obj_quartel.custo_dinheiro
    _custo_m = 250; // Equivalente a obj_quartel.custo_minerio
    _nome_edificio = "Quartel";
}

// Verifica se temos dinheiro E minério suficientes.
if (global.dinheiro >= _custo_d && global.minerio >= _custo_m) {
    
    // TEMOS RECURSOS! Vamos para o próximo passo.
    show_debug_message("Recursos verificados. Construindo " + _nome_edificio + "...");

    // --- PASSO 2: VERIFICAR POSIÇÃO (Lógica Simplificada) ---
    // Futuramente, aqui verificaremos o grid de dados para ver se o tile está ocupado.
    // Por enquanto, vamos assumir que a posição é sempre válida.
    
    // --- PASSO 3: EXECUTAR A CONSTRUÇÃO ---
    
    // Deduz os recursos do tesouro da nação.
    global.dinheiro -= _custo_d;
    global.minerio -= _custo_m;
    
    // Cria a instância final do edifício na posição do fantasma.
    // CORREÇÃO GM1041: Usar asset_get_index para garantir tipo correto
    var _new_building = noone;
    
    // Determinar qual objeto criar baseado no tipo
    if (global.construindo_agora == asset_get_index("obj_casa")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", asset_get_index("obj_casa"));
    } else if (global.construindo_agora == asset_get_index("obj_banco")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", asset_get_index("obj_banco"));
    } else if (global.construindo_agora == asset_get_index("obj_quartel")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", asset_get_index("obj_quartel"));
    }
    
    // Verifica se a criação foi bem-sucedida
    if (instance_exists(_new_building)) {
        // Limpa a seleção para finalizar o modo de construção.
        global.construindo_agora = noone;
        
        show_debug_message("Construção de " + _nome_edificio + " concluída com sucesso!");
        show_debug_message("Custo: $" + string(_custo_d) + " dinheiro, " + string(_custo_m) + " minério");
        show_debug_message("Recursos restantes: $" + string(global.dinheiro) + " dinheiro, " + string(global.minerio) + " minério");
    } else {
        // Se falhou, reembolsar recursos
        global.dinheiro += _custo_d;
        global.minerio += _custo_m;
        show_debug_message("ERRO: Falha ao criar edifício! Recursos reembolsados.");
    }

} else {
    // NÃO TEMOS RECURSOS!
    show_debug_message("RECURSOS INSUFICIENTES! Construção de " + _nome_edificio + " cancelada.");
    show_debug_message("Precisa: $" + string(_custo_d) + " dinheiro, " + string(_custo_m) + " minério");
    show_debug_message("Tem: $" + string(global.dinheiro) + " dinheiro, " + string(global.minerio) + " minério");
    
    // Cancela a construção.
    global.construindo_agora = noone;
}