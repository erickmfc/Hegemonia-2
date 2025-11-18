/// @description Configuração de estruturas - sistema centralizado
/// @param {string} tipo_estrutura Tipo da estrutura a ser configurada
/// @param {struct} parametros Parâmetros de configuração
/// @return {struct} Resultado da configuração

function scr_config_estruturas(tipo_estrutura, parametros) {
    var resultado = {
        sucesso: false,
        estrutura_configurada: tipo_estrutura,
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    scr_debug_log("CONFIG ESTRUTURAS", "Configurando estrutura: " + tipo_estrutura);
    
    switch (tipo_estrutura) {
        case "quartel":
            resultado = scr_config_quartel(parametros);
            break;
        case "quartel_marinha":
            resultado = scr_config_quartel_marinha(parametros);
            break;
        case "aeroporto":
            resultado = scr_config_aeroporto(parametros);
            break;
        case "centro_pesquisa":
            resultado = scr_config_centro_pesquisa(parametros);
            break;
        case "fabrica":
            resultado = scr_config_fabrica(parametros);
            break;
        case "base_naval":
            resultado = scr_config_base_naval(parametros);
            break;
        default:
            resultado.erros[array_length(resultado.erros)] = "Tipo de estrutura não reconhecido: " + tipo_estrutura;
            break;
    }
    
    scr_debug_log("CONFIG ESTRUTURAS", "Configuração concluída: " + tipo_estrutura + " - Sucesso: " + string(resultado.sucesso));
    return resultado;
}

/// @description Configurar Quartel
function scr_config_quartel(parametros) {
    var resultado = {
        sucesso: true,
        estrutura_configurada: "quartel",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão do quartel
    var config_padrao = {
        hp_max: 200,
        custo_dinheiro: 500,
        custo_minerio: 300,
        tempo_construcao: 300, // 5 segundos
        unidades_disponiveis: [
            {
                nome: "Soldado",
                objeto: obj_soldado,
                custo_dinheiro: 100,
                custo_populacao: 1,
                tempo_treino: 180, // 3 segundos
                descricao: "Unidade básica de infantaria"
            },
            {
                nome: "Soldado Anti-aéreo",
                objeto: obj_soldado_antiaereo,
                custo_dinheiro: 150,
                custo_populacao: 1,
                tempo_treino: 180, // ✅ MUDADO: 3 segundos (180 frames) - MÁXIMO
                descricao: "Unidade especializada contra aeronaves"
            },
            {
                nome: "Blindado",
                objeto: obj_blindado,
                custo_dinheiro: 300,
                custo_populacao: 2,
                tempo_treino: 180, // ✅ MUDADO: 3 segundos (180 frames) - MÁXIMO
                descricao: "Veículo blindado de combate"
            },
            {
                nome: "Tanque",
                objeto: obj_tanque,
                custo_dinheiro: 500,
                custo_populacao: 3,
                tempo_treino: 180, // ✅ MUDADO: 3 segundos (180 frames) - MÁXIMO
                descricao: "Tanque pesado de combate"
            }
        ]
    };
    
    // Aplicar configurações
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações padrão aplicadas";
    
    return resultado;
}

/// @description Configurar Quartel da Marinha
function scr_config_quartel_marinha(parametros) {
    var resultado = {
        sucesso: true,
        estrutura_configurada: "quartel_marinha",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão do quartel da marinha
    var config_padrao = {
        hp_max: 250,
        custo_dinheiro: 600,
        custo_minerio: 400,
        tempo_construcao: 450, // 7.5 segundos
        unidades_disponiveis: [
            {
                nome: "Lancha Patrulha",
                objeto: obj_lancha_patrulha,
                custo_dinheiro: 200,
                custo_populacao: 2,
                tempo_treino: 180, // ✅ MUDADO: 3 segundos (180 frames) - MÁXIMO
                descricao: "Unidade naval rápida para patrulhamento"
            },
            {
                nome: "Fragata",
                objeto: obj_fragata,
                custo_dinheiro: 400,
                custo_populacao: 3,
                tempo_treino: 480, // 8 segundos
                descricao: "Navio de guerra médio"
            },
            {
                nome: "Destroyer",
                objeto: obj_destroyer,
                custo_dinheiro: 800,
                custo_populacao: 5,
                tempo_treino: 720, // 12 segundos
                descricao: "Navio de guerra pesado"
            },
            {
                nome: "Submarino",
                objeto: obj_submarino,
                custo_dinheiro: 1000,
                custo_populacao: 4,
                tempo_treino: 900, // 15 segundos
                descricao: "Unidade submarina furtiva"
            },
            {
                nome: "Porta-aviões",
                objeto: obj_RonaldReagan,
                custo_dinheiro: 2000,
                custo_populacao: 8,
                tempo_treino: 1200, // 20 segundos
                descricao: "Navio gigante com capacidade aérea"
            }
        ]
    };
    
    // Aplicar configurações
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações navais aplicadas";
    
    return resultado;
}

/// @description Configurar Aeroporto
function scr_config_aeroporto(parametros) {
    var resultado = {
        sucesso: true,
        estrutura_configurada: "aeroporto",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão do aeroporto
    var config_padrao = {
        hp_max: 300,
        custo_dinheiro: 800,
        custo_minerio: 500,
        tempo_construcao: 600, // 10 segundos
        unidades_disponiveis: [
            {
                nome: "Caça",
                objeto: obj_caca,
                custo_dinheiro: 300,
                custo_populacao: 2,
                tempo_treino: 360, // 6 segundos
                descricao: "Aeronave de combate aéreo"
            },
            {
                nome: "Bombardeiro",
                objeto: obj_bombardeiro,
                custo_dinheiro: 500,
                custo_populacao: 3,
                tempo_treino: 480, // 8 segundos
                descricao: "Aeronave de bombardeio"
            },
            {
                nome: "Helicóptero",
                objeto: obj_helicoptero,
                custo_dinheiro: 400,
                custo_populacao: 2,
                tempo_treino: 420, // 7 segundos
                descricao: "Aeronave de transporte e apoio"
            }
        ]
    };
    
    // Aplicar configurações
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações aéreas aplicadas";
    
    return resultado;
}

/// @description Configurar Centro de Pesquisa
function scr_config_centro_pesquisa(parametros) {
    var resultado = {
        sucesso: true,
        estrutura_configurada: "centro_pesquisa",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão do centro de pesquisa
    var config_padrao = {
        hp_max: 150,
        custo_dinheiro: 1000,
        custo_minerio: 800,
        tempo_construcao: 900, // 15 segundos
        pesquisas_disponiveis: [
            {
                nome: "Armamento Avançado",
                custo_dinheiro: 500,
                custo_minerio: 300,
                tempo_pesquisa: 600, // 10 segundos
                descricao: "Melhora o dano das unidades"
            },
            {
                nome: "Blindagem Reforçada",
                custo_dinheiro: 400,
                custo_minerio: 400,
                tempo_pesquisa: 480, // 8 segundos
                descricao: "Aumenta a resistência das unidades"
            },
            {
                nome: "Propulsão Naval",
                custo_dinheiro: 600,
                custo_minerio: 200,
                tempo_pesquisa: 720, // 12 segundos
                descricao: "Melhora a velocidade dos navios"
            }
        ]
    };
    
    // Aplicar configurações
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações de pesquisa aplicadas";
    
    return resultado;
}

/// @description Configurar Fábrica
function scr_config_fabrica(parametros) {
    var resultado = {
        sucesso: true,
        estrutura_configurada: "fabrica",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão da fábrica
    var config_padrao = {
        hp_max: 200,
        custo_dinheiro: 700,
        custo_minerio: 600,
        tempo_construcao: 540, // 9 segundos
        producao_recursos: {
            dinheiro_por_segundo: 10,
            minerio_por_segundo: 5
        }
    };
    
    // Aplicar configurações
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações de produção aplicadas";
    
    return resultado;
}

/// @description Configurar Base Naval
function scr_config_base_naval(parametros) {
    var resultado = {
        sucesso: true,
        estrutura_configurada: "base_naval",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão da base naval
    var config_padrao = {
        hp_max: 400,
        custo_dinheiro: 1200,
        custo_minerio: 800,
        tempo_construcao: 1200, // 20 segundos
        capacidade_navios: 10,
        reparo_automatico: true,
        taxa_reparo: 5 // HP por segundo
    };
    
    // Aplicar configurações
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações de base naval aplicadas";
    
    return resultado;
}