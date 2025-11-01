/// @description Inicialização do Navio Transporte com Sistema de Embarque/Desembarque

// === HERANÇA DO PAI (OBRIGATÓRIO) ===
event_inherited();

// === ENUMS GLOBAIS ===
// Os enums LanchaState e LanchaMode estão no script global scr_enums_navais

// Atributos básicos
hp_atual = 150;
hp_max = 150;
velocidade_movimento = 1.4;
nacao_proprietaria = 1; // 1 = jogador

// Estado e modo
estado = LanchaState.PARADO;
modo_combate = LanchaMode.PASSIVO;

// Sensores e alcance
radar_alcance = 1000;
missil_alcance = 1000;
missil_max_alcance = 1000;
alcance_ataque = missil_alcance;

// Alvo e movimento
alvo_x = x;
alvo_y = y;

// Patrulha
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// Seleção e UI
selecionado = false;

// Controle de taxa de tiro
reload_time = 60;
reload_timer = 0;

// Identificador
nome_unidade = "Navio Transporte";

// Variáveis auxiliares
alvo_unidade = noone;
alvo_pos_anterior_x = -1;
alvo_pos_anterior_y = -1;

// Estado anterior para retorno após ataque
estado_anterior = LanchaState.PARADO;

// Mapeamento de compatibilidade
modo_ataque = (modo_combate == LanchaMode.ATAQUE);
velocidade_atual = velocidade_movimento;
timer_ataque = reload_timer;
destino_x = alvo_x;
destino_y = alvo_y;

// === SISTEMA DE EMBARQUE/DESEMBARQUE (NOVO) ===
estado_transporte = NavioTransporteEstado.PARADO;
modo_embarque = false;
menu_carga_aberto = false;
desembarque_timer = 0;
desembarque_intervalo = 120; // 2 segundos entre desembarques

// === CAPACIDADES DO NAVIO ===
avioes_max = 10;
unidades_max = 10;
soldados_max = 50;

avioes_count = 0;
unidades_count = 0;
soldados_count = 0;

avioes_embarcados = ds_list_create();
unidades_embarcadas = ds_list_create();
soldados_embarcados = ds_list_create();

raio_embarque = 80; // Raio de detecção para embarque
desembarque_offset_angulo = 0; // Ângulo para desembarque radial

// === VARIÁVEIS DE COMANDOS ===
ultimo_comando = "nenhum";
comando_timer = 0;

// === FUNÇÕES BÁSICAS ===
ordem_mover = function(dest_x, dest_y) {
    var _dx = clamp(dest_x, 8, room_width - 8);
    var _dy = clamp(dest_y, 8, room_height - 8);
    destino_x = _dx;
    destino_y = _dy;
    estado = LanchaState.MOVENDO;
    alvo_unidade = noone;
    show_debug_message("🚢 " + nome_unidade + " recebeu ordem de movimento para (" + string(destino_x) + ", " + string(destino_y) + "). Estado: MOVENDO");
}

func_ordem_mover = ordem_mover;

func_adicionar_ponto = function(px, py) {
    ds_list_add(pontos_patrulha, [px, py]);
}

func_iniciar_patrulha = function() {
    if (ds_list_size(pontos_patrulha) > 0) {
        indice_patrulha_atual = 0;
        var p = pontos_patrulha[| indice_patrulha_atual];
        destino_x = p[0];
        destino_y = p[1];
        estado = LanchaState.PATRULHANDO;
    } else {
        estado = LanchaState.PARADO;
    }
}

func_proximo_ponto = function() {
    if (ds_list_size(pontos_patrulha) == 0) {
        estado = LanchaState.PARADO;
        return;
    }
    indice_patrulha_atual = (indice_patrulha_atual + 1) mod ds_list_size(pontos_patrulha);
    var p = pontos_patrulha[| indice_patrulha_atual];
    destino_x = p[0];
    destino_y = p[1];
}

func_procurar_inimigo = function() {
    var melhor = noone;
    var melhor_d = 999999;
    with (obj_inimigo) {
        if (nacao_proprietaria != other.nacao_proprietaria) {
            var d = point_distance(other.x, other.y, x, y);
            if (d < other.radar_alcance && d < melhor_d) {
                melhor = id;
                melhor_d = d;
            }
        }
    }
    return melhor;
}

