// ===============================================
// HEGEMONIA GLOBAL - VERIFICAÇÃO DE QUARTEL E MARINHA
// Sistema de verificação e gerenciamento de instalações militares
// ===============================================

/// @function sc_verificar_quartel_marinha(tipo_instalacao, operacao, parametros);
/// @description Verifica e gerencia instalações militares (quartel, marinha, aeroporto)
/// @param {string} tipo_instalacao - Tipo da instalação ("quartel", "marinha", "aeroporto")
/// @param {string} operacao - Operação a realizar ("verificar", "reparar", "abastecer", "treinar")
/// @param {array} parametros - Parâmetros específicos da operação

function sc_verificar_quartel_marinha(tipo_instalacao, operacao, parametros = []) {
    var _instalacao = noone;
    
    // Encontra a instalação baseada no tipo
    switch (tipo_instalacao) {
        case "quartel":
            _instalacao = instance_find(obj_quartel, 0);
            break;
        case "marinha":
            _instalacao = instance_find(obj_marinha, 0);
            break;
        case "aeroporto":
            _instalacao = instance_find(obj_aeroporto_militar, 0);
            break;
        default:
            show_debug_message("❌ ERRO: Tipo de instalação desconhecido: " + string(tipo_instalacao));
            return false;
    }
    
    if (!instance_exists(_instalacao)) {
        show_debug_message("❌ ERRO: " + string(tipo_instalacao) + " não encontrado");
        return false;
    }
    
    with (_instalacao) {
        switch (operacao) {
            case "verificar":
                // Verifica status da instalação
                var _status = {
                    hp_atual: hp_atual,
                    hp_max: hp_max,
                    operacional: (hp_atual > 0),
                    capacidade_producao: capacidade_producao,
                    unidades_produzidas: unidades_produzidas,
                    recursos_disponiveis: recursos_disponiveis,
                    nivel_tecnologia: nivel_tecnologia
                };
                
                show_debug_message("📊 Status " + string(tipo_instalacao) + ": HP " + string(hp_atual) + "/" + string(hp_max));
                show_debug_message("🏭 Capacidade: " + string(capacidade_producao) + " | Produzidas: " + string(unidades_produzidas));
                return _status;
                
            case "reparar":
                // Repara a instalação
                if (array_length(parametros) > 0) {
                    var _valor_reparo = parametros[0];
                    hp_atual = min(hp_max, hp_atual + _valor_reparo);
                    show_debug_message("🔧 " + string(tipo_instalacao) + " reparado: +" + string(_valor_reparo) + " HP");
                } else {
                    hp_atual = hp_max; // Reparo completo
                    show_debug_message("🔧 " + string(tipo_instalacao) + " totalmente reparado");
                }
                break;
                
            case "abastecer":
                // Abastece recursos da instalação
                if (array_length(parametros) >= 2) {
                    var _combustivel = parametros[0];
                    var _municao = parametros[1];
                    
                    if (variable_instance_exists(id, "combustivel_atual")) {
                        combustivel_atual = min(combustivel_max, combustivel_atual + _combustivel);
                    }
                    if (variable_instance_exists(id, "municao_atual")) {
                        municao_atual = min(municao_max, municao_atual + _municao);
                    }
                    
                    show_debug_message("⛽ " + string(tipo_instalacao) + " abastecido");
                }
                break;
                
            case "treinar":
                // Treina unidades na instalação
                if (array_length(parametros) > 0) {
                    var _tipo_unidade = parametros[0];
                    var _quantidade = (array_length(parametros) > 1) ? parametros[1] : 1;
                    
                    // Verifica se pode produzir a unidade
                    if (capacidade_producao > unidades_produzidas) {
                        unidades_produzidas += _quantidade;
                        show_debug_message("🎓 Treinamento: " + string(_quantidade) + "x " + string(_tipo_unidade));
                        
                        // Cria as unidades treinadas
                        for (var i = 0; i < _quantidade; i++) {
                            var _nova_unidade = instance_create_layer(x + random_range(-50, 50), y + random_range(-50, 50), "Instances", _tipo_unidade);
                            if (instance_exists(_nova_unidade)) {
                                _nova_unidade.nacao_proprietaria = nacao_proprietaria;
                                _nova_unidade.experiencia = 1; // Unidade treinada
                            }
                        }
                    } else {
                        show_debug_message("❌ Capacidade de produção esgotada");
                        return false;
                    }
                }
                break;
                
            case "melhorar":
                // Melhora a instalação
                if (array_length(parametros) > 0) {
                    var _tipo_melhoria = parametros[0];
                    
                    switch (_tipo_melhoria) {
                        case "capacidade":
                            capacidade_producao += 2;
                            show_debug_message("📈 Capacidade de produção aumentada");
                            break;
                        case "tecnologia":
                            nivel_tecnologia++;
                            show_debug_message("🔬 Nível tecnológico aumentado");
                            break;
                        case "defesa":
                            if (variable_instance_exists(id, "defesa")) {
                                defesa += 10;
                                show_debug_message("🛡️ Defesa da instalação aumentada");
                            }
                            break;
                    }
                }
                break;
                
            case "evacuar":
                // Evacua unidades da instalação
                var _unidades_evacuadas = 0;
                
                // Encontra unidades próximas para evacuar
                with (obj_infantaria) {
                    if (point_distance(x, y, other.x, other.y) < 100) {
                        // Move para posição segura
                        destino_x = other.x + random_range(-200, 200);
                        destino_y = other.y + random_range(-200, 200);
                        estado = "evacuando";
                        _unidades_evacuadas++;
                    }
                }
                
                show_debug_message("🚨 Evacuação: " + string(_unidades_evacuadas) + " unidades evacuadas");
                break;
                
            default:
                show_debug_message("❌ Operação desconhecida: " + string(operacao));
                return false;
        }
    }
    
    return true;
}

