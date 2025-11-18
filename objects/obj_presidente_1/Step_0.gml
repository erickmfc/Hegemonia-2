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

// === ✅ CORREÇÃO GM2043: Garantir que variáveis de instância existam ===
if (!variable_instance_exists(id, "_sucesso")) {
    _sucesso = false;
}
if (!variable_instance_exists(id, "_pos_estrategica")) {
    _pos_estrategica = noone;
}

// === ✅ NOVO - FASE 4: Processar Ataques Coordenados ===
// ✅ CORREÇÃO: Verificar se há ataque coordenado em andamento antes de processar
if (!variable_instance_exists(id, "timer_ataque_coordenado")) {
    timer_ataque_coordenado = 0;
}
if (timer_ataque_coordenado > 0) {
    // Executar ataque coordenado diretamente (lógica inline para evitar erro de função não encontrada)
    var _script_executar = asset_get_index("scr_ia_ataque_coordenado");
    if (_script_executar != -1) {
        scr_ia_executar_ataque_coordenado(id);
    }
    timer_ataque_coordenado--;
}

// === ✅ NOVO - FASE 7: Monitorar Performance ===
if (!variable_instance_exists(id, "timer_monitor_performance")) {
    timer_monitor_performance = 0;
}
timer_monitor_performance++;
if (timer_monitor_performance >= 600) { // A cada 10 segundos
    timer_monitor_performance = 0;
    // ✅ CORREÇÃO: Verificar se script existe antes de chamar
    var _script_monitorar = asset_get_index("scr_ia_monitorar_performance");
    if (_script_monitorar != -1) {
        scr_ia_monitorar_performance(id);
    } else {
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚠️ scr_ia_monitorar_performance não encontrado!");
        }
    }
}

// === ✅ NOVO - FASE 4: Reposicionar Unidades Órfãs ===
if (!variable_instance_exists(id, "timer_reposicionar_unidades")) {
    timer_reposicionar_unidades = 0;
}
timer_reposicionar_unidades++;
if (timer_reposicionar_unidades >= 180) { // A cada 3 segundos
    timer_reposicionar_unidades = 0;
    
    // ✅ CORREÇÃO: Verificar se script existe antes de chamar funções
    var _script_comando = asset_get_index("scr_ia_comando_unidades");
    if (_script_comando != -1) {
        // === REPOSICIONAR AVIÕES SEM COMANDO ===
        with (obj_f15) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                    var _script_ataque = asset_get_index("scr_ia_ataque_coordenado");
                    if (_script_ataque != -1) {
                        var _alvo = scr_ia_encontrar_alvo_prioritario();
                        if (_alvo != noone) {
                            alvo = _alvo;
                            x_destino = _alvo.x;
                            y_destino = _alvo.y;
                            if (variable_instance_exists(id, "em_movimento")) {
                                em_movimento = true;
                            }
                        }
                    }
                }
            }
        }
        
        // === REPOSICIONAR TANQUES SEM COMANDO ===
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                    var _script_ataque = asset_get_index("scr_ia_ataque_coordenado");
                    if (_script_ataque != -1) {
                        var _alvo = scr_ia_encontrar_alvo_prioritario();
                        if (_alvo != noone) {
                            alvo = _alvo;
                            x_destino = _alvo.x;
                            y_destino = _alvo.y;
                            if (variable_instance_exists(id, "em_movimento")) {
                                em_movimento = true;
                            }
                        }
                    }
                }
            }
        }
        
        // === VERIFICAR UNIDADES BLOQUEADAS ===
        var _unidades_bloqueadas = 0;
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                if (variable_instance_exists(id, "x") && variable_instance_exists(id, "y") &&
                    variable_instance_exists(id, "x_destino") && variable_instance_exists(id, "y_destino")) {
                    
                    var _dist = point_distance(x, y, x_destino, y_destino);
                    
                    // Se está muito perto do destino mas ainda com ordem de movimento
                    if (_dist < 50 && variable_instance_exists(id, "em_movimento") && em_movimento) {
                        // ✅ CORREÇÃO: Usar random_range() em vez de random() com dois argumentos
                        // Pode estar bloqueado por colisão - tentar se desviar
                        x = x + random_range(-30, 30);
                        y = y + random_range(-30, 30);
                    }
                }
            }
        }
    }
}

