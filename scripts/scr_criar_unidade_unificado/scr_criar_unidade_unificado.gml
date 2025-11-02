/// @description Criar unidade unificado - sistema centralizado de criação
/// @param {string} tipo_unidade Tipo da unidade a ser criada
/// @param {real} pos_x Posição X
/// @param {real} pos_y Posição Y
/// @param {real} nacao Nação proprietária (opcional)
/// @param {struct} propriedades Propriedades adicionais (opcional)
/// @return {Id.Instance} ID da unidade criada ou -1 se falhou

function scr_criar_unidade_unificado(tipo_unidade, pos_x, pos_y, nacao = 1, propriedades = {}) {
    scr_debug_log("CRIAR UNIDADE UNIFICADO", "Iniciando criação: " + tipo_unidade);
    
    // Determinar objeto baseado no tipo
    var objeto_tipo = scr_obter_objeto_por_tipo(tipo_unidade);
    if (objeto_tipo == -1) {
        scr_debug_log("CRIAR UNIDADE UNIFICADO", "Erro: Tipo de unidade não reconhecido: " + tipo_unidade);
        return -1;
    }
    
    // Verificar se a posição é válida
    if (!scr_verificar_posicao_unidade(tipo_unidade, pos_x, pos_y)) {
        scr_debug_log("CRIAR UNIDADE UNIFICADO", "Erro: Posição inválida para o tipo de unidade");
        return -1;
    }
    
    // Criar unidade com segurança
    var unidade_id = scr_criar_objeto_seguro(objeto_tipo, pos_x, pos_y, "Instances", propriedades);
    if (unidade_id == -1) {
        scr_debug_log("CRIAR UNIDADE UNIFICADO", "Erro: Falha ao criar unidade");
        return -1;
    }
    
    // Configurar unidade
    scr_configurar_unidade_criada(unidade_id, tipo_unidade, nacao);
    
    scr_debug_log("CRIAR UNIDADE UNIFICADO", "Unidade criada com sucesso: " + tipo_unidade + " ID: " + string(unidade_id));
    return unidade_id;
}

/// @description Obter objeto baseado no tipo de unidade
function scr_obter_objeto_por_tipo(tipo_unidade) {
    switch (tipo_unidade) {
        // Unidades Navais
        case "lancha_patrulha":
            return obj_lancha_patrulha;
        case "fragata":
            return obj_fragata;
        case "destroyer":
            return obj_destroyer;
        case "submarino":
            return obj_submarino;
        case "porta_avioes":
            return obj_RonaldReagan;
        
        // Unidades Terrestres
        case "soldado":
            return obj_soldado;
        case "soldado_antiaereo":
            return obj_soldado_antiaereo;
        case "blindado":
            return obj_blindado;
        case "tanque":
            return obj_tanque;
        
        // Unidades Aéreas
        case "caca":
            return obj_caca;
        case "bombardeiro":
            return obj_bombardeiro;
        case "helicoptero":
            return obj_helicoptero;
        
        // Estruturas
        case "quartel":
            return obj_quartel;
        case "quartel_marinha":
            return obj_quartel_marinha;
        case "aeroporto":
            return obj_aeroporto;
        case "centro_pesquisa":
            return obj_centro_pesquisa;
        
        default:
            return -1;
    }
}

/// @description Verificar se a posição é válida para o tipo de unidade
function scr_verificar_posicao_unidade(tipo_unidade, pos_x, pos_y) {
    // Verificar limites da sala
    if (pos_x < 0 || pos_y < 0 || pos_x >= room_width || pos_y >= room_height) {
        return false;
    }
    
    // Verificar se navios precisam estar em água
    switch (tipo_unidade) {
        case "lancha_patrulha":
        case "fragata":
        case "destroyer":
        case "submarino":
        case "porta_avioes":
            return scr_check_water_tile(pos_x, pos_y);
        default:
            return true;
    }
}

