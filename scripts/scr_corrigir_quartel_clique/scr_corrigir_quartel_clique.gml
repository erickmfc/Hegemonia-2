/// @description Corrigir quartel ao clicar - sistema de reparo de quartel
/// @param {Id.Instance} quartel_id ID do quartel a ser corrigido
/// @return {struct} Resultado da correção

function scr_corrigir_quartel_clique(quartel_id) {
    var resultado = {
        sucesso: false,
        quartel_id: quartel_id,
        correcoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    scr_debug_log("CORRIGIR QUARTEL", "Iniciando correção de quartel: " + string(quartel_id));
    
    // Verificar se o quartel existe
    if (!instance_exists(quartel_id)) {
        resultado.erros[array_length(resultado.erros)] = "Quartel não existe (ID: " + string(quartel_id) + ")";
        return resultado;
    }
    
    var quartel = quartel_id;
    
    // Verificar se é um quartel válido
    if (quartel.object_index != obj_quartel && quartel.object_index != obj_quartel_marinha) {
        resultado.erros[array_length(resultado.erros)] = "Objeto não é um quartel válido: " + string(quartel.object_index);
        return resultado;
    }
    
    // Aplicar correções específicas para quartel
    resultado = scr_corrigir_quartel_especifico(quartel);
    
    scr_debug_log("CORRIGIR QUARTEL", "Correção concluída - Sucesso: " + string(resultado.sucesso));
    return resultado;
}

/// @description Corrigir quartel específico
function scr_corrigir_quartel_especifico(quartel) {
    var resultado = {
        sucesso: true,
        quartel_id: quartel.id,
        correcoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // === CORREÇÃO DE VARIÁVEIS ESSENCIAIS ===
    
    // HP
    if (!variable_instance_exists(quartel, "hp_atual")) {
        quartel.hp_atual = 200;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "HP atual definido: 200";
    }
    
    if (!variable_instance_exists(quartel, "hp_max")) {
        quartel.hp_max = 200;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "HP máximo definido: 200";
    }
    
    // Nação proprietária
    if (!variable_instance_exists(quartel, "nacao_proprietaria")) {
        quartel.nacao_proprietaria = 1;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Nação proprietária definida: 1";
    }
    
    // Estado
    if (!variable_instance_exists(quartel, "estado")) {
        quartel.estado = "ativo";
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Estado definido: ativo";
    }
    
    // === CORREÇÃO DE SISTEMA DE PRODUÇÃO ===
    
    // Fila de produção
    if (!variable_instance_exists(quartel, "fila_producao")) {
        quartel.fila_producao = ds_queue_create();
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Fila de produção criada";
    }
    
    // Timer de produção
    if (!variable_instance_exists(quartel, "timer_producao")) {
        quartel.timer_producao = 0;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Timer de produção definido: 0";
    }
    
    // Status de produção
    if (!variable_instance_exists(quartel, "produzindo")) {
        quartel.produzindo = false;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Status de produção definido: false";
    }
    
    // Unidades produzidas
    if (!variable_instance_exists(quartel, "unidades_produzidas")) {
        quartel.unidades_produzidas = 0;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Contador de unidades produzidas definido: 0";
    }
    
    // === CORREÇÃO DE UNIDADES DISPONÍVEIS ===
    
    if (!variable_instance_exists(quartel, "unidades_disponiveis")) {
        quartel.unidades_disponiveis = ds_list_create();
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Lista de unidades disponíveis criada";
    }
    
    // Configurar unidades baseado no tipo de quartel
    if (quartel.object_index == obj_quartel) {
        resultado = scr_configurar_unidades_quartel_terrestre(quartel, resultado);
    } else if (quartel.object_index == obj_quartel_marinha) {
        resultado = scr_configurar_unidades_quartel_marinha(quartel, resultado);
    }
    
    // === CORREÇÃO DE PROPRIEDADES VISUAIS ===
    
    if (quartel.sprite_index == -1) {
        if (quartel.object_index == obj_quartel) {
            quartel.sprite_index = spr_quartel;
        } else {
            quartel.sprite_index = spr_quartel_marinha;
        }
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Sprite definido";
    }
    
    if (!quartel.visible) {
        quartel.visible = true;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Visibilidade ativada";
    }
    
    // === CORREÇÃO DE EVENTOS ===
    
    // Verificar se tem eventos essenciais
    resultado.avisos[array_length(resultado.avisos)] = "Verifique se o quartel tem os eventos: Create_0, Step_0, Draw_0, Mouse_0";
    
    return resultado;
}

/// @description Configurar unidades do quartel terrestre
function scr_configurar_unidades_quartel_terrestre(quartel, resultado) {
    // Limpar lista existente
    if (ds_exists(quartel.unidades_disponiveis, ds_type_list)) {
        ds_list_clear(quartel.unidades_disponiveis);
    }
    
    // Adicionar unidades terrestres
    ds_list_add(quartel.unidades_disponiveis, {
        nome: "Soldado",
        objeto: obj_soldado,
        custo_dinheiro: 100,
        custo_populacao: 1,
        tempo_treino: 180,
        descricao: "Unidade básica de infantaria"
    });
    
    ds_list_add(quartel.unidades_disponiveis, {
        nome: "Soldado Anti-aéreo",
        objeto: obj_soldado_antiaereo,
        custo_dinheiro: 150,
        custo_populacao: 1,
        tempo_treino: 240,
        descricao: "Unidade especializada contra aeronaves"
    });
    
    ds_list_add(quartel.unidades_disponiveis, {
        nome: "Blindado",
        objeto: obj_blindado,
        custo_dinheiro: 300,
        custo_populacao: 2,
        tempo_treino: 360,
        descricao: "Veículo blindado de combate"
    });
    
    ds_list_add(quartel.unidades_disponiveis, {
        nome: "Tanque",
        objeto: obj_tanque,
        custo_dinheiro: 500,
        custo_populacao: 3,
        tempo_treino: 480,
        descricao: "Tanque pesado de combate"
    });
    
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Unidades terrestres configuradas";
    
    return resultado;
}

/// @description Configurar unidades do quartel da marinha
function scr_configurar_unidades_quartel_marinha(quartel, resultado) {
    // Limpar lista existente
    if (ds_exists(quartel.unidades_disponiveis, ds_type_list)) {
        ds_list_clear(quartel.unidades_disponiveis);
    }
    
    // Adicionar unidades navais
    ds_list_add(quartel.unidades_disponiveis, {
        nome: "Lancha Patrulha",
        objeto: obj_lancha_patrulha,
        custo_dinheiro: 200,
        custo_populacao: 2,
        tempo_treino: 240,
        descricao: "Unidade naval rápida para patrulhamento"
    });
    
    ds_list_add(quartel.unidades_disponiveis, {
        nome: "Fragata",
        objeto: obj_fragata,
        custo_dinheiro: 400,
        custo_populacao: 3,
        tempo_treino: 480,
        descricao: "Navio de guerra médio"
    });
    
    ds_list_add(quartel.unidades_disponiveis, {
        nome: "Destroyer",
        objeto: obj_destroyer,
        custo_dinheiro: 800,
        custo_populacao: 5,
        tempo_treino: 720,
        descricao: "Navio de guerra pesado"
    });
    
    ds_list_add(quartel.unidades_disponiveis, {
        nome: "Submarino",
        objeto: obj_submarino,
        custo_dinheiro: 1000,
        custo_populacao: 4,
        tempo_treino: 900,
        descricao: "Unidade submarina furtiva"
    });
    
    ds_list_add(quartel.unidades_disponiveis, {
        nome: "Porta-aviões",
        objeto: obj_porta_avioes,
        custo_dinheiro: 2000,
        custo_populacao: 8,
        tempo_treino: 1200,
        descricao: "Navio gigante com capacidade aérea"
    });
    
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Unidades navais configuradas";
    
    return resultado;
}

/// @description Verificar integridade do quartel
function scr_verificar_integridade_quartel(quartel_id) {
    var resultado = {
        integro: true,
        problemas: [],
        avisos: []
    };
    
    if (!instance_exists(quartel_id)) {
        resultado.integro = false;
        resultado.problemas[array_length(resultado.problemas)] = "Quartel não existe";
        return resultado;
    }
    
    var quartel = quartel_id;
    
    // Verificar variáveis essenciais
    var variaveis_essenciais = ["hp_atual", "hp_max", "nacao_proprietaria", "estado", "fila_producao", "timer_producao", "produzindo", "unidades_produzidas", "unidades_disponiveis"];
    
    for (var i = 0; i < array_length(variaveis_essenciais); i++) {
        var var_name = variaveis_essenciais[i];
        if (!variable_instance_exists(quartel, var_name)) {
            resultado.integro = false;
            resultado.problemas[array_length(resultado.problemas)] = "Variável ausente: " + var_name;
        }
    }
    
    // Verificar HP
    if (variable_instance_exists(quartel, "hp_atual") && variable_instance_exists(quartel, "hp_max")) {
        if (quartel.hp_atual <= 0) {
            resultado.integro = false;
            resultado.problemas[array_length(resultado.problemas)] = "Quartel destruído (HP: " + string(quartel.hp_atual) + ")";
        }
    }
    
    // Verificar lista de unidades
    if (variable_instance_exists(quartel, "unidades_disponiveis")) {
        if (!ds_exists(quartel.unidades_disponiveis, ds_type_list)) {
            resultado.integro = false;
            resultado.problemas[array_length(resultado.problemas)] = "Lista de unidades inválida";
        } else if (ds_list_size(quartel.unidades_disponiveis) == 0) {
            resultado.avisos[array_length(resultado.avisos)] = "Lista de unidades vazia";
        }
    }
    
    return resultado;
}