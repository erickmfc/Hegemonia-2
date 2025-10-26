/// @description Inicialização Porta-Aviões
// ===============================================
// HEGEMONIA GLOBAL - PORTA-AVIÕES (HERDA DE NAVIO_BASE)
// Transporte de Unidades Aéreas, Terrestres e Marinhas
// ===============================================

// === CONFIGURAÇÕES BÁSICAS (ANTES DA HERANÇA) ===
nome_unidade = "Ronald Reagan";

// === CONFIGURAÇÕES DE COMBATE ===
hp_atual = 4000; // MAIOR VIDA ATÉ AGORA
hp_max = 4000;
velocidade_movimento = 1.5; // Lento (é navio de transporte)
radar_alcance = 1000;
missil_alcance = 1000;
missil_max_alcance = 1000;
alcance_ataque = missil_alcance;
alcance_visao = radar_alcance;
dano_ataque = 50; // Menor dano, é navio de suporte
reload_time = 300; // 5 segundos de cooldown

// === SISTEMA DE MÍSSEIS (IGUAL CONSTELLATION) ===
pode_disparar_missil = false; // Desabilitar sistema do pai (usa sistema próprio)
missil_timer = 0;
missil_cooldown = 120; // 2 segundos entre mísseis

// === HERANÇA DO PAI (OBRIGATÓRIO) ===
// HERDAR DEPOIS de configurar hp e velocidade
event_inherited();

// === VARIÁVEIS DE MOVIMENTO (DEFINIR DEPOIS DA HERANÇA) ===
destino_x = x;
destino_y = y;
alvo_x = x;
alvo_y = y;

// === VARIÁVEIS DE COMBATE ===
estado_anterior = LanchaState.PARADO;

// === SISTEMA DE ARMAZENAMENTO DE UNIDADES ===
// Capacidades máximas
avioes_max = 35;
unidades_max = 20;
soldados_max = 100;

// Contadores atuais
avioes_count = 0;
unidades_count = 0;
soldados_count = 0;

// Listas de armazenamento
avioes_embarcados = ds_list_create();          // Lista de IDs embarcados
unidades_embarcadas = ds_list_create();
soldados_embarcados = ds_list_create();

// Aviões visíveis sobre o navio (máximo 10)
avioes_visiveis = ds_list_create();

// === SISTEMA DE DESEMBARQUE ===
desembarque_fila = ds_queue_create();
desembarque_timer = 0;
desembarque_intervalo = 150; // 3 segundos
desembarque_ativo = false;
desembarque_offset_x = 100;
desembarque_offset_y = 0;

// === SISTEMA DE ESTADO DE EMBARQUE (PADRONIZADO) ===
estado_transporte = NavioTransporteEstado.PARADO;
modo_embarque = false;
menu_carga_aberto = false;
raio_embarque = 80;                         // Raio de detecção aumentado
desembarque_offset_angulo = 0;

// === SISTEMA DE MENU DE DESEMBARQUE (COMPATIBILIDADE) ===
menu_desembarque_aberto = false;
menu_desembarque_selecionado = -1;
menu_desembarque_scroll = 0;

// === SISTEMA DE PATRULHA ===
modo_definicao_patrulha = false; // Modo de definição de rota de patrulha

// === VARIÁVEIS DE FEEDBACK ===
ultima_acao = "nenhuma";
cor_feedback = c_white;
feedback_timer = 0;

// === VALIDAÇÃO E DEBUG ===
debug_timer = 0;

