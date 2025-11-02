// ===============================================
// HEGEMONIA GLOBAL - IA PRESIDENTE 1
// Sistema de Decisão e Execução - REVISADO
// ===============================================

// === TIMER DE DECISÃO ===
timer_decisao--;
if (timer_decisao <= 0) {
    timer_decisao = intervalo_decisao;
    
    // ✅ NOVO: FORÇAR ATAQUE IMEDIATO SE TIVER TROPAS
    // Contar tropas da IA
    var _total_tropas_ia = 0;
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _total_tropas_ia++;
        }
    }
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _total_tropas_ia++;
        }
    }
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _total_tropas_ia++;
        }
    }
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _total_tropas_ia++;
        }
    }
    
    // Se tiver pelo menos 1 tropa, ATACAR IMEDIATAMENTE
    if (_total_tropas_ia >= 1) {
        show_debug_message("⚔️ IA TEM " + string(_total_tropas_ia) + " TROPAS - FORÇANDO ATAQUE!");
        
        // Encontrar inimigo mais próximo (sem limite de distância)
        var _inimigo_mais_proximo = noone;
        var _menor_dist = 999999;
        
        // Procurar QUALQUER inimigo do jogador (nacao_proprietaria == 1)
        with (obj_infantaria) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, other.base_x, other.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _inimigo_mais_proximo = id;
                }
            }
        }
        
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, other.base_x, other.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _inimigo_mais_proximo = id;
                }
            }
        }
        
        // Se encontrou inimigo, ATACAR!
        if (instance_exists(_inimigo_mais_proximo)) {
            show_debug_message("🎯 INIMIGO ENCONTRADO A " + string(round(_menor_dist)) + "px - ATACANDO!");
            
            var _comandos_enviados = 0;
            
            // Comandar TODAS as tropas da IA para atacar
            with (obj_infantaria) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    // ✅ CRÍTICO: Forçar estado "movendo" primeiro para unidades se moverem
                    if (variable_instance_exists(id, "estado")) {
                        estado = "movendo"; // Mudado para "movendo" primeiro
                    }
                    
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _inimigo_mais_proximo.x;
                        destino_y = _inimigo_mais_proximo.y;
                    }
                    
                    // Depois de se mover, atacar
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _inimigo_mais_proximo;
                    }
                    
                    // ✅ CRÍTICO: Forçar modo_ataque = true para atacar automaticamente
                    if (variable_instance_exists(id, "modo_ataque")) {
                        modo_ataque = true;
                    }
                    
                    _comandos_enviados++;
                    show_debug_message("🤖 COMANDO IA: Infantaria ID:" + string(id) + " Estado:" + estado + " Destino:(" + string(destino_x) + "," + string(destino_y) + ")");
                }
            }
            
            with (obj_tanque) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    // ✅ CRÍTICO: Forçar estado "movendo" primeiro
                    if (variable_instance_exists(id, "estado")) {
                        estado = "movendo";
                    }
                    
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _inimigo_mais_proximo.x;
                        destino_y = _inimigo_mais_proximo.y;
                    }
                    
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _inimigo_mais_proximo;
                    }
                    
                    if (variable_instance_exists(id, "modo_ataque")) {
                        modo_ataque = true;
                    }
                    
                    _comandos_enviados++;
                    show_debug_message("🤖 COMANDO IA: Tanque ID:" + string(id) + " Estado:" + estado);
                }
            }
            
            with (obj_soldado_antiaereo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    if (variable_instance_exists(id, "estado")) {
                        estado = "movendo";
                    }
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _inimigo_mais_proximo.x;
                        destino_y = _inimigo_mais_proximo.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _inimigo_mais_proximo;
                    }
                    if (variable_instance_exists(id, "modo_ataque")) {
                        modo_ataque = true;
                    }
                    _comandos_enviados++;
                }
            }
            
            with (obj_blindado_antiaereo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    if (variable_instance_exists(id, "estado")) {
                        estado = "movendo";
                    }
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _inimigo_mais_proximo.x;
                        destino_y = _inimigo_mais_proximo.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _inimigo_mais_proximo;
                    }
                    if (variable_instance_exists(id, "modo_ataque")) {
                        modo_ataque = true;
                    }
                    _comandos_enviados++;
                }
            }
            
            show_debug_message("✅ " + string(_comandos_enviados) + " UNIDADES COMANDADAS PARA ATACAR!");
            // ✅ REMOVIDO: exit; - Deixar continuar para outras decisões se necessário
        } else {
            show_debug_message("⚠️ Nenhum inimigo encontrado para atacar");
        }
    }
    
    // 1. VERIFICAR ESTADO DO JOGO E TOMAR DECISÃO
    var _decisao = scr_ia_decisao_economia(id);
    
    // 2. EXECUTAR DECISÃO
    switch (_decisao) {
        case "construir_economia":
            // ✅ NOVO: Usar posicionamento estratégico (não grudado)
            var _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "economia", 300);
            var _sucesso = scr_ia_construir(id, obj_fazenda, _pos_estrategica.x, _pos_estrategica.y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir fazenda");
            }
            break;
            
        case "construir_mina":
            // ✅ NOVO: Posicionamento estratégico
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "economia", 280);
            _sucesso = scr_ia_construir(id, obj_mina, _pos_estrategica.x, _pos_estrategica.y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir mina");
            }
            break;
            
        case "construir_militar":
            // ✅ NOVO: Quartel em posição estratégica (bem espaçado)
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "militar", 350);
            _sucesso = scr_ia_construir(id, obj_quartel, _pos_estrategica.x, _pos_estrategica.y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir quartel");
            }
            break;
            
        case "construir_naval":
            // ✅ NOVO: Quartel naval estrategicamente posicionado
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "naval", 400);
            _sucesso = scr_ia_construir(id, obj_quartel_marinha, _pos_estrategica.x, _pos_estrategica.y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir quartel naval");
            }
            break;
            
        case "construir_aereo":
            // ✅ NOVO: Aeroporto em posição estratégica (bem espaçado)
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "aereo", 450);
            _sucesso = scr_ia_construir(id, obj_aeroporto_militar, _pos_estrategica.x, _pos_estrategica.y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir aeroporto");
            }
            break;
            
        case "expandir_economia":
            // ✅ NOVO: Expandir com posicionamento estratégico
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "economia", 320);
            _sucesso = scr_ia_construir(id, obj_fazenda, _pos_estrategica.x, _pos_estrategica.y);
            break;
            
        case "recrutar_unidades":
            // Recrutar unidades usando o sistema automático - PRODUZIR MAIS
            _sucesso = scr_ia_recrutar_unidade(id, obj_infantaria, 8); // AUMENTADO de 5 para 8
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode recrutar unidades (sem recursos ou quartel ocupado)");
            }
            break;
            
        case "atacar":
            // Primeiro formar esquadrão se ainda não formou
            if (!esquadrao_formando) {
                var _esquadrao_formado = scr_ia_formar_esquadrao(id);
                if (_esquadrao_formado) {
                    show_debug_message("📋 IA formou esquadrão de ataque, iniciando ataque...");
                    scr_ia_atacar(id); // Atacar com esquadrão formado
                } else {
                    show_debug_message("⚠️ IA não pode atacar - esquadrão insuficiente");
                }
            } else {
                // Esquadrão já formado, apenas atacar
                show_debug_message("⚔️ IA atacando com esquadrão existente...");
                scr_ia_atacar(id);
            }
            break;
            
        case "defender":
            // ✅ NOVO: Defesa já foi executada em scr_ia_decisao_economia
            // Apenas confirmar
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("✅ IA em modo defesa - contra-ataque em curso");
            }
            break;
            
        case "expandir":
        default:
            // Nenhuma ação específica - IA em modo passivo/expansão
            show_debug_message("🗺️ IA em modo expansão (aguardando recursos para próxima ação)");
            break;
    }
}

