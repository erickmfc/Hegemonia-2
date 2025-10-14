/// @description Corrigir objeto automaticamente - sistema de reparo
/// @param {Id.Instance} objeto_id ID do objeto a ser corrigido
/// @param {string} tipo_correcao Tipo de correção a ser aplicada
/// @return {struct} Resultado da correção

function scr_corrigir_objeto_automaticamente(objeto_id, tipo_correcao = "completa") {
    var resultado = {
        sucesso: false,
        objeto_id: objeto_id,
        tipo_correcao: tipo_correcao,
        correcoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    scr_debug_log("CORRIGIR OBJETO", "Iniciando correção automática: " + tipo_correcao);
    
    // Verificar se o objeto existe
    if (!instance_exists(objeto_id)) {
        resultado.erros[array_length(resultado.erros)] = "Objeto não existe (ID: " + string(objeto_id) + ")";
        return resultado;
    }
    
    var objeto = objeto_id;
    
    // Aplicar correções baseadas no tipo
    switch (tipo_correcao) {
        case "completa":
            resultado = scr_corrigir_objeto_completa(objeto);
            break;
        case "variaveis":
            resultado = scr_corrigir_variaveis_objeto(objeto);
            break;
        case "eventos":
            resultado = scr_corrigir_eventos_objeto(objeto);
            break;
        case "propriedades":
            resultado = scr_corrigir_propriedades_objeto(objeto);
            break;
        case "estado":
            resultado = scr_corrigir_estado_objeto(objeto);
            break;
        default:
            resultado.erros[array_length(resultado.erros)] = "Tipo de correção não reconhecido: " + tipo_correcao;
            break;
    }
    
    scr_debug_log("CORRIGIR OBJETO", "Correção concluída: " + tipo_correcao + " - Sucesso: " + string(resultado.sucesso));
    return resultado;
}

/// @description Correção completa do objeto
function scr_corrigir_objeto_completa(objeto) {
    var resultado = {
        sucesso: true,
        objeto_id: objeto.id,
        tipo_correcao: "completa",
        correcoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Correção de variáveis
    var resultado_variaveis = scr_corrigir_variaveis_objeto(objeto);
    resultado.correcoes_aplicadas = array_concat(resultado.correcoes_aplicadas, resultado_variaveis.correcoes_aplicadas);
    resultado.erros = array_concat(resultado.erros, resultado_variaveis.erros);
    resultado.avisos = array_concat(resultado.avisos, resultado_variaveis.avisos);
    
    // Correção de propriedades
    var resultado_propriedades = scr_corrigir_propriedades_objeto(objeto);
    resultado.correcoes_aplicadas = array_concat(resultado.correcoes_aplicadas, resultado_propriedades.correcoes_aplicadas);
    resultado.erros = array_concat(resultado.erros, resultado_propriedades.erros);
    resultado.avisos = array_concat(resultado.avisos, resultado_propriedades.avisos);
    
    // Correção de estado
    var resultado_estado = scr_corrigir_estado_objeto(objeto);
    resultado.correcoes_aplicadas = array_concat(resultado.correcoes_aplicadas, resultado_estado.correcoes_aplicadas);
    resultado.erros = array_concat(resultado.erros, resultado_estado.erros);
    resultado.avisos = array_concat(resultado.avisos, resultado_estado.avisos);
    
    return resultado;
}

/// @description Corrigir variáveis do objeto
function scr_corrigir_variaveis_objeto(objeto) {
    var resultado = {
        sucesso: true,
        objeto_id: objeto.id,
        tipo_correcao: "variaveis",
        correcoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Lista de variáveis essenciais para diferentes tipos de objeto
    var variaveis_essenciais = [];
    
    // Determinar tipo de objeto e variáveis necessárias
    switch (objeto.object_index) {
        case obj_lancha_patrulha:
        case obj_fragata:
        case obj_destroyer:
        case obj_submarino:
        case obj_porta_avioes:
            variaveis_essenciais = [
                "hp_atual", "hp_max", "velocidade", "dano", "alcance",
                "estado", "nacao_proprietaria", "experiencia", "nivel",
                "atq_cooldown", "atq_rate", "raio_de_visao"
            ];
            break;
        case obj_soldado:
        case obj_soldado_antiaereo:
            variaveis_essenciais = [
                "hp_atual", "hp_max", "velocidade", "dano", "alcance",
                "estado", "nacao_proprietaria", "experiencia", "nivel",
                "atq_cooldown", "atq_rate", "raio_de_visao"
            ];
            break;
        case obj_blindado:
        case obj_tanque:
            variaveis_essenciais = [
                "hp_atual", "hp_max", "velocidade", "dano", "alcance",
                "estado", "nacao_proprietaria", "experiencia", "nivel",
                "atq_cooldown", "atq_rate", "raio_de_visao"
            ];
            break;
        case obj_quartel:
        case obj_quartel_marinha:
        case obj_aeroporto:
        case obj_centro_pesquisa:
            variaveis_essenciais = [
                "hp_atual", "hp_max", "nacao_proprietaria", "estado"
            ];
            break;
    }
    
    // Verificar e corrigir variáveis
    for (var i = 0; i < array_length(variaveis_essenciais); i++) {
        var var_name = variaveis_essenciais[i];
        
        if (!variable_instance_exists(objeto, var_name)) {
            // Aplicar valor padrão baseado no tipo de variável
            var valor_padrao = scr_obter_valor_padrao_variavel(var_name, objeto.object_index);
            objeto[$var_name] = valor_padrao;
            resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Variável adicionada: " + var_name + " = " + string(valor_padrao);
        }
    }
    
    return resultado;
}

/// @description Corrigir propriedades do objeto
function scr_corrigir_propriedades_objeto(objeto) {
    var resultado = {
        sucesso: true,
        objeto_id: objeto.id,
        tipo_correcao: "propriedades",
        correcoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Corrigir propriedades básicas
    if (objeto.sprite_index == -1) {
        objeto.sprite_index = spr_default;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Sprite definido: spr_default";
    }
    
    if (objeto.image_speed == 0) {
        objeto.image_speed = 1;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Velocidade de imagem definida: 1";
    }
    
    if (!objeto.visible) {
        objeto.visible = true;
        resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Visibilidade ativada";
    }
    
    // Corrigir propriedades específicas por tipo
    switch (objeto.object_index) {
        case obj_lancha_patrulha:
        case obj_fragata:
        case obj_destroyer:
        case obj_submarino:
        case obj_porta_avioes:
            // Verificar se está em água
            if (!scr_check_water_tile()) {
                var pos_agua = scr_find_nearest_water();
                if (pos_agua.x != -1) {
                    objeto.x = pos_agua.x;
                    objeto.y = pos_agua.y;
                    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Posição corrigida para água";
                } else {
                    resultado.avisos[array_length(resultado.avisos)] = "Navio não está em água e não foi possível encontrar posição válida";
                }
            }
            break;
    }
    
    return resultado;
}

/// @description Corrigir estado do objeto
function scr_corrigir_estado_objeto(objeto) {
    var resultado = {
        sucesso: true,
        objeto_id: objeto.id,
        tipo_correcao: "estado",
        correcoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Verificar e corrigir estado
    if (variable_instance_exists(objeto, "estado")) {
        var estados_validos = ["parado", "movendo", "atacando", "patrulhando", "seguindo", "destruida", "ativo"];
        var estado_valido = false;
        
        for (var i = 0; i < array_length(estados_validos); i++) {
            if (objeto.estado == estados_validos[i]) {
                estado_valido = true;
                break;
            }
        }
        
        if (!estado_valido) {
            objeto.estado = "parado";
            resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Estado corrigido: parado";
        }
    }
    
    // Verificar HP
    if (variable_instance_exists(objeto, "hp_atual") && variable_instance_exists(objeto, "hp_max")) {
        if (objeto.hp_atual <= 0) {
            objeto.estado = "destruida";
            resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Estado definido como destruída (HP <= 0)";
        } else if (objeto.hp_atual > objeto.hp_max) {
            objeto.hp_atual = objeto.hp_max;
            resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "HP corrigido para máximo";
        }
    }
    
    return resultado;
}

/// @description Obter valor padrão para variável
function scr_obter_valor_padrao_variavel(nome_variavel, tipo_objeto) {
    switch (nome_variavel) {
        case "hp_atual":
        case "hp_max":
            switch (tipo_objeto) {
                case obj_lancha_patrulha: return 150;
                case obj_fragata: return 200;
                case obj_destroyer: return 300;
                case obj_submarino: return 180;
                case obj_porta_avioes: return 500;
                case obj_soldado: return 100;
                case obj_soldado_antiaereo: return 120;
                case obj_blindado: return 200;
                case obj_tanque: return 300;
                default: return 100;
            }
        case "velocidade":
            switch (tipo_objeto) {
                case obj_lancha_patrulha: return 2.0;
                case obj_fragata: return 1.8;
                case obj_destroyer: return 1.5;
                case obj_submarino: return 1.2;
                case obj_porta_avioes: return 1.0;
                case obj_soldado: return 1.5;
                case obj_soldado_antiaereo: return 1.3;
                case obj_blindado: return 1.2;
                case obj_tanque: return 1.0;
                default: return 1.0;
            }
        case "dano":
            switch (tipo_objeto) {
                case obj_lancha_patrulha: return 25;
                case obj_fragata: return 35;
                case obj_destroyer: return 50;
                case obj_submarino: return 60;
                case obj_porta_avioes: return 40;
                case obj_soldado: return 20;
                case obj_soldado_antiaereo: return 25;
                case obj_blindado: return 40;
                case obj_tanque: return 60;
                default: return 25;
            }
        case "alcance":
            switch (tipo_objeto) {
                case obj_lancha_patrulha: return 400;
                case obj_fragata: return 450;
                case obj_destroyer: return 500;
                case obj_submarino: return 500;
                case obj_porta_avioes: return 600;
                case obj_soldado: return 300;
                case obj_soldado_antiaereo: return 400;
                case obj_blindado: return 350;
                case obj_tanque: return 400;
                default: return 300;
            }
        case "estado":
            return "parado";
        case "nacao_proprietaria":
            return 1;
        case "experiencia":
            return 0;
        case "nivel":
            return 1;
        case "atq_cooldown":
            return 0;
        case "atq_rate":
            switch (tipo_objeto) {
                case obj_lancha_patrulha: return 60;
                case obj_fragata: return 75;
                case obj_destroyer: return 90;
                case obj_submarino: return 120;
                case obj_porta_avioes: return 150;
                case obj_soldado: return 45;
                case obj_soldado_antiaereo: return 60;
                case obj_blindado: return 75;
                case obj_tanque: return 90;
                default: return 60;
            }
        case "raio_de_visao":
            switch (tipo_objeto) {
                case obj_lancha_patrulha: return 500;
                case obj_fragata: return 550;
                case obj_destroyer: return 600;
                case obj_submarino: return 400;
                case obj_porta_avioes: return 700;
                case obj_soldado: return 400;
                case obj_soldado_antiaereo: return 500;
                case obj_blindado: return 450;
                case obj_tanque: return 500;
                default: return 400;
            }
        default:
            return 0;
    }
}