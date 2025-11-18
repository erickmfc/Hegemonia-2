/// @description Debug específico para quartel da marinha
/// @param {Id.Instance} quartel_id ID do quartel da marinha
/// @param {string} tipo_debug Tipo de debug a ser realizado
/// @return {struct} Resultado do debug

function scr_debug_quartel_marinha(quartel_id, tipo_debug = "completo") {
    var resultado = {
        sucesso: false,
        quartel_id: quartel_id,
        tipo_debug: tipo_debug,
        informacoes: {},
        problemas: [],
        avisos: [],
        recomendacoes: []
    };
    
    scr_debug_log("DEBUG QUARTEL MARINHA", "Iniciando debug: " + tipo_debug);
    
    // Verificar se o quartel existe
    if (!instance_exists(quartel_id)) {
        resultado.problemas[array_length(resultado.problemas)] = "Quartel não existe (ID: " + string(quartel_id) + ")";
        scr_debug_log("DEBUG QUARTEL MARINHA", "Erro: Quartel não existe");
        return resultado;
    }
    
    var quartel = quartel_id;
    
    // Verificar se é um quartel da marinha
    if (quartel.object_index != obj_quartel_marinha) {
        resultado.problemas[array_length(resultado.problemas)] = "Objeto não é um quartel da marinha: " + string(quartel.object_index);
        scr_debug_log("DEBUG QUARTEL MARINHA", "Erro: Objeto não é quartel da marinha");
        return resultado;
    }
    
    // Executar debug baseado no tipo
    switch (tipo_debug) {
        case "completo":
            resultado = scr_debug_quartel_marinha_completo(quartel);
            break;
        case "producao":
            resultado = scr_debug_quartel_marinha_producao(quartel);
            break;
        case "recursos":
            resultado = scr_debug_quartel_marinha_recursos(quartel);
            break;
        case "unidades":
            resultado = scr_debug_quartel_marinha_unidades(quartel);
            break;
        case "eventos":
            resultado = scr_debug_quartel_marinha_eventos(quartel);
            break;
        case "performance":
            resultado = scr_debug_quartel_marinha_performance(quartel);
            break;
        default:
            resultado.problemas[array_length(resultado.problemas)] = "Tipo de debug não reconhecido: " + tipo_debug;
            break;
    }
    
    scr_debug_log("DEBUG QUARTEL MARINHA", "Debug concluído: " + tipo_debug + " - Sucesso: " + string(resultado.sucesso));
    return resultado;
}

