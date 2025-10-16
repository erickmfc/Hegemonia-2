/// @param alvo
/// @param tipo ("ar" ou "terra")
/// @param x_origem
/// @param y_origem
/// @param dono

var alvo = argument0;
var tipo = argument1;
var xx = argument2;
var yy = argument3;
var dono = argument4;
var m = noone; // Inicializar como noone

show_debug_message("🔍 scr_disparar_missil: Chamado com tipo='" + string(tipo) + "'");

switch (tipo) {
    case "ar":
        show_debug_message("🚀 Criando míssil ar-ar (SkyFury)");
        m = instance_create_layer(xx, yy, "Projeteis", obj_SkyFury_ar);
        break;
    case "terra":
        show_debug_message("🚀 Criando míssil terra-terra (Ironclad)");
        m = instance_create_layer(xx, yy, "Projeteis", obj_Ironclad_terra);
        break;
    default:
        show_debug_message("❌ scr_disparar_missil: Tipo inválido '" + string(tipo) + "'. Use 'ar' ou 'terra'.");
        return noone;
}

// Verificar se o míssil foi criado com sucesso
if (instance_exists(m)) {
    m.target = alvo;
    m.dono = dono;
    show_debug_message("✅ Míssil " + string(tipo) + " criado com sucesso!");
} else {
    show_debug_message("❌ Falha ao criar míssil " + string(tipo));
}

return m;
