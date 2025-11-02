/// @description Criar objeto com segurança - sistema de criação robusto
/// @param {real} objeto_tipo Tipo do objeto a ser criado
/// @param {real} pos_x Posição X
/// @param {real} pos_y Posição Y
/// @param {string} layer Camada (opcional)
/// @param {struct} propriedades Propriedades adicionais (opcional)
/// @return {Id.Instance} ID do objeto criado ou -1 se falhou

function scr_criar_objeto_seguro(objeto_tipo, pos_x, pos_y, layer = "Instances", propriedades = {}) {
    scr_debug_log("CRIAR OBJETO SEGURO", "Iniciando criação: " + string(objeto_tipo));
    
    // Verificar se o objeto existe
    if (!asset_exists(objeto_tipo)) {
        scr_debug_log("CRIAR OBJETO SEGURO", "Erro: Objeto não existe: " + string(objeto_tipo));
        return -1;
    }
    
    // Verificar se a posição é válida
    if (!scr_verificar_posicao_valida(objeto_tipo, pos_x, pos_y)) {
        scr_debug_log("CRIAR OBJETO SEGURO", "Erro: Posição inválida para o tipo de objeto");
        return -1;
    }
    
    // Verificar se a camada existe
    if (!layer_exists(layer)) {
        scr_debug_log("CRIAR OBJETO SEGURO", "Aviso: Camada não existe, usando padrão");
        layer = "Instances";
    }
    
    // Criar instância
    var objeto_id = instance_create_layer(pos_x, pos_y, layer, objeto_tipo);
    
    if (!instance_exists(objeto_id)) {
        scr_debug_log("CRIAR OBJETO SEGURO", "Erro: Falha ao criar instância");
        return -1;
    }
    
    // Aplicar propriedades adicionais
    if (is_struct(propriedades) && struct_size(propriedades) > 0) {
        scr_aplicar_propriedades_objeto(objeto_id, propriedades);
    }
    
    // Configurar objeto baseado no tipo
    scr_configurar_objeto_criado(objeto_id, objeto_tipo);
    
    scr_debug_log("CRIAR OBJETO SEGURO", "Objeto criado com sucesso: " + string(objeto_tipo) + " ID: " + string(objeto_id));
    return objeto_id;
}

/// @description Verificar se a posição é válida para o tipo de objeto
function scr_verificar_posicao_valida(objeto_tipo, pos_x, pos_y) {
    // Verificar limites da sala
    if (pos_x < 0 || pos_y < 0 || pos_x >= room_width || pos_y >= room_height) {
        return false;
    }
    
    // Verificar se navios precisam estar em água
    switch (objeto_tipo) {
        case obj_lancha_patrulha:
        case obj_fragata:
        case obj_destroyer:
        case obj_submarino:
        case obj_RonaldReagan:
            return scr_check_water_tile(pos_x, pos_y);
        default:
            return true;
    }
}

/// @description Aplicar propriedades ao objeto
function scr_aplicar_propriedades_objeto(objeto_id, propriedades) {
    if (!instance_exists(objeto_id)) {
        return;
    }
    
    var objeto = objeto_id;
    
    var key = struct_get_names(propriedades);
    for (var i = 0; i < array_length(key); i++) {
        var chave = key[i];
        var valor = propriedades[$chave];
        
        // Aplicar propriedade com segurança
        try {
            objeto[$chave] = valor;
            scr_debug_log("CRIAR OBJETO SEGURO", "Propriedade aplicada: " + chave + " = " + string(valor));
        } catch (e) {
            scr_debug_log("CRIAR OBJETO SEGURO", "Erro ao aplicar propriedade: " + chave);
        }
    }
}

/// @description Configurar objeto recém-criado
function scr_configurar_objeto_criado(objeto_id, objeto_tipo) {
    if (!instance_exists(objeto_id)) {
        return;
    }
    
    var objeto = objeto_id;
    
    // Configurações básicas
    objeto.nacao_proprietaria = 1; // Jogador
    objeto.estado = "parado";
    objeto.experiencia = 0;
    objeto.nivel = 1;
    
    // Configurações específicas por tipo
    switch (objeto_tipo) {
        case obj_lancha_patrulha:
            scr_configurar_lancha_patrulha(objeto);
            break;
        case obj_fragata:
            scr_configurar_fragata(objeto);
            break;
        case obj_destroyer:
            scr_configurar_destroyer(objeto);
            break;
        case obj_submarino:
            scr_configurar_submarino(objeto);
            break;
        case obj_RonaldReagan:
            scr_configurar_porta_avioes(objeto);
            break;
        case obj_soldado:
            scr_configurar_soldado(objeto);
            break;
        case obj_soldado_antiaereo:
            scr_configurar_soldado_antiaereo(objeto);
            break;
        case obj_blindado:
            scr_configurar_blindado(objeto);
            break;
        case obj_tanque:
            scr_configurar_tanque(objeto);
            break;
        case obj_quartel:
            scr_configurar_quartel(objeto);
            break;
        case obj_quartel_marinha:
            scr_configurar_quartel_marinha(objeto);
            break;
        case obj_aeroporto:
            scr_configurar_aeroporto(objeto);
            break;
        case obj_centro_pesquisa:
            scr_configurar_centro_pesquisa(objeto);
            break;
    }
}

