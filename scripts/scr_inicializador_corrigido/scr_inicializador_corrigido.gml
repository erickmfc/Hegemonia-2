// ===============================================
// HEGEMONIA GLOBAL - INICIALIZADOR CORRIGIDO
// Sistema Unificado com Correções de Erros
// ===============================================

/// @description Inicializar sistema unificado corrigido
function inicializar_sistema_unificado_corrigido() {
    show_debug_message("🚀 Iniciando sistema unificado corrigido...");
    
    // 1. Inicializar recursos globais se não existirem
    if (!variable_global_exists("dinheiro")) {
        global.dinheiro = 1000;
        show_debug_message("💰 Dinheiro inicializado: " + string(global.dinheiro));
    }
    
    if (!variable_global_exists("minerio")) {
        global.minerio = 500;
        show_debug_message("⛏️ Minério inicializado: " + string(global.minerio));
    }
    
    if (!variable_global_exists("populacao")) {
        global.populacao = 100;
        show_debug_message("👥 População inicializada: " + string(global.populacao));
    }
    
    if (!variable_global_exists("militares_totais")) {
        global.militares_totais = 0;
        show_debug_message("🪖 Militares totais inicializados: " + string(global.militares_totais));
    }
    
    // 2. Validar objetos existentes
    validar_objetos_sistema_unificado();
    
    // 3. Configurar quartéis existentes
    configurar_quartéis_sistema_unificado();
    
    show_debug_message("✅ Sistema unificado corrigido inicializado!");
}

/// @description Validar objetos do sistema unificado
function validar_objetos_sistema_unificado() {
    show_debug_message("🔍 Validando objetos do sistema unificado...");
    
    // Verificar objeto base
    if (!object_exists(obj_quartel_base)) {
        show_debug_message("❌ ERRO CRÍTICO: obj_quartel_base não existe!");
        return false;
    }
    
    // Verificar quartéis específicos
    if (!object_exists(obj_quartel)) {
        show_debug_message("❌ ERRO: obj_quartel não existe!");
        return false;
    }
    
    if (!object_exists(obj_quartel_marinha)) {
        show_debug_message("❌ ERRO: obj_quartel_marinha não existe!");
        return false;
    }
    
    // Verificar objetos de unidades
    var _objetos_unidades = [obj_infantaria, obj_soldado_antiaereo, obj_tanque, obj_lancha_patrulha];
    var _objetos_validos = 0;
    
    for (var i = 0; i < array_length(_objetos_unidades); i++) {
        if (object_exists(_objetos_unidades[i])) {
            _objetos_validos++;
            show_debug_message("✅ " + string(_objetos_unidades[i]) + " existe");
        } else {
            show_debug_message("❌ " + string(_objetos_unidades[i]) + " não existe");
        }
    }
    
    show_debug_message("📊 Objetos de unidades válidos: " + string(_objetos_validos) + "/" + string(array_length(_objetos_unidades)));
    
    return _objetos_validos > 0;
}

/// @description Configurar quartéis do sistema unificado
function configurar_quartéis_sistema_unificado() {
    show_debug_message("🔧 Configurando quartéis do sistema unificado...");
    
    var _quartéis_configurados = 0;
    
    // Configurar quartéis terrestres
    with (obj_quartel) {
        // Verificar se variáveis existem (devem existir por herança)
        if (!variable_instance_exists(id, "fila_producao")) {
            fila_producao = ds_queue_create();
            show_debug_message("⚠️ fila_producao criada para quartel " + string(id));
        }
        
        if (!variable_instance_exists(id, "unidades_disponiveis")) {
            unidades_disponiveis = ds_list_create();
            show_debug_message("⚠️ unidades_disponiveis criada para quartel " + string(id));
        }
        
        _quartéis_configurados++;
        show_debug_message("✅ Quartel terrestre ID " + string(id) + " configurado");
    }
    
    // Configurar quartéis navais
    with (obj_quartel_marinha) {
        // Verificar se variáveis existem (devem existir por herança)
        if (!variable_instance_exists(id, "fila_producao")) {
            fila_producao = ds_queue_create();
            show_debug_message("⚠️ fila_producao criada para quartel naval " + string(id));
        }
        
        if (!variable_instance_exists(id, "unidades_disponiveis")) {
            unidades_disponiveis = ds_list_create();
            show_debug_message("⚠️ unidades_disponiveis criada para quartel naval " + string(id));
        }
        
        _quartéis_configurados++;
        show_debug_message("✅ Quartel naval ID " + string(id) + " configurado");
    }
    
    show_debug_message("📊 Quartéis configurados: " + string(_quartéis_configurados));
}

/// @description Testar sistema unificado corrigido
function testar_sistema_unificado_corrigido() {
    show_debug_message("🧪 === TESTE DO SISTEMA UNIFICADO CORRIGIDO ===");
    
    // 1. Verificar recursos
    var _recursos = scr_obter_recursos_disponiveis();
    show_debug_message("💰 Recursos disponíveis:");
    show_debug_message("   Dinheiro: " + string(_recursos.dinheiro));
    show_debug_message("   Minério: " + string(_recursos.minerio));
    show_debug_message("   População: " + string(_recursos.populacao));
    
    // 2. Verificar quartéis
    var _quartéis_terrestres = 0;
    var _quartéis_navais = 0;
    
    with (obj_quartel) {
        _quartéis_terrestres++;
        show_debug_message("🏛️ Quartel terrestre ID " + string(id) + ":");
        show_debug_message("   Unidades disponíveis: " + string(ds_list_size(unidades_disponiveis)));
        show_debug_message("   Fila de produção: " + string(ds_queue_size(fila_producao)));
    }
    
    with (obj_quartel_marinha) {
        _quartéis_navais++;
        show_debug_message("🚢 Quartel naval ID " + string(id) + ":");
        show_debug_message("   Unidades disponíveis: " + string(ds_list_size(unidades_disponiveis)));
        show_debug_message("   Fila de produção: " + string(ds_queue_size(fila_producao)));
    }
    
    show_debug_message("📊 Total de quartéis: " + string(_quartéis_terrestres + _quartéis_navais));
    show_debug_message("===============================================");
    
    return true;
}
