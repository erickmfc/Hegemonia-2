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
}
