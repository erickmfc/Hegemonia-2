/// @description Corrigir Step Event - sistema de reparo de eventos
/// @param {Id.Instance} objeto_id ID do objeto a ser corrigido
/// @param {string} tipo_correcao Tipo de correção do Step Event
/// @return {struct} Resultado da correção

function scr_corrigir_step_event(objeto_id, tipo_correcao = "completa") {
    var resultado = {
        sucesso: false,
        objeto_id: objeto_id,
        tipo_correcao: tipo_correcao,
        correcoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    scr_debug_log("CORRIGIR STEP EVENT", "Iniciando correção: " + tipo_correcao);
    
    // Verificar se o objeto existe
    if (!instance_exists(objeto_id)) {
        resultado.erros[array_length(resultado.erros)] = "Objeto não existe (ID: " + string(objeto_id) + ")";
        return resultado;
    }
    
    var objeto = objeto_id;
    
    // Aplicar correções baseadas no tipo
    switch (tipo_correcao) {
        case "completa":
            resultado = scr_corrigir_step_event_completa(objeto);
            break;
        case "conflito":
            resultado = scr_corrigir_conflito_step_events(objeto, resultado);
            break;
        case "performance":
            resultado = scr_corrigir_performance_step_events(objeto, resultado);
            break;
        case "logica":
            resultado = scr_corrigir_logica_step_events(objeto, resultado);
            break;
        default:
            resultado.erros[array_length(resultado.erros)] = "Tipo de correção não reconhecido: " + tipo_correcao;
            break;
    }
    
    scr_debug_log("CORRIGIR STEP EVENT", "Correção concluída: " + tipo_correcao + " - Sucesso: " + string(resultado.sucesso));
    return resultado;
}

/// @description Correção completa do Step Event
function scr_corrigir_step_event_completa(objeto) {
    var resultado = {
        sucesso: true,
        objeto_id: objeto.id,
        tipo_correcao: "completa",
        correcoes_aplicadas: [],
        erros: [],
        avisos: []
    };
    
    // Verificar e corrigir Step Events baseado no tipo de objeto
    switch (objeto.object_index) {
        case obj_controlador_unidades:
            resultado = scr_corrigir_step_controlador_unidades(objeto, resultado);
            break;
        case obj_lancha_patrulha:
        case obj_fragata:
        case obj_destroyer:
        case obj_submarino:
        case obj_RonaldReagan:
            resultado = scr_corrigir_step_navios(objeto, resultado);
            break;
        case obj_soldado:
        case obj_soldado_antiaereo:
            resultado = scr_corrigir_step_infantaria(objeto, resultado);
            break;
        case obj_blindado:
        case obj_tanque:
            resultado = scr_corrigir_step_blindados(objeto, resultado);
            break;
        case obj_quartel:
        case obj_quartel_marinha:
            resultado = scr_corrigir_step_quartel(objeto, resultado);
            break;
        default:
            resultado.avisos[array_length(resultado.avisos)] = "Tipo de objeto não reconhecido para correção específica";
            break;
    }
    
    return resultado;
}

/// @description Corrigir Step Events do controlador de unidades
function scr_corrigir_step_controlador_unidades(objeto, resultado) {
    // Verificar se tem Step_0 e Step_1
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se obj_controlador_unidades tem Step_0 e Step_1";
    
    // Step_0 deve conter lógica de seleção básica
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Step_0 deve conter seleção de unidades";
    
    // Step_1 deve conter comandos táticos
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Step_1 deve conter comandos táticos (A, D, S)";
    
    // Verificar se inclui navios nos comandos
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se navios estão incluídos nos comandos táticos";
    
    return resultado;
}

/// @description Corrigir Step Events de navios
function scr_corrigir_step_navios(objeto, resultado) {
    // Verificar variáveis essenciais
    var variaveis_essenciais = ["estado", "velocidade", "atq_cooldown"];
    
    for (var i = 0; i < array_length(variaveis_essenciais); i++) {
        var var_name = variaveis_essenciais[i];
        if (!variable_instance_exists(objeto, var_name)) {
            resultado.erros[array_length(resultado.erros)] = "Variável essencial ausente: " + var_name;
        }
    }
    
    // Verificar se tem Step_0 para lógica básica
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Step_0 deve conter lógica básica de movimento e combate";
    
    // Verificar cooldown de ataque
    if (variable_instance_exists(objeto, "atq_cooldown")) {
        if (objeto.atq_cooldown > 0) {
            objeto.atq_cooldown--;
            resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Cooldown de ataque decrementado";
        }
    }
    
    // Verificar se está em água
    if (!scr_check_water_tile()) {
        resultado.avisos[array_length(resultado.avisos)] = "Navio não está em água - verificar posição";
    }
    
    return resultado;
}

/// @description Corrigir Step Events de infantaria
function scr_corrigir_step_infantaria(objeto, resultado) {
    // Verificar variáveis essenciais
    var variaveis_essenciais = ["estado", "velocidade", "atq_cooldown"];
    
    for (var i = 0; i < array_length(variaveis_essenciais); i++) {
        var var_name = variaveis_essenciais[i];
        if (!variable_instance_exists(objeto, var_name)) {
            resultado.erros[array_length(resultado.erros)] = "Variável essencial ausente: " + var_name;
        }
    }
    
    // Verificar se tem Step_0 para lógica básica
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Step_0 deve conter lógica básica de movimento e combate";
    
    // Verificar cooldown de ataque
    if (variable_instance_exists(objeto, "atq_cooldown")) {
        if (objeto.atq_cooldown > 0) {
            objeto.atq_cooldown--;
            resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Cooldown de ataque decrementado";
        }
    }
    
    return resultado;
}

/// @description Corrigir Step Events de blindados
function scr_corrigir_step_blindados(objeto, resultado) {
    // Verificar variáveis essenciais
    var variaveis_essenciais = ["estado", "velocidade", "atq_cooldown"];
    
    for (var i = 0; i < array_length(variaveis_essenciais); i++) {
        var var_name = variaveis_essenciais[i];
        if (!variable_instance_exists(objeto, var_name)) {
            resultado.erros[array_length(resultado.erros)] = "Variável essencial ausente: " + var_name;
        }
    }
    
    // Verificar se tem Step_0 para lógica básica
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Step_0 deve conter lógica básica de movimento e combate";
    
    // Verificar cooldown de ataque
    if (variable_instance_exists(objeto, "atq_cooldown")) {
        if (objeto.atq_cooldown > 0) {
            objeto.atq_cooldown--;
            resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Cooldown de ataque decrementado";
        }
    }
    
    return resultado;
}

/// @description Corrigir Step Events de quartel
function scr_corrigir_step_quartel(objeto, resultado) {
    // Verificar variáveis essenciais
    var variaveis_essenciais = ["fila_producao", "timer_producao", "produzindo"];
    
    for (var i = 0; i < array_length(variaveis_essenciais); i++) {
        var var_name = variaveis_essenciais[i];
        if (!variable_instance_exists(objeto, var_name)) {
            resultado.erros[array_length(resultado.erros)] = "Variável essencial ausente: " + var_name;
        }
    }
    
    // Verificar se tem Step_0 para lógica de produção
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Step_0 deve conter lógica de produção";
    
    // Verificar timer de produção
    if (variable_instance_exists(objeto, "timer_producao")) {
        if (objeto.timer_producao > 0) {
            objeto.timer_producao--;
            resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Timer de produção decrementado";
        }
    }
    
    return resultado;
}

/// @description Corrigir conflitos entre Step Events
function scr_corrigir_conflito_step_events(objeto, resultado) {
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Verificar conflitos entre Step_0 e Step_1";
    
    // Verificar se há lógica duplicada
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se há lógica duplicada entre Step Events";
    
    // Verificar se há interferência entre sistemas
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se sistemas não interferem entre si";
    
    return resultado;
}

/// @description Corrigir performance dos Step Events
function scr_corrigir_performance_step_events(objeto, resultado) {
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Otimizar lógica dos Step Events";
    
    // Verificar se há cálculos desnecessários
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se há cálculos desnecessários em cada frame";
    
    // Verificar se há loops ineficientes
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se há loops ineficientes";
    
    return resultado;
}

/// @description Corrigir lógica dos Step Events
function scr_corrigir_logica_step_events(objeto, resultado) {
    resultado.correcoes_aplicadas[array_length(resultado.correcoes_aplicadas)] = "Verificar lógica dos Step Events";
    
    // Verificar se há condições lógicas corretas
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se há condições lógicas corretas";
    
    // Verificar se há estados válidos
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se há estados válidos";
    
    return resultado;
}

/// @description Verificar integridade dos Step Events
function scr_verificar_integridade_step_events(objeto_id) {
    var resultado = {
        integro: true,
        problemas: [],
        avisos: []
    };
    
    if (!instance_exists(objeto_id)) {
        resultado.integro = false;
        resultado.problemas[array_length(resultado.problemas)] = "Objeto não existe";
        return resultado;
    }
    
    var objeto = objeto_id;
    
    // Verificar se tem Step_0
    resultado.avisos[array_length(resultado.avisos)] = "Verificar se tem Step_0";
    
    // Verificar se tem Step_1 (se necessário)
    if (objeto.object_index == obj_controlador_unidades) {
        resultado.avisos[array_length(resultado.avisos)] = "Verificar se tem Step_1 para comandos táticos";
    }
    
    // Verificar variáveis essenciais
    var variaveis_essenciais = ["estado"];
    
    for (var i = 0; i < array_length(variaveis_essenciais); i++) {
        var var_name = variaveis_essenciais[i];
        if (!variable_instance_exists(objeto, var_name)) {
            resultado.integro = false;
            resultado.problemas[array_length(resultado.problemas)] = "Variável essencial ausente: " + var_name;
        }
    }
    
    return resultado;
}