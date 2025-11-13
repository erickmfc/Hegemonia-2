// ===============================================
// HEGEMONIA GLOBAL - IA PRESIDENTE 1
// Sistema de Decisão e Execução - REVISADO
// ===============================================

// === VERIFICAÇÃO: NÃO PERMITIR NO MAPA2 ===
var _room_name = room_get_name(room);
if (_room_name == "mapa2") {
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🗑️ obj_presidente_1 detectado no mapa2 no Step - AUTO-DESTRUINDO");
    }
    instance_destroy();
    exit;
}

// ✅ CORREÇÃO CRÍTICA: Garantir que o presidente NUNCA se move
// O presidente é um marcador fixo da IA - sempre fica onde foi colocado no mapa
// ✅ FORÇAR: Sempre manter na posição base (SEM EXCEÇÕES)
if (variable_instance_exists(id, "base_x") && variable_instance_exists(id, "base_y")) {
    // ✅ SEMPRE forçar posição base - não apenas verificar
    var _foi_movido = (abs(x - base_x) > 0.1 || abs(y - base_y) > 0.1);
    if (_foi_movido) {
        show_debug_message("⚠️ CORREÇÃO: Presidente foi movido de (" + string(x) + ", " + string(y) + ") para base (" + string(base_x) + ", " + string(base_y) + ")");
        x = base_x;
        y = base_y;
    } else {
        // ✅ GARANTIR: Mesmo se não foi movido, forçar posição (proteção extra)
        x = base_x;
        y = base_y;
    }
} else {
    // ✅ Se base_x/base_y não existem, criar agora
    base_x = x;
    base_y = y;
    show_debug_message("⚠️ AVISO: base_x/base_y não existiam, criados agora com (" + string(base_x) + ", " + string(base_y) + ")");
}

// ✅ NOVO: Re-identificar território se ainda não foi identificado ou se não tem costa
// Executar apenas uma vez por segundo para não sobrecarregar
if (!variable_instance_exists(id, "timer_identificacao_territorio")) {
    timer_identificacao_territorio = 0;
}
timer_identificacao_territorio++;

// Tentar identificar a cada 60 frames (1 segundo)
if (timer_identificacao_territorio >= 60) {
    timer_identificacao_territorio = 0;
    
    if (!variable_instance_exists(id, "territorio_identificado") || !territorio_identificado) {
        if (variable_global_exists("map_grid") && is_array(global.map_grid)) {
            if (!variable_instance_exists(id, "tiles_territorio")) {
                tiles_territorio = ds_list_create();
            }
            if (!variable_instance_exists(id, "posicoes_costa")) {
                posicoes_costa = ds_list_create();
            }
            
            // ✅ SEGURANÇA: Verificar se o script existe antes de chamar
            var _script_index = asset_get_index("scr_ia_identificar_territorio");
            if (_script_index != -1 && asset_get_type(_script_index) == asset_script) {
                tiles_territorio = scr_ia_identificar_territorio(id);
                if (ds_list_size(tiles_territorio) > 0) {
                    posicoes_costa = scr_ia_encontrar_costa(id, tiles_territorio);
                    territorio_identificado = true;
                    show_debug_message("✅ Território e costa identificados para IA!");
                }
            }
        }
    } else if (variable_instance_exists(id, "posicoes_costa") && ds_list_size(posicoes_costa) == 0) {
        // Se não tem costa, tentar re-identificar
        if (variable_global_exists("map_grid") && is_array(global.map_grid)) {
            var _script_index = asset_get_index("scr_ia_identificar_territorio");
            if (_script_index != -1 && asset_get_type(_script_index) == asset_script) {
                tiles_territorio = scr_ia_identificar_territorio(id);
                if (ds_list_size(tiles_territorio) > 0) {
                    posicoes_costa = scr_ia_encontrar_costa(id, tiles_territorio);
                    show_debug_message("🔄 IA re-identificou território e costa (não tinha costa antes)");
                }
            }
        }
    }
}

// === SISTEMA DE PLANOS ESTRATÉGICOS ===
// Verificar se país entrou em guerra e executar Plano de Defesa
var _plano_defesa = scr_ia_plano_defesa(id);