/// @description Debug completo do quartel da marinha
function scr_debug_quartel_marinha_completo(quartel) {
    var resultado = {
        sucesso: true,
        quartel_id: quartel.id,
        tipo_debug: "completo",
        informacoes: {},
        problemas: [],
        avisos: [],
        recomendacoes: []
    };
    
    // === INFORMAÇÕES BÁSICAS ===
    resultado.informacoes.posicao = {
        x: quartel.x,
        y: quartel.y,
        layer: quartel.layer
    };
    
    resultado.informacoes.propriedades_basicas = {
        object_index: quartel.object_index,
        sprite_index: quartel.sprite_index,
        image_index: quartel.image_index,
        image_speed: quartel.image_speed,
        visible: quartel.visible
    };
    
    // === INFORMAÇÕES DE SAÚDE ===
    if (variable_instance_exists(quartel, "hp_atual") && variable_instance_exists(quartel, "hp_max")) {
        resultado.informacoes.saude = {
            hp_atual: quartel.hp_atual,
            hp_max: quartel.hp_max,
            percentual_hp: (quartel.hp_atual / quartel.hp_max) * 100
        };
        
        if (quartel.hp_atual <= 0) {
            resultado.problemas[array_length(resultado.problemas)] = "Quartel destruído (HP: " + string(quartel.hp_atual) + ")";
        } else if (quartel.hp_atual < quartel.hp_max * 0.3) {
            resultado.avisos[array_length(resultado.avisos)] = "Quartel com HP crítico (" + string(quartel.hp_atual) + "/" + string(quartel.hp_max) + ")";
        }
    } else {
        resultado.problemas[array_length(resultado.problemas)] = "Variáveis de HP ausentes";
    }
    
    // === INFORMAÇÕES DE PRODUÇÃO ===
    if (variable_instance_exists(quartel, "fila_producao")) {
        if (ds_exists(quartel.fila_producao, ds_type_queue)) {
            resultado.informacoes.producao = {
                fila_producao: ds_queue_size(quartel.fila_producao),
                timer_producao: variable_instance_exists(quartel, "timer_producao") ? quartel.timer_producao : -1,
                produzindo: variable_instance_exists(quartel, "produzindo") ? quartel.produzindo : false,
                unidades_produzidas: variable_instance_exists(quartel, "unidades_produzidas") ? quartel.unidades_produzidas : -1
            };
        } else {
            resultado.problemas[array_length(resultado.problemas)] = "Fila de produção inválida";
        }
    } else {
        resultado.problemas[array_length(resultado.problemas)] = "Fila de produção ausente";
    }
    
    // === INFORMAÇÕES DE UNIDADES ===
    if (variable_instance_exists(quartel, "unidades_disponiveis")) {
        if (ds_exists(quartel.unidades_disponiveis, ds_type_list)) {
            resultado.informacoes.unidades = {
                total_disponiveis: ds_list_size(quartel.unidades_disponiveis),
                lista_unidades: []
            };
            
            for (var i = 0; i < ds_list_size(quartel.unidades_disponiveis); i++) {
                var unidade = ds_list_find_value(quartel.unidades_disponiveis, i);
                if (is_struct(unidade)) {
                    resultado.informacoes.unidades.lista_unidades[array_length(resultado.informacoes.unidades.lista_unidades)] = {
                        nome: struct_exists(unidade, "nome") ? unidade.nome : "Desconhecido",
                        objeto: struct_exists(unidade, "objeto") ? unidade.objeto : -1,
                        custo_dinheiro: struct_exists(unidade, "custo_dinheiro") ? unidade.custo_dinheiro : 0,
                        tempo_treino: struct_exists(unidade, "tempo_treino") ? unidade.tempo_treino : 0
                    };
                }
            }
        } else {
            resultado.problemas[array_length(resultado.problemas)] = "Lista de unidades inválida";
        }
    } else {
        resultado.problemas[array_length(resultado.problemas)] = "Lista de unidades ausente";
    }
    
    // === INFORMAÇÕES DE RECURSOS ===
    if (variable_global_exists("global.recursos")) {
        var recursos = global.recursos;
        resultado.informacoes.recursos = {
            dinheiro: recursos.dinheiro,
            minerio: recursos.minerio,
            populacao_atual: recursos.populacao_atual,
            populacao_maxima: recursos.populacao_maxima
        };
    } else {
        resultado.avisos[array_length(resultado.avisos)] = "Sistema de recursos não inicializado";
    }
    
    // === VERIFICAÇÕES DE INTEGRIDADE ===
    
    // Verificar se está em água (se houver instância)
    var _instancia_quartel = instance_find(obj_quartel_marinha, 0);
    if (instance_exists(_instancia_quartel)) {
        if (!scr_verificar_agua(_instancia_quartel.x, _instancia_quartel.y)) {
            resultado.avisos[array_length(resultado.avisos)] = "Quartel da marinha não está em água";
        }
    }
    
    // Verificar eventos essenciais
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se tem eventos: Create_0, Step_0, Draw_0, Mouse_0";
    
    // === RECOMENDAÇÕES ===
    
    if (array_length(resultado.problemas) == 0) {
        resultado.recomendacoes[array_length(resultado.recomendacoes)] = "Quartel em bom estado geral";
    }
    
    if (array_length(resultado.problemas) > 0) {
        resultado.recomendacoes[array_length(resultado.recomendacoes)] = "Corrigir problemas identificados";
    }
    
    if (array_length(resultado.avisos) > 0) {
        resultado.recomendacoes[array_length(resultado.recomendacoes)] = "Monitorar avisos";
    }
    
    return resultado;
}

