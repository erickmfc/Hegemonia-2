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
direcao_patrulha = 1; // 1 = horário (avançar), -1 = anti-horário (retroceder)

// === TERRENOS PERMITIDOS ===
terrenos_permitidos = [TERRAIN.AGUA]; // Só água

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
comando_p_contador = 0; // ✅ NOVO: Contador para P, PP, PPP (0 = nenhum, 1 = P, 2 = PP, 3 = PPP)
comando_p_timer = 0; // ✅ NOVO: Timer para resetar contador após 1 segundo

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

raio_embarque = 80; // Raio de detecção para embarque (será usado como metade da largura/altura do retângulo)
largura_embarque = 136; // ✅ REDUZIDO 20%: era 170, agora 136 (170 * 0.8 = 136)
altura_embarque = 163; // ✅ REDUZIDO 20%: era 204, agora 163 (204 * 0.8 = 163)
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
    // ✅ NOVO: Sistema de rotação de patrulha (horário/anti-horário)
    var _total_pontos = ds_list_size(pontos_patrulha);
    if (!variable_instance_exists(id, "direcao_patrulha")) {
        direcao_patrulha = 1; // Padrão: horário
    }
    indice_patrulha_atual = (indice_patrulha_atual + direcao_patrulha + _total_pontos) mod _total_pontos;
    var p = pontos_patrulha[| indice_patrulha_atual];
    destino_x = p[0];
    destino_y = p[1];
}

func_procurar_inimigo = function() {
    // ✅ CORREÇÃO: obj_inimigo removido - buscar apenas obj_infantaria
    var melhor = noone;
    var melhor_d = 999999;
    with (obj_infantaria) {
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
    if (!instance_exists(unidade)) return "desconhecido";
    
    // ✅ CORREÇÃO: Usar object_get_name para comparação mais confiável
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
        _nome == "obj_M1A_Abrams") { // ✅ CORREÇÃO: Comparar por nome em vez de object_index
        return "unidade";
    }
    
    show_debug_message("⚠️ [NAVIO] tipo_unidade: Tipo desconhecido para " + _nome);
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
    
    var _nome_unidade = object_get_name(_unidade.object_index);
    show_debug_message("🔍 [NAVIO] Tentando embarcar: " + _nome_unidade + " | Tipo: " + _tipo);
    
    // ✅ DEBUG ESPECIAL PARA ABRAMS
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object && _unidade.object_index == _obj_abrams) {
        show_debug_message("🎯 [NAVIO] É um Abrams! Verificando tipo_unidade...");
        show_debug_message("  object_index do Abrams: " + string(_unidade.object_index));
        show_debug_message("  _obj_abrams asset: " + string(_obj_abrams));
        show_debug_message("  São iguais? " + string(_unidade.object_index == _obj_abrams));
    }
    
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
    
    if (instance_exists(unidade_id)) {
        // ✅ CORREÇÃO: Desembarcar na PROA (frente) do navio
        var _distancia_proa = 120; // Distância da proa
        var _angulo_proa = image_angle; // Direção da proa (frente do navio)
        
        unidade_id.x = x + lengthdir_x(_distancia_proa, _angulo_proa);
        unidade_id.y = y + lengthdir_y(_distancia_proa, _angulo_proa);
        unidade_id.visible = true;
        
        // Parar a unidade ao desembarcar
        if (variable_instance_exists(unidade_id, "velocidade_atual")) {
            unidade_id.velocidade_atual = 0;
        }
        if (variable_instance_exists(unidade_id, "estado")) {
            unidade_id.estado = "parado";
        }
    }
    
    show_debug_message("✅ Soldado desembarcou na proa!");
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
    
    if (instance_exists(veiculo_id)) {
        // ✅ CORREÇÃO: Desembarcar na PROA (frente) do navio
        var _distancia_proa = 150; // Distância maior para veículos
        var _angulo_proa = image_angle; // Direção da proa (frente do navio)
        
        veiculo_id.x = x + lengthdir_x(_distancia_proa, _angulo_proa);
        veiculo_id.y = y + lengthdir_y(_distancia_proa, _angulo_proa);
        veiculo_id.visible = true;
        
        // Parar o veículo ao desembarcar
        if (variable_instance_exists(veiculo_id, "velocidade_atual")) {
            veiculo_id.velocidade_atual = 0;
        }
        if (variable_instance_exists(veiculo_id, "estado")) {
            veiculo_id.estado = "parado";
        }
    }
    
    show_debug_message("✅ Veículo desembarcou na proa!");
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