// === SISTEMA DE PLANOS ESTRATÉGICOS ===
// ✅ OTIMIZAÇÃO: Verificar apenas a cada 2 segundos (120 frames)
if (!variable_instance_exists(id, "timer_plano_estrategico")) {
    timer_plano_estrategico = 0;
}
timer_plano_estrategico++;
if (timer_plano_estrategico >= 120) {
    timer_plano_estrategico = 0;
    
    // Verificar se país entrou em guerra e executar Plano de Defesa
    var _plano_defesa = scr_ia_plano_defesa(id);

    // ✅ PROTEÇÃO: Verificar se a função retornou uma estrutura válida
    if (is_struct(_plano_defesa)) {
        // Se plano de defesa está ativo, priorizar defesa sobre outras ações
        if (variable_struct_exists(_plano_defesa, "plano_ativo") && _plano_defesa.plano_ativo) {
            // Cancelar ações ofensivas se em defesa crítica
            if (variable_struct_exists(_plano_defesa, "fase_atual") && 
                (_plano_defesa.fase_atual == FasePlanoDefesa.DEFESA_ATIVA || 
                 _plano_defesa.fase_atual == FasePlanoDefesa.PREPARACAO)) {
                esquadrao_formando = false;
                alvo_atual = noone;
            }
        }
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

// === ✅ NOVO - FASE 4: SISTEMA DE COMANDO CONTÍNUO DE UNIDADES ===
// Verificar e comandar unidades órfãs a cada 5 segundos (300 frames)
// + Processar ataques coordenados
if (!variable_instance_exists(id, "timer_comando_unidades")) {
    timer_comando_unidades = 0;
}
timer_comando_unidades++;
if (timer_comando_unidades >= 300) { // 5 segundos
    timer_comando_unidades = 0;
    
    // ✅ NOVO: Comandar unidades órfãs (sem destino/alvo)
    var _script_comando = asset_get_index("scr_ia_comandar_unidades_continuo");
    if (_script_comando != -1 && asset_get_type(_script_comando) == asset_script) {
        var _unidades_comandadas = scr_ia_comandar_unidades_continuo(id);
        if (variable_global_exists("debug_enabled") && global.debug_enabled && _unidades_comandadas > 0) {
            show_debug_message("🤖 IA: " + string(_unidades_comandadas) + " unidades comandadas continuamente");
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
        // ✅ CORREÇÃO GM2043 DEFINITIVA: Variáveis compartilhadas como variáveis de instância
        var _decisao = "";
        // ✅ _pos_estrategica e _sucesso são variáveis de instância (declaradas no Create_0.gml)
        _pos_estrategica = noone; // Resetar valor
        _sucesso = false; // Resetar valor
        var _sucesso_local = false; // ✅ CORREÇÃO GM2044: Declarar UMA VEZ antes do switch
        
        // 1. VERIFICAR ESTADO DO JOGO E TOMAR DECISÃO
        _decisao = scr_ia_decisao_economia(id);
        show_debug_message("🤖 IA DECISÃO: " + _decisao);
    
        // 2. EXECUTAR DECISÃO
        switch (_decisao) {
        case "construir_economia":
            // ✅ NOVO: Usar posicionamento estratégico (não grudado)
            // ✅ CORREÇÃO GM2044: Removido reset - variável já inicializada como false antes do switch
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "economia", 300);
            if (is_struct(_pos_estrategica) && variable_struct_exists(_pos_estrategica, "x") && variable_struct_exists(_pos_estrategica, "y")) {
                _sucesso_local = scr_ia_construir(id, obj_fazenda, _pos_estrategica.x, _pos_estrategica.y);
                if (!_sucesso_local) {
                    show_debug_message("⚠️ IA não pode construir fazenda");
                }
            } else {
                show_debug_message("❌ ERRO: Posição estratégica inválida para fazenda");
            }
            break;
            
        case "construir_mina":
            // ✅ NOVO: Posicionamento estratégico
            // ✅ CORREÇÃO GM2044: Removido reset - variável já inicializada como false antes do switch
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "economia", 280);
            if (is_struct(_pos_estrategica) && variable_struct_exists(_pos_estrategica, "x") && variable_struct_exists(_pos_estrategica, "y")) {
                _sucesso_local = scr_ia_construir(id, obj_mina, _pos_estrategica.x, _pos_estrategica.y);
                if (!_sucesso_local) {
                    show_debug_message("⚠️ IA não pode construir mina");
                }
            } else {
                show_debug_message("❌ ERRO: Posição estratégica inválida para mina");
            }
            break;
            
        case "construir_militar":
            // ✅ NOVO: Quartel em posição estratégica (bem espaçado)
            // ✅ CORREÇÃO GM2044: Removido reset - variável já inicializada como false antes do switch
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "militar", 350);
            if (is_struct(_pos_estrategica) && variable_struct_exists(_pos_estrategica, "x") && variable_struct_exists(_pos_estrategica, "y")) {
                _sucesso_local = scr_ia_construir(id, obj_quartel, _pos_estrategica.x, _pos_estrategica.y);
                if (!_sucesso_local) {
                    show_debug_message("⚠️ IA não pode construir quartel");
                }
            } else {
                show_debug_message("❌ ERRO: Posição estratégica inválida para quartel");
            }
            break;
            
        case "construir_naval":
            // ✅ NOVO: Quartel naval estrategicamente posicionado
            // ✅ CORREÇÃO GM2044: Removido reset - variável já inicializada como false antes do switch
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "naval", 400);
            if (is_struct(_pos_estrategica) && variable_struct_exists(_pos_estrategica, "x") && variable_struct_exists(_pos_estrategica, "y")) {
                _sucesso_local = scr_ia_construir(id, obj_quartel_marinha, _pos_estrategica.x, _pos_estrategica.y);
                if (!_sucesso_local) {
                    show_debug_message("⚠️ IA não pode construir quartel naval");
                }
            } else {
                show_debug_message("❌ ERRO: Posição estratégica inválida para quartel naval");
            }
            break;
            
        case "construir_aereo":
            // ✅ NOVO: Aeroporto em posição estratégica (bem espaçado)
            // ✅ CORREÇÃO GM2044: Removido reset - variável já inicializada como false antes do switch
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "aereo", 450);
            if (is_struct(_pos_estrategica) && variable_struct_exists(_pos_estrategica, "x") && variable_struct_exists(_pos_estrategica, "y")) {
                _sucesso_local = scr_ia_construir(id, obj_aeroporto_militar, _pos_estrategica.x, _pos_estrategica.y);
                if (!_sucesso_local) {
                    show_debug_message("⚠️ IA não pode construir aeroporto");
                }
            } else {
                show_debug_message("❌ ERRO: Posição estratégica inválida para aeroporto");
            }
            break;
            
        case "expandir_economia":
            // ✅ NOVO: Expandir com posicionamento estratégico
            // ✅ CORREÇÃO GM2044: Removido reset - variável já inicializada como false antes do switch
            _pos_estrategica = scr_ia_encontrar_posicao_estrategica(id, "economia", 320);
            if (is_struct(_pos_estrategica) && variable_struct_exists(_pos_estrategica, "x") && variable_struct_exists(_pos_estrategica, "y")) {
                _sucesso_local = scr_ia_construir(id, obj_fazenda, _pos_estrategica.x, _pos_estrategica.y);
            } else {
                show_debug_message("❌ ERRO: Posição estratégica inválida para expandir economia");
            }
            break;
            
        case "recrutar_unidades":
            // ✅ CORREÇÃO GM2043: _sucesso já declarada no início do bloco else (linha 213)
            _sucesso = false; // Resetar valor
            
            // ✅ NOVO - FASE 2: Usar seleção inteligente de unidades
            var _melhor_unidade = scr_ia_selecionar_melhor_unidade(id);
            
            // Se conseguiu melhor unidade, tentar recrutar
            if (_melhor_unidade != noone && object_exists(_melhor_unidade)) {
                
                // Encontrar estrutura apropriada para recrutar
                var _estrutura_recruta = noone;
                
                // Aviões → Aeroporto
                if (_melhor_unidade == obj_f15 || _melhor_unidade == obj_f6 || _melhor_unidade == obj_caca_f5 ||
                    _melhor_unidade == obj_helicoptero_militar) {
                    with (obj_aeroporto_militar) {
                        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                            _estrutura_recruta = id;
                            break;
                        }
                    }
                }
                // Navios → Quartel Naval
                else if (_melhor_unidade == obj_lancha_patrulha || _melhor_unidade == obj_submarino_base ||
                         _melhor_unidade == obj_RonaldReagan || _melhor_unidade == obj_Independence ||
                         _melhor_unidade == obj_Constellation) {
                    with (obj_quartel_marinha) {
                        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                            _estrutura_recruta = id;
                            break;
                        }
                    }
                }
                // Terrestre → Quartel
                else {
                    with (obj_quartel) {
                        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                            _estrutura_recruta = id;
                            break;
                        }
                    }
                }
                
                // Se encontrou estrutura, recrutar
                if (_estrutura_recruta != noone && instance_exists(_estrutura_recruta)) {
                    _estrutura_recruta.unidade_a_recrutar = _melhor_unidade;
                    _sucesso = true;
                    
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("✅ IA Recrutando: " + object_get_name(_melhor_unidade));
                    }
                }
            }
            
            // ✅ CORREÇÃO GM2043: Declarar antes do if para escopo correto
            var _tem_aeroporto = false;
            var _aeroporto_ia = noone;
            
            // FALLBACK: Se seleção inteligente falhar, usar lógica antiga
            if (!_sucesso) {
                // ✅ CORREÇÃO GM2043: Usar variável temporária dentro do with
                var _temp_aeroporto = noone;
                with (obj_aeroporto_militar) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                        _temp_aeroporto = id;
                        break; // ✅ OTIMIZAÇÃO: Parar na primeira encontrada
                    }
                }
                
                // Atribuir após o with
                if (_temp_aeroporto != noone) {
                    _tem_aeroporto = true;
                    _aeroporto_ia = _temp_aeroporto;
                }
            } // Fim do FALLBACK
            
            if (_tem_aeroporto) {
                // ✅ NOVO: Recrutar diferentes tipos de aviões baseado em recursos
                var _tipo_aereo = noone;
                var _quantidade_aereo = 1;
                _sucesso = false; // ✅ CORREÇÃO GM2043: Resetar valor (já declarada no início do case)
                
                // ✅ MELHORADO: Priorizar unidades premium aéreas
                // Escolher tipo de avião baseado em recursos disponíveis
                var _obj_su35 = asset_get_index("obj_su35");
                
                // PRIORIDADE 1: SU-35 Flanker (unidade premium - muito poderosa)
                if (_obj_su35 != -1 && asset_get_type(_obj_su35) == asset_object &&
                    global.ia_dinheiro >= 5900 && global.ia_minerio >= 2950) {
                    _tipo_aereo = _obj_su35;
                    _quantidade_aereo = 1;
                }
                // PRIORIDADE 2: F-15 Eagle (unidade premium)
                else if (global.ia_dinheiro >= 2000 && global.ia_minerio >= 1000 && object_exists(obj_f15)) {
                    _tipo_aereo = obj_f15;
                    _quantidade_aereo = 2;
                }
                // PRIORIDADE 3: Independence (porta-aviões aéreo)
                else if (global.ia_dinheiro >= 5000 && global.ia_minerio >= 2500 && object_exists(obj_Independence)) {
                    _tipo_aereo = obj_Independence;
                    _quantidade_aereo = 1;
                }
                // PRIORIDADE 4: F6 (bom custo-benefício)
                else if (global.ia_dinheiro >= 3000 && global.ia_minerio >= 1500 && object_exists(obj_f6)) {
                    _tipo_aereo = obj_f6;
                    _quantidade_aereo = 2;
                }
                // PRIORIDADE 5: F5 (mais barato)
                else if (global.ia_dinheiro >= 1500 && global.ia_minerio >= 500 && object_exists(obj_caca_f5)) {
                    _tipo_aereo = obj_caca_f5;
                    _quantidade_aereo = 3;
                }
                // FALLBACK: Helicóptero (mais barato)
                else if (global.ia_dinheiro >= 800 && global.ia_minerio >= 300 && object_exists(obj_helicoptero_militar)) {
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
            var _num_quartel_marinha = 0; // ✅ CORREÇÃO: Inicializar contador de quartéis marinhos
            with (obj_quartel_marinha) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
                    _tem_quartel_naval = true;
                    _quartel_naval_ia = id;
                    _num_quartel_marinha++; // ✅ Contar quartéis marinhos da IA
                }
            }
            
            if (_tem_quartel_naval) {
                // ✅ MELHORADO: Recrutar diferentes tipos de navios baseado em recursos
                var _tipo_naval = noone;
                var _quantidade_naval = 1;
                _sucesso = false; // ✅ CORREÇÃO GM2043: Resetar valor (já declarada no início do case)
                
                // ✅ MELHORADO: Priorizar unidades premium navais
                // Escolher tipo de navio baseado em recursos disponíveis
                var _obj_ronald_reagan = asset_get_index("obj_RonaldReagan");
                var _obj_fragata = asset_get_index("obj_fragata");
                var _obj_destroyer = asset_get_index("obj_destroyer");
                
                // PRIORIDADE 1: Ronald Reagan (porta-aviões nuclear - unidade premium máxima)
                if (_obj_ronald_reagan != -1 && asset_get_type(_obj_ronald_reagan) == asset_object &&
                    global.ia_dinheiro >= 12000 && global.ia_minerio >= 6000) {
                    _tipo_naval = _obj_ronald_reagan;
                    _quantidade_naval = 1;
                }
                // PRIORIDADE 2: Independence (porta-aviões)
                else if (global.ia_dinheiro >= 5000 && global.ia_minerio >= 2500 && object_exists(obj_Independence)) {
                    _tipo_naval = obj_Independence;
                    _quantidade_naval = 1;
                }
                // PRIORIDADE 3: Constellation (cruzador avançado)
                else if (global.ia_dinheiro >= 2500 && global.ia_minerio >= 1200 && object_exists(obj_Constellation)) {
                    _tipo_naval = obj_Constellation;
                    _quantidade_naval = 1;
                }
                // PRIORIDADE 4: Destroyer (navio de guerra)
                else if (_obj_destroyer != -1 && asset_get_type(_obj_destroyer) == asset_object && 
                         global.ia_dinheiro >= 1500 && global.ia_minerio >= 750) {
                    _tipo_naval = _obj_destroyer;
                    _quantidade_naval = 1;
                }
                // PRIORIDADE 5: Submarino (furtivo)
                else if (global.ia_dinheiro >= 2000 && global.ia_minerio >= 1000 && object_exists(obj_submarino_base)) {
                    _tipo_naval = obj_submarino_base;
                    _quantidade_naval = 1;
                }
                // PRIORIDADE 6: Fragata
                else if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object && 
                         global.ia_dinheiro >= 800 && global.ia_minerio >= 400) {
                    _tipo_naval = _obj_fragata;
                    _quantidade_naval = 2;
                }
                // PRIORIDADE 7: Navio Base
                else if (global.ia_dinheiro >= 1000 && global.ia_minerio >= 500 && object_exists(obj_navio_base)) {
                    _tipo_naval = obj_navio_base;
                    _quantidade_naval = 1;
                }
                // FALLBACK: Lancha Patrulha (mais barata)
                else if (global.ia_dinheiro >= 50 && object_exists(obj_lancha_patrulha)) {
                    _tipo_naval = obj_lancha_patrulha;
                    _quantidade_naval = 5; // ✅ AUMENTADO de 3 para 5 - recrutar mais navios
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
                if (_sucesso) {
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("🌊 IA RECRUTOU NAVIOS: " + string(_quantidade_naval) + "x " + object_get_name(_tipo_naval));
                    }
                    break;
                } else {
                    // ✅ NOVO: Se falhou, tentar recrutar lancha (mais barata)
                    if (_num_quartel_marinha >= 1 && global.ia_dinheiro >= 50 && object_exists(obj_lancha_patrulha)) {
                        _sucesso = scr_ia_recrutar_unidade(id, obj_lancha_patrulha, 3);
                        if (_sucesso) {
                            show_debug_message("🌊 IA recrutou lanchas de fallback!");
                            break;
                        }
                    }
                }
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
                // ✅ MELHORADO: Priorizar unidades premium quando recursos permitirem
                var _tipo_terrestre = noone;
                var _quantidade_terrestre = 1;
                _sucesso = false; // ✅ CORREÇÃO GM2043: Resetar valor (já declarada no início do case)
                
                // ✅ MELHORADO: Priorizar unidades premium quando recursos permitirem
                var _obj_abrams = asset_get_index("obj_M1A_Abrams");
                var _obj_gepard = asset_get_index("obj_Gepard_Anti_Aereo");
                
                // PRIORIDADE 1: M1A Abrams (unidade premium - muito poderosa)
                if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object &&
                    global.ia_dinheiro >= 1000 && global.ia_minerio >= 500) {
                    _tipo_terrestre = _obj_abrams;
                    _quantidade_terrestre = 1;
                }
                // PRIORIDADE 2: Gepard Anti-Aéreo (unidade premium anti-aérea)
                else if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object &&
                         global.ia_dinheiro >= 1800 && global.ia_minerio >= 900) {
                    _tipo_terrestre = _obj_gepard;
                    _quantidade_terrestre = 1;
                }
                // PRIORIDADE 3: Blindado Anti-Aéreo (versátil)
                else if (global.ia_dinheiro >= 600 && global.ia_minerio >= 300 && object_exists(obj_blindado_antiaereo)) {
                    _tipo_terrestre = obj_blindado_antiaereo;
                    _quantidade_terrestre = 2;
                }
                // PRIORIDADE 4: Tanque (bom custo-benefício)
                else if (global.ia_dinheiro >= 500 && global.ia_minerio >= 250 && object_exists(obj_tanque)) {
                    _tipo_terrestre = obj_tanque;
                    _quantidade_terrestre = 2;
                }
                // PRIORIDADE 5: Soldado Anti-Aéreo
                else if (global.ia_dinheiro >= 150 && global.ia_minerio >= 50 && object_exists(obj_soldado_antiaereo)) {
                    _tipo_terrestre = obj_soldado_antiaereo;
                    _quantidade_terrestre = 3;
                }
                // FALLBACK: Infantaria (mais barata)
                else if (global.ia_dinheiro >= 100 && object_exists(obj_infantaria)) {
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
            // ✅ PROTEÇÃO: Verificar se a função retornou uma estrutura válida
            if (is_struct(_decisao_estrategica) && 
                variable_struct_exists(_decisao_estrategica, "precisa_resposta") &&
                variable_struct_exists(_decisao_estrategica, "tipo_unidade") &&
                _decisao_estrategica.precisa_resposta && 
                _decisao_estrategica.tipo_unidade != "nenhuma") {
                var _tipo_obj = noone;
                var _sucesso_estrategico = false; // ✅ CORREÇÃO GM2043: Usar nome diferente para evitar conflito
                
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
                    if (variable_struct_exists(_decisao_estrategica, "quantidade")) {
                        _sucesso_estrategico = scr_ia_recrutar_unidade(id, _tipo_obj, _decisao_estrategica.quantidade);
                        if (_sucesso_estrategico) {
                            var _razao = variable_struct_exists(_decisao_estrategica, "razao") ? _decisao_estrategica.razao : "";
                            show_debug_message("🎯 IA recrutou " + string(_decisao_estrategica.quantidade) + "x " + _decisao_estrategica.tipo_unidade + " - " + _razao);
                        } else {
                            show_debug_message("⚠️ IA não pode recrutar unidades estratégicas (sem recursos ou quartel ocupado)");
                        }
                    } else {
                        show_debug_message("❌ ERRO: Decisão estratégica não tem quantidade definida");
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

// === ATUALIZAR CONTADORES PERIÓDICAMENTE (OTIMIZADO) ===
// ✅ OTIMIZAÇÃO: Usar timers separados e cache para reduzir verificações

// Timer para estruturas (a cada 60 frames = 1 segundo)
timer_verificacao_estruturas++;
if (timer_verificacao_estruturas >= intervalo_verificacao_estruturas || !cache_estruturas_valido) {
    timer_verificacao_estruturas = 0;
    cache_estruturas_valido = true;
    cache_timestamp_estruturas = current_time;
    
    estruturas_totais = 0;
    
    // ✅ OTIMIZAÇÃO: Contar estruturas usando lista de tipos
    // ✅ CORREÇÃO GM2043: Usar asset_get_index() para verificar sem causar erro
    var _tipos_estruturas = [];
    
    // Adicionar apenas objetos que existem (usando asset_get_index para evitar erro)
    var _obj_id = asset_get_index("obj_fazenda");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_quartel");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_quartel_marinha");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_aeroporto_militar");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_casa");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_banco");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_mina");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_centro_pesquisa");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_research_center");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_casa_da_moeda");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_serraria");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_plantacao_borracha");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_extrator_silicio");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_mina_ouro");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_mina_aluminio");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_mina_cobre");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_mina_titanio");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_mina_uranio");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_mina_litio");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    _obj_id = asset_get_index("obj_poco_petroleo");
    if (_obj_id != -1) array_push(_tipos_estruturas, _obj_id);
    
    for (var i = 0; i < array_length(_tipos_estruturas); i++) {
        if (!object_exists(_tipos_estruturas[i])) continue;
        with (_tipos_estruturas[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
                other.estruturas_totais++;
            }
        }
    }
}

