/// @description Configuração de unidades - sistema centralizado
/// @param {string} tipo_unidade Tipo da unidade a ser configurada
/// @param {struct} parametros Parâmetros de configuração
/// @return {struct} Resultado da configuração

function scr_config_unidades(tipo_unidade, parametros) {
    var resultado = {
        sucesso: false,
        tipo_unidade: tipo_unidade,
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    scr_debug_log("CONFIG UNIDADES", "Configurando unidade: " + tipo_unidade);
    
    switch (tipo_unidade) {
        case "infantaria":
            resultado = scr_config_infantaria(parametros);
            break;
        case "naval":
            resultado = scr_config_naval(parametros);
            break;
        case "aerea":
            resultado = scr_config_aerea(parametros);
            break;
        case "blindada":
            resultado = scr_config_blindada(parametros);
            break;
        case "estrutura":
            resultado = scr_config_estrutura_unidade(parametros);
            break;
        default:
            resultado.erros[array_length(resultado.erros)] = "Tipo de unidade não reconhecido: " + tipo_unidade;
            break;
    }
    
    scr_debug_log("CONFIG UNIDADES", "Configuração concluída: " + tipo_unidade + " - Sucesso: " + string(resultado.sucesso));
    return resultado;
}

/// @description Configurar unidades de infantaria
function scr_config_infantaria(parametros) {
    var resultado = {
        sucesso: true,
        tipo_unidade: "infantaria",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão para infantaria
    var config_padrao = {
        hp_base: 100,
        velocidade_base: 1.5,
        dano_base: 20,
        alcance_base: 300,
        atq_rate_base: 45,
        experiencia_base: 0,
        nivel_base: 1,
        custo_dinheiro_base: 100,
        custo_populacao_base: 1,
        tempo_treino_base: 180
    };
    
    // Aplicar configurações específicas
    var unidades_infantaria = [
        {
            objeto: obj_soldado,
            nome: "Soldado",
            hp: 100,
            velocidade: 1.5,
            dano: 20,
            alcance: 300,
            atq_rate: 45,
            custo_dinheiro: 100,
            custo_populacao: 1,
            tempo_treino: 180,
            descricao: "Unidade básica de infantaria"
        },
        {
            objeto: obj_soldado_antiaereo,
            nome: "Soldado Anti-aéreo",
            hp: 120,
            velocidade: 1.3,
            dano: 25,
            alcance: 400,
            atq_rate: 60,
            custo_dinheiro: 150,
            custo_populacao: 1,
            tempo_treino: 240,
            descricao: "Unidade especializada contra aeronaves"
        }
    ];
    
    // Salvar configurações
    global.config_infantaria = {
        padrao: config_padrao,
        unidades: unidades_infantaria
    };
    
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações de infantaria aplicadas";
    
    return resultado;
}

/// @description Configurar unidades navais
function scr_config_naval(parametros) {
    var resultado = {
        sucesso: true,
        tipo_unidade: "naval",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão para unidades navais
    var config_padrao = {
        hp_base: 150,
        velocidade_base: 2.0,
        dano_base: 25,
        alcance_base: 400,
        atq_rate_base: 60,
        experiencia_base: 0,
        nivel_base: 1,
        custo_dinheiro_base: 200,
        custo_populacao_base: 2,
        tempo_treino_base: 240
    };
    
    // Aplicar configurações específicas
    var unidades_naval = [
        {
            objeto: obj_lancha_patrulha,
            nome: "Lancha Patrulha",
            hp: 150,
            velocidade: 2.0,
            dano: 25,
            alcance: 400,
            atq_rate: 60,
            custo_dinheiro: 200,
            custo_populacao: 2,
            tempo_treino: 240,
            descricao: "Unidade naval rápida para patrulhamento"
        },
        {
            objeto: obj_fragata,
            nome: "Fragata",
            hp: 200,
            velocidade: 1.8,
            dano: 35,
            alcance: 450,
            atq_rate: 75,
            custo_dinheiro: 400,
            custo_populacao: 3,
            tempo_treino: 480,
            descricao: "Navio de guerra médio"
        },
        {
            objeto: obj_destroyer,
            nome: "Destroyer",
            hp: 300,
            velocidade: 1.5,
            dano: 50,
            alcance: 500,
            atq_rate: 90,
            custo_dinheiro: 800,
            custo_populacao: 5,
            tempo_treino: 720,
            descricao: "Navio de guerra pesado"
        },
        {
            objeto: obj_submarino,
            nome: "Submarino",
            hp: 180,
            velocidade: 1.2,
            dano: 60,
            alcance: 500,
            atq_rate: 120,
            custo_dinheiro: 1000,
            custo_populacao: 4,
            tempo_treino: 900,
            descricao: "Unidade submarina furtiva"
        },
        {
            objeto: obj_RonaldReagan,
            nome: "Porta-aviões",
            hp: 500,
            velocidade: 1.0,
            dano: 40,
            alcance: 600,
            atq_rate: 150,
            custo_dinheiro: 2000,
            custo_populacao: 8,
            tempo_treino: 1200,
            descricao: "Navio gigante com capacidade aérea"
        }
    ];
    
    // Salvar configurações
    global.config_naval = {
        padrao: config_padrao,
        unidades: unidades_naval
    };
    
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações navais aplicadas";
    
    return resultado;
}

/// @description Configurar unidades aéreas
function scr_config_aerea(parametros) {
    var resultado = {
        sucesso: true,
        tipo_unidade: "aerea",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão para unidades aéreas
    var config_padrao = {
        hp_base: 80,
        velocidade_base: 3.0,
        dano_base: 30,
        alcance_base: 500,
        atq_rate_base: 90,
        experiencia_base: 0,
        nivel_base: 1,
        custo_dinheiro_base: 300,
        custo_populacao_base: 2,
        tempo_treino_base: 360
    };
    
    // Aplicar configurações específicas
    var unidades_aerea = [
        {
            objeto: obj_caca,
            nome: "Caça",
            hp: 80,
            velocidade: 3.0,
            dano: 30,
            alcance: 500,
            atq_rate: 90,
            custo_dinheiro: 300,
            custo_populacao: 2,
            tempo_treino: 360,
            descricao: "Aeronave de combate aéreo"
        },
        {
            objeto: obj_bombardeiro,
            nome: "Bombardeiro",
            hp: 120,
            velocidade: 2.5,
            dano: 50,
            alcance: 600,
            atq_rate: 120,
            custo_dinheiro: 500,
            custo_populacao: 3,
            tempo_treino: 480,
            descricao: "Aeronave de bombardeio"
        },
        {
            objeto: obj_helicoptero,
            nome: "Helicóptero",
            hp: 100,
            velocidade: 2.8,
            dano: 25,
            alcance: 400,
            atq_rate: 75,
            custo_dinheiro: 400,
            custo_populacao: 2,
            tempo_treino: 420,
            descricao: "Aeronave de transporte e apoio"
        }
    ];
    
    // Salvar configurações
    global.config_aerea = {
        padrao: config_padrao,
        unidades: unidades_aerea
    };
    
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações aéreas aplicadas";
    
    return resultado;
}

/// @description Configurar unidades blindadas
function scr_config_blindada(parametros) {
    var resultado = {
        sucesso: true,
        tipo_unidade: "blindada",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão para unidades blindadas
    var config_padrao = {
        hp_base: 200,
        velocidade_base: 1.2,
        dano_base: 40,
        alcance_base: 350,
        atq_rate_base: 75,
        experiencia_base: 0,
        nivel_base: 1,
        custo_dinheiro_base: 300,
        custo_populacao_base: 2,
        tempo_treino_base: 360
    };
    
    // Aplicar configurações específicas
    var unidades_blindada = [
        {
            objeto: obj_blindado,
            nome: "Blindado",
            hp: 200,
            velocidade: 1.2,
            dano: 40,
            alcance: 350,
            atq_rate: 75,
            custo_dinheiro: 300,
            custo_populacao: 2,
            tempo_treino: 360,
            descricao: "Veículo blindado de combate"
        },
        {
            objeto: obj_tanque,
            nome: "Tanque",
            hp: 300,
            velocidade: 1.0,
            dano: 60,
            alcance: 400,
            atq_rate: 90,
            custo_dinheiro: 500,
            custo_populacao: 3,
            tempo_treino: 480,
            descricao: "Tanque pesado de combate"
        }
    ];
    
    // Salvar configurações
    global.config_blindada = {
        padrao: config_padrao,
        unidades: unidades_blindada
    };
    
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações blindadas aplicadas";
    
    return resultado;
}

/// @description Configurar estruturas como unidades
function scr_config_estrutura_unidade(parametros) {
    var resultado = {
        sucesso: true,
        tipo_unidade: "estrutura",
        propriedades_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão para estruturas
    var config_padrao = {
        hp_base: 200,
        custo_dinheiro_base: 500,
        custo_minerio_base: 300,
        tempo_construcao_base: 300,
        producao_recursos: false
    };
    
    // Aplicar configurações específicas
    var estruturas = [
        {
            objeto: obj_quartel,
            nome: "Quartel",
            hp: 200,
            custo_dinheiro: 500,
            custo_minerio: 300,
            tempo_construcao: 300,
            descricao: "Produz unidades terrestres"
        },
        {
            objeto: obj_quartel_marinha,
            nome: "Quartel da Marinha",
            hp: 250,
            custo_dinheiro: 600,
            custo_minerio: 400,
            tempo_construcao: 450,
            descricao: "Produz unidades navais"
        },
        {
            objeto: obj_aeroporto,
            nome: "Aeroporto",
            hp: 300,
            custo_dinheiro: 800,
            custo_minerio: 500,
            tempo_construcao: 600,
            descricao: "Produz unidades aéreas"
        },
        {
            objeto: obj_centro_pesquisa,
            nome: "Centro de Pesquisa",
            hp: 150,
            custo_dinheiro: 1000,
            custo_minerio: 800,
            tempo_construcao: 900,
            descricao: "Desenvolve tecnologias"
        }
    ];
    
    // Salvar configurações
    global.config_estrutura = {
        padrao: config_padrao,
        estruturas: estruturas
    };
    
    resultado.propriedades_aplicadas[array_length(resultado.propriedades_aplicadas)] = "Configurações de estruturas aplicadas";
    
    return resultado;
}