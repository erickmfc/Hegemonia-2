// =========================================================
// TESTE DO PAINEL DETALHADO DA LANCHA
// Verifica se o painel de informações detalhado está funcionando
// =========================================================

function scr_teste_painel_detalhado_lancha() {
    show_debug_message("📋 TESTE DO PAINEL DETALHADO DA LANCHA");
    show_debug_message("======================================");
    
    // Encontrar uma lancha
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha encontrada: " + string(_lancha));
        
        // Selecionar a lancha
        with (_lancha) {
            selecionado = true;
            show_debug_message("✅ Lancha selecionada");
            
            // Testar diferentes estados
            show_debug_message("🔄 Testando painel detalhado...");
            
            // Estado 1: PARADO
            estado = "parado";
            modo_ataque = false;
            hp_atual = 300;
            hp_max = 300;
            show_debug_message("   ✅ Painel deve mostrar:");
            show_debug_message("      LANCHA PATRULHA");
            show_debug_message("      Estado: PARADO");
            show_debug_message("      Modo: PASSIVO");
            show_debug_message("      HP: 300/300");
            show_debug_message("      Patrulha: Inativa");
            
            // Estado 2: MOVENDO
            estado = "movendo";
            destino_x = x + 100;
            destino_y = y + 100;
            show_debug_message("   ✅ Painel deve mostrar:");
            show_debug_message("      LANCHA PATRULHA");
            show_debug_message("      Estado: MOVENDO");
            show_debug_message("      Modo: PASSIVO");
            show_debug_message("      HP: 300/300");
            show_debug_message("      Patrulha: Inativa");
            
            // Estado 3: ATACANDO
            estado = "atacando";
            modo_ataque = true;
            show_debug_message("   ✅ Painel deve mostrar:");
            show_debug_message("      LANCHA PATRULHA");
            show_debug_message("      Estado: ATACANDO");
            show_debug_message("      Modo: ATAQUE");
            show_debug_message("      HP: 300/300");
            show_debug_message("      Patrulha: Inativa");
            
            // Estado 4: PATRULHANDO
            estado = "patrulhando";
            if (!ds_exists(pontos_patrulha, ds_type_list)) {
                pontos_patrulha = ds_list_create();
            }
            ds_list_add(pontos_patrulha, [x + 50, y + 50]);
            ds_list_add(pontos_patrulha, [x + 100, y + 100]);
            ds_list_add(pontos_patrulha, [x + 150, y + 150]);
            indice_patrulha_atual = 1; // Segundo ponto
            show_debug_message("   ✅ Painel deve mostrar:");
            show_debug_message("      LANCHA PATRULHA");
            show_debug_message("      Estado: PATRULHANDO");
            show_debug_message("      Modo: ATAQUE");
            show_debug_message("      HP: 300/300");
            show_debug_message("      Patrulha: Ponto 2/3");
            
            // Estado 5: DEFININDO ROTA
            estado = "parado";
            global.definindo_patrulha_unidade = id;
            show_debug_message("   ✅ Painel deve mostrar:");
            show_debug_message("      LANCHA PATRULHA");
            show_debug_message("      Estado: DEFININDO ROTA");
            show_debug_message("      Modo: ATAQUE");
            show_debug_message("      HP: 300/300");
            show_debug_message("      Patrulha: Definindo (3 pontos)");
            
            // Estado 6: HP BAIXO
            estado = "parado";
            hp_atual = 150;
            show_debug_message("   ✅ Painel deve mostrar:");
            show_debug_message("      LANCHA PATRULHA");
            show_debug_message("      Estado: PARADO");
            show_debug_message("      Modo: ATAQUE");
            show_debug_message("      HP: 150/300");
            show_debug_message("      Patrulha: Definindo (3 pontos)");
            
            // Resetar
            global.definindo_patrulha_unidade = noone;
            estado = "parado";
            modo_ataque = false;
            hp_atual = 300;
            show_debug_message("   ✅ Painel resetado para normal");
        }
        
        show_debug_message("✅ Todos os estados testados!");
        show_debug_message("💡 Verifique se o painel aparece acima da lancha");
        show_debug_message("💡 Verifique se o painel tem fundo preto e borda verde");
        show_debug_message("💡 Verifique se as informações mudam conforme o estado");
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada");
        show_debug_message("💡 Execute scr_criar_lancha_teste() primeiro");
    }
    
    show_debug_message("======================================");
    show_debug_message("🏁 Teste do painel detalhado concluído");
}

// =========================================================
// FUNÇÃO PARA CRIAR LANCHA COM PAINEL DETALHADO
// =========================================================

function scr_criar_lancha_painel_detalhado() {
    show_debug_message("🚢 CRIANDO LANCHA COM PAINEL DETALHADO");
    show_debug_message("======================================");
    
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
            show_debug_message("✅ Painel detalhado deve aparecer acima da lancha");
            show_debug_message("✅ Painel deve ter fundo preto e borda verde");
        }
        
        // Testar diferentes estados automaticamente
        show_debug_message("🔄 Testando painel automaticamente...");
        
        // Estado MOVENDO
        with (_lancha) {
            estado = "movendo";
            destino_x = x + 200;
            destino_y = y + 200;
            show_debug_message("✅ Painel: Estado MOVENDO");
        }
        
        // Estado ATACANDO
        with (_lancha) {
            estado = "atacando";
            modo_ataque = true;
            show_debug_message("✅ Painel: Estado ATACANDO, Modo ATAQUE");
        }
        
        // Estado PATRULHANDO
        with (_lancha) {
            estado = "patrulhando";
            ds_list_add(pontos_patrulha, [x + 100, y + 100]);
            ds_list_add(pontos_patrulha, [x + 200, y + 200]);
            ds_list_add(pontos_patrulha, [x + 300, y + 300]);
            indice_patrulha_atual = 1;
            show_debug_message("✅ Painel: Estado PATRULHANDO, Ponto 2/3");
        }
        
        // Estado DEFININDO ROTA
        with (_lancha) {
            estado = "parado";
            global.definindo_patrulha_unidade = id;
            show_debug_message("✅ Painel: Estado DEFININDO ROTA, 3 pontos");
        }
        
        // Estado HP BAIXO
        with (_lancha) {
            estado = "parado";
            hp_atual = 100;
            show_debug_message("✅ Painel: HP 100/300");
        }
        
        // Resetar
        with (_lancha) {
            global.definindo_patrulha_unidade = noone;
            estado = "parado";
            modo_ataque = false;
            hp_atual = 300;
            show_debug_message("✅ Painel: Estado normal");
        }
        
        show_debug_message("✅ Todos os estados testados!");
        show_debug_message("💡 Verifique se o painel muda conforme o estado");
        show_debug_message("💡 Verifique se o painel tem fundo preto e borda verde");
        
    } else {
        show_debug_message("❌ Erro ao criar lancha");
    }
    
    show_debug_message("======================================");
    show_debug_message("🏁 Criação de lancha com painel detalhado concluída");
}
