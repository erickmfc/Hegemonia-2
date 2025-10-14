// =========================================================
// HEGEMONIA GLOBAL - SCRIPT DE TESTE DE REGISTRO
// Teste para verificar se obj_controlador_construcao foi registrado
// =========================================================

// Função para testar se o objeto existe no projeto
function test_construction_controller() {
    show_debug_message("=== TESTE DE REGISTRO DO CONTROLADOR ===");
    
    // Tenta verificar se o objeto existe
    try {
        var test_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_controlador_construcao);
        if (instance_exists(test_instance)) {
            show_debug_message("✅ obj_controlador_construcao registrado corretamente!");
            instance_destroy(test_instance);
            return true;
        } else {
            show_debug_message("❌ Falha ao criar instância do objeto");
            return false;
        }
    } catch (e) {
        show_debug_message("❌ Erro ao tentar criar objeto: " + string(e));
        return false;
    }
}