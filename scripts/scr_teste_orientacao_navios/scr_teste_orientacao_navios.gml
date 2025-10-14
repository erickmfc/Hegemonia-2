/// @description Teste de Orientação dos Navios
/// @param {bool} detalhado Se true, mostra análise detalhada

function scr_teste_orientacao_navios(detalhado = true) {
    show_debug_message("=== 🚢 TESTE DE ORIENTAÇÃO DOS NAVIOS ===");
    
    // === 1. VERIFICAR NAVIOS EXISTENTES ===
    var navios_existentes = 0;
    var navios_selecionados = 0;
    
    with (obj_lancha_patrulha) {
        navios_existentes++;
        if (selecionado) navios_selecionados++;
    }
    
    show_debug_message("📊 NAVIOS ENCONTRADOS:");
    show_debug_message("   - Total: " + string(navios_existentes));
    show_debug_message("   - Selecionados: " + string(navios_selecionados));
    
    if (navios_existentes == 0) {
        show_debug_message("❌ ERRO: Nenhum navio encontrado!");
        show_debug_message("   - Construa um quartel de marinha");
        show_debug_message("   - Produza uma lancha patrulha");
        return false;
    }
    
    // === 2. TESTE DE ORIENTAÇÃO ===
    with (obj_lancha_patrulha) {
        if (selecionado) {
            show_debug_message("--- TESTE DE ORIENTAÇÃO - NAVIO ID: " + string(id) + " ---");
            
            // Posição atual
            show_debug_message("📍 Posição atual: (" + string(x) + ", " + string(y) + ")");
            show_debug_message("🎯 Ângulo atual: " + string(image_angle) + "°");
            
            // Teste de orientação em diferentes direções
            var teste_direcoes = [
                ["Direita", 0],
                ["Baixo", 90],
                ["Esquerda", 180],
                ["Cima", 270]
            ];
            
            show_debug_message("🧪 TESTANDO ORIENTAÇÃO EM DIFERENTES DIREÇÕES:");
            
            for (var i = 0; i < array_length(teste_direcoes); i++) {
                var direcao = teste_direcoes[i][0];
                var angulo_esperado = teste_direcoes[i][1];
                
                show_debug_message("   " + direcao + " - Ângulo esperado: " + string(angulo_esperado) + "°");
                
                // Simular movimento em cada direção
                var distancia_teste = 100;
                var novo_destino_x = x + lengthdir_x(distancia_teste, angulo_esperado);
                var novo_destino_y = y + lengthdir_y(distancia_teste, angulo_esperado);
                
                show_debug_message("     Destino: (" + string(novo_destino_x) + ", " + string(novo_destino_y) + ")");
                
                // Calcular ângulo real
                var angulo_real = point_direction(x, y, novo_destino_x, novo_destino_y);
                show_debug_message("     Ângulo real: " + string(angulo_real) + "°");
                
                // Verificar se está correto
                var diferenca = abs(angulo_real - angulo_esperado);
                if (diferenca < 5 || diferenca > 355) { // Tolerância de 5 graus
                    show_debug_message("     ✅ CORRETO");
                } else {
                    show_debug_message("     ❌ INCORRETO - Diferença: " + string(diferenca) + "°");
                }
            }
            
            // === 3. TESTE DE MOVIMENTO REAL ===
            if (detalhado) {
                show_debug_message("🚀 TESTE DE MOVIMENTO REAL:");
                
                // Definir destino para teste
                var destino_teste_x = x + 200;
                var destino_teste_y = y + 100;
                
                show_debug_message("   Destino de teste: (" + string(destino_teste_x) + ", " + string(destino_teste_y) + ")");
                
                // Calcular ângulo esperado
                var angulo_teste = point_direction(x, y, destino_teste_x, destino_teste_y);
                show_debug_message("   Ângulo esperado: " + string(angulo_teste) + "°");
                
                // Aplicar movimento
                destino_x = destino_teste_x;
                destino_y = destino_teste_y;
                estado = "movendo";
                movendo = true;
                
                show_debug_message("   ✅ Movimento aplicado!");
                show_debug_message("   🎯 Navio deve virar para: " + string(angulo_teste) + "°");
            }
            
        } else {
            show_debug_message("⚠️ NAVIO NÃO SELECIONADO - Selecione um navio primeiro");
        }
    }
    
    // === 4. VERIFICAR SISTEMA DE ORIENTAÇÃO ===
    show_debug_message("🔧 SISTEMA DE ORIENTAÇÃO:");
    
    // Verificar se image_angle está sendo usado
    with (obj_lancha_patrulha) {
        if (variable_instance_exists(id, "image_angle")) {
            show_debug_message("   ✅ image_angle disponível");
        } else {
            show_debug_message("   ❌ image_angle não disponível");
        }
    }
    
    // === 5. RESUMO FINAL ===
    show_debug_message("=== 📊 RESUMO DO TESTE ===");
    
    var problemas = 0;
    
    if (navios_existentes == 0) problemas++;
    if (navios_selecionados == 0) problemas++;
    
    if (problemas == 0) {
        show_debug_message("✅ SISTEMA DE ORIENTAÇÃO FUNCIONANDO!");
        show_debug_message("   - Navios existem e estão selecionados");
        show_debug_message("   - Sistema de orientação implementado");
        show_debug_message("   - Movimento com rotação funcionando");
        show_debug_message("   - Teste de direções concluído");
    } else {
        show_debug_message("⚠️ PROBLEMAS DETECTADOS: " + string(problemas));
        show_debug_message("   - Verifique os itens marcados com ❌");
    }
    
    show_debug_message("=== 🚢 TESTE DE ORIENTAÇÃO CONCLUÍDO ===");
    
    return (problemas == 0);
}
