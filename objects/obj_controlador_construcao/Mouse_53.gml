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
    _nome_edificio = "Casa da Moeda";
} else if (global.construindo_agora == asset_get_index("obj_centro_pesquisa")) {
    _custo_d = 5000;
    _custo_m = 1000;
    _nome_edificio = "Centro de Pesquisa";
} else if (global.construindo_agora == asset_get_index("obj_research_center")) {
    _custo_d = 5000;
    _custo_m = 1000;
    _nome_edificio = "Research Center";
} else if (global.construindo_agora == asset_get_index("obj_mina")) {
    _custo_d = 1000;
    _custo_m = 200;
    _nome_edificio = "Mina";
} else if (global.construindo_agora == asset_get_index("obj_mina_ouro")) {
    _custo_d = 2500;
    _custo_m = 500;
    _nome_edificio = "Mina de Ouro";
} else if (global.construindo_agora == asset_get_index("obj_mina_aluminio")) {
    _custo_d = 2000;
    _custo_m = 400;
    _nome_edificio = "Mina de Alumínio";
} else if (global.construindo_agora == asset_get_index("obj_mina_cobre")) {
    _custo_d = 1500;
    _custo_m = 300;
    _nome_edificio = "Mina de Cobre";
} else if (global.construindo_agora == asset_get_index("obj_mina_titanio")) {
    _custo_d = 4000;
    _custo_m = 800;
    _nome_edificio = "Mina de Titânio";
} else if (global.construindo_agora == asset_get_index("obj_mina_uranio")) {
    _custo_d = 6000;
    _custo_m = 1200;
    _nome_edificio = "Mina de Urânio";
} else if (global.construindo_agora == asset_get_index("obj_mina_litio")) {
    _custo_d = 3000;
    _custo_m = 600;
    _nome_edificio = "Mina de Lítio";
} else if (global.construindo_agora == asset_get_index("obj_poco_petroleo")) {
    _custo_d = 3000;
    _custo_m = 500;
    _nome_edificio = "Poço de Petróleo";
} else if (global.construindo_agora == asset_get_index("obj_serraria")) {
    _custo_d = 800;
    _custo_m = 150;
    _nome_edificio = "Serraria";
} else if (global.construindo_agora == asset_get_index("obj_plantacao_borracha")) {
    _custo_d = 1200;
    _custo_m = 200;
    _nome_edificio = "Plantação de Borracha";
} else if (global.construindo_agora == asset_get_index("obj_extrator_silicio")) {
    _custo_d = 2500;
    _custo_m = 500;
    _nome_edificio = "Extrator de Silício";
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
    show_debug_message("Recursos verificados. Verificando terreno para construir " + _nome_edificio + "...");

    // --- PASSO 2: VERIFICAR TERRENO ---
    // Obter o objeto que será construído
    var _objeto_construir = global.construindo_agora;
    var _largura = 64;
    var _altura = 64;
    
    // Determinar dimensões baseado no tipo de edifício (para validação de terreno)
    if (global.construindo_agora == asset_get_index("obj_casa")) {
        _largura = 64;
        _altura = 64;
    } else if (global.construindo_agora == asset_get_index("obj_banco")) {
        _largura = 64;
        _altura = 64;
    } else if (global.construindo_agora == asset_get_index("obj_quartel")) {
        _largura = 64;
        _altura = 64;
    } else if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
        _largura = 96;
        _altura = 96;
    } else if (global.construindo_agora == asset_get_index("obj_fazenda")) {
        _largura = 64;
        _altura = 64;
    } else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
        _largura = 96;
        _altura = 96;
    } else if (global.construindo_agora == asset_get_index("obj_casa_da_moeda")) {
        _largura = 128;
        _altura = 128;
    } else if (global.construindo_agora == asset_get_index("obj_centro_pesquisa")) {
        _largura = 64;
        _altura = 64;
    } else if (global.construindo_agora == asset_get_index("obj_research_center")) {
        _largura = 64;
        _altura = 64;
    } else if (global.construindo_agora == asset_get_index("obj_mina") ||
               global.construindo_agora == asset_get_index("obj_mina_ouro") ||
               global.construindo_agora == asset_get_index("obj_mina_aluminio") ||
               global.construindo_agora == asset_get_index("obj_mina_cobre") ||
               global.construindo_agora == asset_get_index("obj_mina_titanio") ||
               global.construindo_agora == asset_get_index("obj_mina_uranio") ||
               global.construindo_agora == asset_get_index("obj_mina_litio") ||
               global.construindo_agora == asset_get_index("obj_poco_petroleo") ||
               global.construindo_agora == asset_get_index("obj_serraria") ||
               global.construindo_agora == asset_get_index("obj_plantacao_borracha") ||
               global.construindo_agora == asset_get_index("obj_extrator_silicio")) {
        _largura = 64;
        _altura = 64;
    }
    
    // ✅ NOVO: VALIDAÇÃO DE TERRENO
    // Verificar se o terreno é compatível antes de verificar espaço
    var _terreno_valido = scr_validar_terreno_construcao(
        global.construindo_agora,
        grid_x,
        grid_y,
        _largura,
        _altura
    );
    
    if (!_terreno_valido) {
        show_debug_message("❌ TERRENO INVÁLIDO! " + _nome_edificio + " não pode ser construído neste tipo de terreno.");
        show_debug_message("💡 Dica: Verifique se está construindo no terreno correto (terra/água).");
        global.construindo_agora = noone;
        exit;
    }
    
    show_debug_message("✅ Terreno validado. Verificando espaço livre...");

    // --- PASSO 3: VERIFICAR SE HÁ ESPAÇO LIVRE ---
    // (Dimensões já foram calculadas no passo anterior)
    
    // Verifica se há espaço livre para construir (função inline)
    var _espaco_livre = true;
    
    // Lista de todos os edifícios que bloqueiam construção
    // ✅ CORREÇÃO: Verificar existência de cada objeto sem causar erro
    var _edificios = [];
    
    // Edifícios principais (sempre adicionar)
    array_push(_edificios, obj_casa);
    array_push(_edificios, obj_banco);
    array_push(_edificios, obj_fazenda);
    array_push(_edificios, obj_quartel);
    array_push(_edificios, obj_quartel_marinha);
    array_push(_edificios, obj_aeroporto_militar);
    
    // Research center (se existir)
    var _research_index = asset_get_index("obj_research_center");
    if (_research_index != -1) {
        array_push(_edificios, obj_research_center);
    }
    
    // Centro de Pesquisa (se existir)
    var _centro_pesquisa_index = asset_get_index("obj_centro_pesquisa");
    if (_centro_pesquisa_index != -1) {
        array_push(_edificios, obj_centro_pesquisa);
    }
    
    // Casa da Moeda (se existir)
    var _casa_moeda_index = asset_get_index("obj_casa_da_moeda");
    if (_casa_moeda_index != -1) {
        array_push(_edificios, obj_casa_da_moeda);
    }
    
    // Estruturas de produção (se existirem)
    if (object_exists(obj_mina)) array_push(_edificios, obj_mina);
    if (object_exists(obj_mina_ouro)) array_push(_edificios, obj_mina_ouro);
    if (object_exists(obj_mina_aluminio)) array_push(_edificios, obj_mina_aluminio);
    if (object_exists(obj_mina_cobre)) array_push(_edificios, obj_mina_cobre);
    if (object_exists(obj_mina_titanio)) array_push(_edificios, obj_mina_titanio);
    if (object_exists(obj_mina_uranio)) array_push(_edificios, obj_mina_uranio);
    if (object_exists(obj_mina_litio)) array_push(_edificios, obj_mina_litio);
    if (object_exists(obj_poco_petroleo)) array_push(_edificios, obj_poco_petroleo);
    if (object_exists(obj_serraria)) array_push(_edificios, obj_serraria);
    if (object_exists(obj_plantacao_borracha)) array_push(_edificios, obj_plantacao_borracha);
    if (object_exists(obj_extrator_silicio)) array_push(_edificios, obj_extrator_silicio);
    
    // Verifica se há algum edifício ocupando a área
    for (var i = 0; i < array_length(_edificios); i++) {
        var _edificio_obj = _edificios[i];
        if (!object_exists(_edificio_obj)) continue;
        
        // Verifica múltiplos pontos para garantir que não há overlap
        var _check_points = [
            [grid_x, grid_y],  // Centro
            [grid_x - _largura/2 + 10, grid_y - _altura/2 + 10],  // Canto superior esquerdo
            [grid_x + _largura/2 - 10, grid_y - _altura/2 + 10],  // Canto superior direito
            [grid_x - _largura/2 + 10, grid_y + _altura/2 - 10],  // Canto inferior esquerdo
            [grid_x + _largura/2 - 10, grid_y + _altura/2 - 10]   // Canto inferior direito
        ];
        
        // Verifica todos os pontos
        for (var j = 0; j < array_length(_check_points); j++) {
            var _x = _check_points[j][0];
            var _y = _check_points[j][1];
            
            // Verifica se há alguma instância do edifício nesta posição
            if (instance_position(_x, _y, _edificio_obj) != noone) {
                _espaco_livre = false;
                show_debug_message("🚫 Espaço ocupado por edifício na posição (" + string(_x) + ", " + string(_y) + ")");
                break;
            }
        }
        
        if (!_espaco_livre) break;
    }
    
    if (!_espaco_livre) {
        show_debug_message("❌ ESPAÇO OCUPADO! Não é possível construir em cima de outro edifício.");
        global.construindo_agora = noone;
        exit;
    }
    
    show_debug_message("✅ Espaço livre verificado. Construindo " + _nome_edificio + "...");

    // --- PASSO 4: EXECUTAR A CONSTRUÇÃO ---
    
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
    } else if (global.construindo_agora == asset_get_index("obj_centro_pesquisa")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_centro_pesquisa);
        show_debug_message("Criando Centro de Pesquisa...");
    } else if (global.construindo_agora == asset_get_index("obj_research_center")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_research_center);
        show_debug_message("Criando Research Center...");
    } else if (global.construindo_agora == asset_get_index("obj_mina")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_mina);
        show_debug_message("Criando Mina...");
    } else if (global.construindo_agora == asset_get_index("obj_mina_ouro")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_mina_ouro);
        show_debug_message("Criando Mina de Ouro...");
    } else if (global.construindo_agora == asset_get_index("obj_mina_aluminio")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_mina_aluminio);
        show_debug_message("Criando Mina de Alumínio...");
    } else if (global.construindo_agora == asset_get_index("obj_mina_cobre")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_mina_cobre);
        show_debug_message("Criando Mina de Cobre...");
    } else if (global.construindo_agora == asset_get_index("obj_mina_titanio")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_mina_titanio);
        show_debug_message("Criando Mina de Titânio...");
    } else if (global.construindo_agora == asset_get_index("obj_mina_uranio")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_mina_uranio);
        show_debug_message("Criando Mina de Urânio...");
    } else if (global.construindo_agora == asset_get_index("obj_mina_litio")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_mina_litio);
        show_debug_message("Criando Mina de Lítio...");
    } else if (global.construindo_agora == asset_get_index("obj_poco_petroleo")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_poco_petroleo);
        show_debug_message("Criando Poço de Petróleo...");
    } else if (global.construindo_agora == asset_get_index("obj_serraria")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_serraria);
        show_debug_message("Criando Serraria...");
    } else if (global.construindo_agora == asset_get_index("obj_plantacao_borracha")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_plantacao_borracha);
        show_debug_message("Criando Plantação de Borracha...");
    } else if (global.construindo_agora == asset_get_index("obj_extrator_silicio")) {
        _new_building = instance_create_layer(grid_x, grid_y, "Instances", obj_extrator_silicio);
        show_debug_message("Criando Extrator de Silício...");
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
        } else if (global.construindo_agora == asset_get_index("obj_centro_pesquisa")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_centro_pesquisa, true);
        } else if (global.construindo_agora == asset_get_index("obj_research_center")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_research_center, true);
        } else if (global.construindo_agora == asset_get_index("obj_mina")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_mina, true);
        } else if (global.construindo_agora == asset_get_index("obj_mina_ouro")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_mina_ouro, true);
        } else if (global.construindo_agora == asset_get_index("obj_mina_aluminio")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_mina_aluminio, true);
        } else if (global.construindo_agora == asset_get_index("obj_mina_cobre")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_mina_cobre, true);
        } else if (global.construindo_agora == asset_get_index("obj_mina_titanio")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_mina_titanio, true);
        } else if (global.construindo_agora == asset_get_index("obj_mina_uranio")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_mina_uranio, true);
        } else if (global.construindo_agora == asset_get_index("obj_mina_litio")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_mina_litio, true);
        } else if (global.construindo_agora == asset_get_index("obj_poco_petroleo")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_poco_petroleo, true);
        } else if (global.construindo_agora == asset_get_index("obj_serraria")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_serraria, true);
        } else if (global.construindo_agora == asset_get_index("obj_plantacao_borracha")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_plantacao_borracha, true);
        } else if (global.construindo_agora == asset_get_index("obj_extrator_silicio")) {
            mp_grid_add_instances(global.pathfinding_grid, obj_extrator_silicio, true);
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
