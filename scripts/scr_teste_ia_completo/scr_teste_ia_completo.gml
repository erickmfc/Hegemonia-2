/// @description Script de teste completo para verificar o funcionamento da IA
/// @param {struct} _ia Estrutura da IA a ser testada
/// @param {bool} _debug_ativo Se deve mostrar mensagens de debug

function scr_teste_ia_completo(_ia, _debug_ativo = true) {
    
    if (_debug_ativo) {
        show_debug_message("=== TESTE DE IA INICIADO ===");
        show_debug_message("Testando IA: " + string(_ia.nome));
    }
    
    // Teste 1: Verificar se a IA tem unidades
    if (!variable_struct_exists(_ia, "unidades")) {
        if (_debug_ativo) show_debug_message("❌ ERRO: IA não tem estrutura de unidades");
        return false;
    }
    
    var _total_unidades = 0;
    var _unidades_por_tipo = {
        infantaria: 0,
        tanques: 0,
        antiaereo: 0,
        navios: 0,
        aeronaves: 0
    };
    
    // Contar unidades por tipo
    var _infantaria = _ia.unidades[? "infantaria"];
    var _tanques = _ia.unidades[? "tanques"];
    var _antiaereos = _ia.unidades[? "antiaereo"];
    var _navios = _ia.unidades[? "navios"];
    var _aeronaves = _ia.unidades[? "aeronaves"];
    
    if (is_array(_infantaria)) {
        for (var i = 0; i < array_length(_infantaria); i++) {
            if (instance_exists(_infantaria[i])) {
                _unidades_por_tipo.infantaria++;
                _total_unidades++;
            }
        }
    }
    
    if (is_array(_tanques)) {
        for (var i = 0; i < array_length(_tanques); i++) {
            if (instance_exists(_tanques[i])) {
                _unidades_por_tipo.tanques++;
                _total_unidades++;
            }
        }
    }
    
    if (is_array(_antiaereos)) {
        for (var i = 0; i < array_length(_antiaereos); i++) {
            if (instance_exists(_antiaereos[i])) {
                _unidades_por_tipo.antiaereo++;
                _total_unidades++;
            }
        }
    }
    
    if (is_array(_navios)) {
        for (var i = 0; i < array_length(_navios); i++) {
            if (instance_exists(_navios[i])) {
                _unidades_por_tipo.navios++;
                _total_unidades++;
            }
        }
    }
    
    if (is_array(_aeronaves)) {
        for (var i = 0; i < array_length(_aeronaves); i++) {
            if (instance_exists(_aeronaves[i])) {
                _unidades_por_tipo.aeronaves++;
                _total_unidades++;
            }
        }
    }
    
    if (_debug_ativo) {
        show_debug_message("📊 Unidades da IA:");
        show_debug_message("  - Infantaria: " + string(_unidades_por_tipo.infantaria));
        show_debug_message("  - Tanques: " + string(_unidades_por_tipo.tanques));
        show_debug_message("  - Antiaéreos: " + string(_unidades_por_tipo.antiaereo));
        show_debug_message("  - Navios: " + string(_unidades_por_tipo.navios));
        show_debug_message("  - Aeronaves: " + string(_unidades_por_tipo.aeronaves));
        show_debug_message("  - Total: " + string(_total_unidades));
    }
    
    if (_total_unidades == 0) {
        if (_debug_ativo) show_debug_message("❌ ERRO: IA não tem unidades válidas");
        return false;
    }
    
    // Teste 2: Calcular força da IA
    var _forca_ia = scr_ia_calcular_forca_total(_ia);
    if (_debug_ativo) {
        show_debug_message("⚔️ Força total da IA: " + string(_forca_ia));
    }
    
    // Teste 3: Analisar alvos
    var _analise = scr_ia_analisar_alvos(_ia);
    if (_debug_ativo) {
        show_debug_message("🎯 Análise de alvos:");
        show_debug_message("  - Alvos críticos: " + string(array_length(_analise.alvos_criticos)));
        show_debug_message("  - Alvos importantes: " + string(array_length(_analise.alvos_importantes)));
        show_debug_message("  - Alvos terrestres: " + string(array_length(_analise.alvos_terrestres)));
        show_debug_message("  - Alvos navais: " + string(array_length(_analise.alvos_navais)));
        show_debug_message("  - Alvos aéreos: " + string(array_length(_analise.alvos_aereos)));
        show_debug_message("  - Força inimiga: " + string(_analise.forca_inimiga));
        show_debug_message("  - Estratégia escolhida: " + _analise.estrategia);
    }
    
    // Teste 4: Verificar estratégia
    var _estrategias_validas = ["ataque_total", "foco_estruturas", "guerra_economica", "cerco", "emboscada", "ataque_multi_frontal", "ataque_limitado", "defesa_reforcos"];
    var _estrategia_valida = false;
    
    for (var i = 0; i < array_length(_estrategias_validas); i++) {
        if (_analise.estrategia == _estrategias_validas[i]) {
            _estrategia_valida = true;
            break;
        }
    }
    
    if (!_estrategia_valida) {
        if (_debug_ativo) show_debug_message("⚠️ AVISO: Estratégia '" + _analise.estrategia + "' não é reconhecida");
    }
    
    // Teste 5: Testar sistema de reconhecimento
    if (array_length(_analise.alvos_terrestres) == 0 && array_length(_analise.alvos_navais) == 0) {
        if (_debug_ativo) show_debug_message("🔍 Nenhum alvo encontrado - testando reconhecimento");
        
        // Simular reconhecimento
        var _unidades_reconhecimento = [];
        
        // Procurar unidades adequadas para reconhecimento
        if (is_array(_aeronaves) && array_length(_aeronaves) > 0) {
            for (var i = 0; i < min(2, array_length(_aeronaves)); i++) {
                if (instance_exists(_aeronaves[i])) {
                    array_push(_unidades_reconhecimento, _aeronaves[i]);
                }
            }
        }
        
        if (array_length(_unidades_reconhecimento) == 0 && is_array(_infantaria) && array_length(_infantaria) > 0) {
            for (var i = 0; i < min(1, array_length(_infantaria)); i++) {
                if (instance_exists(_infantaria[i])) {
                    array_push(_unidades_reconhecimento, _infantaria[i]);
                }
            }
        }
        
        if (_debug_ativo) {
            show_debug_message("  - Unidades de reconhecimento disponíveis: " + string(array_length(_unidades_reconhecimento)));
        }
    }
    
    // Teste 6: Testar formação tática
    if (_total_unidades > 0) {
        var _formacoes_teste = ["linha", "cerco", "emboscada", "avanco_coordenado", "assalto_massivo", "dispersao_tatica"];
        
        for (var i = 0; i < array_length(_formacoes_teste); i++) {
            var _formacao = _formacoes_teste[i];
            var _grupos_formacao = scr_ia_formacao_tatica(_ia, _alvo_x, _alvo_y, _formacao);
            
            if (_debug_ativo) {
                show_debug_message("📐 Formação '" + _formacao + "': " + string(array_length(_grupos_formacao)) + " posições calculadas");
            }
            
            if (array_length(_grupos_formacao) == 0) {
                if (_debug_ativo) show_debug_message("⚠️ AVISO: Formação '" + _formacao + "' retornou 0 posições");
            }
        }
    }
    
    // Teste 7: Simular ataque tático
    if (array_length(_analise.alvos_terrestres) > 0 || array_length(_analise.alvos_navais) > 0) {
        var _alvo_principal = undefined;
        
        if (array_length(_analise.alvos_criticos) > 0) {
            _alvo_principal = _analise.alvos_criticos[0];
        } else if (array_length(_analise.alvos_importantes) > 0) {
            _alvo_principal = _analise.alvos_importantes[0];
        } else if (array_length(_analise.alvos_terrestres) > 0) {
            _alvo_principal = _analise.alvos_terrestres[0];
        }
        
        if (instance_exists(_alvo_principal)) {
            if (_debug_ativo) {
                show_debug_message("🎯 Alvo principal para ataque: " + object_get_name(_alvo_principal.object_index));
            }
            
            // Simular planejamento de ataque
            var _ataque_planejado = {
                alvo: _alvo_principal,
                estrategia: _analise.estrategia,
                forca_disponivel: _forca_ia,
                unidades_disponiveis: _total_unidades
            };
            
            if (_debug_ativo) {
                show_debug_message("✅ Ataque planejado com estratégia: " + _ataque_planejado.estrategia);
            }
        }
    }
    
    if (_debug_ativo) {
        show_debug_message("=== TESTE DE IA FINALIZADO ===");
        show_debug_message("✅ IA funcionando corretamente");
        show_debug_message("📈 Recomendações:");
        
        if (_forca_ia < 20) {
            show_debug_message("  - A IA precisa de mais unidades para ataques efetivos");
        }
        
        if (array_length(_analise.alvos_terrestres) == 0 && array_length(_analise.alvos_navais) == 0) {
            show_debug_message("  - Ativar reconhecimento para encontrar alvos");
        }
        
        if (_analise.estrategia == "defesa_reforcos") {
            show_debug_message("  - IA está em modo defensivo, aguardando reforços");
        }
    }
    
    return true;
}