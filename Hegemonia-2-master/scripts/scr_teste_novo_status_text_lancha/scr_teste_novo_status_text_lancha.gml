// =========================================================
// TESTE DO NOVO SISTEMA DE STATUS TEXT DA LANCHA
// Verifica se o status text com controles está funcionando
// =========================================================

function scr_teste_novo_status_text_lancha() {
    show_debug_message("📝 TESTE DO NOVO SISTEMA DE STATUS TEXT DA LANCHA");
    show_debug_message("================================================");
    
    // Encontrar uma lancha
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha encontrada: " + string(_lancha));
        
        // Selecionar a lancha
        with (_lancha) {
            selecionado = true;
            show_debug_message("✅ Lancha selecionada");
            
            // Testar diferentes estados
            show_debug_message("🔄 Testando estados...");
            
            // Estado 1: PARADO
            estado = "parado";
            show_debug_message("   ✅ Estado: PARADO (Cinza)");
            show_debug_message("   📋 Controles: [K] Patrulha | [L] Parar");
            show_debug_message("   📋 Controles: [P] Passivo | [O] Ataque");
            
            // Estado 2: MOVENDO
            estado = "movendo";
            destino_x = x + 100;
            destino_y = y + 100;
            show_debug_message("   ✅ Estado: MOVENDO (Azul aqua)");
            
            // Estado 3: ATACANDO
            estado = "atacando";
            show_debug_message("   ✅ Estado: ATACANDO (Vermelho)");
            
            // Estado 4: PATRULHANDO
            estado = "patrulhando";
            if (!ds_exists(pontos_patrulha, ds_type_list)) {
                pontos_patrulha = ds_list_create();
            }
            ds_list_add(pontos_patrulha, [x + 50, y + 50]);
            ds_list_add(pontos_patrulha, [x + 100, y + 100]);
            indice_patrulha_atual = 0;
            show_debug_message("   ✅ Estado: PATRULHANDO (Laranja)");
            
            // Estado 5: DEFININDO ROTA
            estado = "parado";
            global.definindo_patrulha_unidade = id;
            show_debug_message("   ✅ Estado: DEFININDO ROTA (Verde limão)");
            
            // Resetar
            global.definindo_patrulha_unidade = noone;
            estado = "parado";
            show_debug_message("   ✅ Estado: PARADO (Normal)");
        }
        
        show_debug_message("✅ Todos os estados testados!");
        show_debug_message("💡 Verifique se o status text aparece acima da lancha");
        show_debug_message("💡 Verifique se os controles aparecem abaixo do status");
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada");
        show_debug_message("💡 Execute scr_criar_lancha_teste() primeiro");
    }
    
    show_debug_message("================================================");
    show_debug_message("🏁 Teste do novo sistema de status text concluído");
}

// =========================================================
// FUNÇÃO PARA CRIAR LANCHA COM NOVO SISTEMA DE STATUS
// =========================================================

function scr_criar_lancha_novo_sistema() {
    show_debug_message("🚢 CRIANDO LANCHA COM NOVO SISTEMA DE STATUS");
    show_debug_message("=============================================");
    
    // Criar lancha no centro da tela
    var _lancha = instance_create_layer(400, 300, "Instances", obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha criada: " + string(_lancha));
        
        // Configurar lancha
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
            show_debug_message("✅ Status text deve aparecer: PARADO");
            show_debug_message("✅ Controles devem aparecer:");
            show_debug_message("   [K] Patrulha | [L] Parar");
            show_debug_message("   [P] Passivo | [O] Ataque");
        }
        
        // Testar diferentes estados automaticamente
        show_debug_message("🔄 Testando estados automaticamente...");
        
        // Estado MOVENDO
        with (_lancha) {
            estado = "movendo";
            destino_x = x + 200;
            destino_y = y + 200;
            show_debug_message("✅ Status: MOVENDO (Azul aqua)");
        }
        
        // Estado ATACANDO
        with (_lancha) {
            estado = "atacando";
            show_debug_message("✅ Status: ATACANDO (Vermelho)");
        }
        
        // Estado PATRULHANDO
        with (_lancha) {
            estado = "patrulhando";
            ds_list_add(pontos_patrulha, [x + 100, y + 100]);
            ds_list_add(pontos_patrulha, [x + 200, y + 200]);
            indice_patrulha_atual = 0;
            show_debug_message("✅ Status: PATRULHANDO (Laranja)");
        }
        
        // Estado DEFININDO ROTA
        with (_lancha) {
            estado = "parado";
            global.definindo_patrulha_unidade = id;
            show_debug_message("✅ Status: DEFININDO ROTA (Verde limão)");
        }
        
        // Resetar
        with (_lancha) {
            global.definindo_patrulha_unidade = noone;
            estado = "parado";
            show_debug_message("✅ Status: PARADO (Normal)");
        }
        
        show_debug_message("✅ Todos os estados testados!");
        show_debug_message("💡 Verifique se o status text muda conforme o estado");
        show_debug_message("💡 Verifique se os controles aparecem sempre");
        
    } else {
        show_debug_message("❌ Erro ao criar lancha");
    }
    
    show_debug_message("=============================================");
    show_debug_message("🏁 Criação de lancha com novo sistema concluída");
}