// Timer para unidades (a cada 30 frames = 0.5 segundos)
timer_verificacao_unidades++;
if (timer_verificacao_unidades >= intervalo_verificacao_unidades || !cache_unidades_valido) {
    timer_verificacao_unidades = 0;
    cache_unidades_valido = true;
    cache_timestamp_unidades = current_time;
    
    unidades_totais = 0;
    
    // ✅ OTIMIZAÇÃO: Usar spatial grid se disponível, senão contar diretamente
    if (variable_global_exists("spatial_grid_initialized") && global.spatial_grid_initialized) {
        // Usar spatial grid para busca otimizada
        var _unidades_proximas = scr_find_nearby_units_spatial(base_x, base_y, raio_expansao);
        for (var i = 0; i < array_length(_unidades_proximas); i++) {
            var _unidade = _unidades_proximas[i];
            if (instance_exists(_unidade) && 
                variable_instance_exists(_unidade, "nacao_proprietaria") && 
                _unidade.nacao_proprietaria == nacao_proprietaria) {
                unidades_totais++;
            }
        }
    } else {
        // Fallback: Contar unidades diretamente (método original)
        // Contar unidades terrestres
        var _tipos_terrestres = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
        var _obj_abrams = asset_get_index("obj_M1A_Abrams");
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            array_push(_tipos_terrestres, _obj_abrams);
        }
        var _obj_gepard = asset_get_index("obj_gepard");
        if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
            array_push(_tipos_terrestres, _obj_gepard);
        }
        
        for (var i = 0; i < array_length(_tipos_terrestres); i++) {
            if (!object_exists(_tipos_terrestres[i])) continue;
            with (_tipos_terrestres[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
                    other.unidades_totais++;
                }
            }
        }
        
        // Contar unidades navais
        var _tipos_navais = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte, 
                            obj_Constellation, obj_Independence, obj_RonaldReagan, obj_wwhendrick];
        var _obj_fragata = asset_get_index("obj_fragata");
        if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
            array_push(_tipos_navais, _obj_fragata);
        }
        var _obj_destroyer = asset_get_index("obj_destroyer");
        if (_obj_destroyer != -1 && asset_get_type(_obj_destroyer) == asset_object) {
            array_push(_tipos_navais, _obj_destroyer);
        }
        
        for (var i = 0; i < array_length(_tipos_navais); i++) {
            if (!object_exists(_tipos_navais[i])) continue;
            with (_tipos_navais[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
                    other.unidades_totais++;
                }
            }
        }
        
        // Contar unidades aéreas
        var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15, obj_su35, obj_c100];
        for (var i = 0; i < array_length(_tipos_aereos); i++) {
            if (!object_exists(_tipos_aereos[i])) continue;
            with (_tipos_aereos[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == other.nacao_proprietaria) {
                    other.unidades_totais++;
                }
            }
        }
    }
}

// ✅ NOVO: Timer para verificação de inimigos (usando cache)
timer_verificacao_inimigos++;
if (timer_verificacao_inimigos >= intervalo_verificacao_inimigos || !cache_inimigos_valido) {
    timer_verificacao_inimigos = 0;
    cache_inimigos_valido = true;
    cache_timestamp_inimigos = current_time;
    
    // ✅ OTIMIZAÇÃO: Usar cache de busca de inimigos
    // Limpar lista antiga
    ds_list_clear(lista_inimigas_visiveis);
    
    // Buscar inimigos usando sistema de cache
    var _inimigo_proximo = scr_buscar_inimigo(base_x, base_y, raio_expansao, nacao_proprietaria);
    if (_inimigo_proximo != noone && instance_exists(_inimigo_proximo)) {
        ds_list_add(lista_inimigas_visiveis, _inimigo_proximo);
    }
}