// === 6. FUNÇÕES DE EMBARQUE/DESEMBARQUE ===

// ✅ Função para detectar tipo de unidade
tipo_unidade = function(unidade) {
    // Aeronaves
    if (unidade.object_index == obj_caca_f5 ||
        unidade.object_index == obj_f15 ||
        unidade.object_index == obj_f6 ||
        unidade.object_index == obj_helicoptero_militar ||
        unidade.object_index == obj_c100) {
        return "aereo";
    }
    
    // Soldados (unidades de infantaria)
    if (unidade.object_index == obj_infantaria ||
        unidade.object_index == obj_soldado_antiaereo) {
        return "soldado";
    }
    
    // Veículos (tanques e blindados)
    if (unidade.object_index == obj_tanque ||
        unidade.object_index == obj_blindado_antiaereo) {
        return "unidade";
    }
    
    return "desconhecido";
}

// ✅ FUNÇÃO UNIFICADA DE EMBARQUE
funcao_embarcar_unidade = function(unidade_id) {
    if (!instance_exists(unidade_id)) {
        show_debug_message("❌ EMBARQUE FALHOU: Unidade não existe!");
        return false;
    }
    
    var _unidade = unidade_id;
    var _tipo = tipo_unidade(_unidade);
    var _pode_embarcar = false;
    var _lista_usar;
    
    show_debug_message("🔍 Tentando embarcar: " + object_get_name(_unidade.object_index) + " | Tipo: " + _tipo);
    
    // Verificar se pode embarcar de acordo com o tipo
    switch (_tipo) {
        case "aereo":
            if (avioes_count >= avioes_max) {
                show_debug_message("❌ EMBARQUE FALHOU: Capacidade AÉREA esgotada! (" + string(avioes_count) + "/" + string(avioes_max) + ")");
                return false;
            }
            _lista_usar = avioes_embarcados;
            _pode_embarcar = true;
            show_debug_message("✅ Capacidade AÉREA OK: " + string(avioes_count) + "/" + string(avioes_max));
            break;
        case "unidade":
            if (unidades_count >= unidades_max) {
                show_debug_message("❌ EMBARQUE FALHOU: Capacidade VEÍCULOS esgotada! (" + string(unidades_count) + "/" + string(unidades_max) + ")");
                return false;
            }
            _lista_usar = unidades_embarcadas;
            _pode_embarcar = true;
            show_debug_message("✅ Capacidade VEÍCULOS OK: " + string(unidades_count) + "/" + string(unidades_max));
            break;
        case "soldado":
            if (soldados_count >= soldados_max) {
                show_debug_message("❌ EMBARQUE FALHOU: Capacidade SOLDADOS esgotada! (" + string(soldados_count) + "/" + string(soldados_max) + ")");
                return false;
            }
            _lista_usar = soldados_embarcados;
            _pode_embarcar = true;
            show_debug_message("✅ Capacidade SOLDADOS OK: " + string(soldados_count) + "/" + string(soldados_max));
            break;
        default:
            show_debug_message("❌ EMBARQUE FALHOU: Tipo desconhecido: " + _tipo);
            return false;
    }
    
    if (!_pode_embarcar) {
        show_debug_message("❌ EMBARQUE FALHOU: Flag _pode_embarcar é false (ERRO INESPERADO)");
        return false;
    }
    
    // Verificar se já está embarcado
    if (ds_list_find_index(_lista_usar, unidade_id) != -1) {
        show_debug_message("⚠️ EMBARQUE FALHOU: " + object_get_name(_unidade.object_index) + " já está na lista!");
        return false;
    }
    
    // --- SE CHEGAR ATÉ AQUI, DEVERIA FUNCIONAR ---
    show_debug_message(">>> PASSO FINAL: Adicionando à lista e escondendo...");
    
    // Adicionar à lista correta baseado no tipo
    ds_list_add(_lista_usar, unidade_id);
    
    // Atualizar contador CORRETO baseado no tipo
    switch (_tipo) {
        case "aereo":
            avioes_count++;
            break;
        case "unidade":
            unidades_count++;
            break;
        case "soldado":
            soldados_count++;
            break;
    }
    
    // IMPORTANTE: Apenas esconder a unidade (NÃO desativar!)
    _unidade.visible = false;
    
    show_debug_message("✅ " + object_get_name(_unidade.object_index) + " embarcou! (A:" + 
                      string(avioes_count) + "/" + string(avioes_max) + " | " +
                      "U:" + string(unidades_count) + "/" + string(unidades_max) + " | " +
                      "S:" + string(soldados_count) + "/" + string(soldados_max) + ")");
    
    return true;
}

