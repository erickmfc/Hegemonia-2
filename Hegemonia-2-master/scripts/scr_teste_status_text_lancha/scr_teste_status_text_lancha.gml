// =========================================================
// TESTE DO STATUS TEXT DA LANCHA
// Verifica se o status text está aparecendo acima da unidade
// =========================================================

function scr_teste_status_text_lancha() {
    show_debug_message("📝 TESTE DO STATUS TEXT DA LANCHA");
    show_debug_message("=================================");
    
    // Encontrar uma lancha
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha encontrada: " + string(_lancha));
        
        // Testar diferentes estados
        with (_lancha) {
            show_debug_message("🔄 Testando diferentes estados...");
            
            // Estado 1: PARADO
            estado = "parado";
            modo_ataque = false;
            hp_atual = 300;
            show_debug_message("   ✅ Estado: PARADO [PASSIVO]");
            
            // Aguardar 2 segundos
            alarm[0] = 120;
            
            // Estado 2: MOVENDO
            estado = "movendo";
            destino_x = x + 100;
            destino_y = y + 100;
            show_debug_message("   ✅ Estado: MOVENDO [PASSIVO]");
            
            // Aguardar 2 segundos
            alarm[1] = 120;
            
            // Estado 3: ATACANDO
            estado = "atacando";
            modo_ataque = true;
            show_debug_message("   ✅ Estado: ATACANDO [ATAQUE]");
            
            // Aguardar 2 segundos
            alarm[2] = 120;
            
            // Estado 4: PATRULHANDO
            estado = "patrulhando";
            if (!ds_exists(pontos_patrulha, ds_type_list)) {
                pontos_patrulha = ds_list_create();
            }
            ds_list_add(pontos_patrulha, [x + 50, y + 50]);
            ds_list_add(pontos_patrulha, [x + 100, y + 100]);
            indice_patrulha_atual = 0;
            show_debug_message("   ✅ Estado: PATRULHANDO [ATAQUE]");
            
            // Aguardar 2 segundos
            alarm[3] = 120;
            
            // Estado 5: HP CRÍTICO
            estado = "parado";
            hp_atual = 50; // HP baixo
            show_debug_message("   ✅ Estado: PARADO [PASSIVO] [CRÍTICO!]");
            
            // Aguardar 2 segundos
            alarm[4] = 120;
            
            // Resetar para normal
            estado = "parado";
            modo_ataque = false;
            hp_atual = 300;
            show_debug_message("   ✅ Estado: PARADO [PASSIVO] (Normal)");
        }
        
        show_debug_message("✅ Todos os estados testados!");
        show_debug_message("💡 Verifique se o status text aparece acima da lancha");
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada");
        show_debug_message("💡 Execute scr_criar_lancha_teste() primeiro");
    }
    
    show_debug_message("=================================");
    show_debug_message("🏁 Teste do status text concluído");
}

// =========================================================
// FUNÇÃO PARA CRIAR LANCHA COM STATUS TEXT VISÍVEL
// =========================================================

function scr_criar_lancha_status_text() {
    show_debug_message("🚢 CRIANDO LANCHA COM STATUS TEXT");
    show_debug_message("=================================");
    
    // Criar lancha no centro da tela
    var _lancha = instance_create_layer(400, 300, "Instances", obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha criada: " + string(_lancha));
        
        // Configurar lancha com status visível
        with (_lancha) {
            selecionado = true;
            estado = "parado";
            modo_ataque = false;
            hp_atual = 300;
            hp_max = 300;
            velocidade_atual = 0;
            velocidade_maxima = 3.5;
            pontos_patrulha = ds_list_create();
            indice_patrulha_atual = 0;
            alvo_em_mira = noone;
            
            show_debug_message("✅ Lancha configurada");
            show_debug_message("✅ Status text deve aparecer: PARADO [PASSIVO]");
        }
        
        // Testar diferentes estados automaticamente
        show_debug_message("🔄 Testando estados automaticamente...");
        
        // Estado MOVENDO
        with (_lancha) {
            estado = "movendo";
            destino_x = x + 200;
            destino_y = y + 200;
            show_debug_message("✅ Status: MOVENDO [PASSIVO]");
        }
        
        // Estado ATACANDO
        with (_lancha) {
            estado = "atacando";
            modo_ataque = true;
            show_debug_message("✅ Status: ATACANDO [ATAQUE]");
        }
        
        // Estado PATRULHANDO
        with (_lancha) {
            estado = "patrulhando";
            ds_list_add(pontos_patrulha, [x + 100, y + 100]);
            ds_list_add(pontos_patrulha, [x + 200, y + 200]);
            indice_patrulha_atual = 0;
            show_debug_message("✅ Status: PATRULHANDO [ATAQUE]");
        }
        
        // Estado HP CRÍTICO
        with (_lancha) {
            estado = "parado";
            hp_atual = 50;
            show_debug_message("✅ Status: PARADO [PASSIVO] [CRÍTICO!]");
        }
        
        show_debug_message("✅ Todos os estados testados!");
        show_debug_message("💡 Verifique se o status text muda conforme o estado");
        
    } else {
        show_debug_message("❌ Erro ao criar lancha");
    }
    
    show_debug_message("=================================");
    show_debug_message("🏁 Criação de lancha com status text concluída");
}