/// @description Debug de produção do quartel da marinha
function scr_debug_quartel_marinha_producao(quartel) {
    var resultado = {
        sucesso: true,
        quartel_id: quartel.id,
        tipo_debug: "producao",
        informacoes: {},
        problemas: [],
        avisos: [],
        recomendacoes: []
    };
    
    // Verificar sistema de produção
    if (variable_instance_exists(quartel, "fila_producao")) {
        if (ds_exists(quartel.fila_producao, ds_type_queue)) {
            resultado.informacoes.fila_producao = ds_queue_size(quartel.fila_producao);
        } else {
            resultado.problemas[array_length(resultado.problemas)] = "Fila de produção inválida";
        }
    } else {
        resultado.problemas[array_length(resultado.problemas)] = "Fila de produção ausente";
    }
    
    if (variable_instance_exists(quartel, "timer_producao")) {
        resultado.informacoes.timer_producao = quartel.timer_producao;
    } else {
        resultado.problemas[array_length(resultado.problemas)] = "Timer de produção ausente";
    }
    
    if (variable_instance_exists(quartel, "produzindo")) {
        resultado.informacoes.produzindo = quartel.produzindo;
    } else {
        resultado.problemas[array_length(resultado.problemas)] = "Status de produção ausente";
    }
    
    if (variable_instance_exists(quartel, "unidades_produzidas")) {
        resultado.informacoes.unidades_produzidas = quartel.unidades_produzidas;
    } else {
        resultado.problemas[array_length(resultado.problemas)] = "Contador de unidades produzidas ausente";
    }
    
    return resultado;
}

/// @description Debug de recursos do quartel da marinha
function scr_debug_quartel_marinha_recursos(quartel) {
    var resultado = {
        sucesso: true,
        quartel_id: quartel.id,
        tipo_debug: "recursos",
        informacoes: {},
        problemas: [],
        avisos: [],
        recomendacoes: []
    };
    
    // Verificar sistema de recursos global
    if (variable_global_exists("global.recursos")) {
        var recursos = global.recursos;
        resultado.informacoes.recursos_globais = {
            dinheiro: recursos.dinheiro,
            minerio: recursos.minerio,
            populacao_atual: recursos.populacao_atual,
            populacao_maxima: recursos.populacao_maxima
        };
    } else {
        resultado.problemas[array_length(resultado.problemas)] = "Sistema de recursos global não inicializado";
    }
    
    // Verificar custos das unidades
    if (variable_instance_exists(quartel, "unidades_disponiveis")) {
        if (ds_exists(quartel.unidades_disponiveis, ds_type_list)) {
            resultado.informacoes.custos_unidades = [];
            
            for (var i = 0; i < ds_list_size(quartel.unidades_disponiveis); i++) {
                var unidade = ds_list_find_value(quartel.unidades_disponiveis, i);
                if (is_struct(unidade)) {
                    resultado.informacoes.custos_unidades[array_length(resultado.informacoes.custos_unidades)] = {
                        nome: struct_exists(unidade, "nome") ? unidade.nome : "Desconhecido",
                        custo_dinheiro: struct_exists(unidade, "custo_dinheiro") ? unidade.custo_dinheiro : 0,
                        custo_minerio: struct_exists(unidade, "custo_minerio") ? unidade.custo_minerio : 0,
                        custo_populacao: struct_exists(unidade, "custo_populacao") ? unidade.custo_populacao : 0
                    };
                }
            }
        }
    }
    
    return resultado;
}

