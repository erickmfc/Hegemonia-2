/// @function scr_diagnostico_edificios_completo()
/// @description Diagnóstico completo do sistema de clique em edifícios
/// @return {Boolean} true se todos os testes passaram

function scr_diagnostico_edificios_completo() {
    show_debug_message("=== 🔍 DIAGNÓSTICO COMPLETO - SISTEMA DE EDIFÍCIOS ===");
    
    var _testes_passaram = true;
    
    // === TESTE 1: FUNÇÃO GLOBAL ===
    show_debug_message("🧪 TESTE 1: Função global scr_mouse_to_world");
    if (!variable_global_exists("scr_mouse_to_world")) {
        show_debug_message("❌ FALHA: Função global scr_mouse_to_world não existe!");
        _testes_passaram = false;
    } else {
        show_debug_message("✅ PASSOU: Função global scr_mouse_to_world existe");
        
        // Testar conversão de coordenadas
        var _coords = global.scr_mouse_to_world();
        show_debug_message("   Coordenadas convertidas: (" + string(_coords[0]) + ", " + string(_coords[1]) + ")");
    }
    
    // === TESTE 2: SCRIPT UNIFICADO ===
    show_debug_message("🧪 TESTE 2: Script unificado scr_edificio_clique_unificado");
    if (!script_exists(scr_edificio_clique_unificado)) {
        show_debug_message("❌ FALHA: Script scr_edificio_clique_unificado não existe!");
        _testes_passaram = false;
    } else {
        show_debug_message("✅ PASSOU: Script scr_edificio_clique_unificado existe");
    }
    
    // === TESTE 3: OBJETOS DE EDIFÍCIOS ===
    show_debug_message("🧪 TESTE 3: Objetos de edifícios");
    var _edificios = [
        obj_quartel,
        obj_quartel_marinha, 
        obj_aeroporto_militar,
        obj_casa,
        obj_banco,
        obj_research_center
    ];
    
    for (var i = 0; i < array_length(_edificios); i++) {
        var _edificio = _edificios[i];
        if (!object_exists(_edificio)) {
            show_debug_message("❌ FALHA: Objeto " + object_get_name(_edificio) + " não existe!");
            _testes_passaram = false;
        } else {
            show_debug_message("✅ PASSOU: " + object_get_name(_edificio) + " existe");
        }
    }
    
    // === TESTE 4: OBJETOS DE MENU ===
    show_debug_message("🧪 TESTE 4: Objetos de menu");
    var _menus = [
        obj_menu_recrutamento,
        obj_menu_recrutamento_marinha,
        obj_menu_recrutamento_aereo
    ];
    
    for (var i = 0; i < array_length(_menus); i++) {
        var _menu = _menus[i];
        if (!object_exists(_menu)) {
            show_debug_message("❌ FALHA: Objeto " + object_get_name(_menu) + " não existe!");
            _testes_passaram = false;
        } else {
            show_debug_message("✅ PASSOU: " + object_get_name(_menu) + " existe");
        }
    }
    
    // === TESTE 5: EVENTOS MOUSE_53 ===
    show_debug_message("🧪 TESTE 5: Eventos Mouse_53 dos edifícios");
    for (var i = 0; i < array_length(_edificios); i++) {
        var _edificio = _edificios[i];
        if (event_exists(_edificio, ev_mouse, ev_mouse_left)) {
            show_debug_message("✅ PASSOU: " + object_get_name(_edificio) + " tem evento Mouse_53");
        } else {
            show_debug_message("❌ FALHA: " + object_get_name(_edificio) + " não tem evento Mouse_53!");
            _testes_passaram = false;
        }
    }
    
    // === TESTE 6: CONFLITO DE EVENTOS ===
    show_debug_message("🧪 TESTE 6: Conflito de eventos");
    if (event_exists(obj_controlador_unidades, ev_mouse, ev_mouse_left)) {
        show_debug_message("❌ FALHA: obj_controlador_unidades ainda tem evento Mouse_53 (conflito)!");
        _testes_passaram = false;
    } else {
        show_debug_message("✅ PASSOU: obj_controlador_unidades não tem evento Mouse_53");
    }
    
    // === TESTE 7: VARIÁVEIS GLOBAIS ===
    show_debug_message("🧪 TESTE 7: Variáveis globais necessárias");
    var _variaveis_globais = [
        "menu_recrutamento_aberto",
        "modo_construcao",
        "construindo_agora",
        "menu_pesquisa_aberto"
    ];
    
    for (var i = 0; i < array_length(_variaveis_globais); i++) {
        var _var = _variaveis_globais[i];
        if (!variable_global_exists(_var)) {
            show_debug_message("⚠️ AVISO: Variável global " + _var + " não existe (será criada automaticamente)");
        } else {
            show_debug_message("✅ PASSOU: Variável global " + _var + " existe");
        }
    }
    
    // === RESULTADO FINAL ===
    show_debug_message("=== 📊 RESULTADO FINAL ===");
    if (_testes_passaram) {
        show_debug_message("✅ TODOS OS TESTES PASSARAM!");
        show_debug_message("🎯 Sistema de clique em edifícios está funcionando corretamente");
    } else {
        show_debug_message("❌ ALGUNS TESTES FALHARAM!");
        show_debug_message("🔧 Verifique os problemas listados acima");
    }
    
    return _testes_passaram;
}
