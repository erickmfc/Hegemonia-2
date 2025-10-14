// =========================================================
// VERIFICADOR DE FONTES PROBLEMÁTICAS
// Procura por referências incorretas de fontes no projeto
// =========================================================

function scr_verificar_fontes_problematicas() {
    show_debug_message("🔍 VERIFICADOR DE FONTES PROBLEMÁTICAS");
    show_debug_message("=====================================");
    
    // Lista de fontes problemáticas conhecidas
    var _fontes_problematicas = [
        "font_ hegemonia_main",
        "font_hegemonia_main", 
        "fnt_arial",
        "font_arial"
    ];
    
    var _problemas_encontrados = 0;
    
    // Verificar cada fonte problemática
    for (var i = 0; i < array_length(_fontes_problematicas); i++) {
        var _fonte_problema = _fontes_problematicas[i];
        
        // Verificar se a fonte existe
        if (!font_exists(asset_get_index(_fonte_problema))) {
            show_debug_message("❌ Fonte problemática encontrada: " + _fonte_problema);
            _problemas_encontrados++;
        }
    }
    
    // Verificar fontes válidas
    var _fontes_validas = [
        "fnt_ui_main"
    ];
    
    show_debug_message("✅ Fontes válidas disponíveis:");
    for (var i = 0; i < array_length(_fontes_validas); i++) {
        var _fonte_valida = _fontes_validas[i];
        if (font_exists(asset_get_index(_fonte_valida))) {
            show_debug_message("   ✅ " + _fonte_valida + " - Disponível");
        } else {
            show_debug_message("   ❌ " + _fonte_valida + " - NÃO encontrada");
            _problemas_encontrados++;
        }
    }
    
    // Resultado final
    show_debug_message("=====================================");
    if (_problemas_encontrados == 0) {
        show_debug_message("🎉 TODAS AS FONTES ESTÃO CORRETAS!");
    } else {
        show_debug_message("⚠️ " + string(_problemas_encontrados) + " problemas encontrados");
    }
    
    return (_problemas_encontrados == 0);
}
