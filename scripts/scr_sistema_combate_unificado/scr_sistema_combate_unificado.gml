// Sistema de Combate Unificado - Hegemonia Global
// Elimina conflitos entre combate automático e manual

// Estados de combate
enum ESTADO_COMBATE {
    PARADO,
    PROCURANDO_ALVO,
    MOVENDO_PARA_ALVO,
    ATACANDO,
    RECARREGANDO,
    RETIRANDO_SE,
    DEFENDENDO
}

// Tipos de comando de combate
enum COMANDO_COMBATE {
    ATACAR_ALVO,
    ATACAR_AREA,
    DEFENDER_POSICAO,
    RETIRAR_SE,
    PARAR_COMBATE
}

// Sistema global de combate
global.sistema_combate = {
    modo: "unified", // "unified", "automatic", "manual"
    unidades_em_combate: [],
    alvos_prioritarios: [],
    area_combate_ativa: false,
    estatisticas: {
        ataques_realizados: 0,
        unidades_destruidas: 0,
        dano_total_causado: 0,
        dano_total_recebido: 0
    }
};

function scr_inicializar_sistema_combate() {
    scr_log_sistema("COMBATE", "Sistema de combate unificado inicializado");
    
    global.sistema_combate.unidades_em_combate = [];
    global.sistema_combate.alvos_prioritarios = [];
    global.sistema_combate.area_combate_ativa = false;
    
    // Resetar estatísticas
    global.sistema_combate.estatisticas.ataques_realizados = 0;
    global.sistema_combate.estatisticas.unidades_destruidas = 0;
    global.sistema_combate.estatisticas.dano_total_causado = 0;
    global.sistema_combate.estatisticas.dano_total_recebido = 0;
}

function scr_processar_comando_combate(comando, unidades_selecionadas, parametros = {}) {
    scr_debug_log("COMBATE", "Processando comando: " + string(comando), DEBUG_LEVEL.BASIC);
    
    switch(comando) {
        case COMANDO_COMBATE.ATACAR_ALVO:
            scr_comando_atacar_alvo(unidades_selecionadas, parametros.alvo);
            break;
            
        case COMANDO_COMBATE.ATACAR_AREA:
            scr_comando_atacar_area(unidades_selecionadas, parametros.x, parametros.y, parametros.raio);
            break;
            
        case COMANDO_COMBATE.DEFENDER_POSICAO:
            scr_comando_defender_posicao(unidades_selecionadas, parametros.x, parametros.y);
            break;
            
        case COMANDO_COMBATE.RETIRAR_SE:
            scr_comando_retirar_se(unidades_selecionadas);
            break;
            
        case COMANDO_COMBATE.PARAR_COMBATE:
            scr_comando_parar_combate(unidades_selecionadas);
            break;
    }
}

function scr_comando_atacar_alvo(unidades, alvo) {
    if (!instance_exists(alvo)) {
        scr_debug_log("COMBATE", "Alvo não existe para ataque", DEBUG_LEVEL.BASIC);
        return;
    }
    
    scr_debug_log("COMBATE", "Comando de ataque a alvo específico: " + string(alvo), DEBUG_LEVEL.BASIC);
    
    for (var i = 0; i < array_length(unidades); i++) {
        var _unidade = unidades[i];
        if (instance_exists(_unidade)) {
            scr_definir_estado_combate(_unidade, ESTADO_COMBATE.PROCURANDO_ALVO);
            _unidade.alvo_especifico = alvo;
            _unidade.comando_combate = COMANDO_COMBATE.ATACAR_ALVO;
            
            // Adicionar à lista de unidades em combate
            scr_adicionar_unidade_combate(_unidade);
        }
    }
}

function scr_comando_atacar_area(unidades, x, y, raio) {
    scr_debug_log("COMBATE", "Comando de ataque a área: (" + string(x) + ", " + string(y) + ") raio: " + string(raio), DEBUG_LEVEL.BASIC);
    
    for (var i = 0; i < array_length(unidades); i++) {
        var _unidade = unidades[i];
        if (instance_exists(_unidade)) {
            scr_definir_estado_combate(_unidade, ESTADO_COMBATE.MOVENDO_PARA_ALVO);
            _unidade.alvo_x = x;
            _unidade.alvo_y = y;
            _unidade.raio_ataque_area = raio;
            _unidade.comando_combate = COMANDO_COMBATE.ATACAR_AREA;
            
            scr_adicionar_unidade_combate(_unidade);
        }
    }
}

function scr_comando_defender_posicao(unidades, x, y) {
    scr_debug_log("COMBATE", "Comando de defesa de posição: (" + string(x) + ", " + string(y) + ")", DEBUG_LEVEL.BASIC);
    
    for (var i = 0; i < array_length(unidades); i++) {
        var _unidade = unidades[i];
        if (instance_exists(_unidade)) {
            scr_definir_estado_combate(_unidade, ESTADO_COMBATE.DEFENDENDO);
            _unidade.posicao_defesa_x = x;
            _unidade.posicao_defesa_y = y;
            _unidade.comando_combate = COMANDO_COMBATE.DEFENDER_POSICAO;
            
            scr_adicionar_unidade_combate(_unidade);
        }
    }
}

