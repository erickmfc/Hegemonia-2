/// @description Comandar unidades da IA para atacar inimigos (TERRESTRE + NAVAL + AÉREO)
/// @param _ia_id ID da IA

function scr_ia_atacar(_ia_id) {
    // ✅ CORREÇÃO: Verificar se a instância existe antes de usar
    if (!instance_exists(_ia_id)) {
        show_debug_message("❌ ERRO: scr_ia_atacar - Instância IA não existe! ID: " + string(_ia_id));
        return;
    }
    
    var _ia = _ia_id;
    
    // ✅ CORREÇÃO: Verificar se propriedades necessárias existem
    if (!variable_instance_exists(_ia, "nacao_proprietaria")) {
        show_debug_message("❌ ERRO: scr_ia_atacar - Instância IA não tem nacao_proprietaria! ID: " + string(_ia));
        return;
    }
    
    if (!variable_instance_exists(_ia, "base_x") || !variable_instance_exists(_ia, "base_y")) {
        show_debug_message("❌ ERRO: scr_ia_atacar - Instância IA não tem base_x/base_y! ID: " + string(_ia));
        return;
    }
    
    if (!variable_instance_exists(_ia, "raio_expansao")) {
        show_debug_message("❌ ERRO: scr_ia_atacar - Instância IA não tem raio_expansao! ID: " + string(_ia));
        return;
    }
    
    if (!variable_global_exists("ia_dinheiro")) {
        show_debug_message("❌ ERRO: Recursos da IA não inicializados!");
        return;
    }
    
    // ✅ NOVO: Sistema de agressividade e reconhecimento
    var _agressividade = 0.7; // 70% de chance de atacar mesmo sem ameaça direta
    var _reconhecimento_ativo = false;
    
    // ✅ CORREÇÃO: Inicializar modo_agressivo se não existir
    if (!variable_instance_exists(_ia, "modo_agressivo")) {
        _ia.modo_agressivo = false;
    }
    
    // ✅ NOVO: Sistema de reconhecimento - explorar mapa para encontrar alvos
    // ✅ CORREÇÃO: Verificar se ultimo_reconhecimento existe antes de usar
    var _tem_ultimo_reconhecimento = variable_instance_exists(_ia, "ultimo_reconhecimento");
    var _tempo_ultimo_reconhecimento = _tem_ultimo_reconhecimento ? _ia.ultimo_reconhecimento : 0;
    var _intervalo_reconhecimento = 10000; // 10 segundos entre reconhecimentos
    
    // Executar reconhecimento se:
    // - 30% de chance aleatória OU
    // - Nunca executou antes OU
    // - Passou mais de 10 segundos desde o último
    if (irandom(100) < 30 || _tempo_ultimo_reconhecimento == 0 || (current_time - _tempo_ultimo_reconhecimento) > _intervalo_reconhecimento) {
        // ✅ REATIVADO: Reconhecimento agora está funcional
        // ✅ CORREÇÃO: Verificar se o script existe antes de chamar
        var _script_reconhecimento = asset_get_index("scr_ia_reconhecimento");
        if (instance_exists(_ia) && _script_reconhecimento != -1 && asset_get_type(_script_reconhecimento) == asset_script) {
            scr_ia_reconhecimento(_ia);
            _reconhecimento_ativo = true;
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("🔍 Reconhecimento ativado - explorando mapa para encontrar alvos");
            }
        } else {
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                if (!instance_exists(_ia)) {
                    show_debug_message("⚠️ scr_ia_atacar - Instância IA não existe para reconhecimento");
                } else if (_script_reconhecimento == -1) {
                    show_debug_message("⚠️ scr_ia_atacar - Script scr_ia_reconhecimento não encontrado");
                }
            }
            _reconhecimento_ativo = false;
        }
    }
    
    // ✅ NOVO: Se tiver alvos mas força insuficiente, esperar reforços
    var _forca_ia = scr_ia_calcular_forca_total(_ia);
    var _estrategia = "ataque_normal"; // ✅ CORRIGIDO: Inicializar variável
    if (_forca_ia < 30) {
        // Mudar estratégia para defensiva e esperar reforços
        _estrategia = "defesa_reforcos";
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("IA: Força insuficiente, mudando para estratégia defensiva");
        }
    }
    
    // ✅ NOVO: Ataque proativo - mesmo sem inimigos próximos
    if (irandom(100) < _agressividade * 100) {
        _ia.modo_agressivo = true;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🎯 IA MODO AGRESSIVO ATIVADO!");
        }
    }
    
    // ✅ NOVO: Detectar tipo de guerra e escolher estratégia
    var _inimigos_terrestres = ds_list_create();
    var _inimigos_navais = ds_list_create();
    var _inimigos_aereos = ds_list_create();
    
    // ✅ CORRIGIDO: Garantir destruição de listas mesmo em caso de erro
    var _listas_criadas = true;
    
    // === DETECTAR INIMIGOS TERRESTRES ===
    // ✅ CORRIGIDO: Implementação direta (sem depender de função externa)
    var _tipos_terrestres = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
    
    // ✅ NOVO: Expandir raio de busca em modo agressivo
    var _raio_busca = _ia.raio_expansao;
    // ✅ CORREÇÃO: Verificar se modo_agressivo existe antes de acessar
    if (variable_instance_exists(_ia, "modo_agressivo") && _ia.modo_agressivo) {
        _raio_busca = _ia.raio_expansao * 2; // Dobrar alcance em modo agressivo
    }
    
    for (var i = 0; i < array_length(_tipos_terrestres); i++) {
        var _tipo = _tipos_terrestres[i];
        if (!object_exists(_tipo)) continue;
        
        with (_tipo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                if (_dist <= _raio_busca) {
                    ds_list_add(_inimigos_terrestres, id);
                }
            }
        }
    }
    
    // === DETECTAR INIMIGOS NAVAIS ===
    // ✅ CORRIGIDO: Implementação direta (sem depender de função externa)
    var _tipos_navais = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte, obj_Constellation, obj_Independence, obj_RonaldReagan];
    var _obj_fragata_navais = asset_get_index("obj_fragata");
    if (_obj_fragata_navais != -1 && asset_get_type(_obj_fragata_navais) == asset_object) {
        array_push(_tipos_navais, _obj_fragata_navais);
    }
    
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        var _navio_tipo = _tipos_navais[i];
        if (!object_exists(_navio_tipo)) continue;
        
        with (_navio_tipo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                if (_dist <= _raio_busca) { // Usar raio expandido
                    // ✅ CORREÇÃO: Adicionar apenas o ID da instância (mais simples e eficiente)
                    ds_list_add(_inimigos_navais, id);
                }
            }
        }
    }
    
    // === DETECTAR INIMIGOS AÉREOS ===
    // ✅ CORRIGIDO: Implementação direta (sem depender de função externa)
    var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15, obj_c100];
    var _obj_su35 = asset_get_index("obj_su35");
    if (_obj_su35 != -1 && asset_get_type(_obj_su35) == asset_object) {
        array_push(_tipos_aereos, _obj_su35);
    }
    
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        var _tipo = _tipos_aereos[i];
        if (!object_exists(_tipo)) continue;
        
        with (_tipo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                if (_dist <= _ia.raio_expansao * 1.2) {
                    ds_list_add(_inimigos_aereos, id);
                }
            }
        }
    }
    
    // === ESCOLHER PRIORIDADE DE ATAQUE ===
    var _alvo_prioritario = noone;
    var _tipo_guerra = "terrestre";
    
    // Prioridade: Naval > Aéreo > Terrestre (navios são mais perigosos)
    if (ds_list_size(_inimigos_navais) > 0) {
        _tipo_guerra = "naval";
        // Escolher navio mais próximo
        var _menor_dist = 999999;
        for (var i = 0; i < ds_list_size(_inimigos_navais); i++) {
            var _alvo = ds_list_find_value(_inimigos_navais, i);
            // ✅ CORREÇÃO: Agora _inimigos_navais contém apenas IDs de instâncias
            if (instance_exists(_alvo)) {
                var _dist = point_distance(_alvo.x, _alvo.y, _ia.base_x, _ia.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _alvo_prioritario = _alvo;
                }
            }
        }
    } else if (ds_list_size(_inimigos_aereos) > 0) {
        _tipo_guerra = "aereo";
        var _menor_dist = 999999;
        for (var i = 0; i < ds_list_size(_inimigos_aereos); i++) {
            var _alvo = ds_list_find_value(_inimigos_aereos, i);
            if (instance_exists(_alvo)) {
                var _dist = point_distance(_alvo.x, _alvo.y, _ia.base_x, _ia.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _alvo_prioritario = _alvo;
                }
            }
        }
        
        // ✅ NOVO: PRIORIDADE MÁXIMA - Usar TANQUES e ARTILHARIA ANTI-AÉREA contra aviões
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🚨 AMEAÇA AÉREA DETECTADA! Usando tanques e artilharia anti-aérea!");
        }
    } else if (ds_list_size(_inimigos_terrestres) > 0) {
        _tipo_guerra = "terrestre";
        var _menor_dist = 999999;
        for (var i = 0; i < ds_list_size(_inimigos_terrestres); i++) {
            var _alvo = ds_list_find_value(_inimigos_terrestres, i);
            if (instance_exists(_alvo)) {
                var _dist = point_distance(_alvo.x, _alvo.y, _ia.base_x, _ia.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _alvo_prioritario = _alvo;
                }
            }
        }
    }
    
    // === EXECUTAR ATAQUE ===
    if (instance_exists(_alvo_prioritario)) {
        // ✅ NOVO: SISTEMA TÁTICO AVANÇADO
        var _analise_tatica = scr_ia_analisar_alvos(_ia);
        
        if (ds_list_size(_analise_tatica.alvos) > 0) {
            // Usar sistema tático avançado
            scr_ia_ataque_tatico(_ia, _analise_tatica);
            
            // Limpar análise após uso
            ds_list_destroy(_analise_tatica.alvos);
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚔️ IA ATAQUE TÁTICO EXECUTADO! Estratégia: " + _analise_tatica.estrategia);
            }
            
            return; // Sair após usar sistema tático
        }
        
        // Fallback: sistema antigo se análise não encontrou alvos
        // ✅ Ativar squad antes de atacar
        scr_activate_enemy_squad(_alvo_prioritario.x, _alvo_prioritario.y, 1500);
        
        // ✅ NOVO: Distribuir unidades antes de atacar (não ficar grudadas)
        if (_tipo_guerra != "naval") {
            // Distribuir unidades em formação ao redor da base antes de atacar
            scr_ia_distribuir_unidades(_ia, _ia.base_x, _ia.base_y, 250);
        }
        
        var _comandos = 0;
        
        // === ✅ NOVO: COMANDAR TODAS AS UNIDADES (NÃO SÓ INFANTARIA E TANQUE) ===
        
        // ✅ NOVO: Se é guerra aérea, PRIORIZAR unidades anti-aéreas e tanques
        if (_tipo_guerra == "aereo") {
            // PRIORIDADE 1: Blindados Anti-Aéreos (mais eficazes contra aviões)
            with (obj_blindado_antiaereo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "modo_ataque")) {
                        modo_ataque = true; // Ativar modo ataque
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
            
            // PRIORIDADE 2: Soldados Anti-Aéreos
            with (obj_soldado_antiaereo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "modo_ataque")) {
                        modo_ataque = true; // Ativar modo ataque
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
            
            // PRIORIDADE 3: Tanques (também podem atacar aviões em algumas situações)
            with (obj_tanque) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "modo_ataque")) {
                        modo_ataque = true; // Ativar modo ataque
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
            
            // ✅ NOVO: M1A Abrams também pode ajudar na defesa anti-aérea
            var _obj_abrams = asset_get_index("obj_M1A_Abrams");
            if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                with (_obj_abrams) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                        if (variable_instance_exists(id, "destino_x")) {
                            destino_x = _alvo_prioritario.x;
                            destino_y = _alvo_prioritario.y;
                        }
                        if (variable_instance_exists(id, "alvo")) {
                            alvo = _alvo_prioritario;
                        }
                        if (variable_instance_exists(id, "modo_ataque")) {
                            modo_ataque = true; // Ativar modo ataque
                        }
                        if (variable_instance_exists(id, "estado")) {
                            estado = "atacando";
                        }
                        _comandos++;
                    }
                }
            }
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("🎯 IA ATACANDO AVIÕES: " + string(_comandos) + " unidades anti-aéreas e tanques mobilizadas!");
            }
        } else {
            // Para outros tipos de guerra, usar lógica normal
            
            // Comandar blindados antiaéreos
            with (obj_blindado_antiaereo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
            
            // Comandar soldados antiaéreos
            with (obj_soldado_antiaereo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
        }
        
        // Comandar navios (se houver)
        // ✅ CORRIGIDO: Implementação direta (sem depender de função externa)
        var _tipos_navais_ia = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte, obj_Constellation, obj_Independence, obj_RonaldReagan];
        var _obj_fragata_navais_ia = asset_get_index("obj_fragata");
        if (_obj_fragata_navais_ia != -1 && asset_get_type(_obj_fragata_navais_ia) == asset_object) {
            array_push(_tipos_navais_ia, _obj_fragata_navais_ia);
        }
        
        for (var i = 0; i < array_length(_tipos_navais_ia); i++) {
            if (!object_exists(_tipos_navais_ia[i])) continue;
            with (_tipos_navais_ia[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
        }
        
        // Comandar aeronaves (se houver)
        // ✅ CORRIGIDO: Implementação direta (sem depender de função externa)
        var _tipos_aereos_ia = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15, obj_c100];
        for (var i = 0; i < array_length(_tipos_aereos_ia); i++) {
            if (!object_exists(_tipos_aereos_ia[i])) continue;
            with (_tipos_aereos_ia[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    // ✅ NOVO: F6 também precisa de alvo_em_mira
                    if (variable_instance_exists(id, "alvo_em_mira")) {
                        alvo_em_mira = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
        }
        
        // === ATAQUE BASEADO NO TIPO ===
        if (_tipo_guerra == "naval") {
            // Usar navios para atacar
            scr_ia_atacar_naval(_ia);
        } else {
            // ✅ NOVO: Mover tropas estrategicamente (não tudo junto)
            scr_ia_mover_tropas_estrategico(_ia, _alvo_prioritario.x, _alvo_prioritario.y, 350);
            
            // Comandar infantaria
            with (obj_infantaria) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
            
            // Comandar tanques
            with (obj_tanque) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
        }
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚔️ IA ATAQUE TOTAL [" + _tipo_guerra + "]! " + string(_comandos) + " unidades | Alvo: (" + string(round(_alvo_prioritario.x)) + ", " + string(round(_alvo_prioritario.y)) + ")");
        }
    } else {
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚠️ IA não encontrou alvos para atacar");
        }
    }
    
    // ✅ CORRIGIDO: Garantir destruição de listas em todos os caminhos
    if (_listas_criadas) {
        if (ds_exists(_inimigos_terrestres, ds_type_list)) ds_list_destroy(_inimigos_terrestres);
        if (ds_exists(_inimigos_navais, ds_type_list)) ds_list_destroy(_inimigos_navais);
        if (ds_exists(_inimigos_aereos, ds_type_list)) ds_list_destroy(_inimigos_aereos);
    }
}