// === ATUALIZAR CONTADORES PERIÓDICAMENTE ===
// Atualizar contadores de estruturas e unidades a cada 30 frames
counter_update++;

if (counter_update % 30 == 0) {
    unidades_totais = 0;
    estruturas_totais = 0;
    
    // Contar unidades
    with (obj_infantaria) if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) other.unidades_totais++;
    with (obj_tanque) if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) other.unidades_totais++;
    with (obj_blindado_antiaereo) if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) other.unidades_totais++;
    
    // Contar estruturas
    with (obj_fazenda) if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) other.estruturas_totais++;
    with (obj_quartel) if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) other.estruturas_totais++;
    with (obj_quartel_marinha) if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) other.estruturas_totais++;
    
    // ✅ ATAQUE CONTÍNUO - Executar A CADA 30 FRAMES (não só quando timer acaba)
    // Isso garante que tropas da IA sempre recebem comandos atualizados
    var _tropas_ia_agora = 0;
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _tropas_ia_agora++;
        }
    }
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _tropas_ia_agora++;
        }
    }
    
    if (_tropas_ia_agora >= 1) {
        // Encontrar inimigo mais próximo
        var _inimigo = noone;
        var _menor_dist = 999999;
        
        with (obj_infantaria) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, other.base_x, other.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _inimigo = id;
                }
            }
        }
        
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, other.base_x, other.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _inimigo = id;
                }
            }
        }
        
        if (instance_exists(_inimigo)) {
            // Comandar tropas continuamente
            with (obj_infantaria) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    // ✅ Verificar se precisa atualizar comando (só se destino mudou significativamente)
                    var _dist_destino_atual = 0;
                    if (variable_instance_exists(id, "destino_x") && variable_instance_exists(id, "destino_y")) {
                        _dist_destino_atual = point_distance(destino_x, destino_y, _inimigo.x, _inimigo.y);
                    }
                    
                    // Atualizar apenas se destino mudou muito ou não tem destino
                    if (_dist_destino_atual > 100 || !variable_instance_exists(id, "destino_x")) {
                        estado = "movendo";
                        destino_x = _inimigo.x;
                        destino_y = _inimigo.y;
                        modo_ataque = true;
                        alvo = _inimigo;
                    }
                }
            }
            
            with (obj_tanque) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    var _dist_destino_atual = 0;
                    if (variable_instance_exists(id, "destino_x") && variable_instance_exists(id, "destino_y")) {
                        _dist_destino_atual = point_distance(destino_x, destino_y, _inimigo.x, _inimigo.y);
                    }
                    
                    if (_dist_destino_atual > 100 || !variable_instance_exists(id, "destino_x")) {
                        estado = "movendo";
                        destino_x = _inimigo.x;
                        destino_y = _inimigo.y;
                        modo_ataque = true;
                        alvo = _inimigo;
                    }
                }
            }
        }
    }
}