/// @description Configurar unidade recém-criada
function scr_configurar_unidade_criada(unidade_id, tipo_unidade, nacao) {
    if (!instance_exists(unidade_id)) {
        return;
    }
    
    var unidade = unidade_id;
    
    // Configurações básicas
    unidade.nacao_proprietaria = nacao;
    unidade.estado = "parado";
    unidade.experiencia = 0;
    unidade.nivel = 1;
    
    // Configurações específicas por tipo
    switch (tipo_unidade) {
        // Unidades Navais
        case "lancha_patrulha":
            scr_configurar_lancha_patrulha(unidade);
            break;
        case "fragata":
            scr_configurar_fragata(unidade);
            break;
        case "destroyer":
            scr_configurar_destroyer(unidade);
            break;
        case "submarino":
            scr_configurar_submarino(unidade);
            break;
        case "porta_avioes":
            scr_configurar_porta_avioes(unidade);
            break;
        
        // Unidades Terrestres
        case "soldado":
            scr_configurar_soldado(unidade);
            break;
        case "soldado_antiaereo":
            scr_configurar_soldado_antiaereo(unidade);
            break;
        case "blindado":
            scr_configurar_blindado(unidade);
            break;
        case "tanque":
            scr_configurar_tanque(unidade);
            break;
        
        // Unidades Aéreas
        case "caca":
            scr_configurar_caca(unidade);
            break;
        case "bombardeiro":
            scr_configurar_bombardeiro(unidade);
            break;
        case "helicoptero":
            scr_configurar_helicoptero(unidade);
            break;
        
        // Estruturas
        case "quartel":
            scr_configurar_quartel(unidade);
            break;
        case "quartel_marinha":
            scr_configurar_quartel_marinha(unidade);
            break;
        case "aeroporto":
            scr_configurar_aeroporto(unidade);
            break;
        case "centro_pesquisa":
            scr_configurar_centro_pesquisa(unidade);
            break;
    }
}

/// @description Configurar Caça
function scr_configurar_caca(unidade) {
    unidade.hp_atual = 80;
    unidade.hp_max = 80;
    unidade.velocidade = 3.0;
    unidade.dano = 30;
    unidade.alcance = 500;
    unidade.atq_cooldown = 0;
    unidade.atq_rate = 90;
    unidade.raio_de_visao = 600;
}

/// @description Configurar Bombardeiro
function scr_configurar_bombardeiro(unidade) {
    unidade.hp_atual = 120;
    unidade.hp_max = 120;
    unidade.velocidade = 2.5;
    unidade.dano = 50;
    unidade.alcance = 600;
    unidade.atq_cooldown = 0;
    unidade.atq_rate = 120;
    unidade.raio_de_visao = 700;
}

/// @description Configurar Helicóptero
function scr_configurar_helicoptero(unidade) {
    unidade.hp_atual = 100;
    unidade.hp_max = 100;
    unidade.velocidade = 2.8;
    unidade.dano = 25;
    unidade.alcance = 400;
    unidade.atq_cooldown = 0;
    unidade.atq_rate = 75;
    unidade.raio_de_visao = 500;
}

/// @description Criar unidade em posição aleatória válida
function scr_criar_unidade_posicao_aleatoria(tipo_unidade, nacao = 1) {
    var pos_x, pos_y;
    var tentativas = 0;
    var max_tentativas = 100;
    
    for (var i = 0; i < max_tentativas; i++) {
        pos_x = random(room_width);
        pos_y = random(room_height);
        tentativas++;
        if (scr_verificar_posicao_unidade(tipo_unidade, pos_x, pos_y)) {
            break;
        }
    }
    
    if (tentativas >= max_tentativas) {
        scr_debug_log("CRIAR UNIDADE UNIFICADO", "Erro: Não foi possível encontrar posição válida");
        return -1;
    }
    
    return scr_criar_unidade_unificado(tipo_unidade, pos_x, pos_y, nacao);
}

/// @description Criar múltiplas unidades
function scr_criar_multiplas_unidades(tipo_unidade, quantidade, pos_x, pos_y, nacao = 1) {
    var unidades_criadas = [];
    var espacamento = 50; // Espaçamento entre unidades
    
    for (var i = 0; i < quantidade; i++) {
        var offset_x = (i % 5) * espacamento;
        var offset_y = floor(i / 5) * espacamento;
        
        var unidade_id = scr_criar_unidade_unificado(tipo_unidade, pos_x + offset_x, pos_y + offset_y, nacao);
        
        if (unidade_id != -1) {
            unidades_criadas[array_length(unidades_criadas)] = unidade_id;
        }
    }
    
    scr_debug_log("CRIAR UNIDADE UNIFICADO", "Criadas " + string(array_length(unidades_criadas)) + " unidades de " + string(quantidade) + " solicitadas");
    return unidades_criadas;
}

/// @description Obter lista de tipos de unidades disponíveis
function scr_obter_tipos_unidades_disponiveis() {
    return [
        // Unidades Navais
        "lancha_patrulha", "fragata", "destroyer", "submarino", "porta_avioes",
        
        // Unidades Terrestres
        "soldado", "soldado_antiaereo", "blindado", "tanque",
        
        // Unidades Aéreas
        "caca", "bombardeiro", "helicoptero",
        
        // Estruturas
        "quartel", "quartel_marinha", "aeroporto", "centro_pesquisa"
    ];
}

/// @description Verificar se tipo de unidade é válido
function scr_verificar_tipo_unidade_valido(tipo_unidade) {
    var tipos_validos = scr_obter_tipos_unidades_disponiveis();
    
    for (var i = 0; i < array_length(tipos_validos); i++) {
        if (tipos_validos[i] == tipo_unidade) {
            return true;
        }
    }
    
    return false;
}