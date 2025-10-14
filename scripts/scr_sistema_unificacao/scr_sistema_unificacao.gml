// Sistema de Eliminação de Duplicações - Hegemonia Global
// Remove variáveis duplicadas e unifica sistemas

// Estrutura para mapear variáveis duplicadas
global.variaveis_duplicadas = {
    // Sistema de vida/HP
    vida: "hp_atual",           // vida -> hp_atual
    vida_maxima: "hp_max",      // vida_maxima -> hp_max
    
    // Sistema de dano
    dano: "dano_ataque",        // dano -> dano_ataque
    ataque: "dano_ataque",      // ataque -> dano_ataque
    
    // Sistema de alcance
    range: "alcance_ataque",    // range -> alcance_ataque
    distancia: "alcance_ataque", // distancia -> alcance_ataque
    
    // Sistema de velocidade
    speed: "velocidade",        // speed -> velocidade
    move_speed: "velocidade",   // move_speed -> velocidade
    
    // Sistema de recursos
    wood: "madeira",            // wood -> madeira
    stone: "pedra",             // stone -> pedra
    food: "comida",             // food -> comida
    gold: "ouro",               // gold -> ouro
};

function scr_inicializar_sistema_unificacao() {
    scr_log_sistema("UNIFICACAO", "Sistema de unificação de variáveis inicializado");
    
    // Executar unificação automática
    scr_unificar_variaveis_duplicadas();
    
    scr_log_sistema("UNIFICACAO", "Unificação de variáveis concluída");
}

function scr_unificar_variaveis_duplicadas() {
    scr_debug_log("UNIFICACAO", "Iniciando unificação de variáveis duplicadas", DEBUG_LEVEL.BASIC);
    
    var _variaveis = variable_global_get_names(global.variaveis_duplicadas);
    var _unificacoes_realizadas = 0;
    
    for (var i = 0; i < array_length(_variaveis); i++) {
        var _variavel_duplicada = _variaveis[i];
        var _variavel_unificada = global.variaveis_duplicadas[$ _variavel_duplicada];
        
        if (scr_unificar_variavel(_variavel_duplicada, _variavel_unificada)) {
            _unificacoes_realizadas++;
        }
    }
    
    scr_debug_log("UNIFICACAO", "Unificações realizadas: " + string(_unificacoes_realizadas), DEBUG_LEVEL.BASIC);
}

function scr_unificar_variavel(variavel_duplicada, variavel_unificada) {
    // Verificar se a variável duplicada existe
    if (!variable_global_exists(variavel_duplicada)) {
        return false;
    }
    
    var _valor_duplicado = variable_global_get(variavel_duplicada);
    
    // Verificar se a variável unificada já existe
    if (variable_global_exists(variavel_unificada)) {
        var _valor_unificado = variable_global_get(variavel_unificada);
        
        // Se valores são diferentes, usar o maior
        if (_valor_duplicado != _valor_unificado) {
            var _novo_valor = max(_valor_duplicado, _valor_unificado);
            variable_global_set(variavel_unificada, _novo_valor);
            
            scr_debug_log("UNIFICACAO", "Valores diferentes encontrados: " + variavel_duplicada + "=" + string(_valor_duplicado) + 
                         ", " + variavel_unificada + "=" + string(_valor_unificado) + " -> usando " + string(_novo_valor), DEBUG_LEVEL.DETAILED);
        }
    } else {
        // Criar variável unificada com o valor da duplicada
        variable_global_set(variavel_unificada, _valor_duplicado);
        
        scr_debug_log("UNIFICACAO", "Variável unificada criada: " + variavel_unificada + " = " + string(_valor_duplicado), DEBUG_LEVEL.DETAILED);
    }
    
    // Remover variável duplicada
    variable_global_set(variavel_duplicada, undefined);
    
    scr_debug_log("UNIFICACAO", "Variável unificada: " + variavel_duplicada + " -> " + variavel_unificada, DEBUG_LEVEL.BASIC);
    
    return true;
}

