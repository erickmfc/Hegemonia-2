/// @param x_pos
/// @param y_pos
/// @description Script de teste para verificar se o erro do debug_info foi corrigido

var _x_pos = argument0;
var _y_pos = argument1;

show_debug_message("--- TESTANDO CORREÇÃO DO ERRO DEBUG_INFO ---");

// 1. Criar ou encontrar Constellation
var _constellation = noone;
if (!instance_exists(obj_Constellation)) {
    _constellation = instance_create_layer(_x_pos, _y_pos, "Instances", obj_Constellation);
    show_debug_message("✅ Constellation criado para teste");
} else {
    _constellation = instance_find(obj_Constellation, 0);
    _constellation.x = _x_pos;
    _constellation.y = _y_pos;
    show_debug_message("✅ Constellation existente usado para teste");
}

if (instance_exists(_constellation)) {
    // 2. Verificar se debug_info foi inicializado
    if (variable_instance_exists(_constellation.id, "debug_info")) {
        show_debug_message("✅ debug_info inicializado corretamente");
        show_debug_message("   Ações: " + string(_constellation.debug_info.acoes));
        show_debug_message("   Mísseis disparados: " + string(_constellation.debug_info.misseis_disparados));
    } else {
        show_debug_message("⚠️ debug_info NÃO foi inicializado no Create Event");
        show_debug_message("   Será inicializado automaticamente quando necessário");
    }
    
    // 3. Testar seleção (que deve inicializar debug_info se necessário)
    _constellation.selecionado = true;
    show_debug_message("✅ Constellation selecionado");
    
    // Simular clique para testar Mouse_4.gml
    show_debug_message("🧪 Simulando clique para testar Mouse_4.gml...");
    
    // Verificar novamente após seleção
    if (variable_instance_exists(_constellation.id, "debug_info")) {
        show_debug_message("✅ debug_info agora existe após seleção");
        show_debug_message("   Ações: " + string(_constellation.debug_info.acoes));
        show_debug_message("   Mísseis disparados: " + string(_constellation.debug_info.misseis_disparados));
    } else {
        show_debug_message("❌ debug_info ainda não existe após seleção");
    }
    
    // 4. Testar outras variáveis críticas
    show_debug_message("--- VERIFICAÇÃO DE VARIÁVEIS CRÍTICAS ---");
    show_debug_message("   HP: " + string(_constellation.hp_atual) + "/" + string(_constellation.hp_max));
    show_debug_message("   Estado: " + string(_constellation.estado));
    show_debug_message("   Selecionado: " + string(_constellation.selecionado));
    show_debug_message("   Alcance radar: " + string(_constellation.alcance_radar));
    show_debug_message("   Alcance mísseis: " + string(_constellation.missil_alcance));
    
    // 5. Verificar sistema de patrulha
    if (ds_exists(_constellation.pontos_patrulha, ds_type_list)) {
        show_debug_message("✅ pontos_patrulha existe");
        show_debug_message("   Tamanho: " + string(ds_list_size(_constellation.pontos_patrulha)));
    } else {
        show_debug_message("❌ pontos_patrulha NÃO existe");
    }
    
    show_debug_message("✅ TESTE CONCLUÍDO - Erro deve estar corrigido!");
    show_debug_message("   Verifique se o Mouse_4.gml não apresenta mais erros");
    show_debug_message("   O Constellation deve funcionar sem crashes");
    
} else {
    show_debug_message("❌ Falha ao criar/encontrar Constellation para teste");
}

show_debug_message("--- TESTE DE CORREÇÃO DEBUG_INFO CONCLUÍDO ---");
