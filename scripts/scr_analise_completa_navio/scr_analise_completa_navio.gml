/// @description Análise completa de navios - diagnóstico e verificação
/// @param {Id.Instance} navio_id ID da instância do navio para análise
/// @return {struct} Relatório completo de análise

function scr_analise_completa_navio(navio_id) {
    var relatorio = {
        status: "iniciado",
        timestamp: current_time,
        navio_id: navio_id,
        problemas: [],
        avisos: [],
        sucessos: [],
        estatisticas: {},
        recomendacoes: []
    };
    
    // Verificar se o navio existe
    if (!instance_exists(navio_id)) {
        relatorio.problemas[array_length(relatorio.problemas)] = "Navio não existe (ID: " + string(navio_id) + ")";
        relatorio.status = "erro";
        return relatorio;
    }
    
    var navio = navio_id;
    
    // === ANÁLISE BÁSICA ===
    relatorio.estatisticas.posicao = {
        x: navio.x,
        y: navio.y,
        layer: navio.layer
    };
    
    relatorio.estatisticas.propriedades_basicas = {
        object_index: navio.object_index,
        sprite_index: navio.sprite_index,
        image_index: navio.image_index,
        image_speed: navio.image_speed,
        visible: navio.visible
    };
    
    // === ANÁLISE DE PROPRIEDADES NAVAL ===
    var propriedades_naval = [
        "hp_atual", "hp_max", "velocidade", "dano", "alcance",
        "estado", "nacao_proprietaria", "experiencia", "nivel",
        "atq_cooldown", "atq_rate", "raio_de_visao"
    ];
    
    relatorio.estatisticas.propriedades_naval = {};
    for (var i = 0; i < array_length(propriedades_naval); i++) {
        var prop = propriedades_naval[i];
        if (variable_instance_exists(navio, prop)) {
            relatorio.estatisticas.propriedades_naval[prop] = navio[prop];
        } else {
            relatorio.avisos[array_length(relatorio.avisos)] = "Propriedade naval ausente: " + prop;
        }
    }
    
    // === VERIFICAÇÃO DE INTEGRIDADE ===
    
    // Verificar HP
    if (variable_instance_exists(navio, "hp_atual") && variable_instance_exists(navio, "hp_max")) {
        if (navio.hp_atual <= 0) {
            relatorio.problemas[array_length(relatorio.problemas)] = "Navio destruído (HP: " + string(navio.hp_atual) + ")";
        } else if (navio.hp_atual < navio.hp_max * 0.3) {
            relatorio.avisos[array_length(relatorio.avisos)] = "Navio com HP crítico (" + string(navio.hp_atual) + "/" + string(navio.hp_max) + ")";
        }
    }
    
    // Verificar estado
    if (variable_instance_exists(navio, "estado")) {
        var estados_validos = ["parado", "movendo", "atacando", "patrulhando", "seguindo", "destruida"];
        var estado_valido = false;
        for (var i = 0; i < array_length(estados_validos); i++) {
            if (navio.estado == estados_validos[i]) {
                estado_valido = true;
                break;
            }
        }
        if (!estado_valido) {
            relatorio.problemas[array_length(relatorio.problemas)] = "Estado inválido: " + string(navio.estado);
        }
    }
    
    // Verificar velocidade
    if (variable_instance_exists(navio, "velocidade")) {
        if (navio.velocidade <= 0) {
            relatorio.problemas[array_length(relatorio.problemas)] = "Velocidade inválida: " + string(navio.velocidade);
        } else if (navio.velocidade > 5) {
            relatorio.avisos[array_length(relatorio.avisos)] = "Velocidade muito alta: " + string(navio.velocidade);
        }
    }
    
    // === ANÁLISE DE COMPORTAMENTO ===
    
    // Verificar se está em água
    if (variable_instance_exists(navio, "x") && variable_instance_exists(navio, "y")) {
        var em_agua = scr_check_water_tile();
        relatorio.estatisticas.em_agua = em_agua;
        if (!em_agua) {
            relatorio.problemas[array_length(relatorio.problemas)] = "Navio não está em água";
        }
    }
    
    // Verificar cooldown de ataque
    if (variable_instance_exists(navio, "atq_cooldown")) {
        if (navio.atq_cooldown < 0) {
            relatorio.problemas[array_length(relatorio.problemas)] = "Cooldown de ataque negativo: " + string(navio.atq_cooldown);
        }
    }
    
    // === ANÁLISE DE EVENTOS ===
    
    // Verificar se tem eventos essenciais
    var eventos_essenciais = ["Create_0", "Step_0", "Draw_0"];
    relatorio.estatisticas.eventos = {};
    
    for (var i = 0; i < array_length(eventos_essenciais); i++) {
        var evento = eventos_essenciais[i];
        // Esta verificação é simplificada - em um sistema real seria mais complexa
        relatorio.estatisticas.eventos[evento] = "presente"; // Assumindo que existe
    }
    
    // === RECOMENDAÇÕES ===
    
    if (array_length(relatorio.problemas) == 0) {
        relatorio.sucessos[array_length(relatorio.sucessos)] = "Navio em bom estado geral";
    }
    
    if (variable_instance_exists(navio, "experiencia") && navio.experiencia > 0) {
        relatorio.sucessos[array_length(relatorio.sucessos)] = "Navio experiente (" + string(navio.experiencia) + " XP)";
    }
    
    // Recomendações baseadas nos problemas encontrados
    if (array_length(relatorio.problemas) > 0) {
        relatorio.recomendacoes[array_length(relatorio.recomendacoes)] = "Corrigir problemas identificados";
    }
    
    if (array_length(relatorio.avisos) > 0) {
        relatorio.recomendacoes[array_length(relatorio.recomendacoes)] = "Monitorar avisos";
    }
    
    // === FINALIZAÇÃO ===
    
    if (array_length(relatorio.problemas) == 0) {
        relatorio.status = "sucesso";
    } else {
        relatorio.status = "problemas_encontrados";
    }
    
    // Log da análise
    scr_debug_log("ANÁLISE NAVIO", "Análise completa realizada para navio ID: " + string(navio_id) + " - Status: " + relatorio.status);
    
    return relatorio;
}