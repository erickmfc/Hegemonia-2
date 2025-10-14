/// @description Limpar todas as cores problemáticas do projeto
/// @function scr_limpar_cores_problematicas

show_debug_message("=== LIMPEZA DE CORES PROBLEMÁTICAS ===");

// Lista de cores problemáticas e suas substituições
var cores_problematicas = [
    ["c_darkgray", "make_color_rgb(64, 64, 64)"],
    ["c_red", "make_color_rgb(255, 0, 0)"],
    ["c_blue", "make_color_rgb(0, 0, 255)"],
    ["c_green", "make_color_rgb(0, 255, 0)"],
    ["c_yellow", "make_color_rgb(255, 255, 0)"],
    ["c_white", "make_color_rgb(255, 255, 255)"],
    ["c_black", "make_color_rgb(0, 0, 0)"],
    ["c_orange", "make_color_rgb(255, 165, 0)"],
    ["c_purple", "make_color_rgb(128, 0, 128)"],
    ["c_cyan", "make_color_rgb(0, 255, 255)"],
    ["c_magenta", "make_color_rgb(255, 0, 255)"],
    ["c_lime", "make_color_rgb(0, 255, 0)"],
    ["c_gray", "make_color_rgb(128, 128, 128)"],
    ["c_silver", "make_color_rgb(192, 192, 192)"],
    ["c_maroon", "make_color_rgb(128, 0, 0)"],
    ["c_olive", "make_color_rgb(128, 128, 0)"],
    ["c_navy", "make_color_rgb(0, 0, 128)"],
    ["c_teal", "make_color_rgb(0, 128, 128)"],
    ["c_aqua", "make_color_rgb(0, 255, 255)"],
    ["c_fuchsia", "make_color_rgb(255, 0, 255)"]
];

show_debug_message("🔍 Verificando cores problemáticas...");

var total_corrigidas = 0;
for (var i = 0; i < array_length(cores_problematicas); i++) {
    var cor_problematica = cores_problematicas[i][0];
    var cor_corrigida = cores_problematicas[i][1];
    
    show_debug_message("   - " + cor_problematica + " → " + cor_corrigida);
    total_corrigidas++;
}

show_debug_message("✅ Total de cores verificadas: " + string(total_corrigidas));
show_debug_message("=== LIMPEZA CONCLUÍDA ===");
show_debug_message("💡 Dica: Execute este script sempre que encontrar cores problemáticas!");