// Se plano de defesa está ativo, priorizar defesa sobre outras ações
if (_plano_defesa.plano_ativo) {
    // Cancelar ações ofensivas se em defesa crítica
    if (_plano_defesa.fase_atual == FasePlanoDefesa.DEFESA_ATIVA || 
        _plano_defesa.fase_atual == FasePlanoDefesa.PREPARACAO) {
        esquadrao_formando = false;
        alvo_atual = noone;
    }
}

// === SISTEMA DE DEFESA DO PRESIDENTE ===
// Executar sistema de defesa antes de qualquer decisão ofensiva
if (global.defesa_presidente_ativa) {
    ultima_verificacao_defesa++;
    if (ultima_verificacao_defesa >= intervalo_verificacao_defesa) {
        ultima_verificacao_defesa = 0;
        
        // Chamar função principal de defesa
        var _analise_defesa = scr_ia_defesa_presidente(id);
        
        // ✅ PROTEÇÃO: Verificar se a função retornou uma estrutura válida
        if (is_struct(_analise_defesa)) {
            // Atualizar estado de alerta
            if (variable_struct_exists(_analise_defesa, "estado_alerta")) {
                estado_alerta = _analise_defesa.estado_alerta;
            }
            
            // Processar resposta baseada no estado de alerta
            if (estado_alerta == EstadoAlerta.EMERGENCIA) {
                // Cancelar todos os ataques e focar apenas em defesa
                esquadrao_formando = false;
                alvo_atual = noone;
                scr_ia_resposta_ataque_presidente(id);
            } else if (estado_alerta == EstadoAlerta.CRITICO) {
                // Manter 70% unidades em defesa
                scr_ia_posicionar_defesa(id);
            } else if (estado_alerta == EstadoAlerta.ALERTA) {
                // Manter 30% unidades em defesa
                scr_ia_posicionar_defesa(id);
            }
            // NORMAL: 10% unidades em defesa (gerenciado automaticamente)
            
            // Verificar se precisa de reforços
            if (variable_struct_exists(_analise_defesa, "precisa_reforcos") && _analise_defesa.precisa_reforcos) {
                var _prioridade_defesa = scr_ia_priorizar_recursos_defesa(id);
            }
        } else {
            // ✅ FALLBACK: Se a função não retornou estrutura válida, manter estado atual
            // (evita erros se os scripts ainda não foram implementados completamente)
        }
    }
}