// === FUNÇÕES DE EMBARQUE/DESEMBARQUE ===
eh_embarcavel = function(unidade) {
    if (!instance_exists(unidade)) return false;
    if (unidade.id == id) return false; // Não embarcar a si mesmo
    
    // Verificar se é do jogador
    if (!variable_instance_exists(unidade, "nacao_proprietaria")) return false;
    if (unidade.nacao_proprietaria != nacao_proprietaria) return false;
    
    // Verificar se é aéreo
    if (object_is_ancestor(unidade.object_index, obj_caca_f5) || 
        object_is_ancestor(unidade.object_index, obj_f6) ||
        object_is_ancestor(unidade.object_index, obj_helicoptero_militar)) return true;
    
    // Verificar se é terrestre/naval
    if (object_is_ancestor(unidade.object_index, obj_infantaria)) return true;
    if (object_is_ancestor(unidade.object_index, obj_tanque)) return true;
    if (object_is_ancestor(unidade.object_index, obj_inimigo)) return true;
    if (object_is_ancestor(unidade.object_index, obj_soldado_antiaereo)) return true;
    if (object_is_ancestor(unidade.object_index, obj_blindado_antiaereo)) return true;
    
    return false;
}

tipo_unidade = function(unidade) {
    if (object_is_ancestor(unidade.object_index, obj_caca_f5) || 
        object_is_ancestor(unidade.object_index, obj_f6) ||
        object_is_ancestor(unidade.object_index, obj_helicoptero_militar)) {
        return "aereo";
    } else if (object_is_ancestor(unidade.object_index, obj_infantaria) ||
               object_is_ancestor(unidade.object_index, obj_soldado_antiaereo)) {
        return "soldado";
    } else {
        return "unidade";
    }
}

embarcar_unidade = function(unidade) {
    var _tipo = tipo_unidade(unidade);
    var _pode_embarcar = false;
    
    // Verificar capacidade
    switch (_tipo) {
        case "aereo":
            if (avioes_count >= avioes_max) return false;
            _pode_embarcar = true;
            break;
        case "unidade":
            if (unidades_count >= unidades_max) return false;
            _pode_embarcar = true;
            break;
        case "soldado":
            if (soldados_count >= soldados_max) return false;
            _pode_embarcar = true;
            break;
    }
    
    if (!_pode_embarcar) return false;
    
    // Escolher qual lista usar
    var _lista_usar = avioes_embarcados;
    if (_tipo == "unidade") _lista_usar = unidades_embarcadas;
    else if (_tipo == "soldado") _lista_usar = soldados_embarcados;
    
    // Adicionar à lista
    ds_list_add(_lista_usar, unidade.id);
    
    // Atualizar contador
    if (_tipo == "aereo") avioes_count++;
    else if (_tipo == "unidade") unidades_count++;
    else soldados_count++;
    
    // IMPORTANTE: Apenas esconder a unidade (NÃO desativar!)
    unidade.visible = false;
    
    // NÃO usar instance_deactivate_object() porque desativa TODAS as instâncias!
    // Apenas deixar visible = false é suficiente
    
    show_debug_message("✅ " + object_get_name(unidade.object_index) + " embarcou! (A:" + 
                      string(avioes_count) + "/" + string(avioes_max) + " | " +
                      "U:" + string(unidades_count) + "/" + string(unidades_max) + " | " +
                      "S:" + string(soldados_count) + "/" + string(soldados_max) + ")");
    
    return true;
}

adicionar_fila_desembarque = function(unidade_id) {
    if (ds_queue_size(desembarque_fila) < 50) {
        ds_queue_enqueue(desembarque_fila, unidade_id);
        desembarque_ativo = true;
        return true;
    }
    return false;
}