/// @description Configurar Lancha Patrulha
function scr_configurar_lancha_patrulha(objeto) {
    objeto.hp_atual = 150;
    objeto.hp_max = 150;
    objeto.velocidade = 2.0;
    objeto.dano = 25;
    objeto.alcance = 400;
    objeto.atq_cooldown = 0;
    objeto.atq_rate = 60;
    objeto.raio_de_visao = 500;
}

/// @description Configurar Fragata
function scr_configurar_fragata(objeto) {
    objeto.hp_atual = 200;
    objeto.hp_max = 200;
    objeto.velocidade = 1.8;
    objeto.dano = 35;
    objeto.alcance = 450;
    objeto.atq_cooldown = 0;
    objeto.atq_rate = 75;
    objeto.raio_de_visao = 550;
}

/// @description Configurar Destroyer
function scr_configurar_destroyer(objeto) {
    objeto.hp_atual = 300;
    objeto.hp_max = 300;
    objeto.velocidade = 1.5;
    objeto.dano = 50;
    objeto.alcance = 500;
    objeto.atq_cooldown = 0;
    objeto.atq_rate = 90;
    objeto.raio_de_visao = 600;
}

/// @description Configurar Submarino
function scr_configurar_submarino(objeto) {
    objeto.hp_atual = 180;
    objeto.hp_max = 180;
    objeto.velocidade = 1.2;
    objeto.dano = 60;
    objeto.alcance = 500;
    objeto.atq_cooldown = 0;
    objeto.atq_rate = 120;
    objeto.raio_de_visao = 400;
}

/// @description Configurar Porta-aviões
function scr_configurar_porta_avioes(objeto) {
    objeto.hp_atual = 500;
    objeto.hp_max = 500;
    objeto.velocidade = 1.0;
    objeto.dano = 40;
    objeto.alcance = 600;
    objeto.atq_cooldown = 0;
    objeto.atq_rate = 150;
    objeto.raio_de_visao = 700;
}

/// @description Configurar Soldado
function scr_configurar_soldado(objeto) {
    objeto.hp_atual = 100;
    objeto.hp_max = 100;
    objeto.velocidade = 1.5;
    objeto.dano = 20;
    objeto.alcance = 300;
    objeto.atq_cooldown = 0;
    objeto.atq_rate = 45;
    objeto.raio_de_visao = 400;
}

/// @description Configurar Soldado Anti-aéreo
function scr_configurar_soldado_antiaereo(objeto) {
    objeto.hp_atual = 120;
    objeto.hp_max = 120;
    objeto.velocidade = 1.3;
    objeto.dano = 25;
    objeto.alcance = 400;
    objeto.atq_cooldown = 0;
    objeto.atq_rate = 60;
    objeto.raio_de_visao = 500;
}

/// @description Configurar Blindado
function scr_configurar_blindado(objeto) {
    objeto.hp_atual = 200;
    objeto.hp_max = 200;
    objeto.velocidade = 1.2;
    objeto.dano = 40;
    objeto.alcance = 350;
    objeto.atq_cooldown = 0;
    objeto.atq_rate = 75;
    objeto.raio_de_visao = 450;
}

/// @description Configurar Tanque
function scr_configurar_tanque(objeto) {
    objeto.hp_atual = 300;
    objeto.hp_max = 300;
    objeto.velocidade = 1.0;
    objeto.dano = 60;
    objeto.alcance = 400;
    objeto.atq_cooldown = 0;
    objeto.atq_rate = 90;
    objeto.raio_de_visao = 500;
}

/// @description Configurar Quartel
function scr_configurar_quartel(objeto) {
    objeto.hp_atual = 200;
    objeto.hp_max = 200;
    objeto.estado = "ativo";
    objeto.fila_producao = ds_queue_create();
    objeto.timer_producao = 0;
    objeto.produzindo = false;
    objeto.unidades_produzidas = 0;
    objeto.unidades_disponiveis = ds_list_create();
}

/// @description Configurar Quartel da Marinha
function scr_configurar_quartel_marinha(objeto) {
    objeto.hp_atual = 250;
    objeto.hp_max = 250;
    objeto.estado = "ativo";
    objeto.fila_producao = ds_queue_create();
    objeto.timer_producao = 0;
    objeto.produzindo = false;
    objeto.unidades_produzidas = 0;
    objeto.unidades_disponiveis = ds_list_create();
}

/// @description Configurar Aeroporto
function scr_configurar_aeroporto(objeto) {
    objeto.hp_atual = 300;
    objeto.hp_max = 300;
    objeto.estado = "ativo";
    objeto.fila_producao = ds_queue_create();
    objeto.timer_producao = 0;
    objeto.produzindo = false;
    objeto.unidades_produzidas = 0;
    objeto.unidades_disponiveis = ds_list_create();
}

/// @description Configurar Centro de Pesquisa
function scr_configurar_centro_pesquisa(objeto) {
    objeto.hp_atual = 150;
    objeto.hp_max = 150;
    objeto.estado = "ativo";
    objeto.pesquisas_disponiveis = ds_list_create();
    objeto.pesquisa_atual = -1;
    objeto.timer_pesquisa = 0;
    objeto.pesquisando = false;
}