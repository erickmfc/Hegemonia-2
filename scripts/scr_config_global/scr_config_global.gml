/// @description Configuração global do jogo - sistema centralizado
/// @param {string} categoria Categoria de configuração
/// @param {struct} valores Valores de configuração
/// @return {struct} Resultado da configuração

function scr_config_global(categoria, valores) {
    var resultado = {
        sucesso: false,
        categoria: categoria,
        configuracoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    scr_debug_log("CONFIG GLOBAL", "Configurando categoria: " + categoria);
    
    switch (categoria) {
        case "jogo":
            resultado = scr_config_jogo(valores);
            break;
        case "recursos":
            resultado = scr_config_recursos(valores);
            break;
        case "combate":
            resultado = scr_config_combate(valores);
            break;
        case "ui":
            resultado = scr_config_ui(valores);
            break;
        case "audio":
            resultado = scr_config_audio(valores);
            break;
        case "graficos":
            resultado = scr_config_graficos(valores);
            break;
        default:
            resultado.erros[array_length(resultado.erros)] = "Categoria não reconhecida: " + categoria;
            break;
    }
    
    scr_debug_log("CONFIG GLOBAL", "Configuração concluída: " + categoria + " - Sucesso: " + string(resultado.sucesso));
    return resultado;
}

/// @description Configurar parâmetros do jogo
function scr_config_jogo(valores) {
    var resultado = {
        sucesso: true,
        categoria: "jogo",
        configuracoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão do jogo
    if (!variable_global_exists("global.jogo_config")) {
        global.jogo_config = {
            fps_alvo: 60,
            velocidade_jogo: 1.0,
            modo_debug: false,
            idioma: "pt_BR",
            dificuldade: "normal",
            modo_jogo: "campanha"
        };
    }
    
    // Aplicar valores fornecidos
    if (is_struct(valores)) {
        var key = struct_get_names(valores);
        for (var i = 0; i < array_length(key); i++) {
            var chave = key[i];
            var valor = valores[$chave];
            global.jogo_config[$chave] = valor;
            resultado.configuracoes_aplicadas[array_length(resultado.configuracoes_aplicadas)] = chave + ": " + string(valor);
        }
    }
    
    return resultado;
}

/// @description Configurar sistema de recursos
function scr_config_recursos(valores) {
    var resultado = {
        sucesso: true,
        categoria: "recursos",
        configuracoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão de recursos
    if (!variable_global_exists("global.recursos_config")) {
        global.recursos_config = {
            dinheiro_inicial: 1000,
            minerio_inicial: 500,
            energia_inicial: 100,
            populacao_maxima: 50,
            taxa_dinheiro: 10,
            taxa_minerio: 5,
            taxa_energia: 2
        };
    }
    
    // Aplicar valores fornecidos
    if (is_struct(valores)) {
        var key = struct_get_names(valores);
        for (var i = 0; i < array_length(key); i++) {
            var chave = key[i];
            var valor = valores[$chave];
            global.recursos_config[$chave] = valor;
            resultado.configuracoes_aplicadas[array_length(resultado.configuracoes_aplicadas)] = chave + ": " + string(valor);
        }
    }
    
    return resultado;
}

/// @description Configurar sistema de combate
function scr_config_combate(valores) {
    var resultado = {
        sucesso: true,
        categoria: "combate",
        configuracoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão de combate
    if (!variable_global_exists("global.combate_config")) {
        global.combate_config = {
            dano_base: 25,
            multiplicador_critico: 1.5,
            chance_critico: 0.1,
            experiencia_por_morte: 10,
            experiencia_por_nivel: 100,
            bonus_nivel_dano: 0.1,
            bonus_nivel_hp: 0.15
        };
    }
    
    // Aplicar valores fornecidos
    if (is_struct(valores)) {
        var key = struct_get_names(valores);
        for (var i = 0; i < array_length(key); i++) {
            var chave = key[i];
            var valor = valores[$chave];
            global.combate_config[$chave] = valor;
            resultado.configuracoes_aplicadas[array_length(resultado.configuracoes_aplicadas)] = chave + ": " + string(valor);
        }
    }
    
    return resultado;
}

/// @description Configurar interface do usuário
function scr_config_ui(valores) {
    var resultado = {
        sucesso: true,
        categoria: "ui",
        configuracoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão da UI
    if (!variable_global_exists("global.ui_config")) {
        global.ui_config = {
            escala_ui: 1.0,
            mostrar_fps: false,
            mostrar_coordenadas: false,
            mostrar_debug: false,
            tema: "padrao",
            animacoes: true,
            efeitos_sonoros: true
        };
    }
    
    // Aplicar valores fornecidos
    if (is_struct(valores)) {
        var key = struct_get_names(valores);
        for (var i = 0; i < array_length(key); i++) {
            var chave = key[i];
            var valor = valores[$chave];
            global.ui_config[$chave] = valor;
            resultado.configuracoes_aplicadas[array_length(resultado.configuracoes_aplicadas)] = chave + ": " + string(valor);
        }
    }
    
    return resultado;
}

/// @description Configurar sistema de áudio
function scr_config_audio(valores) {
    var resultado = {
        sucesso: true,
        categoria: "audio",
        configuracoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão de áudio
    if (!variable_global_exists("global.audio_config")) {
        global.audio_config = {
            volume_master: 1.0,
            volume_musica: 0.7,
            volume_efeitos: 0.8,
            volume_interface: 0.6,
            musica_ativa: true,
            efeitos_ativos: true
        };
    }
    
    // Aplicar valores fornecidos
    if (is_struct(valores)) {
        var key = struct_get_names(valores);
        for (var i = 0; i < array_length(key); i++) {
            var chave = key[i];
            var valor = valores[$chave];
            global.audio_config[$chave] = valor;
            resultado.configuracoes_aplicadas[array_length(resultado.configuracoes_aplicadas)] = chave + ": " + string(valor);
        }
    }
    
    return resultado;
}

/// @description Configurar sistema de gráficos
function scr_config_graficos(valores) {
    var resultado = {
        sucesso: true,
        categoria: "graficos",
        configuracoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Configurações padrão de gráficos
    if (!variable_global_exists("global.graficos_config")) {
        global.graficos_config = {
            resolucao_x: 1920,
            resolucao_y: 1080,
            modo_tela: "janela",
            vsync: true,
            anti_aliasing: true,
            sombras: true,
            particulas: true,
            qualidade_texturas: "alta"
        };
    }
    
    // Aplicar valores fornecidos
    if (is_struct(valores)) {
        var key = struct_get_names(valores);
        for (var i = 0; i < array_length(key); i++) {
            var chave = key[i];
            var valor = valores[$chave];
            global.graficos_config[$chave] = valor;
            resultado.configuracoes_aplicadas[array_length(resultado.configuracoes_aplicadas)] = chave + ": " + string(valor);
        }
    }
    
    return resultado;
}