desembarcar_proxima = function() {
    if (ds_queue_size(desembarque_fila) == 0) {
        desembarque_ativo = false;
        return;
    }
    
    var _unidade_id = ds_queue_dequeue(desembarque_fila);
    
    if (instance_exists(_unidade_id)) {
        var _unidade = _unidade_id;
        var _tipo = tipo_unidade(_unidade);
        
        // Remover das listas
        ds_list_delete_value(avioes_embarcados, _unidade_id);
        ds_list_delete_value(unidades_embarcadas, _unidade_id);
        ds_list_delete_value(soldados_embarcados, _unidade_id);
        ds_list_delete_value(avioes_visiveis, _unidade_id);
        
        // Atualizar contadores
        if (_tipo == "aereo") avioes_count--;
        else if (_tipo == "unidade") unidades_count--;
        else soldados_count--;
        
        // Calcular posição de lançamento
        var _dist = 100;
        var _angulo = image_angle + 90;
        
        _unidade.x = x + lengthdir_x(_dist, _angulo);
        _unidade.y = y + lengthdir_y(_dist, _angulo);
        
        // Apenas tornar visível novamente (NÃO reativar, pois nunca foi desativado)
        if (instance_exists(_unidade)) {
            _unidade.visible = true;
            
            // Se for aéreo, lançar
            if (_tipo == "aereo" && variable_instance_exists(_unidade, "velocidade_atual")) {
                _unidade.velocidade_atual = 5;
                _unidade.image_angle = image_angle;
            }
        }
        
        show_debug_message("✈️ " + object_get_name(_unidade.object_index) + " desembarcou!");
    }
}

// === FUNÇÕES PADRONIZADAS DO SISTEMA DE TRANSPORTE ===
funcao_embarcar_unidade = function(unidade_id) {
    return embarcar_unidade(unidade_id);
}

funcao_embarcar_aeronave = function(aeronave_id) {
    return embarcar_unidade(aeronave_id);
}

funcao_embarcar_veiculo = function(veiculo_id) {
    return embarcar_unidade(veiculo_id);
}

funcao_desembarcar_soldado = function() {
    if (soldados_count <= 0) return false;
    var _soldado_id = ds_list_find_value(soldados_embarcados, 0);
    if (instance_exists(_soldado_id)) {
        var _dist = 80;
        var _angulo = image_angle + desembarque_offset_angulo;
        _soldado_id.x = x + lengthdir_x(_dist, _angulo);
        _soldado_id.y = y + lengthdir_y(_dist, _angulo);
        _soldado_id.visible = true;
        // NÃO usar instance_activate_object() porque nunca foi desativado
        ds_list_delete(soldados_embarcados, 0);
        soldados_count--;
        desembarque_offset_angulo += 30;
        if (desembarque_offset_angulo >= 360) desembarque_offset_angulo = 0;
    }
    return true;
}

funcao_desembarcar_aeronave = function() {
    if (avioes_count <= 0) return false;
    var _aeronave_id = ds_list_find_value(avioes_embarcados, 0);
    if (instance_exists(_aeronave_id)) {
        var _dist = 100;
        var _angulo = image_angle + desembarque_offset_angulo;
        _aeronave_id.x = x + lengthdir_x(_dist, _angulo);
        _aeronave_id.y = y + lengthdir_y(_dist, _angulo);
        _aeronave_id.visible = true;
        // NÃO usar instance_activate_object() porque nunca foi desativado
        ds_list_delete(avioes_embarcados, 0);
        avioes_count--;
        ds_list_delete_value(avioes_visiveis, _aeronave_id.id);
        desembarque_offset_angulo += 30;
        if (desembarque_offset_angulo >= 360) desembarque_offset_angulo = 0;
    }
    return true;
}

funcao_desembarcar_veiculo = function() {
    if (unidades_count <= 0) return false;
    var _veiculo_id = ds_list_find_value(unidades_embarcadas, 0);
    if (instance_exists(_veiculo_id)) {
        var _dist = 90;
        var _angulo = image_angle + desembarque_offset_angulo;
        _veiculo_id.x = x + lengthdir_x(_dist, _angulo);
        _veiculo_id.y = y + lengthdir_y(_dist, _angulo);
        _veiculo_id.visible = true;
        // NÃO usar instance_activate_object() porque nunca foi desativado
        ds_list_delete(unidades_embarcadas, 0);
        unidades_count--;
        desembarque_offset_angulo += 30;
        if (desembarque_offset_angulo >= 360) desembarque_offset_angulo = 0;
    }
    return true;
}

show_debug_message("🚢 RONALD REAGAN (Porta-Aviões) CRIADO - Sistema de Embarque/Desembarque Ativo!");
show_debug_message("📦 Capacidade: 35 aviões + 20 veículos + 100 soldados");
