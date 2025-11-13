/// @description Executa o Plano de Defesa quando o país entra em guerra
/// @param {real} _ia_id ID da IA
/// @return {struct} {plano_ativo: bool, fase_atual: FasePlanoDefesa, acoes_executadas: array}
function scr_ia_plano_defesa(_ia_id) {
    if (!instance_exists(_ia_id)) {
        return {
            plano_ativo: false,
            fase_atual: FasePlanoDefesa.DETECCAO,
            acoes_executadas: []
        };
    }
    
    var _ia = _ia_id;
    
    // === DETECTAR GUERRA ===
    var _dados_guerra = scr_ia_detectar_guerra(_ia);
    
    // Inicializar variáveis do plano se não existirem
    if (!variable_instance_exists(_ia, "plano_defesa_ativo")) {
        _ia.plano_defesa_ativo = false;
    }
    if (!variable_instance_exists(_ia, "fase_plano_defesa")) {
        _ia.fase_plano_defesa = FasePlanoDefesa.DETECCAO;
    }
    if (!variable_instance_exists(_ia, "timer_plano_defesa")) {
        _ia.timer_plano_defesa = 0;
    }
    
    var _resultado = {
        plano_ativo: false,
        fase_atual: _ia.fase_plano_defesa,
        acoes_executadas: []
    };
    
    // === ATIVAR PLANO SE EM GUERRA ===
    if (_dados_guerra.em_guerra && !_ia.plano_defesa_ativo) {
        _ia.plano_defesa_ativo = true;
        _ia.fase_plano_defesa = FasePlanoDefesa.DETECCAO;
        _ia.timer_plano_defesa = 0;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🚨 PLANO DE DEFESA ATIVADO! Estado: " + string(_dados_guerra.estado_guerra) + " | Tipo: " + _dados_guerra.tipo_guerra);
        }
    }
    
    // === EXECUTAR PLANO SE ATIVO ===
    if (_ia.plano_defesa_ativo) {
        _resultado.plano_ativo = true;
        _resultado.fase_atual = _ia.fase_plano_defesa;
        _ia.timer_plano_defesa++;
        
        switch (_ia.fase_plano_defesa) {
            case FasePlanoDefesa.DETECCAO:
                // Fase 1: Detectar ameaças e avaliar situação
                var _dados_ataque = scr_ia_detectar_ataque(_ia);
                
                if (_dados_ataque.sendo_atacada || _dados_guerra.unidades_em_combate > 0) {
                    // Mover para preparação
                    _ia.fase_plano_defesa = FasePlanoDefesa.PREPARACAO;
                    _ia.timer_plano_defesa = 0;
                    array_push(_resultado.acoes_executadas, "detecção_completa");
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("📊 DETECÇÃO: " + string(_dados_guerra.unidades_em_combate) + " unidades em combate");
                    }
                }
                break;
                
            case FasePlanoDefesa.PREPARACAO:
                // Fase 2: Preparar defesas
                // - Posicionar unidades em defesa
                // - Recrutar unidades se necessário
                // - Construir estruturas defensivas
                
                // Posicionar defesa
                scr_ia_posicionar_defesa(_ia);
                array_push(_resultado.acoes_executadas, "posicionamento_defesa");
                
                // Verificar se precisa recrutar
                var _total_unidades = 0;
                with (obj_infantaria) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                        _total_unidades++;
                    }
                }
                with (obj_tanque) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                        _total_unidades++;
                    }
                }
                
                if (_total_unidades < 10 && variable_global_exists("ia_dinheiro") && global.ia_dinheiro >= 500) {
                    // Recrutar unidades de emergência
                    scr_ia_recrutar_unidade(_ia, obj_infantaria, 3);
                    array_push(_resultado.acoes_executadas, "recrutamento_emergencia");
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("⚡ RECRUTAMENTO DE EMERGÊNCIA: 3 unidades");
                    }
                }
                
                // Após 2 segundos, mover para defesa ativa
                if (_ia.timer_plano_defesa >= 120) {
                    _ia.fase_plano_defesa = FasePlanoDefesa.DEFESA_ATIVA;
                    _ia.timer_plano_defesa = 0;
                }
                break;
                
            case FasePlanoDefesa.DEFESA_ATIVA:
                // Fase 3: Defender posições ativamente
                // - Manter unidades em posições defensivas
                // - Responder a ataques
                // - Proteger estruturas importantes
                
                scr_ia_resposta_ataque_presidente(_ia);
                array_push(_resultado.acoes_executadas, "defesa_ativa");
                
                // Verificar se pode contra-atacar
                if (_dados_guerra.unidades_atacando >= 3 && _dados_guerra.unidades_em_combate < 5) {
                    // Tem vantagem numérica, pode contra-atacar
                    _ia.fase_plano_defesa = FasePlanoDefesa.CONTRA_ATAQUE;
                    _ia.timer_plano_defesa = 0;
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("⚔️ CONTRA-ATAQUE: Vantagem numérica detectada");
                    }
                }
                break;
                
            case FasePlanoDefesa.CONTRA_ATAQUE:
                // Fase 4: Contra-atacar
                // - Formar esquadrões ofensivos
                // - Atacar alvos inimigos
                // - Expandir território conquistado
                
                // Formar esquadrão de contra-ataque
                if (!variable_instance_exists(_ia, "esquadrao_formando") || !_ia.esquadrao_formando) {
                    var _esquadrao_formado = scr_ia_formar_esquadrao(_ia);
                    if (_esquadrao_formado) {
                        array_push(_resultado.acoes_executadas, "esquadrao_formado");
                    }
                }
                
                // Atacar
                scr_ia_atacar(_ia);
                array_push(_resultado.acoes_executadas, "contra_ataque");
                
                // Verificar se guerra acabou
                if (!_dados_guerra.em_guerra || _dados_guerra.unidades_em_combate == 0) {
                    _ia.fase_plano_defesa = FasePlanoDefesa.CONSOLIDACAO;
                    _ia.timer_plano_defesa = 0;
                }
                break;
                
            case FasePlanoDefesa.CONSOLIDACAO:
                // Fase 5: Consolidar vitória
                // - Reposicionar unidades
                // - Reparar estruturas
                // - Preparar para próxima fase
                
                // Após 5 segundos, desativar plano
                if (_ia.timer_plano_defesa >= 300) {
                    _ia.plano_defesa_ativo = false;
                    _ia.fase_plano_defesa = FasePlanoDefesa.DETECCAO;
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("✅ PLANO DE DEFESA CONCLUÍDO - Retornando ao normal");
                    }
                }
                break;
        }
    } else if (!_dados_guerra.em_guerra && _ia.plano_defesa_ativo) {
        // Guerra acabou, desativar plano
        _ia.plano_defesa_ativo = false;
        _ia.fase_plano_defesa = FasePlanoDefesa.DETECCAO;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🕊️ PAZ RESTAURADA - Plano de defesa desativado");
        }
    }
    
    return _resultado;
}
