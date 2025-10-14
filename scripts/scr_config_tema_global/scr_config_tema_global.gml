/// @description Configuração de tema global - sistema de aparência
/// @param {string} nome_tema Nome do tema a ser aplicado
/// @param {struct} personalizacoes Personalizações específicas
/// @return {struct} Resultado da aplicação do tema

function scr_config_tema_global(nome_tema, personalizacoes = {}) {
    var resultado = {
        sucesso: false,
        tema_aplicado: nome_tema,
        cores_aplicadas: [],
        fontes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    scr_debug_log("CONFIG TEMA", "Aplicando tema: " + nome_tema);
    
    // Inicializar sistema de temas se não existir
    if (!variable_global_exists("global.temas")) {
        global.temas = {};
        scr_inicializar_temas_padrao();
    }
    
    // Verificar se o tema existe
    if (!struct_exists(global.temas, nome_tema)) {
        resultado.erros[array_length(resultado.erros)] = "Tema não encontrado: " + nome_tema;
        return resultado;
    }
    
    var tema = global.temas[$nome_tema];
    
    // Aplicar tema
    resultado = scr_aplicar_tema(tema, personalizacoes);
    
    // Salvar tema atual
    global.tema_atual = nome_tema;
    
    scr_debug_log("CONFIG TEMA", "Tema aplicado com sucesso: " + nome_tema);
    return resultado;
}

/// @description Inicializar temas padrão
function scr_inicializar_temas_padrao() {
    // Tema Padrão
    global.temas[$"padrao"] = {
        nome: "Padrão",
        cores: {
            fundo_principal: c_black,
            fundo_secundario: c_dkgray,
            texto_principal: c_white,
            texto_secundario: c_lightgray,
            botao_normal: c_gray,
            botao_hover: c_lightgray,
            botao_pressionado: c_dkgray,
            borda: c_white,
            selecao: c_yellow,
            sucesso: c_green,
            erro: c_red,
            aviso: c_orange
        },
        fontes: {
            principal: fnt_arial,
            secundaria: fnt_arial,
            interface: fnt_arial
        },
        tamanhos: {
            texto_pequeno: 12,
            texto_medio: 16,
            texto_grande: 20,
            titulo: 24
        }
    };
    
    // Tema Escuro
    global.temas[$"escuro"] = {
        nome: "Escuro",
        cores: {
            fundo_principal: c_black,
            fundo_secundario: c_navy,
            texto_principal: c_lightgray,
            texto_secundario: c_gray,
            botao_normal: c_dkgray,
            botao_hover: c_gray,
            botao_pressionado: c_black,
            borda: c_gray,
            selecao: c_cyan,
            sucesso: c_lime,
            erro: c_red,
            aviso: c_yellow
        },
        fontes: {
            principal: fnt_arial,
            secundaria: fnt_arial,
            interface: fnt_arial
        },
        tamanhos: {
            texto_pequeno: 12,
            texto_medio: 16,
            texto_grande: 20,
            titulo: 24
        }
    };
    
    // Tema Claro
    global.temas[? "claro"] = {
        nome: "Claro",
        cores: {
            fundo_principal: c_white,
            fundo_secundario: c_lightgray,
            texto_principal: c_black,
            texto_secundario: c_dkgray,
            botao_normal: c_lightgray,
            botao_hover: c_white,
            botao_pressionado: c_gray,
            borda: c_black,
            selecao: c_blue,
            sucesso: c_green,
            erro: c_red,
            aviso: c_orange
        },
        fontes: {
            principal: fnt_arial,
            secundaria: fnt_arial,
            interface: fnt_arial
        },
        tamanhos: {
            texto_pequeno: 12,
            texto_medio: 16,
            texto_grande: 20,
            titulo: 24
        }
    };
    
    // Tema Militar
    global.temas[$"militar"] = {
        nome: "Militar",
        cores: {
            fundo_principal: c_black,
            fundo_secundario: c_olive,
            texto_principal: c_lime,
            texto_secundario: c_yellow,
            botao_normal: c_olive,
            botao_hover: c_yellow,
            botao_pressionado: c_green,
            borda: c_lime,
            selecao: c_yellow,
            sucesso: c_green,
            erro: c_red,
            aviso: c_orange
        },
        fontes: {
            principal: fnt_arial,
            secundaria: fnt_arial,
            interface: fnt_arial
        },
        tamanhos: {
            texto_pequeno: 12,
            texto_medio: 16,
            texto_grande: 20,
            titulo: 24
        }
    };
}

/// @description Aplicar tema específico
function scr_aplicar_tema(tema, personalizacoes) {
    var resultado = {
        sucesso: true,
        tema_aplicado: tema.nome,
        cores_aplicadas: [],
        fontes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Aplicar cores
    if (struct_exists(tema, "cores")) {
        var cores = tema.cores;
        
        // Aplicar personalizações de cores se fornecidas
        if (struct_exists(personalizacoes, "cores")) {
            var cores_personalizadas = personalizacoes.cores;
            var key = struct_get_names(cores_personalizadas);
            for (var i = 0; i < array_length(key); i++) {
                var chave = key[i];
                cores[$chave] = cores_personalizadas[$chave];
            }
        }
        
        // Salvar cores globalmente
        global.cores_tema = cores;
        
        var key = struct_get_names(cores);
        for (var i = 0; i < array_length(key); i++) {
            var chave = key[i];
            resultado.cores_aplicadas[array_length(resultado.cores_aplicadas)] = chave;
        }
    }
    
    // Aplicar fontes
    if (struct_exists(tema, "fontes")) {
        var fontes = tema.fontes;
        
        // Aplicar personalizações de fontes se fornecidas
        if (struct_exists(personalizacoes, "fontes")) {
            var fontes_personalizadas = personalizacoes.fontes;
            var key = struct_get_names(fontes_personalizadas);
            for (var i = 0; i < array_length(key); i++) {
                var chave = key[i];
                fontes[$chave] = fontes_personalizadas[$chave];
            }
        }
        
        // Salvar fontes globalmente
        global.fontes_tema = fontes;
        
        var key = struct_get_names(fontes);
        for (var i = 0; i < array_length(key); i++) {
            var chave = key[i];
            resultado.fontes_aplicadas[array_length(resultado.fontes_aplicadas)] = chave;
        }
    }
    
    // Aplicar tamanhos
    if (struct_exists(tema, "tamanhos")) {
        var tamanhos = tema.tamanhos;
        
        // Aplicar personalizações de tamanhos se fornecidas
        if (struct_exists(personalizacoes, "tamanhos")) {
            var tamanhos_personalizados = personalizacoes.tamanhos;
            var key = struct_get_names(tamanhos_personalizados);
            for (var i = 0; i < array_length(key); i++) {
                var chave = key[i];
                tamanhos[$chave] = tamanhos_personalizados[$chave];
            }
        }
        
        // Salvar tamanhos globalmente
        global.tamanhos_tema = tamanhos;
    }
    
    return resultado;
}

/// @description Obter cor do tema atual
function scr_obter_cor_tema(nome_cor) {
    if (variable_global_exists("global.cores_tema") && struct_exists(global.cores_tema, nome_cor)) {
        return global.cores_tema[$nome_cor];
    }
    
    // Cor padrão se não encontrada
    return c_white;
}

/// @description Obter fonte do tema atual
function scr_obter_fonte_tema(nome_fonte) {
    if (variable_global_exists("global.fontes_tema") && struct_exists(global.fontes_tema, nome_fonte)) {
        return global.fontes_tema[$nome_fonte];
    }
    
    // Fonte padrão se não encontrada
    return fnt_arial;
}

/// @description Obter tamanho do tema atual
function scr_obter_tamanho_tema(nome_tamanho) {
    if (variable_global_exists("global.tamanhos_tema") && struct_exists(global.tamanhos_tema, nome_tamanho)) {
        return global.tamanhos_tema[$nome_tamanho];
    }
    
    // Tamanho padrão se não encontrado
    return 16;
}