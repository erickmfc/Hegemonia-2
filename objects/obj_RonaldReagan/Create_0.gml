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
velocidade_movimento = 0.9; // Lento (é navio de transporte)
radar_alcance = 1000;
missil_alcance = 1000;
missil_max_alcance = 1000;
alcance_ataque = missil_alcance;
alcance_visao = radar_alcance;
dano_ataque = 70; // Dano aumentado
reload_time = 300; // 5 segundos de cooldown

// === SISTEMA DE MÍSSEIS (IGUAL CONSTELLATION) ===
pode_disparar_missil = false; // Desabilitar sistema do pai (usa sistema próprio)
missil_timer = 0;
missil_cooldown = 120; // 2 segundos entre mísseis

// === HERANÇA DO PAI (OBRIGATÓRIO) ===
// GM2040: Verificar se há parent antes de chamar event_inherited
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

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
estado_embarque = "navegando";             // GM2016: Declarado no Create event
modo_embarque = false;
menu_carga_aberto = false;
raio_embarque = 80;                         // Raio de detecção aumentado
desembarque_offset_angulo = 0;

// === RETÂNGULO DE EMBARQUE (SOBRESCREVE O PAI) ===
largura_embarque = 200; // Largura do retângulo de captura (cobre o navio)
altura_embarque = 960; // ✅ AUMENTADO: 50% a mais na proa + 50% a mais na popa (era 480, agora 960 = 480 + 240 + 240)

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
        object_is_ancestor(unidade.object_index, obj_f15) ||
        object_is_ancestor(unidade.object_index, obj_f6) ||
        object_is_ancestor(unidade.object_index, obj_helicoptero_militar)) return true;
    
    // Verificar se é terrestre/naval
    if (object_is_ancestor(unidade.object_index, obj_infantaria)) return true;
    if (object_is_ancestor(unidade.object_index, obj_tanque)) return true;
    if (object_is_ancestor(unidade.object_index, obj_soldado_antiaereo)) return true;
    if (object_is_ancestor(unidade.object_index, obj_blindado_antiaereo)) return true;
    
    // ✅ CORREÇÃO: Verificar explicitamente o M1A Abrams
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object && unidade.object_index == _obj_abrams) return true;
    
    return false;
}

tipo_unidade = function(unidade) {
    if (!instance_exists(unidade)) return "desconhecido";
    
    // ✅ CORREÇÃO: Usar object_get_name para comparação mais confiável (igual ao pai)
    var _nome = object_get_name(unidade.object_index);
    
    // Aeronaves
    if (_nome == "obj_caca_f5" ||
        _nome == "obj_f15" ||
        _nome == "obj_f6" ||
        _nome == "obj_helicoptero_militar" ||
        _nome == "obj_c100") {
        return "aereo";
    }
    
    // Soldados (unidades de infantaria)
    if (_nome == "obj_infantaria" ||
        _nome == "obj_soldado_antiaereo") {
        return "soldado";
    }
    
    // Veículos (tanques, blindados e Abrams)
    if (_nome == "obj_tanque" ||
        _nome == "obj_blindado_antiaereo" ||
        _nome == "obj_M1A_Abrams") { // ✅ CORREÇÃO: Adicionado M1A Abrams
        return "unidade";
    }
    
    show_debug_message("⚠️ [RONALD] tipo_unidade: Tipo desconhecido para " + _nome);
    return "desconhecido";
}