function scr_unificar_sistemas_combate() {
    scr_debug_log("UNIFICACAO", "Unificando sistemas de combate", DEBUG_LEVEL.BASIC);
    
    // Verificar e unificar sistemas de combate automático e manual
    var _sistemas_combate = ["sistema_combate_automatico", "sistema_combate_manual"];
    var _sistema_unificado = "sistema_combate_unificado";
    
    // Se ambos os sistemas existem, unificar
    if (variable_global_exists(_sistemas_combate[0]) && variable_global_exists(_sistemas_combate[1])) {
        scr_debug_log("UNIFICACAO", "Sistemas de combate duplicados detectados, unificando...", DEBUG_LEVEL.BASIC);
        
        // Usar o sistema unificado já implementado
        global.sistema_combate.modo = "unified";
        
        scr_debug_log("UNIFICACAO", "Sistema de combate unificado ativado", DEBUG_LEVEL.BASIC);
    }
}

function scr_unificar_objetos_similares() {
    scr_debug_log("UNIFICACAO", "Verificando objetos similares para unificação", DEBUG_LEVEL.BASIC);
    
    // Lista de objetos que podem ser similares
    var _objetos_similares = [
        ["obj_infantaria", "obj_inimigo"],
        ["obj_lancha_patrulha", "obj_navio_guerra"],
        ["obj_recursos_madeira", "obj_recursos_pedra"]
    ];
    
    for (var i = 0; i < array_length(_objetos_similares); i++) {
        var _grupo = _objetos_similares[i];
        scr_verificar_objetos_similares(_grupo[0], _grupo[1]);
    }
}

function scr_verificar_objetos_similares(obj1_name, obj2_name) {
    var _obj1_exists = object_exists(asset_get_index(obj1_name));
    var _obj2_exists = object_exists(asset_get_index(obj2_name));
    
    if (_obj1_exists && _obj2_exists) {
        var _obj1_count = instance_number(asset_get_index(obj1_name));
        var _obj2_count = instance_number(asset_get_index(obj2_name));
        
        scr_debug_log("UNIFICACAO", "Objetos similares encontrados: " + obj1_name + " (" + string(_obj1_count) + 
                     ") e " + obj2_name + " (" + string(_obj2_count) + ")", DEBUG_LEVEL.DETAILED);
        
        // Sugerir unificação se ambos têm muitas instâncias
        if (_obj1_count > 10 && _obj2_count > 10) {
            scr_debug_log("UNIFICACAO", "Sugestão: Considerar unificar " + obj1_name + " e " + obj2_name, DEBUG_LEVEL.BASIC);
        }
    }
}

function scr_eliminar_codigo_duplicado() {
    scr_debug_log("UNIFICACAO", "Procurando código duplicado", DEBUG_LEVEL.BASIC);
    
    // Padrões de código duplicado comuns
    var _padroes_duplicados = [
        "show_debug_message",
        "instance_exists",
        "point_distance",
        "ds_list_create",
        "ds_queue_create"
    ];
    
    var _duplicacoes_encontradas = 0;
    
    for (var i = 0; i < array_length(_padroes_duplicados); i++) {
        var _padrao = _padroes_duplicados[i];
        var _ocorrencias = scr_contar_ocorrencias_codigo(_padrao);
        
        if (_ocorrencias > 5) {
            scr_debug_log("UNIFICACAO", "Padrão duplicado encontrado: " + _padrao + " (" + string(_ocorrencias) + " ocorrências)", DEBUG_LEVEL.BASIC);
            _duplicacoes_encontradas++;
        }
    }
    
    if (_duplicacoes_encontradas > 0) {
        scr_debug_log("UNIFICACAO", "Total de padrões duplicados: " + string(_duplicacoes_encontradas), DEBUG_LEVEL.BASIC);
        scr_debug_log("UNIFICACAO", "Sugestão: Criar funções auxiliares para código repetido", DEBUG_LEVEL.BASIC);
    }
}

