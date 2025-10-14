// ===============================================
// HEGEMONIA GLOBAL - INICIALIZADOR DO SISTEMA
// Configuração Completa dos Quartéis Simplificados
// ===============================================

/// @description Inicializar sistema completo de quartéis
function inicializar_sistema_quartéis() {
    show_debug_message("🚀 Iniciando sistema de quartéis simplificado...");
    
    // 1. Inicializar sistema de recursos
    inicializar_recursos_globais();
    
    // 2. Validar objetos existentes
    validar_todos_quartéis();
    
    // 3. Obter estatísticas
    obter_estatisticas_validacao();
    
    // 4. Configurar quartéis existentes
    configurar_quartéis_existentes();
    
    show_debug_message("✅ Sistema de quartéis inicializado com sucesso!");
}

/// @description Configurar quartéis existentes no jogo
function configurar_quartéis_existentes() {
    show_debug_message("🔧 Configurando quartéis existentes...");
    
    // Configurar quartéis terrestres
    with (obj_quartel) {
        // Garantir que variáveis existem
        if (!variable_instance_exists(id, "fila_producao")) {
            fila_producao = ds_queue_create();
        }
        if (!variable_instance_exists(id, "timer_producao")) {
            timer_producao = 0;
        }
        if (!variable_instance_exists(id, "produzindo")) {
            produzindo = false;
        }
        if (!variable_instance_exists(id, "unidades_produzidas")) {
            unidades_produzidas = 0;
        }
        
        show_debug_message("✅ Quartel terrestre ID " + string(id) + " configurado");
    }
    
    // Configurar quartéis navais
    with (obj_quartel_marinha) {
        // Garantir que variáveis existem
        if (!variable_instance_exists(id, "fila_producao")) {
            fila_producao = ds_queue_create();
        }
        if (!variable_instance_exists(id, "timer_producao")) {
            timer_producao = 0;
        }
        if (!variable_instance_exists(id, "produzindo")) {
            produzindo = false;
        }
        if (!variable_instance_exists(id, "unidades_produzidas")) {
            unidades_produzidas = 0;
        }
        
        show_debug_message("✅ Quartel naval ID " + string(id) + " configurado");
    }
}

/// @description Testar sistema de produção
/// @param quartel_id ID do quartel para teste
/// @param unidade_index Índice da unidade
/// @param quantidade Quantidade a produzir
function testar_producao_unidade(quartel_id, unidade_index, quantidade) {
    show_debug_message("🧪 Testando produção de unidade...");
    
    var _resultado = iniciar_producao_unidade(quartel_id, unidade_index, quantidade);
    
    if (_resultado) {
        show_debug_message("✅ Teste de produção bem-sucedido!");
    } else {
        show_debug_message("❌ Teste de produção falhou!");
    }
    
    return _resultado;
}

/// @description Obter informações de debug do sistema
function obter_debug_sistema() {
    show_debug_message("📊 === DEBUG DO SISTEMA DE QUARTÉIS ===");
    
    // Recursos globais
    show_debug_message("💰 Recursos:");
    show_debug_message("   Dinheiro: " + string(global.dinheiro));
    show_debug_message("   Minério: " + string(global.minerio));
    show_debug_message("   Petróleo: " + string(global.petroleo));
    show_debug_message("   População: " + string(global.populacao));
    show_debug_message("   Militares: " + string(global.militares_totais));
    
    // Quartéis
    var _quartéis_terrestres = 0;
    var _quartéis_navais = 0;
    
    with (obj_quartel) {
        _quartéis_terrestres++;
        show_debug_message("🏛️ Quartel Terrestre ID " + string(id) + ":");
        show_debug_message("   Produzindo: " + string(produzindo));
        show_debug_message("   Fila: " + string(ds_queue_size(fila_producao)));
        show_debug_message("   Unidades produzidas: " + string(unidades_produzidas));
    }
    
    with (obj_quartel_marinha) {
        _quartéis_navais++;
        show_debug_message("🚢 Quartel Naval ID " + string(id) + ":");
        show_debug_message("   Produzindo: " + string(produzindo));
        show_debug_message("   Fila: " + string(ds_queue_size(fila_producao)));
        show_debug_message("   Unidades produzidas: " + string(unidades_produzidas));
    }
    
    show_debug_message("📈 Total de quartéis: " + string(_quartéis_terrestres + _quartéis_navais));
    show_debug_message("=====================================");
}
