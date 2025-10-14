// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE CONSTRUÇÃO
// Bloco 3, Fase 5: Lógica de Construção Final
// =========================================================

// Se não tivermos um edifício selecionado, o código para aqui imediatamente.
if (global.construindo_agora == noone) {
    exit;
}

// DEBUG: Mostrar informações sobre a tentativa de construção
show_debug_message("=== TENTATIVA DE CONSTRUÇÃO ===");
show_debug_message("Construindo agora: " + string(global.construindo_agora));
show_debug_message("Asset index aeroporto: " + string(asset_get_index("obj_aeroporto_militar")));
show_debug_message("Mouse clicado: " + string(mouse_check_button_pressed(mb_left)));
show_debug_message("Posição grid: (" + string(grid_x) + ", " + string(grid_y) + ")");

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
} else if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
    _custo_d = 600;
    _custo_m = 400;
    _nome_edificio = "Quartel de Marinha";
} else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
    _custo_d = 1000;
    _custo_m = 500;
    _nome_edificio = "Aeroporto Militar";
}

// DEBUG: Mostrar recursos atuais
show_debug_message("=== RECURSOS ATUAIS ===");
show_debug_message("Dinheiro: $" + string(global.dinheiro));
show_debug_message("Minério: " + string(global.minerio));
show_debug_message("Custo necessário: $" + string(_custo_d) + " dinheiro, " + string(_custo_m) + " minério");

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
    show_debug_message("=== TENTANDO CRIAR OBJETO ===");
    if (global.construindo_agora == asset_get_index("obj_casa")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_casa);
        show_debug_message("Criando Casa...");
    } else if (global.construindo_agora == asset_get_index("obj_banco")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_banco);
        show_debug_message("Criando Banco...");
    } else if (global.construindo_agora == asset_get_index("obj_quartel")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_quartel);
        show_debug_message("Criando Quartel...");
    } else if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_quartel_marinha);
        show_debug_message("Criando Quartel de Marinha...");
    } else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
        show_debug_message("Criando Aeroporto Militar...");
        show_debug_message("Posição: (" + string(grid_x) + ", " + string(grid_y) + ")");
        show_debug_message("Camada: Instances");
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_aeroporto_militar);
        show_debug_message("Resultado da criação: " + string(_new_building));
    } else {
        show_debug_message("❌ TIPO DE EDIFÍCIO NÃO RECONHECIDO!");
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
