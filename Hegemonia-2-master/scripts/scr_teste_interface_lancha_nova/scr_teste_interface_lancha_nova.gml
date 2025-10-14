// =========================================================
// TESTE DA NOVA INTERFACE DA LANCHA
// Verifica se a interface recriada está funcionando
// =========================================================

function scr_teste_interface_lancha_nova() {
    show_debug_message("🚢 TESTE DA NOVA INTERFACE DA LANCHA");
    show_debug_message("====================================");
    
    // Encontrar uma lancha para testar
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha encontrada: " + string(_lancha));
        
        // Selecionar a lancha
        with (_lancha) {
            selecionado = true;
            show_debug_message("✅ Lancha selecionada");
            
            // Verificar variáveis necessárias
            if (variable_instance_exists(id, "estado")) {
                show_debug_message("✅ Variável 'estado' existe: " + estado);
            } else {
                show_debug_message("❌ Variável 'estado' não existe");
            }
            
            if (variable_instance_exists(id, "modo_ataque")) {
                show_debug_message("✅ Variável 'modo_ataque' existe: " + string(modo_ataque));
            } else {
                show_debug_message("❌ Variável 'modo_ataque' não existe");
            }
            
            if (variable_instance_exists(id, "hp_atual")) {
                show_debug_message("✅ Variável 'hp_atual' existe: " + string(hp_atual));
            } else {
                show_debug_message("❌ Variável 'hp_atual' não existe");
            }
            
            if (variable_instance_exists(id, "hp_max")) {
                show_debug_message("✅ Variável 'hp_max' existe: " + string(hp_max));
            } else {
                show_debug_message("❌ Variável 'hp_max' não existe");
            }
            
            if (variable_instance_exists(id, "velocidade_atual")) {
                show_debug_message("✅ Variável 'velocidade_atual' existe: " + string(velocidade_atual));
            } else {
                show_debug_message("❌ Variável 'velocidade_atual' não existe");
            }
            
            if (variable_instance_exists(id, "velocidade_maxima")) {
                show_debug_message("✅ Variável 'velocidade_maxima' existe: " + string(velocidade_maxima));
            } else {
                show_debug_message("❌ Variável 'velocidade_maxima' não existe");
            }
        }
        
        show_debug_message("✅ Interface da lancha deve aparecer na tela");
        show_debug_message("💡 Verifique se o painel está sendo desenhado corretamente");
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada para teste");
        show_debug_message("💡 Crie uma lancha primeiro para testar a interface");
    }
    
    show_debug_message("====================================");
    show_debug_message("🏁 Teste da interface concluído");
}

// =========================================================
// FUNÇÃO PARA TESTAR TODOS OS ESTADOS DA LANCHA
// =========================================================

function scr_teste_estados_lancha() {
    show_debug_message("🔄 TESTE DOS ESTADOS DA LANCHA");
    show_debug_message("==============================");
    
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        with (_lancha) {
            selecionado = true;
            
            // Teste 1: Estado PARADO
            estado = "parado";
            show_debug_message("✅ Testando estado PARADO");
            
            // Teste 2: Estado MOVENDO
            estado = "movendo";
            destino_x = x + 100;
            destino_y = y + 100;
            show_debug_message("✅ Testando estado MOVENDO");
            
            // Teste 3: Estado PATRULHANDO
            estado = "patrulhando";
            if (!ds_exists(pontos_patrulha, ds_type_list)) {
                pontos_patrulha = ds_list_create();
            }
            ds_list_add(pontos_patrulha, [x + 50, y + 50]);
            ds_list_add(pontos_patrulha, [x + 100, y + 100]);
            indice_patrulha_atual = 0;
            show_debug_message("✅ Testando estado PATRULHANDO");
            
            // Teste 4: Estado ATACANDO
            estado = "atacando";
            alvo_em_mira = instance_create_layer(x + 200, y + 200, "Instances", obj_inimigo_teste);
            show_debug_message("✅ Testando estado ATACANDO");
            
            // Teste 5: Modo ATAQUE
            modo_ataque = true;
            show_debug_message("✅ Testando modo ATAQUE AGRESSIVO");
            
            // Teste 6: Modo PASSIVO
            modo_ataque = false;
            show_debug_message("✅ Testando modo PASSIVO");
            
            // Teste 7: HP baixo
            hp_atual = 50;
            show_debug_message("✅ Testando HP baixo (50/300)");
            
            // Teste 8: HP crítico
            hp_atual = 20;
            show_debug_message("✅ Testando HP crítico (20/300)");
            
            // Resetar para estado normal
            estado = "parado";
            modo_ataque = false;
            hp_atual = hp_max;
            show_debug_message("✅ Estados resetados para normal");
        }
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada para teste de estados");
    }
    
    show_debug_message("==============================");
    show_debug_message("🏁 Teste dos estados concluído");
}
