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
} else if (global.construindo_agora == asset_get_index("obj_fazenda")) {
    _custo_d = 2500000; // $2.500.000 CG
    _custo_m = 0; // Fazenda não precisa de minério
    _nome_edificio = "Fazenda";
} else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
    _custo_d = 1000;
    _custo_m = 500;
    _nome_edificio = "Aeroporto Militar";
} else if (global.construindo_agora == asset_get_index("obj_casa_da_moeda")) {
    _custo_d = 50000000; // $50.000.000 CG
    _custo_m = 10000;    // 10.000 minério
    _custo_p = 5000;     // 5.000 petróleo
    _nome_edificio = "Casa da Moeda";
}

// DEBUG: Mostrar recursos atuais
show_debug_message("=== RECURSOS ATUAIS ===");
show_debug_message("Dinheiro: $" + string(global.dinheiro));
show_debug_message("Minério: " + string(global.minerio));
show_debug_message("Custo necessário: $" + string(_custo_d) + " dinheiro, " + string(_custo_m) + " minério");

// Verificar petróleo se necessário
var _custo_p = 0;
if (global.construindo_agora == asset_get_index("obj_casa_da_moeda")) {
    _custo_p = 5000; // 5.000 petróleo para Casa da Moeda
}

// === APLICAR INFLATION AOS CUSTOS ===
var _custo_d_inflacionado = _custo_d;
var _custo_m_inflacionado = _custo_m;
var _custo_p_inflacionado = _custo_p;

if (variable_global_exists("taxa_inflacao") && global.taxa_inflacao > 0) {
    _custo_d_inflacionado = floor(_custo_d * (1 + global.taxa_inflacao));
    _custo_m_inflacionado = floor(_custo_m * (1 + global.taxa_inflacao));
    _custo_p_inflacionado = floor(_custo_p * (1 + global.taxa_inflacao));
    
    show_debug_message("💰 Custo com inflação: $" + string(_custo_d_inflacionado) + 
                      " (inflação: " + string(round(global.taxa_inflacao * 100)) + "%)");
}

// Verifica se temos dinheiro E minério suficientes (e petróleo se necessário).
var _tem_petroleo = true;
if (_custo_p_inflacionado > 0) {
    _tem_petroleo = (global.petroleo >= _custo_p_inflacionado);
}

if (global.dinheiro >= _custo_d_inflacionado && global.minerio >= _custo_m_inflacionado && _tem_petroleo) {
    
    // TEMOS RECURSOS! Vamos para o próximo passo.
    show_debug_message("Recursos verificados. Construindo " + _nome_edificio + "...");

    // --- PASSO 2: VERIFICAR POSIÇÃO (Lógica Simplificada) ---
    // Futuramente, aqui verificaremos o grid de dados para ver se o tile está ocupado.
    // Por enquanto, vamos assumir que a posição é sempre válida.
    
    // --- PASSO 3: EXECUTAR A CONSTRUÇÃO ---
    
    // Deduz os recursos do tesouro da nação (com inflação aplicada).
    global.dinheiro -= _custo_d_inflacionado;
    global.minerio -= _custo_m_inflacionado;
    
    // Deduzir petróleo se necessário
    if (_custo_p_inflacionado > 0) {
        global.petroleo -= _custo_p_inflacionado;
    }
    
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
    } else if (global.construindo_agora == asset_get_index("obj_fazenda")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_fazenda);
        show_debug_message("Criando Fazenda...");
    } else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
        show_debug_message("Criando Aeroporto Militar...");
        show_debug_message("Posição: (" + string(grid_x) + ", " + string(grid_y) + ")");
        show_debug_message("Camada: Instances");
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_aeroporto_militar);
        show_debug_message("Resultado da criação: " + string(_new_building));
    } else if (global.construindo_agora == asset_get_index("obj_casa_da_moeda")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_casa_da_moeda);
        show_debug_message("Criando Casa da Moeda...");
    } else {
        show_debug_message("❌ TIPO DE EDIFÍCIO NÃO RECONHECIDO!");
    }
    
    // Verifica se a criação foi bem-sucedida
    if (instance_exists(_new_building)) {
        // === ATUALIZAR PATHFINDING ===
        // Adiciona o novo edifício como obstáculo na grade de pathfinding
        if (global.construindo_agora == asset_get_index("obj_casa")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_casa, true);
        } else if (global.construindo_agora == asset_get_index("obj_banco")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_banco, true);
        } else if (global.construindo_agora == asset_get_index("obj_fazenda")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_fazenda, true);
        } else if (global.construindo_agora == asset_get_index("obj_quartel")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_quartel, true);
        } else if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_quartel_marinha, true);
        } else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_aeroporto_militar, true);
        } else if (global.construindo_agora == asset_get_index("obj_casa_da_moeda")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_casa_da_moeda, true);
        }
        
        // Limpa a seleção para finalizar o modo de construção.
        global.construindo_agora = noone;
        
        show_debug_message("Construção de " + _nome_edificio + " concluída com sucesso!");
        show_debug_message("Custo: $" + string(_custo_d_inflacionado) + " dinheiro, " + string(_custo_m_inflacionado) + " minério");
        if (_custo_p_inflacionado > 0) {
            show_debug_message("Petróleo usado: " + string(_custo_p_inflacionado));
        }
        show_debug_message("Recursos restantes: $" + string(global.dinheiro) + " dinheiro, " + string(global.minerio) + " minério");
        if (_custo_p_inflacionado > 0) {
            show_debug_message("Petróleo restante: " + string(global.petroleo));
        }
        show_debug_message("🗺️ Pathfinding atualizado com novo edifício");
    } else {
        // Se falhou, reembolsar recursos
        global.dinheiro += _custo_d_inflacionado;
        global.minerio += _custo_m_inflacionado;
        if (_custo_p_inflacionado > 0) {
            global.petroleo += _custo_p_inflacionado;
        }
        show_debug_message("ERRO: Falha ao criar edifício! Recursos reembolsados.");
    }

} else {
    // NÃO TEMOS RECURSOS!
    show_debug_message("RECURSOS INSUFICIENTES! Construção de " + _nome_edificio + " cancelada.");
    show_debug_message("Precisa: $" + string(_custo_d_inflacionado) + " dinheiro, " + string(_custo_m_inflacionado) + " minério");
    if (_custo_p_inflacionado > 0) {
        show_debug_message("Petróleo necessário: " + string(_custo_p_inflacionado));
    }
    show_debug_message("Tem: $" + string(global.dinheiro) + " dinheiro, " + string(global.minerio) + " minério");
    if (_custo_p_inflacionado > 0) {
        show_debug_message("Petróleo disponível: " + string(global.petroleo));
    }
    
    // Cancela a construção.
    global.construindo_agora = noone;
}
