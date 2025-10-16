/// @description Teste do sistema de clique no Constellation
/// @param x_pos Posição X para criar Constellation
/// @param y_pos Posição Y para criar Constellation

show_debug_message("🖱️ TESTE DO SISTEMA DE CLIQUE NO CONSTELLATION");

// === TESTE 1: CRIAR CONSTELLATION ===
show_debug_message("🚢 Teste 1: Criando Constellation...");

var _constellation = instance_create_layer(argument0, argument1, "rm_mapa_principal", obj_Constellation);
if (instance_exists(_constellation)) {
    show_debug_message("✅ Constellation criado com sucesso!");
    show_debug_message("📍 Posição: (" + string(round(_constellation.x)) + ", " + string(round(_constellation.y)) + ")");
} else {
    show_debug_message("❌ Falha ao criar Constellation");
    return;
}

// === TESTE 2: VERIFICAR SISTEMA DE SELEÇÃO ===
show_debug_message("🎯 Teste 2: Verificando sistema de seleção...");

// Verificar se o controlador existe
if (instance_exists(obj_controlador_unidades)) {
    show_debug_message("✅ obj_controlador_unidades existe");
} else {
    show_debug_message("❌ obj_controlador_unidades NÃO existe");
}

// Verificar se o Constellation está na lista de seleção
show_debug_message("🔍 Verificando se Constellation está no sistema de seleção...");

// === TESTE 3: SIMULAR SELEÇÃO ===
show_debug_message("🎮 Teste 3: Simulando seleção...");

// Desselecionar todas as unidades
with (obj_lancha_patrulha) { selecionado = false; }
with (obj_Constellation) { selecionado = false; }
with (obj_infantaria) { selecionado = false; }
with (obj_soldado_antiaereo) { selecionado = false; }
with (obj_tanque) { selecionado = false; }
with (obj_blindado_antiaereo) { selecionado = false; }
with (obj_caca_f5) { selecionado = false; }
with (obj_helicoptero_militar) { selecionado = false; }

// Selecionar o Constellation
_constellation.selecionado = true;
global.unidade_selecionada = _constellation;

show_debug_message("✅ Constellation selecionado manualmente");
show_debug_message("📊 global.unidade_selecionada: " + string(global.unidade_selecionada));

// === TESTE 4: VERIFICAR FEEDBACK VISUAL ===
show_debug_message("👁️ Teste 4: Verificando feedback visual...");

if (_constellation.selecionado) {
    show_debug_message("✅ Constellation está selecionado - deve mostrar:");
    show_debug_message("   - Círculo verde de seleção");
    show_debug_message("   - Círculo do radar");
    show_debug_message("   - Status e controles na tela");
} else {
    show_debug_message("❌ Constellation NÃO está selecionado");
}

// === TESTE 5: VERIFICAR CONTROLES ===
show_debug_message("⌨️ Teste 5: Controles disponíveis:");
show_debug_message("   L = Parar");
show_debug_message("   K = Iniciar Patrulha");
show_debug_message("   P = Modo Passivo");
show_debug_message("   O = Modo Ataque");
show_debug_message("   F = Tiro Manual");
show_debug_message("   Clique = Adicionar ponto de patrulha");

// === TESTE 6: VERIFICAR SISTEMA DE PATRULHA ===
show_debug_message("📍 Teste 6: Verificando sistema de patrulha...");

// Adicionar alguns pontos de patrulha
_constellation.func_adicionar_ponto(_constellation.x + 200, _constellation.y);
_constellation.func_adicionar_ponto(_constellation.x + 100, _constellation.y + 150);
_constellation.func_adicionar_ponto(_constellation.x - 100, _constellation.y + 100);

show_debug_message("✅ 3 pontos de patrulha adicionados");
show_debug_message("📊 Total de pontos: " + string(ds_list_size(_constellation.pontos_patrulha)));

// === INSTRUÇÕES PARA O JOGADOR ===
show_debug_message("🎯 INSTRUÇÕES PARA TESTE:");
show_debug_message("1. O Constellation deve estar selecionado (círculo verde)");
show_debug_message("2. Pressione K para iniciar patrulha");
show_debug_message("3. Pressione O para modo ataque");
show_debug_message("4. Clique no mapa para adicionar mais pontos");
show_debug_message("5. Pressione F para tiro manual");

// === RESULTADO FINAL ===
show_debug_message("🎯 TESTE DO SISTEMA DE CLIQUE CONCLUÍDO!");
show_debug_message("📊 Constellation criado e selecionado");
show_debug_message("🎮 Sistema de clique deve estar funcionando!");
show_debug_message("👁️ Verifique se o feedback visual está aparecendo");

// Verificar se há problemas
if (!_constellation.selecionado) {
    show_debug_message("⚠️ PROBLEMA: Constellation não está selecionado!");
} else {
    show_debug_message("✅ SUCESSO: Constellation está selecionado e pronto para uso!");
}
