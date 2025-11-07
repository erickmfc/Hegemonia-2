/// @description Relatório detalhado do estado da IA
/// @param {struct} _ia Estrutura da IA
function scr_ia_relatorio_completo(_ia) {
    
    var _relatorio = {
        forca_total: scr_ia_calcular_forca_total(_ia),
        estrategia_ativa: _ia.estrategias.ativa,
        tempo_na_estrategia: _ia.estrategias.tempo_na_estrategia_atual,
        mudancas_estrategia: _ia.estrategias.mudancas_estrategia,
        agressividade: _ia.agressividade,
        reconhecimento_ativo: _ia.reconhecimento.ativo,
        pontos_explorados: array_length(_ia.reconhecimento.pontos_explorados),
        eficiencia_geral: _ia.desempenho.eficiencia_geral,
        ataques_bem_sucedidos: _ia.desempenho.ataques_bem_sucedidos,
        ataques_falhados: _ia.desempenho.ataques_falhados,
        unidades_perdidas: _ia.desempenho.unidades_perdidas,
        unidades_eliminadas: _ia.desempenho.unidades_eliminadas,
        estruturas_destruidas: _ia.desempenho.estruturas_destruidas,
        tempo_jogo: _ia.desempenho.tempo_total_jogo
    };
    
    // Análise de alvos atual
    var _analise = scr_ia_analisar_alvos(_ia);
    _relatorio.alvos_criticos = array_length(_analise.alvos_criticos);
    _relatorio.alvos_importantes = array_length(_analise.alvos_importantes);
    _relatorio.forca_inimiga = _analise.forca_inimiga;
    
    return _relatorio;
}