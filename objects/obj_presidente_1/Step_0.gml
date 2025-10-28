// ===============================================
// HEGEMONIA GLOBAL - IA PRESIDENTE 1
// Sistema de Decisão e Execução - REVISADO
// ===============================================

// === TIMER DE DECISÃO ===
timer_decisao--;
if (timer_decisao <= 0) {
    timer_decisao = intervalo_decisao;
    
    // 1. VERIFICAR ESTADO DO JOGO E TOMAR DECISÃO
    var _decisao = scr_ia_decisao_economia(id);
    
    // 2. EXECUTAR DECISÃO
    switch (_decisao) {
        case "construir_economia":
            // Construir fazenda próxima à base
            var _pos_x = base_x + irandom(200) - 100;
            var _pos_y = base_y + irandom(200) - 100;
            var _sucesso = scr_ia_construir(id, obj_fazenda, _pos_x, _pos_y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir fazenda");
            }
            break;
            
        case "construir_mina":
            // Construir mina próxima à base
            _pos_x = base_x + irandom(200) - 100;
            _pos_y = base_y + irandom(200) - 100;
            _sucesso = scr_ia_construir(id, obj_mina, _pos_x, _pos_y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir mina");
            }
            break;
            
        case "construir_militar":
            // Construir quartel terrestre
            _pos_x = base_x + irandom(150) - 75;
            _pos_y = base_y + irandom(150) - 75;
            _sucesso = scr_ia_construir(id, obj_quartel, _pos_x, _pos_y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir quartel");
            }
            break;
            
        case "construir_naval":
            // Construir quartel naval (requer água)
            _pos_x = base_x + irandom(400) - 200;
            _pos_y = base_y + irandom(400) - 200;
            _sucesso = scr_ia_construir(id, obj_quartel_marinha, _pos_x, _pos_y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir quartel naval");
            }
            break;
            
        case "construir_aereo":
            // Construir aeroporto militar
            _pos_x = base_x + irandom(300) - 150;
            _pos_y = base_y + irandom(300) - 150;
            _sucesso = scr_ia_construir(id, obj_aeroporto_militar, _pos_x, _pos_y);
            if (!_sucesso) {
                show_debug_message("⚠️ IA não pode construir aeroporto");
            }
            break;
            
        case "expandir_economia":
            // Continuar construindo fazendas
            _pos_x = base_x + irandom(300) - 150;
            _pos_y = base_y + irandom(300) - 150;
            _sucesso = scr_ia_construir(id, obj_fazenda, _pos_x, _pos_y);
            break;
            
        case "recrutar_unidades":
            // Recrutar unidades usando o sistema automático
            _sucesso = scr_ia_recrutar_unidade(id, obj_infantaria, 5);
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
}
