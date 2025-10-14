// ===============================================
// HEGEMONIA GLOBAL - INICIALIZADOR DO SISTEMA UNIFICADO
// Configuração Completa dos Quartéis
// ===============================================

/// @description Inicializar sistema unificado de quartéis
function inicializar_sistema_unificado() {
    show_debug_message("🚀 Iniciando sistema unificado de quartéis...");
    
    // 1. Validar objetos existentes
    validar_todos_quartéis_unificados();
    
    // 2. Configurar quartéis existentes
    configurar_quartéis_existentes_unificados();
    
    // 3. Obter estatísticas
    obter_estatisticas_sistema_unificado();
    
    show_debug_message("✅ Sistema unificado inicializado com sucesso!");
}

/// @description Validar todos os quartéis no sistema unificado
function validar_todos_quartéis_unificados() {
    show_debug_message("🔍 Validando quartéis do sistema unificado...");
    
    var _total_quartéis = 0;
    var _quartéis_válidos = 0;
    
    // Validar quartéis terrestres
    with (obj_quartel) {
        _total_quartéis++;
        var _stats = scr_validar_unidades_quartel(id);
        if (_stats.invalidas == 0) {
            _quartéis_válidos++;
        }
    }
    
    // Validar quartéis navais
    with (obj_quartel_marinha) {
        _total_quartéis++;
        var _stats = scr_validar_unidades_quartel(id);
        if (_stats.invalidas == 0) {
            _quartéis_válidos++;
        }
    }
    
    show_debug_message("📊 Validação concluída: " + string(_quartéis_válidos) + "/" + string(_total_quartéis) + " quartéis válidos");
}

/// @description Configurar quartéis existentes no sistema unificado
function configurar_quartéis_existentes_unificados() {
    show_debug_message("🔧 Configurando quartéis do sistema unificado...");
    
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

/// @description Obter estatísticas do sistema unificado
function obter_estatisticas_sistema_unificado() {
    var _stats = {
        quartéis_terrestres: 0,
        quartéis_navais: 0,
        unidades_em_producao: 0,
        unidades_na_fila: 0
    };
    
    // Contar quartéis terrestres
    with (obj_quartel) {
        _stats.quartéis_terrestres++;
        if (produzindo) _stats.unidades_em_producao++;
        _stats.unidades_na_fila += ds_queue_size(fila_producao);
    }
    
    // Contar quartéis navais
    with (obj_quartel_marinha) {
        _stats.quartéis_navais++;
        if (produzindo) _stats.unidades_em_producao++;
        _stats.unidades_na_fila += ds_queue_size(fila_producao);
    }
    
    show_debug_message("📊 === ESTATÍSTICAS DO SISTEMA UNIFICADO ===");
    show_debug_message("   Quartéis terrestres: " + string(_stats.quartéis_terrestres));
    show_debug_message("   Quartéis navais: " + string(_stats.quartéis_navais));
    show_debug_message("   Unidades em produção: " + string(_stats.unidades_em_producao));
    show_debug_message("   Unidades na fila: " + string(_stats.unidades_na_fila));
    show_debug_message("==========================================");
    
    return _stats;
}

/// @description Testar sistema unificado
/// @param quartel_id ID do quartel para teste
/// @param unidade_index Índice da unidade
function testar_sistema_unificado(quartel_id, unidade_index) {
    show_debug_message("🧪 Testando sistema unificado...");
    
    var _quartel = quartel_id;
    if (!instance_exists(_quartel)) {
        show_debug_message("❌ Quartel não encontrado!");
        return false;
    }
    
    var _resultado = scr_adicionar_fila_producao(unidade_index);
    
    if (_resultado) {
        show_debug_message("✅ Teste do sistema unificado bem-sucedido!");
    } else {
        show_debug_message("❌ Teste do sistema unificado falhou!");
    }
    
    return _resultado;
}

/// @description Obter informações de debug do sistema unificado
function obter_debug_sistema_unificado() {
    show_debug_message("📊 === DEBUG DO SISTEMA UNIFICADO ===");
    
    // Recursos globais
    var _recursos = scr_obter_recursos_disponiveis();
    show_debug_message("💰 Recursos:");
    show_debug_message("   Dinheiro: " + string(_recursos.dinheiro));
    show_debug_message("   Minério: " + string(_recursos.minerio));
    show_debug_message("   População: " + string(_recursos.populacao));
    
    // Quartéis
    with (obj_quartel) {
        show_debug_message("🏛️ Quartel Terrestre ID " + string(id) + ":");
        show_debug_message("   Produzindo: " + string(produzindo));
        show_debug_message("   Fila: " + string(ds_queue_size(fila_producao)));
        show_debug_message("   Unidades produzidas: " + string(unidades_produzidas));
        show_debug_message("   Selecionado: " + string(selecionado));
    }
    
    with (obj_quartel_marinha) {
        show_debug_message("🚢 Quartel Naval ID " + string(id) + ":");
        show_debug_message("   Produzindo: " + string(produzindo));
        show_debug_message("   Fila: " + string(ds_queue_size(fila_producao)));
        show_debug_message("   Unidades produzidas: " + string(unidades_produzidas));
        show_debug_message("   Selecionado: " + string(selecionado));
    }
    
    show_debug_message("=====================================");
}
