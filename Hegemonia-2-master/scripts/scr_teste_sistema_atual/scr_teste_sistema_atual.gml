/// @description Teste rápido do sistema atual de edifícios
/// Verificar se o sistema já implementado funciona corretamente

function scr_teste_sistema_atual() {
    show_debug_message("🔍 === TESTE DO SISTEMA ATUAL ===");
    
    // Verificar se função unificada existe
    if (function_exists("scr_edificio_clique_unificado")) {
        show_debug_message("✅ scr_edificio_clique_unificado() existe");
    } else {
        show_debug_message("❌ scr_edificio_clique_unificado() NÃO existe");
        return false;
    }
    
    // Verificar se função de deseleção existe
    if (function_exists("scr_deselecionar_unidades_edificio_clicado")) {
        show_debug_message("✅ scr_deselecionar_unidades_edificio_clicado() existe");
    } else {
        show_debug_message("❌ scr_deselecionar_unidades_edificio_clicado() NÃO existe");
        return false;
    }
    
    // Verificar edifícios
    var _edificios = [
        {obj: obj_quartel, nome: "Quartel"},
        {obj: obj_quartel_marinha, nome: "Quartel Marinha"},
        {obj: obj_aeroporto_militar, nome: "Aeroporto"},
        {obj: obj_casa, nome: "Casa"},
        {obj: obj_banco, nome: "Banco"},
        {obj: obj_research_center, nome: "Research Center"}
    ];
    
    var _edificios_ok = 0;
    
    for (var i = 0; i < array_length(_edificios); i++) {
        var _edificio_data = _edificios[i];
        var _obj = _edificio_data.obj;
        var _nome = _edificio_data.nome;
        
        if (object_exists(_obj)) {
            show_debug_message("✅ " + _nome + ": Objeto existe");
            
            // Verificar Mouse Event
            var _mouse_file = "objects/" + object_get_name(_obj) + "/Mouse_53.gml";
            if (file_exists(_mouse_file)) {
                show_debug_message("✅ " + _nome + ": Mouse Event existe");
                _edificios_ok++;
            } else {
                show_debug_message("❌ " + _nome + ": Mouse Event NÃO existe");
            }
        } else {
            show_debug_message("❌ " + _nome + ": Objeto NÃO existe");
        }
    }
    
    show_debug_message("📊 Edifícios funcionais: " + string(_edificios_ok) + "/" + string(array_length(_edificios)));
    
    if (_edificios_ok == array_length(_edificios)) {
        show_debug_message("🎉 SISTEMA ATUAL ESTÁ FUNCIONANDO!");
        return true;
    } else {
        show_debug_message("⚠️ SISTEMA ATUAL TEM PROBLEMAS");
        return false;
    }
}
