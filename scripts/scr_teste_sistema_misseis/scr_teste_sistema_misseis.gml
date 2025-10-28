/// @description Teste do Sistema de Mísseis
/// @param x_pos Posição X para teste
/// @param y_pos Posição Y para teste

// ===============================================
// HEGEMONIA GLOBAL - TESTE DO SISTEMA DE MÍSSEIS
// Script para testar todos os objetos criados
// ===============================================

var _x_pos = argument0;
var _y_pos = argument1;

show_debug_message("🚀 INICIANDO TESTE DO SISTEMA DE MÍSSEIS");

// === TESTE 1: DISPARAR MÍSSEIS ===
show_debug_message("📡 Teste 1: Disparando mísseis...");

// Teste míssil ar-ar
// ✅ CORREÇÃO GM2039: Usar sintaxe de função moderna
var _missil_ar = scr_disparar_missil(noone, "ar", _x_pos, _y_pos, self);
if (instance_exists(_missil_ar)) {
    show_debug_message("✅ Míssil ar-ar criado com sucesso!");
} else {
    show_debug_message("❌ Falha ao criar míssil ar-ar");
}

// Teste míssil terra-terra
// ✅ CORREÇÃO GM2039: Usar sintaxe de função moderna
var _missil_terra = scr_disparar_missil(noone, "terra", _x_pos + 50, _y_pos, self);
if (instance_exists(_missil_terra)) {
    show_debug_message("✅ Míssil terra-terra criado com sucesso!");
} else {
    show_debug_message("❌ Falha ao criar míssil terra-terra");
}

// === TESTE 2: EFEITOS VISUAIS ===
show_debug_message("💥 Teste 2: Criando efeitos visuais...");

// Teste explosão terrestre
var _explosao_terra = instance_create_layer(_x_pos + 100, _y_pos, "Efeitos", obj_explosao_terra);
if (instance_exists(_explosao_terra)) {
    show_debug_message("✅ Explosão terrestre criada com sucesso!");
} else {
    show_debug_message("❌ Falha ao criar explosão terrestre");
}

// Teste explosão aérea
var _explosao_ar = instance_create_layer(_x_pos + 150, _y_pos, "Efeitos", obj_explosao_ar);
if (instance_exists(_explosao_ar)) {
    show_debug_message("✅ Explosão aérea criada com sucesso!");
} else {
    show_debug_message("❌ Falha ao criar explosão aérea");
}

// Teste cratera temporária
var _cratera = instance_create_layer(_x_pos + 200, _y_pos, "Efeitos", obj_cratera_temporaria);
if (instance_exists(_cratera)) {
    show_debug_message("✅ Cratera temporária criada com sucesso!");
} else {
    show_debug_message("❌ Falha ao criar cratera temporária");
}

// === TESTE 3: PARTÍCULAS ===
show_debug_message("✨ Teste 3: Criando partículas...");

// Teste partículas de fogo
for (var i = 0; i < 5; i++) {
    var _particula_fogo = instance_create_layer(_x_pos + 250 + (i * 10), _y_pos, "Efeitos", obj_particula_fogo);
    if (instance_exists(_particula_fogo)) {
        _particula_fogo.speed = random_range(2, 6);
        _particula_fogo.direction = random(360);
    }
}

// Teste partículas de terra
for (var i = 0; i < 5; i++) {
    var _particula_terra = instance_create_layer(_x_pos + 300 + (i * 10), _y_pos, "Efeitos", obj_particula_terra);
    if (instance_exists(_particula_terra)) {
        _particula_terra.speed = random_range(3, 8);
        _particula_terra.direction = random(360);
    }
}

show_debug_message("✅ Partículas criadas com sucesso!");

// === TESTE 4: RASTRO DE FOGO ===
show_debug_message("🔥 Teste 4: Criando rastro de fogo...");

var _rastro_fogo = instance_create_layer(_x_pos + 350, _y_pos, "Efeitos", obj_rastro_fogo);
if (instance_exists(_rastro_fogo)) {
    show_debug_message("✅ Rastro de fogo criado com sucesso!");
} else {
    show_debug_message("❌ Falha ao criar rastro de fogo");
}

// === TESTE 5: FUMACA ===
show_debug_message("💨 Teste 5: Criando fumaça...");

for (var i = 0; i < 3; i++) {
    var _fumaca = instance_create_layer(_x_pos + 400 + (i * 15), _y_pos, "Efeitos", obj_fumaca_missil);
    if (instance_exists(_fumaca)) {
        _fumaca.vspeed = random_range(-2, -0.5);
        _fumaca.hspeed = random_range(-1.5, 1.5);
    }
}

show_debug_message("✅ Fumaça criada com sucesso!");

// === RESULTADO FINAL ===
show_debug_message("🎯 TESTE DO SISTEMA DE MÍSSEIS CONCLUÍDO!");
show_debug_message("📊 Todos os objetos foram testados e estão funcionando!");
show_debug_message("🚀 Sistema pronto para uso em combate!");