function scr_comando_retirar_se(unidades) {
    scr_debug_log("COMBATE", "Comando de retirada", DEBUG_LEVEL.BASIC);
    
    for (var i = 0; i < array_length(unidades); i++) {
        var _unidade = unidades[i];
        if (instance_exists(_unidade)) {
            scr_definir_estado_combate(_unidade, ESTADO_COMBATE.RETIRANDO_SE);
            _unidade.comando_combate = COMANDO_COMBATE.RETIRAR_SE;
            
            scr_remover_unidade_combate(_unidade);
        }
    }
}

function scr_comando_parar_combate(unidades) {
    scr_debug_log("COMBATE", "Comando de parar combate", DEBUG_LEVEL.BASIC);
    
    for (var i = 0; i < array_length(unidades); i++) {
        var _unidade = unidades[i];
        if (instance_exists(_unidade)) {
            scr_definir_estado_combate(_unidade, ESTADO_COMBATE.PARADO);
            _unidade.comando_combate = COMANDO_COMBATE.PARAR_COMBATE;
            
            scr_remover_unidade_combate(_unidade);
        }
    }
}

function scr_definir_estado_combate(unidade, estado) {
    if (!instance_exists(unidade)) return;
    
    var _estado_anterior = unidade.estado_combate;
    unidade.estado_combate = estado;
    
    scr_debug_log("COMBATE", "Unidade " + string(unidade) + " mudou estado: " + string(_estado_anterior) + " -> " + string(estado), DEBUG_LEVEL.DETAILED);
    
    // Executar ações específicas do estado
    switch(estado) {
        case ESTADO_COMBATE.PARADO:
            scr_parar_unidade(unidade);
            break;
            
        case ESTADO_COMBATE.PROCURANDO_ALVO:
            scr_procurar_alvo(unidade);
            break;
            
        case ESTADO_COMBATE.MOVENDO_PARA_ALVO:
            scr_mover_para_alvo(unidade);
            break;
            
        case ESTADO_COMBATE.ATACANDO:
            scr_executar_ataque(unidade);
            break;
            
        case ESTADO_COMBATE.RECARREGANDO:
            scr_iniciar_recarga(unidade);
            break;
            
        case ESTADO_COMBATE.RETIRANDO_SE:
            scr_executar_retirada(unidade);
            break;
    }
}

function scr_atualizar_sistema_combate() {
    // Atualizar todas as unidades em combate
    for (var i = array_length(global.sistema_combate.unidades_em_combate) - 1; i >= 0; i--) {
        var _unidade = global.sistema_combate.unidades_em_combate[i];
        
        if (!instance_exists(_unidade)) {
            // Remover unidade destruída
            array_delete(global.sistema_combate.unidades_em_combate, i, 1);
            continue;
        }
        
        scr_atualizar_unidade_combate(_unidade);
    }
    
    // Verificar se há combate ativo
    if (array_length(global.sistema_combate.unidades_em_combate) == 0) {
        global.sistema_combate.area_combate_ativa = false;
    }
}

function scr_atualizar_unidade_combate(unidade) {
    switch(unidade.estado_combate) {
        case ESTADO_COMBATE.PROCURANDO_ALVO:
            scr_atualizar_procura_alvo(unidade);
            break;
            
        case ESTADO_COMBATE.MOVENDO_PARA_ALVO:
            scr_atualizar_movimento_alvo(unidade);
            break;
            
        case ESTADO_COMBATE.ATACANDO:
            scr_atualizar_ataque(unidade);
            break;
            
        case ESTADO_COMBATE.RECARREGANDO:
            scr_atualizar_recarga(unidade);
            break;
            
        case ESTADO_COMBATE.RETIRANDO_SE:
            scr_atualizar_retirada(unidade);
            break;
    }
}

function scr_procurar_alvo(unidade) {
    var _alvo_encontrado = false;
    
    // Verificar se há alvo específico
    if (unidade.alvo_especifico != undefined && instance_exists(unidade.alvo_especifico)) {
        unidade.alvo_atual = unidade.alvo_especifico;
        _alvo_encontrado = true;
    } else {
        // Procurar alvo automaticamente
        unidade.alvo_atual = scr_encontrar_alvo_proximo(unidade);
        _alvo_encontrado = (unidade.alvo_atual != noone);
    }
    
    if (_alvo_encontrado) {
        scr_definir_estado_combate(unidade, ESTADO_COMBATE.MOVENDO_PARA_ALVO);
    } else {
        scr_debug_log("COMBATE", "Nenhum alvo encontrado para unidade " + string(unidade), DEBUG_LEVEL.DETAILED);
    }
}