embarcar_unidade = function(unidade) {
    var _tipo = tipo_unidade(unidade);
    var _pode_embarcar = false;
    
    show_debug_message("🔍 [RONALD] Tentando embarcar: " + object_get_name(unidade.object_index) + " | Tipo: " + _tipo);
    
    // Verificar capacidade
    switch (_tipo) {
        case "aereo":
            if (avioes_count >= avioes_max) {
                show_debug_message("❌ [RONALD] EMBARQUE FALHOU: Capacidade AÉREA esgotada! (" + string(avioes_count) + "/" + string(avioes_max) + ")");
                return false;
            }
            _pode_embarcar = true;
            show_debug_message("✅ [RONALD] Capacidade AÉREA OK: " + string(avioes_count) + "/" + string(avioes_max));
            break;
        case "unidade":
            if (unidades_count >= unidades_max) {
                show_debug_message("❌ [RONALD] EMBARQUE FALHOU: Capacidade VEÍCULOS esgotada! (" + string(unidades_count) + "/" + string(unidades_max) + ")");
                return false;
            }
            _pode_embarcar = true;
            show_debug_message("✅ [RONALD] Capacidade VEÍCULOS OK: " + string(unidades_count) + "/" + string(unidades_max));
            break;
        case "soldado":
            if (soldados_count >= soldados_max) {
                show_debug_message("❌ [RONALD] EMBARQUE FALHOU: Capacidade SOLDADOS esgotada! (" + string(soldados_count) + "/" + string(soldados_max) + ")");
                return false;
            }
            _pode_embarcar = true;
            show_debug_message("✅ [RONALD] Capacidade SOLDADOS OK: " + string(soldados_count) + "/" + string(soldados_max));
            break;
        default:
            show_debug_message("❌ [RONALD] EMBARQUE FALHOU: Tipo desconhecido: " + _tipo);
            return false;
    }
    
    if (!_pode_embarcar) {
        show_debug_message("❌ [RONALD] EMBARQUE FALHOU: Flag _pode_embarcar é false (ERRO INESPERADO)");
        return false;
    }
    
    // Escolher qual lista usar
    var _lista_usar = avioes_embarcados;
    if (_tipo == "unidade") _lista_usar = unidades_embarcadas;
    else if (_tipo == "soldado") _lista_usar = soldados_embarcados;
    
    // ✅ CORREÇÃO: Verificar se já está embarcado antes de adicionar
    if (ds_list_find_index(_lista_usar, unidade.id) != -1) {
        show_debug_message("⚠️ [RONALD] EMBARQUE FALHOU: " + object_get_name(unidade.object_index) + " já está na lista!");
        return false;
    }
    
    show_debug_message(">>> [RONALD] PASSO FINAL: Adicionando à lista e escondendo...");
    
    // Adicionar à lista
    ds_list_add(_lista_usar, unidade.id);
    
    // Atualizar contador
    if (_tipo == "aereo") avioes_count++;
    else if (_tipo == "unidade") unidades_count++;
    else soldados_count++;
    
    // IMPORTANTE: Apenas esconder a unidade (NÃO desativar!)
    unidade.visible = false;
    
    show_debug_message("✅ [RONALD] " + object_get_name(unidade.object_index) + " embarcou! (A:" + 
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
        // ✅ CORREÇÃO: Validar antes de deletar valores das listas
        if (ds_exists(avioes_embarcados, ds_type_list)) {
            var _idx = ds_list_find_index(avioes_embarcados, _unidade_id);
            if (_idx >= 0) ds_list_delete(avioes_embarcados, _idx);
        }
        if (ds_exists(unidades_embarcadas, ds_type_list)) {
            var _idx = ds_list_find_index(unidades_embarcadas, _unidade_id);
            if (_idx >= 0) ds_list_delete(unidades_embarcadas, _idx);
        }
        if (ds_exists(soldados_embarcados, ds_type_list)) {
            var _idx = ds_list_find_index(soldados_embarcados, _unidade_id);
            if (_idx >= 0) ds_list_delete(soldados_embarcados, _idx);
        }
        if (ds_exists(avioes_visiveis, ds_type_list)) {
            var _idx = ds_list_find_index(avioes_visiveis, _unidade_id);
            if (_idx >= 0) ds_list_delete(avioes_visiveis, _idx);
        }
        
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
        
        // ✅ CORREÇÃO: Validar antes de deletar de avioes_visiveis
        if (ds_exists(avioes_visiveis, ds_type_list)) {
            var _id_para_deletar = _aeronave_id.id;
            // Verificar se o valor existe na lista antes de deletar
            var _indice = ds_list_find_index(avioes_visiveis, _id_para_deletar);
            if (_indice >= 0) {
                ds_list_delete(avioes_visiveis, _indice);
            }
        }
        
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

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("🚢 RONALD REAGAN (Porta-Aviões) CRIADO - Sistema de Embarque/Desembarque Ativo!");
show_debug_message("📦 Capacidade: 35 aviões + 20 veículos + 100 soldados");
