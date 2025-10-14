/// @description Construir navio - sistema de criação naval
/// @param {Id.Instance} quartel_id ID do quartel da marinha
/// @param {string} tipo_navio Tipo do navio a ser construído
/// @param {real} pos_x Posição X de spawn
/// @param {real} pos_y Posição Y de spawn
/// @return {real} ID do navio criado ou -1 se falhou

function scr_construir_navio(quartel_id, tipo_navio, pos_x, pos_y) {
    scr_debug_log("CONSTRUIR NAVIO", "Iniciando construção: " + tipo_navio);
    
    // Verificar se o quartel existe
    if (!instance_exists(quartel_id)) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Quartel não existe");
        return -1;
    }
    
    var quartel = quartel_id;
    
    // Verificar se é um quartel da marinha
    if (quartel.object_index != obj_quartel_marinha) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Não é um quartel da marinha");
        return -1;
    }
    
    // Verificar se está produzindo
    if (variable_instance_exists(quartel, "produzindo") && quartel.produzindo) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Quartel já está produzindo");
        return -1;
    }
    
    // Determinar objeto do navio
    var objeto_navio = scr_obter_objeto_navio(tipo_navio);
    if (objeto_navio == -1) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Tipo de navio não reconhecido: " + tipo_navio);
        return -1;
    }
    
    // Verificar recursos
    var custo = scr_obter_custo_navio(tipo_navio);
    if (!scr_verificar_recursos(custo)) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Recursos insuficientes");
        return -1;
    }
    
    // Verificar se a posição é válida (em água)
    if (!scr_check_water_tile()) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Posição não está em água");
        return -1;
    }
    
    // Criar navio
    var navio_id = scr_criar_navio_seguro(objeto_navio, pos_x, pos_y);
    if (navio_id == -1) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Falha ao criar navio");
        return -1;
    }
    
    // Aplicar custos
    scr_aplicar_custos(custo);
    
    // Configurar navio
    scr_configurar_navio_criado(navio_id, tipo_navio);
    
    scr_debug_log("CONSTRUIR NAVIO", "Navio criado com sucesso: " + tipo_navio + " ID: " + string(navio_id));
    return navio_id;
}

/// @description Obter objeto do navio baseado no tipo
function scr_obter_objeto_navio(tipo_navio) {
    switch (tipo_navio) {
        case "lancha_patrulha":
            return obj_lancha_patrulha;
        case "fragata":
            return obj_fragata;
        case "destroyer":
            return obj_destroyer;
        case "submarino":
            return obj_submarino;
        case "porta_avioes":
            return obj_porta_avioes;
        default:
            return -1;
    }
}

/// @description Obter custo do navio
function scr_obter_custo_navio(tipo_navio) {
    switch (tipo_navio) {
        case "lancha_patrulha":
            return {
                dinheiro: 200,
                minerio: 100,
                populacao: 2,
                tempo: 240
            };
        case "fragata":
            return {
                dinheiro: 400,
                minerio: 200,
                populacao: 3,
                tempo: 480
            };
        case "destroyer":
            return {
                dinheiro: 800,
                minerio: 400,
                populacao: 5,
                tempo: 720
            };
        case "submarino":
            return {
                dinheiro: 1000,
                minerio: 500,
                populacao: 4,
                tempo: 900
            };
        case "porta_avioes":
            return {
                dinheiro: 2000,
                minerio: 1000,
                populacao: 8,
                tempo: 1200
            };
        default:
            return {
                dinheiro: 0,
                minerio: 0,
                populacao: 0,
                tempo: 0
            };
    }
}

/// @description Verificar se há recursos suficientes
function scr_verificar_recursos(custo) {
    if (!variable_global_exists("global.recursos")) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Sistema de recursos não inicializado");
        return false;
    }
    
    var recursos = global.recursos;
    
    if (recursos.dinheiro < custo.dinheiro) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Dinheiro insuficiente (" + string(recursos.dinheiro) + " < " + string(custo.dinheiro) + ")");
        return false;
    }
    
    if (recursos.minerio < custo.minerio) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Minério insuficiente (" + string(recursos.minerio) + " < " + string(custo.minerio) + ")");
        return false;
    }
    
    if (recursos.populacao_atual + custo.populacao > recursos.populacao_maxima) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: População máxima excedida");
        return false;
    }
    
    return true;
}

/// @description Aplicar custos de construção
function scr_aplicar_custos(custo) {
    if (!variable_global_exists("global.recursos")) {
        return;
    }
    
    var recursos = global.recursos;
    
    recursos.dinheiro -= custo.dinheiro;
    recursos.minerio -= custo.minerio;
    recursos.populacao_atual += custo.populacao;
    
    scr_debug_log("CONSTRUIR NAVIO", "Custos aplicados - Dinheiro: " + string(custo.dinheiro) + ", Minério: " + string(custo.minerio) + ", População: " + string(custo.populacao));
}

/// @description Criar navio com segurança
function scr_criar_navio_seguro(objeto_navio, pos_x, pos_y) {
    // Verificar se o objeto existe
    if (!asset_exists(objeto_navio)) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Objeto não existe: " + string(objeto_navio));
        return -1;
    }
    
    // Criar instância
    var navio_id = instance_create_layer(pos_x, pos_y, "Instances", objeto_navio);
    
    if (!instance_exists(navio_id)) {
        scr_debug_log("CONSTRUIR NAVIO", "Erro: Falha ao criar instância");
        return -1;
    }
    
    return navio_id;
}

/// @description Configurar navio recém-criado
function scr_configurar_navio_criado(navio_id, tipo_navio) {
    if (!instance_exists(navio_id)) {
        return;
    }
    
    var navio = navio_id;
    
    // Configurações básicas
    navio.nacao_proprietaria = 1; // Jogador
    navio.estado = "parado";
    navio.experiencia = 0;
    navio.nivel = 1;
    navio.atq_cooldown = 0;
    
    // Configurações específicas por tipo
    switch (tipo_navio) {
        case "lancha_patrulha":
            navio.hp_atual = 150;
            navio.hp_max = 150;
            navio.velocidade = 2.0;
            navio.dano = 25;
            navio.alcance = 400;
            navio.atq_rate = 60;
            navio.raio_de_visao = 500;
            break;
        case "fragata":
            navio.hp_atual = 200;
            navio.hp_max = 200;
            navio.velocidade = 1.8;
            navio.dano = 35;
            navio.alcance = 450;
            navio.atq_rate = 75;
            navio.raio_de_visao = 550;
            break;
        case "destroyer":
            navio.hp_atual = 300;
            navio.hp_max = 300;
            navio.velocidade = 1.5;
            navio.dano = 50;
            navio.alcance = 500;
            navio.atq_rate = 90;
            navio.raio_de_visao = 600;
            break;
        case "submarino":
            navio.hp_atual = 180;
            navio.hp_max = 180;
            navio.velocidade = 1.2;
            navio.dano = 60;
            navio.alcance = 500;
            navio.atq_rate = 120;
            navio.raio_de_visao = 400;
            break;
        case "porta_avioes":
            navio.hp_atual = 500;
            navio.hp_max = 500;
            navio.velocidade = 1.0;
            navio.dano = 40;
            navio.alcance = 600;
            navio.atq_rate = 150;
            navio.raio_de_visao = 700;
            break;
    }
    
    scr_debug_log("CONSTRUIR NAVIO", "Navio configurado: " + tipo_navio + " - HP: " + string(navio.hp_atual) + "/" + string(navio.hp_max));
}