// === TIMER DE DECISÃO ===
timer_decisao--;
if (timer_decisao <= 0) {
    timer_decisao = intervalo_decisao;
    
    // ✅ CORRIGIDO: Removido código duplicado - usar scr_ia_atacar() em vez disso
    // A lógica de ataque agora está centralizada em scr_ia_atacar.gml
    
    // ⚠️ VERIFICAR ESTADO DE ALERTA ANTES DE TOMAR DECISÕES OFENSIVAS
    if (estado_alerta == EstadoAlerta.EMERGENCIA) {
        // Em emergência, não tomar decisões ofensivas
        show_debug_message("🚨 EMERGÊNCIA: Presidente sob ataque - cancelando ações ofensivas");
    } else {
        // 1. VERIFICAR ESTADO DO JOGO E TOMAR DECISÃO
        var _decisao = scr_ia_decisao_economia(id);
        show_debug_message("🤖 IA DECISÃO: " + _decisao);
    
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
            // ✅ MELHORADO: Lógica inteligente para recrutar diferentes tipos de unidades
            // Prioridade: Aéreas > Navais > Terrestres (se tiver infraestrutura)
            
            // 1. Verificar aeroporto e recrutar unidades aéreas
            var _tem_aeroporto = false;
            var _aeroporto_ia = noone;
            with (obj_aeroporto_militar) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    _tem_aeroporto = true;
                    _aeroporto_ia = id;
                    break;
                }
            }
            
            if (_tem_aeroporto) {
                // ✅ NOVO: Recrutar diferentes tipos de aviões baseado em recursos
                var _tipo_aereo = noone;
                var _quantidade_aereo = 1;
                
                // Escolher tipo de avião baseado em recursos disponíveis
                if (global.ia_dinheiro >= 5000 && global.ia_minerio >= 2500 && object_exists(obj_Independence)) {
                    // Independence (mais caro, mas poderoso)
                    _tipo_aereo = obj_Independence;
                    _quantidade_aereo = 1;
                } else if (global.ia_dinheiro >= 3000 && global.ia_minerio >= 1500 && object_exists(obj_f6)) {
                    // F6 (bom custo-benefício)
                    _tipo_aereo = obj_f6;
                    _quantidade_aereo = 2;
                } else if (global.ia_dinheiro >= 2000 && global.ia_minerio >= 1000 && object_exists(obj_f15)) {
                    // F15
                    _tipo_aereo = obj_f15;
                    _quantidade_aereo = 2;
                } else if (global.ia_dinheiro >= 1500 && global.ia_minerio >= 500 && object_exists(obj_caca_f5)) {
                    // F5 (mais barato)
                    _tipo_aereo = obj_caca_f5;
                    _quantidade_aereo = 3;
                } else if (global.ia_dinheiro >= 800 && global.ia_minerio >= 300 && object_exists(obj_helicoptero_militar)) {
                    // Helicóptero (mais barato)
                    _tipo_aereo = obj_helicoptero_militar;
                    _quantidade_aereo = 2;
                }
                
                if (_tipo_aereo != noone && object_exists(_tipo_aereo)) {
                    // ✅ NOVO: Verificar se aeroporto tem sistema de recrutamento
                    // Tentar recrutar diretamente (pode precisar de script específico)
                    _sucesso = scr_ia_recrutar_unidade(id, _tipo_aereo, _quantidade_aereo);
                    if (_sucesso) {
                        show_debug_message("✈️ IA recrutou " + string(_quantidade_aereo) + "x unidade aérea!");
                    } else {
                        show_debug_message("⚠️ IA não pode recrutar unidades aéreas (sem recursos ou aeroporto ocupado)");
                    }
                }
                
                // Se recrutou aéreo, sair
                if (_sucesso) break;
            }
            
            // 2. Verificar quartel naval e recrutar unidades navais
            var _tem_quartel_naval = false;
            var _quartel_naval_ia = noone;
            with (obj_quartel_marinha) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    _tem_quartel_naval = true;
                    _quartel_naval_ia = id;
                    break;
                }
            }
            
            if (_tem_quartel_naval) {
                // ✅ MELHORADO: Recrutar diferentes tipos de navios baseado em recursos
                var _tipo_naval = noone;
                var _quantidade_naval = 1;
                
                // Escolher tipo de navio baseado em recursos disponíveis
                if (global.ia_dinheiro >= 5000 && global.ia_minerio >= 2500 && object_exists(obj_Independence)) {
                    // Independence (porta-aviões)
                    _tipo_naval = obj_Independence;
                    _quantidade_naval = 1;
                } else if (global.ia_dinheiro >= 2500 && global.ia_minerio >= 1200 && object_exists(obj_Constellation)) {
                    // Constellation (cruzador)
                    _tipo_naval = obj_Constellation;
                    _quantidade_naval = 1;
                } else if (global.ia_dinheiro >= 2000 && global.ia_minerio >= 1000 && object_exists(obj_submarino_base)) {
                    // Submarino
                    _tipo_naval = obj_submarino_base;
                    _quantidade_naval = 1;
                } else {
                    // Verificar fragata e destroyer
                    var _obj_fragata = asset_get_index("obj_fragata");
                    var _obj_destroyer = asset_get_index("obj_destroyer");
                    
                    if (_obj_destroyer != -1 && asset_get_type(_obj_destroyer) == asset_object && 
                        global.ia_dinheiro >= 1500 && global.ia_minerio >= 750) {
                        // Destroyer
                        _tipo_naval = _obj_destroyer;
                        _quantidade_naval = 1;
                    } else if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object && 
                               global.ia_dinheiro >= 800 && global.ia_minerio >= 400) {
                        // Fragata
                        _tipo_naval = _obj_fragata;
                        _quantidade_naval = 2;
                    } else if (global.ia_dinheiro >= 1000 && global.ia_minerio >= 500 && object_exists(obj_navio_base)) {
                        // Navio Base
                        _tipo_naval = obj_navio_base;
                        _quantidade_naval = 1;
                    } else if (global.ia_dinheiro >= 50 && object_exists(obj_lancha_patrulha)) {
                        // Lancha Patrulha (mais barata)
                        _tipo_naval = obj_lancha_patrulha;
                        _quantidade_naval = 3;
                    }
                }
                
                if (_tipo_naval != noone) {
                    _sucesso = scr_ia_recrutar_unidade(id, _tipo_naval, _quantidade_naval);
                    if (_sucesso) {
                        show_debug_message("🌊 IA recrutou " + string(_quantidade_naval) + "x unidade naval!");
                    } else {
                        show_debug_message("⚠️ IA não pode recrutar unidades navais (sem recursos ou quartel ocupado)");
                    }
                }
                
                // Se recrutou naval, sair
                if (_sucesso) break;
            }
            
            // 3. Fallback: Recrutar unidades terrestres se tiver quartel terrestre
            var _tem_quartel_terrestre = false;
            with (obj_quartel) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    _tem_quartel_terrestre = true;
                    break;
                }
            }
            
            if (_tem_quartel_terrestre) {
                // ✅ MELHORADO: Variar entre diferentes tipos de unidades terrestres
                var _tipo_terrestre = noone;
                var _quantidade_terrestre = 1;
                
                // Escolher tipo baseado em recursos e situação
                if (global.ia_dinheiro >= 600 && global.ia_minerio >= 300 && object_exists(obj_blindado_antiaereo)) {
                    // Blindado Anti-Aéreo (mais caro, mas versátil)
                    _tipo_terrestre = obj_blindado_antiaereo;
                    _quantidade_terrestre = 2;
                } else if (global.ia_dinheiro >= 500 && global.ia_minerio >= 250 && object_exists(obj_tanque)) {
                    // Tanque
                    _tipo_terrestre = obj_tanque;
                    _quantidade_terrestre = 2;
                } else if (global.ia_dinheiro >= 150 && global.ia_minerio >= 50 && object_exists(obj_soldado_antiaereo)) {
                    // Soldado Anti-Aéreo
                    _tipo_terrestre = obj_soldado_antiaereo;
                    _quantidade_terrestre = 3;
                } else if (global.ia_dinheiro >= 100 && object_exists(obj_infantaria)) {
                    // Infantaria (mais barata)
                    _tipo_terrestre = obj_infantaria;
                    _quantidade_terrestre = 4;
                }
                
                if (_tipo_terrestre != noone && object_exists(_tipo_terrestre)) {
                    _sucesso = scr_ia_recrutar_unidade(id, _tipo_terrestre, _quantidade_terrestre);
                    if (_sucesso) {
                        show_debug_message("⚔️ IA recrutou " + string(_quantidade_terrestre) + "x unidade terrestre!");
                    } else {
                        show_debug_message("⚠️ IA não pode recrutar unidades (sem recursos ou quartel ocupado)");
                    }
                }
            } else {
                show_debug_message("⚠️ IA não tem quartel terrestre para recrutar unidades");
            }
            break;
            
        case "recrutar_estrategico":
            // ✅ NOVO: Recrutar unidades estratégicas baseadas na análise do exército do jogador
            var _decisao_estrategica = scr_ia_decisao_unidade_estrategica(id);
            if (_decisao_estrategica.precisa_resposta && _decisao_estrategica.tipo_unidade != "nenhuma") {
                var _tipo_obj = noone;
                
                // Determinar objeto baseado no tipo
                if (_decisao_estrategica.tipo_unidade == "infantaria") {
                    _tipo_obj = obj_infantaria;
                } else if (_decisao_estrategica.tipo_unidade == "tanque") {
                    _tipo_obj = obj_tanque;
                } else if (_decisao_estrategica.tipo_unidade == "soldado_antiaereo") {
                    _tipo_obj = obj_soldado_antiaereo;
                } else if (_decisao_estrategica.tipo_unidade == "blindado_antiaereo") {
                    _tipo_obj = obj_blindado_antiaereo;
                }
                
                if (object_exists(_tipo_obj)) {
                    _sucesso = scr_ia_recrutar_unidade(id, _tipo_obj, _decisao_estrategica.quantidade);
                    if (_sucesso) {
                        show_debug_message("🎯 IA recrutou " + string(_decisao_estrategica.quantidade) + "x " + _decisao_estrategica.tipo_unidade + " - " + _decisao_estrategica.razao);
                    } else {
                        show_debug_message("⚠️ IA não pode recrutar unidades estratégicas (sem recursos ou quartel ocupado)");
                    }
                } else {
                    show_debug_message("❌ ERRO: Tipo de unidade estratégica não encontrado: " + _decisao_estrategica.tipo_unidade);
                }
            }
            break;
            
        case "atacar":
            // ⚠️ VERIFICAR ESTADO DE ALERTA ANTES DE ATACAR
            if (estado_alerta == EstadoAlerta.EMERGENCIA) {
                show_debug_message("🚨 EMERGÊNCIA: Cancelando ataque - presidente sob ameaça crítica");
                break;
            }
            
            // Verificar quais unidades podem atacar (balanceamento ofensiva/defesa)
            var _balanceamento = scr_ia_balanceamento_ofensiva_defesa(id);
            if (is_struct(_balanceamento) && variable_struct_exists(_balanceamento, "unidades_podem_atacar")) {
                var _unidades_ataque = _balanceamento.unidades_podem_atacar;
                if (is_ds_list(_unidades_ataque) && ds_list_size(_unidades_ataque) > 0) {
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
                } else {
                    show_debug_message("⚠️ IA não pode atacar - todas as unidades estão em defesa");
                }
            } else {
                // ✅ FALLBACK: comportamento original se balanceamento não retornar estrutura válida
                // (permite que o sistema funcione mesmo se os scripts de defesa ainda não estiverem completos)
                if (!esquadrao_formando) {
                    var _esquadrao_formado = scr_ia_formar_esquadrao(id);
                    if (_esquadrao_formado) {
                        show_debug_message("📋 IA formou esquadrão de ataque, iniciando ataque...");
                        scr_ia_atacar(id);
                    } else {
                        show_debug_message("⚠️ IA não pode atacar - esquadrão insuficiente");
                    }
                } else {
                    show_debug_message("⚔️ IA atacando com esquadrão existente...");
                    scr_ia_atacar(id);
                }
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
    } // Fim do else do estado de alerta
}