/// @function sc_verificar_rede_militar();
/// @description Verifica status de toda a rede militar
/// @return {struct} Status completo da rede militar

function sc_verificar_rede_militar() {
    var _rede_militar = {
        quartel: {existe: false, operacional: false, unidades: 0},
        marinha: {existe: false, operacional: false, unidades: 0},
        aeroporto: {existe: false, operacional: false, unidades: 0},
        total_unidades: 0,
        capacidade_total: 0
    };
    
    // Verifica quartel
    var _quartel = instance_find(obj_quartel, 0);
    if (instance_exists(_quartel)) {
        with (_quartel) {
            _rede_militar.quartel.existe = true;
            _rede_militar.quartel.operacional = (hp_atual > 0);
            _rede_militar.quartel.unidades = unidades_produzidas;
            _rede_militar.capacidade_total += capacidade_producao;
        }
    }
    
    // Verifica marinha
    var _marinha = instance_find(obj_marinha, 0);
    if (instance_exists(_marinha)) {
        with (_marinha) {
            _rede_militar.marinha.existe = true;
            _rede_militar.marinha.operacional = (hp_atual > 0);
            _rede_militar.marinha.unidades = unidades_produzidas;
            _rede_militar.capacidade_total += capacidade_producao;
        }
    }
    
    // Verifica aeroporto
    var _aeroporto = instance_find(obj_aeroporto_militar, 0);
    if (instance_exists(_aeroporto)) {
        with (_aeroporto) {
            _rede_militar.aeroporto.existe = true;
            _rede_militar.aeroporto.operacional = (hp_atual > 0);
            _rede_militar.aeroporto.unidades = unidades_produzidas;
            _rede_militar.capacidade_total += capacidade_producao;
        }
    }
    
    // Conta unidades totais
    _rede_militar.total_unidades = _rede_militar.quartel.unidades + _rede_militar.marinha.unidades + _rede_militar.aeroporto.unidades;
    
    show_debug_message("🏛️ Rede Militar - Unidades: " + string(_rede_militar.total_unidades) + "/" + string(_rede_militar.capacidade_total));
    return _rede_militar;
}

/// @function sc_manutencao_preventiva();
/// @description Executa manutenção preventiva em todas as instalações

function sc_manutencao_preventiva() {
    var _instalacoes = [obj_quartel, obj_marinha, obj_aeroporto_militar];
    var _manutencoes_realizadas = 0;
    
    for (var i = 0; i < array_length(_instalacoes); i++) {
        var _instalacao = instance_find(_instalacoes[i], 0);
        if (instance_exists(_instalacao)) {
            with (_instalacao) {
                // Reparo preventivo (5% do HP máximo)
                var _reparo_preventivo = hp_max * 0.05;
                hp_atual = min(hp_max, hp_atual + _reparo_preventivo);
                
                // Reset de contadores se necessário
                if (unidades_produzidas >= capacidade_producao * 0.9) {
                    unidades_produzidas = floor(capacidade_producao * 0.8); // Libera 20% da capacidade
                }
                
                _manutencoes_realizadas++;
            }
        }
    }
    
    show_debug_message("🔧 Manutenção preventiva: " + string(_manutencoes_realizadas) + " instalações");
    return _manutencoes_realizadas;
}