// ✅ ALIAS PARA COMPATIBILIDADE
funcao_embarcar_aeronave = function(aeronave_id) {
    return funcao_embarcar_unidade(aeronave_id);
}

funcao_embarcar_veiculo = function(veiculo_id) {
    return funcao_embarcar_unidade(veiculo_id);
}

// Função para desembarcar soldado
funcao_desembarcar_soldado = function() {
    if (ds_list_size(soldados_embarcados) == 0) return;
    
    var unidade_id = soldados_embarcados[| 0];
    ds_list_delete(soldados_embarcados, 0);
    soldados_count--;
    
    var offset_x = lengthdir_x(30, desembarque_offset_angulo);
    var offset_y = lengthdir_y(30, desembarque_offset_angulo);
    desembarque_offset_angulo += 30;
    
    if (instance_exists(unidade_id)) {
        var _offset_x_final = x + offset_x;
        var _offset_y_final = y + offset_y;
        
        unidade_id.x = _offset_x_final;
        unidade_id.y = _offset_y_final;
        unidade_id.visible = true;  // Mostrar visualmente ANTES de parar a velocidade
        
        // Parar a unidade ao desembarcar
        if (variable_instance_exists(unidade_id, "velocidade_atual")) {
            unidade_id.velocidade_atual = 0;
        }
    }
    
    show_debug_message("✅ Soldado desembarcou! Restantes: " + string(soldados_count));
}

// Função para desembarcar aeronave
funcao_desembarcar_aeronave = function() {
    if (ds_list_size(avioes_embarcados) == 0) return;
    
    var aeronave_id = avioes_embarcados[| 0];
    ds_list_delete(avioes_embarcados, 0);
    avioes_count--;
    
    var offset_x = lengthdir_x(40, desembarque_offset_angulo);
    var offset_y = lengthdir_y(40, desembarque_offset_angulo);
    desembarque_offset_angulo += 45;
    
    if (instance_exists(aeronave_id)) {
        var _offset_x_final = x + offset_x;
        var _offset_y_final = y + offset_y;
        
        aeronave_id.x = _offset_x_final;
        aeronave_id.y = _offset_y_final;
        aeronave_id.visible = true;  // Mostrar visualmente ANTES de dar velocidade
        
        // Dar velocidade ao avião ao desembarcar
        if (variable_instance_exists(aeronave_id, "velocidade_atual")) {
            aeronave_id.velocidade_atual = 5;
        }
    }
    
    show_debug_message("✅ Aeronave desembarcou! Restantes: " + string(avioes_count));
}

// Função para desembarcar veículo
funcao_desembarcar_veiculo = function() {
    if (ds_list_size(unidades_embarcadas) == 0) return;
    
    var veiculo_id = unidades_embarcadas[| 0];
    ds_list_delete(unidades_embarcadas, 0);
    unidades_count--;
    
    var offset_x = lengthdir_x(35, desembarque_offset_angulo);
    var offset_y = lengthdir_y(35, desembarque_offset_angulo);
    desembarque_offset_angulo += 35;
    
    if (instance_exists(veiculo_id)) {
        var _offset_x_final = x + offset_x;
        var _offset_y_final = y + offset_y;
        
        veiculo_id.x = _offset_x_final;
        veiculo_id.y = _offset_y_final;
        veiculo_id.visible = true;  // Mostrar visualmente ANTES de parar a velocidade
        
        // Parar o veículo ao desembarcar
        if (variable_instance_exists(veiculo_id, "velocidade_atual")) {
            veiculo_id.velocidade_atual = 0;
        }
    }
    
    show_debug_message("✅ Veículo desembarcou! Restantes: " + string(unidades_count));
}

// Callbacks
on_select = function() {
    selecionado = true;
};

on_deselect = function() {
    selecionado = false;
};

// Garantir existência de ds_list
if (!ds_exists(pontos_patrulha, ds_type_list)) {
    pontos_patrulha = ds_list_create();
}

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("🚢 Navio Transporte criado - Sistema de embarque/desembarque ativo!");
