/// @description Teste simples dos mísseis
/// @param x_pos Posição X
/// @param y_pos Posição Y

show_debug_message("🧪 TESTE SIMPLES DOS MÍSSEIS");

// Teste 1: Verificar se os objetos existem
show_debug_message("🔍 Verificando objetos...");
if (object_exists(obj_SkyFury_ar)) {
    show_debug_message("✅ obj_SkyFury_ar existe");
} else {
    show_debug_message("❌ obj_SkyFury_ar NÃO existe");
}

if (object_exists(obj_Ironclad_terra)) {
    show_debug_message("✅ obj_Ironclad_terra existe");
} else {
    show_debug_message("❌ obj_Ironclad_terra NÃO existe");
}

// Teste 2: Verificar se o layer existe
show_debug_message("🔍 Verificando layer Projeteis...");
if (layer_exists("Projeteis")) {
    show_debug_message("✅ Layer Projeteis existe");
} else {
    show_debug_message("❌ Layer Projeteis NÃO existe");
}

// Teste 3: Criar mísseis diretamente
show_debug_message("🚀 Teste 3: Criando mísseis diretamente...");

var _missil_ar = instance_create_layer(argument0, argument1, "Projeteis", obj_SkyFury_ar);
if (instance_exists(_missil_ar)) {
    show_debug_message("✅ Míssil ar-ar criado diretamente!");
} else {
    show_debug_message("❌ Falha ao criar míssil ar-ar diretamente");
}

var _missil_terra = instance_create_layer(argument0 + 50, argument1, "Projeteis", obj_Ironclad_terra);
if (instance_exists(_missil_terra)) {
    show_debug_message("✅ Míssil terra-terra criado diretamente!");
} else {
    show_debug_message("❌ Falha ao criar míssil terra-terra diretamente");
}

// Teste 4: Usar o script
show_debug_message("🚀 Teste 4: Usando scr_disparar_missil...");

var _missil_script_ar = scr_disparar_missil(noone, "ar", argument0 + 100, argument1, self);
if (instance_exists(_missil_script_ar)) {
    show_debug_message("✅ Script criou míssil ar-ar!");
} else {
    show_debug_message("❌ Script falhou ao criar míssil ar-ar");
}

var _missil_script_terra = scr_disparar_missil(noone, "terra", argument0 + 150, argument1, self);
if (instance_exists(_missil_script_terra)) {
    show_debug_message("✅ Script criou míssil terra-terra!");
} else {
    show_debug_message("❌ Script falhou ao criar míssil terra-terra");
}

show_debug_message("🎯 TESTE SIMPLES CONCLUÍDO!");
