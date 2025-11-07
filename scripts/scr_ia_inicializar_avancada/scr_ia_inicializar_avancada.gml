/// @description Inicializa a IA com as novas configurações de agressividade e reconhecimento
/// @param {struct} _ia Estrutura da IA a ser inicializada
/// @param {real} _nivel_agressividade Nível de agressividade (0.0 a 1.0)
function scr_ia_inicializar_avancada(_ia, _nivel_agressividade = 0.7) {
    
    // Configurar nível de agressividade
    _ia.agressividade = clamp(_nivel_agressividade, 0.0, 1.0);
    
    // Inicializar sistema de reconhecimento
    if (!variable_struct_exists(_ia, "reconhecimento")) {
        _ia.reconhecimento = {
            ativo: false,
            pontos_explorados: [],
            unidades_exploradoras: [],
            raio_exploracao: 800,
            tempo_ultima_exploracao: 0,
            intervalo_exploracao: 3000 // 3 segundos
        };
    }
    
    // Inicializar sistema de estratégias
    if (!variable_struct_exists(_ia, "estrategias")) {
        _ia.estrategias = {
            ativa: "ataque_total",
            historico: [],
            mudancas_estrategia: 0,
            tempo_na_estrategia_atual: 0
        };
    }
    
    // Inicializar sistema de inteligência
    if (!variable_struct_exists(_ia, "inteligencia")) {
        _ia.inteligencia = {
            alvos_conhecidos: [],
            ameacas_identificadas: [],
            pontos_fracos_inimigos: [],
            forca_inimiga_estimada: 0,
            ultima_atualizacao: 0
        };
    }
    
    // Configurar parâmetros de ataque
    if (!variable_struct_exists(_ia, "parametros_ataque")) {
        _ia.parametros_ataque = {
            distancia_minima_ataque: 200,
            distancia_maxima_ataque: 600,
            intervalo_entre_ataques: 2000, // 2 segundos
            forca_minima_para_ataque: 15,
            prioridade_estruturas: 0.8,
            prioridade_unidades: 0.6,
            usar_formacoes_avancadas: true
        };
    }
    
    // Configurar sistema de coordenação
    if (!variable_struct_exists(_ia, "coordenacao")) {
        _ia.coordenacao = {
            grupos_ataque: [],
            lideres_grupos: [],
            canais_comunicacao: [],
            nivel_coordenacao: _nivel_agressividade // Quanto mais agressiva, mais coordenada
        };
    }
    
    // Inicializar contadores de desempenho
    if (!variable_struct_exists(_ia, "desempenho")) {
        _ia.desempenho = {
            ataques_bem_sucedidos: 0,
            ataques_falhados: 0,
            unidades_perdidas: 0,
            unidades_eliminadas: 0,
            estruturas_destruidas: 0,
            tempo_total_jogo: 0,
            eficiencia_geral: 0.0
        };
    }
    
    // Configurar sistema de aprendizado (para futuras melhorias)
    if (!variable_struct_exists(_ia, "aprendizado")) {
        _ia.aprendizado = {
            ativo: true,
            padroes_ataque: [],
            respostas_efetivas: [],
            erros_cometidos: [],
            taxa_aprendizado: 0.1
        };
    }
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("✅ IA Avançada Inicializada");
        show_debug_message("📊 Configurações:");
        show_debug_message("  - Agressividade: " + string(_ia.agressividade * 100) + "%");
        show_debug_message("  - Reconhecimento: " + (_ia.reconhecimento.ativo ? "Ativo" : "Inativo"));
        show_debug_message("  - Estratégia Ativa: " + _ia.estrategias.ativa);
        show_debug_message("  - Unidades Totais: " + string(scr_ia_calcular_forca_total(_ia)));
    }
    
    return _ia;
}