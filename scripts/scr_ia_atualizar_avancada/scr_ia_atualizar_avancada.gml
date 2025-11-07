/// @description Atualiza a IA avançada (deve ser chamada regularmente)
/// @param {struct} _ia Estrutura da IA
function scr_ia_atualizar_avancada(_ia) {
    
    var _tempo_atual = get_timer() / 1000; // Tempo em milissegundos
    
    // Atualizar tempo na estratégia atual
    _ia.estrategias.tempo_na_estrategia_atual++;
    
    // Atualizar inteligência
    if (_tempo_atual - _ia.inteligencia.ultima_atualizacao > 5000) { // A cada 5 segundos
        _ia.inteligencia.ultima_atualizacao = _tempo_atual;
        
        // Reavaliar força inimiga
        var _analise_temp = scr_ia_analisar_alvos(_ia);
        _ia.inteligencia.forca_inimiga_estimada = _analise_temp.forca_inimiga;
        
        // Ajustar estratégia se necessário
        if (_ia.inteligencia.forca_inimiga_estimada > scr_ia_calcular_forca_total(_ia) * 1.5) {
            if (_ia.estrategias.ativa != "defesa_reforcos") {
                _ia.estrategias.ativa = "defesa_reforcos";
                _ia.estrategias.mudancas_estrategia++;
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🔄 IA: Mudando para estratégia defensiva devido à superioridade inimiga");
                }
            }
        }
    }
    
    // Atualizar reconhecimento
    if (_ia.reconhecimento.ativo) {
        if (_tempo_atual - _ia.reconhecimento.tempo_ultima_exploracao > _ia.reconhecimento.intervalo_exploracao) {
            _ia.reconhecimento.tempo_ultima_exploracao = _tempo_atual;
            
            // Reavaliar necessidade de reconhecimento
            var _analise_temp = scr_ia_analisar_alvos(_ia);
            if (array_length(_analise_temp.alvos_terrestres) == 0 && array_length(_analise_temp.alvos_navais) == 0) {
                scr_ia_reconhecimento();
            }
        }
    }
    
    // Atualizar desempenho
    _ia.desempenho.tempo_total_jogo = _tempo_atual;
    
    // Calcular eficiência geral
    var _total_acoes = _ia.desempenho.ataques_bem_sucedidos + _ia.desempenho.ataques_falhados;
    if (_total_acoes > 0) {
        _ia.desempenho.eficiencia_geral = _ia.desempenho.ataques_bem_sucedidos / _total_acoes;
    }
    
    return _ia;
}