/// @description Debug de unidades do quartel da marinha
function scr_debug_quartel_marinha_unidades(quartel) {
    var resultado = {
        sucesso: true,
        quartel_id: quartel.id,
        tipo_debug: "unidades",
        informacoes: {},
        problemas: [],
        avisos: [],
        recomendacoes: []
    };
    
    // Verificar lista de unidades disponíveis
    if (variable_instance_exists(quartel, "unidades_disponiveis")) {
        if (ds_exists(quartel.unidades_disponiveis, ds_type_list)) {
            resultado.informacoes.unidades_disponiveis = ds_list_size(quartel.unidades_disponiveis);
            resultado.informacoes.lista_unidades = [];
            
            for (var i = 0; i < ds_list_size(quartel.unidades_disponiveis); i++) {
                var unidade = ds_list_find_value(quartel.unidades_disponiveis, i);
                if (is_struct(unidade)) {
                    resultado.informacoes.lista_unidades[array_length(resultado.informacoes.lista_unidades)] = {
                        nome: struct_exists(unidade, "nome") ? unidade.nome : "Desconhecido",
                        objeto: struct_exists(unidade, "objeto") ? unidade.objeto : -1,
                        descricao: struct_exists(unidade, "descricao") ? unidade.descricao : "Sem descrição"
                    };
                }
            }
        } else {
            resultado.problemas[array_length(resultado.problemas)] = "Lista de unidades inválida";
        }
    } else {
        resultado.problemas[array_length(resultado.problemas)] = "Lista de unidades ausente";
    }
    
    return resultado;
}

/// @description Debug de eventos do quartel da marinha
function scr_debug_quartel_marinha_eventos(quartel) {
    var resultado = {
        sucesso: true,
        quartel_id: quartel.id,
        tipo_debug: "eventos",
        informacoes: {},
        problemas: [],
        avisos: [],
        recomendacoes: []
    };
    
    // Verificar eventos essenciais
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se tem Create_0 para inicialização";
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se tem Step_0 para lógica de produção";
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se tem Draw_0 para renderização";
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se tem Mouse_0 para interação";
    
    return resultado;
}

/// @description Debug de performance do quartel da marinha
function scr_debug_quartel_marinha_performance(quartel) {
    var resultado = {
        sucesso: true,
        quartel_id: quartel.id,
        tipo_debug: "performance",
        informacoes: {},
        problemas: [],
        avisos: [],
        recomendacoes: []
    };
    
    // Verificar performance de estruturas de dados
    if (variable_instance_exists(quartel, "fila_producao")) {
        if (ds_exists(quartel.fila_producao, ds_type_queue)) {
            resultado.informacoes.tamanho_fila = ds_queue_size(quartel.fila_producao);
            if (ds_queue_size(quartel.fila_producao) > 100) {
                resultado.avisos[array_length(resultado.avisos)] = "Fila de produção muito grande: " + string(ds_queue_size(quartel.fila_producao));
            }
        }
    }
    
    if (variable_instance_exists(quartel, "unidades_disponiveis")) {
        if (ds_exists(quartel.unidades_disponiveis, ds_type_list)) {
            resultado.informacoes.tamanho_lista = ds_list_size(quartel.unidades_disponiveis);
        }
    }
    
    // Verificar se há loops ineficientes
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se há loops ineficientes no Step Event";
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se há cálculos desnecessários";
    
    return resultado;
}

/// @description Obter resumo do debug
function scr_obter_resumo_debug_quartel_marinha(quartel_id) {
    var debug_completo = scr_debug_quartel_marinha(quartel_id, "completo");
    
    var resumo = {
        quartel_id: quartel_id,
        status: "ok",
        problemas_count: array_length(debug_completo.problemas),
        avisos_count: array_length(debug_completo.avisos),
        recomendacoes_count: array_length(debug_completo.recomendacoes)
    };
    
    if (resumo.problemas_count > 0) {
        resumo.status = "problemas";
    } else if (resumo.avisos_count > 0) {
        resumo.status = "avisos";
    }
    
    return resumo;
}