function scr_encontrar_alvo_proximo(unidade) {
    var _distancia_minima = 999999;
    var _melhor_alvo = noone;
    
    // Procurar inimigos próximos
    with (obj_inimigo) {
        if (self != unidade) {
            var _distancia = point_distance(unidade.x, unidade.y, x, y);
            if (_distancia < _distancia_minima && _distancia <= unidade.alcance_ataque) {
                _distancia_minima = _distancia;
                _melhor_alvo = self;
            }
        }
    }
    
    return _melhor_alvo;
}

function scr_executar_ataque(unidade) {
    if (unidade.alvo_atual == noone || !instance_exists(unidade.alvo_atual)) {
        scr_definir_estado_combate(unidade, ESTADO_COMBATE.PROCURANDO_ALVO);
        return;
    }
    
    var _alvo = unidade.alvo_atual;
    var _distancia = point_distance(unidade.x, unidade.y, _alvo.x, _alvo.y);
    
    if (_distancia <= unidade.alcance_ataque) {
        // Executar ataque
        scr_realizar_ataque(unidade, _alvo);
        
        // Verificar se alvo foi destruído
        if (!instance_exists(_alvo)) {
            scr_definir_estado_combate(unidade, ESTADO_COMBATE.PROCURANDO_ALVO);
        } else {
            scr_definir_estado_combate(unidade, ESTADO_COMBATE.RECARREGANDO);
        }
    } else {
        scr_definir_estado_combate(unidade, ESTADO_COMBATE.MOVENDO_PARA_ALVO);
    }
}

function scr_realizar_ataque(atacante, alvo) {
    var _dano = atacante.dano_ataque;
    
    // Aplicar dano
    alvo.hp_atual -= _dano;
    
    // Atualizar estatísticas
    global.sistema_combate.estatisticas.ataques_realizados++;
    global.sistema_combate.estatisticas.dano_total_causado += _dano;
    
    scr_debug_log("COMBATE", "Ataque realizado: " + string(atacante) + " -> " + string(alvo) + " (dano: " + string(_dano) + ")", DEBUG_LEVEL.DETAILED);
    
    // Verificar se alvo foi destruído
    if (alvo.hp_atual <= 0) {
        scr_destruir_unidade(alvo);
        global.sistema_combate.estatisticas.unidades_destruidas++;
    }
}

function scr_adicionar_unidade_combate(unidade) {
    // Verificar se já está na lista
    for (var i = 0; i < array_length(global.sistema_combate.unidades_em_combate); i++) {
        if (global.sistema_combate.unidades_em_combate[i] == unidade) {
            return; // Já está na lista
        }
    }
    
    array_push(global.sistema_combate.unidades_em_combate, unidade);
    global.sistema_combate.area_combate_ativa = true;
    
    scr_debug_log("COMBATE", "Unidade adicionada ao combate: " + string(unidade), DEBUG_LEVEL.DETAILED);
}

function scr_remover_unidade_combate(unidade) {
    for (var i = array_length(global.sistema_combate.unidades_em_combate) - 1; i >= 0; i--) {
        if (global.sistema_combate.unidades_em_combate[i] == unidade) {
            array_delete(global.sistema_combate.unidades_em_combate, i, 1);
            scr_debug_log("COMBATE", "Unidade removida do combate: " + string(unidade), DEBUG_LEVEL.DETAILED);
            break;
        }
    }
}

function scr_relatorio_combate() {
    scr_debug_log("COMBATE", "=== RELATÓRIO DE COMBATE ===", DEBUG_LEVEL.BASIC, true);
    
    scr_debug_log("COMBATE", "Unidades em combate: " + string(array_length(global.sistema_combate.unidades_em_combate)), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("COMBATE", "Ataques realizados: " + string(global.sistema_combate.estatisticas.ataques_realizados), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("COMBATE", "Unidades destruídas: " + string(global.sistema_combate.estatisticas.unidades_destruidas), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("COMBATE", "Dano total causado: " + string(global.sistema_combate.estatisticas.dano_total_causado), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("COMBATE", "Dano total recebido: " + string(global.sistema_combate.estatisticas.dano_total_recebido), DEBUG_LEVEL.BASIC, true);
    
    scr_debug_log("COMBATE", "=== FIM DO RELATÓRIO ===", DEBUG_LEVEL.BASIC, true);
}

// Funções auxiliares (implementar conforme necessário)
function scr_parar_unidade(unidade) {
    // Implementar parada da unidade
}

function scr_mover_para_alvo(unidade) {
    // Implementar movimento para alvo
}

function scr_iniciar_recarga(unidade) {
    // Implementar sistema de recarga
}

function scr_executar_retirada(unidade) {
    // Implementar retirada
}

function scr_destruir_unidade(unidade) {
    // Implementar destruição de unidade
}