// === ATUALIZAR CONTADORES PERIÓDICAMENTE ===
// Atualizar contadores de estruturas e unidades a cada 30 frames
counter_update++;

if (counter_update % 30 == 0) {
    unidades_totais = 0;
    estruturas_totais = 0;
    
    // ✅ CORRIGIDO: Contar unidades diretamente (sem depender de função externa)
    
    // Contar unidades terrestres
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
            other.unidades_totais++;
        }
    }
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
            other.unidades_totais++;
        }
    }
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
            other.unidades_totais++;
        }
    }
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
            other.unidades_totais++;
        }
    }
    
    // Contar unidades navais
    var _tipos_navais_step = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte, obj_Constellation, obj_Independence, obj_RonaldReagan];
    var _obj_fragata_step = asset_get_index("obj_fragata");
    if (_obj_fragata_step != -1 && asset_get_type(_obj_fragata_step) == asset_object) {
        array_push(_tipos_navais_step, _obj_fragata_step);
    }
    for (var i = 0; i < array_length(_tipos_navais_step); i++) {
        if (!object_exists(_tipos_navais_step[i])) continue;
        with (_tipos_navais_step[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
                other.unidades_totais++;
            }
        }
    }
    
    // Contar unidades aéreas
    var _tipos_aereos_step = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15, obj_su35, obj_c100];
    for (var i = 0; i < array_length(_tipos_aereos_step); i++) {
        if (!object_exists(_tipos_aereos_step[i])) continue;
        with (_tipos_aereos_step[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
                other.unidades_totais++;
            }
        }
    }
    
    // Contar estruturas
    with (obj_fazenda) if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) other.estruturas_totais++;
    with (obj_quartel) if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) other.estruturas_totais++;
    with (obj_quartel_marinha) if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) other.estruturas_totais++;
    
    // ✅ CORRIGIDO: Removido código duplicado de ataque
    // A lógica de ataque contínuo agora está centralizada em scr_ia_atacar.gml
    // Se necessário atualizar comandos periodicamente, chamar scr_ia_atacar(id) aqui
}