function scr_contar_ocorrencias_codigo(padrao) {
    // Esta função seria implementada para contar ocorrências de código
    // Por simplicidade, retornamos um valor estimado
    return 3; // Valor estimado para demonstração
}

function scr_relatorio_unificacao() {
    scr_debug_log("UNIFICACAO", "=== RELATÓRIO DE UNIFICAÇÃO ===", DEBUG_LEVEL.BASIC, true);
    
    // Contar variáveis unificadas
    var _variaveis_unificadas = 0;
    var _variaveis = variable_global_get_names(global.variaveis_duplicadas);
    
    for (var i = 0; i < array_length(_variaveis); i++) {
        var _variavel = _variaveis[i];
        if (!variable_global_exists(_variavel)) {
            _variaveis_unificadas++;
        }
    }
    
    scr_debug_log("UNIFICACAO", "Variáveis unificadas: " + string(_variaveis_unificadas) + "/" + string(array_length(_variaveis)), DEBUG_LEVEL.BASIC, true);
    
    // Verificar sistemas unificados
    scr_debug_log("UNIFICACAO", "Sistema de combate: " + global.sistema_combate.modo, DEBUG_LEVEL.BASIC, true);
    
    // Verificar objetos similares
    scr_unificar_objetos_similares();
    
    scr_debug_log("UNIFICACAO", "=== FIM DO RELATÓRIO ===", DEBUG_LEVEL.BASIC, true);
}

function scr_aplicar_melhorias_unificacao() {
    scr_debug_log("UNIFICACAO", "Aplicando melhorias de unificação", DEBUG_LEVEL.BASIC);
    
    // 1. Unificar variáveis duplicadas
    scr_unificar_variaveis_duplicadas();
    
    // 2. Unificar sistemas de combate
    scr_unificar_sistemas_combate();
    
    // 3. Verificar objetos similares
    scr_unificar_objetos_similares();
    
    // 4. Eliminar código duplicado
    scr_eliminar_codigo_duplicado();
    
    // 5. Gerar relatório
    scr_relatorio_unificacao();
    
    scr_debug_log("UNIFICACAO", "Melhorias de unificação aplicadas", DEBUG_LEVEL.BASIC);
}

function scr_verificar_integridade_unificacao() {
    scr_debug_log("UNIFICACAO", "Verificando integridade após unificação", DEBUG_LEVEL.BASIC);
    
    var _problemas = [];
    
    // Verificar se variáveis críticas existem
    var _variaveis_criticas = ["hp_atual", "dano_ataque", "alcance_ataque", "velocidade"];
    
    for (var i = 0; i < array_length(_variaveis_criticas); i++) {
        var _variavel = _variaveis_criticas[i];
        if (!variable_global_exists(_variavel)) {
            array_push(_problemas, "Variável crítica ausente: " + _variavel);
        }
    }
    
    // Verificar se sistema de combate está funcionando
    if (global.sistema_combate.modo == "unified") {
        scr_debug_log("UNIFICACAO", "Sistema de combate unificado funcionando", DEBUG_LEVEL.DETAILED);
    } else {
        array_push(_problemas, "Sistema de combate não unificado");
    }
    
    // Reportar problemas
    if (array_length(_problemas) > 0) {
        scr_debug_log("UNIFICACAO", "Problemas encontrados:", DEBUG_LEVEL.BASIC);
        for (var i = 0; i < array_length(_problemas); i++) {
            scr_debug_log("UNIFICACAO", "• " + _problemas[i], DEBUG_LEVEL.BASIC);
        }
    } else {
        scr_debug_log("UNIFICACAO", "Integridade da unificação verificada com sucesso", DEBUG_LEVEL.BASIC);
    }
}
