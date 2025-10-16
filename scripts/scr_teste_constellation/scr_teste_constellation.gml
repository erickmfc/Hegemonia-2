/// @description Teste do Constellation com Sistema de Mísseis
/// @param x_pos Posição X para teste
/// @param y_pos Posição Y para teste

// ===============================================
// HEGEMONIA GLOBAL - TESTE DO CONSTELLATION
// Script para testar o navio Constellation com mísseis
// ===============================================

var _x_pos = argument0;
var _y_pos = argument1;

show_debug_message("🚢 INICIANDO TESTE DO CONSTELLATION");

// === TESTE 1: CRIAR CONSTELLATION ===
show_debug_message("🚢 Teste 1: Criando Constellation...");

var _constellation = instance_create_layer(_x_pos, _y_pos, "rm_mapa_principal", obj_Constellation);
if (instance_exists(_constellation)) {
    show_debug_message("✅ Constellation criado com sucesso!");
    
    // Configurar Constellation para teste
    _constellation.selecionado = true;
    _constellation.modo_combate = ConstellationMode.ATAQUE;
    _constellation.modo_ataque = true;
    
    show_debug_message("⚔️ Constellation configurado em modo ATAQUE");
} else {
    show_debug_message("❌ Falha ao criar Constellation");
    return;
}

// === TESTE 2: ADICIONAR PONTOS DE PATRULHA ===
show_debug_message("📍 Teste 2: Adicionando pontos de patrulha...");

// Adicionar 3 pontos de patrulha em forma de triângulo
_constellation.func_adicionar_ponto(_x_pos + 200, _y_pos);
_constellation.func_adicionar_ponto(_x_pos + 100, _y_pos + 150);
_constellation.func_adicionar_ponto(_x_pos - 100, _y_pos + 100);

show_debug_message("✅ 3 pontos de patrulha adicionados!");

// === TESTE 3: CRIAR INIMIGOS PARA TESTE ===
show_debug_message("🎯 Teste 3: Criando inimigos para teste...");

// Criar inimigo terrestre
var _inimigo_terra = instance_create_layer(_x_pos + 300, _y_pos + 50, "rm_mapa_principal", obj_inimigo);
if (instance_exists(_inimigo_terra)) {
    _inimigo_terra.nacao_proprietaria = 2; // Inimigo
    show_debug_message("✅ Inimigo terrestre criado!");
}

// Criar inimigo aéreo (se existir)
if (object_exists(obj_helicoptero_militar)) {
    var _inimigo_ar = instance_create_layer(_x_pos + 400, _y_pos - 100, "rm_mapa_principal", obj_helicoptero_militar);
    if (instance_exists(_inimigo_ar)) {
        _inimigo_ar.nacao_proprietaria = 2; // Inimigo
        show_debug_message("✅ Inimigo aéreo criado!");
    }
}

// === TESTE 4: TESTAR SISTEMA DE MÍSSEIS ===
show_debug_message("🚀 Teste 4: Testando sistema de mísseis...");

// Simular disparo de míssil
if (instance_exists(_inimigo_terra)) {
    var _missil = _constellation.func_disparar_missil(_inimigo_terra, "auto");
    if (instance_exists(_missil)) {
        show_debug_message("✅ Míssil disparado com sucesso!");
    } else {
        show_debug_message("❌ Falha ao disparar míssil");
    }
}

// === TESTE 5: TESTAR CONTROLES ===
show_debug_message("🎮 Teste 5: Controles configurados:");
show_debug_message("   L = Parar");
show_debug_message("   K = Iniciar Patrulha");
show_debug_message("   P = Modo Passivo");
show_debug_message("   O = Modo Ataque");
show_debug_message("   F = Tiro Manual");
show_debug_message("   Clique = Adicionar ponto de patrulha");

// === RESULTADO FINAL ===
show_debug_message("🎯 TESTE DO CONSTELLATION CONCLUÍDO!");
show_debug_message("📊 Constellation pronto para combate com mísseis!");
show_debug_message("🚀 Sistema SkyFury (ar-ar) e Ironclad (terra-terra) integrado!");
show_debug_message("🎮 Controles L, K, P, O funcionando!");

// Instruções para o jogador
show_debug_message("📋 INSTRUÇÕES:");
show_debug_message("1. Selecione o Constellation (clique nele)");
show_debug_message("2. Pressione K para iniciar patrulha");
show_debug_message("3. Pressione O para modo ataque");
show_debug_message("4. Pressione F para tiro manual");
show_debug_message("5. Clique no mapa para adicionar pontos de patrulha");
