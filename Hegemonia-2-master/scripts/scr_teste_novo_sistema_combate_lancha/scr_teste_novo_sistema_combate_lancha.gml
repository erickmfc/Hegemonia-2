// =========================================================
// TESTE DO NOVO SISTEMA DE COMBATE DA LANCHA
// Verifica se as melhorias de combate estão funcionando
// =========================================================

function scr_teste_novo_sistema_combate_lancha() {
    show_debug_message("⚔️ TESTE DO NOVO SISTEMA DE COMBATE DA LANCHA");
    show_debug_message("=============================================");
    
    // Encontrar uma lancha
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha encontrada: " + string(_lancha));
        
        // Configurar lancha para teste
        with (_lancha) {
            selecionado = true;
            modo_ataque = true;
            estado = "parado";
            hp_atual = 300;
            hp_max = 300;
            radar_alcance = 500;
            alcance_ataque = 400;
            seguindo_alvo = false;
            
            show_debug_message("✅ Lancha configurada para teste de combate");
            show_debug_message("✅ Modo ATAQUE ativado");
            show_debug_message("✅ Radar: 500px, Alcance de ataque: 400px");
        }
        
        // Teste 1: Criar alvo próximo (dentro do alcance de ataque)
        var _alvo_proximo = instance_create_layer(_lancha.x + 200, _lancha.y + 200, "Instances", obj_inimigo);
        if (instance_exists(_alvo_proximo)) {
            with (_alvo_proximo) {
                nacao_proprietaria = 2; // Inimigo
                velocidade_atual = 0; // Parado
            }
            
            show_debug_message("✅ Alvo criado próximo (200px) - dentro do alcance de ataque");
            show_debug_message("💡 Lancha deve PARAR e atirar no alvo");
        }
        
        // Teste 2: Criar alvo distante (fora do alcance de ataque, dentro do radar)
        var _alvo_distante = instance_create_layer(_lancha.x + 450, _lancha.y + 450, "Instances", obj_inimigo);
        if (instance_exists(_alvo_distante)) {
            with (_alvo_distante) {
                nacao_proprietaria = 2; // Inimigo
                velocidade_atual = 0; // Parado
            }
            
            show_debug_message("✅ Alvo criado distante (450px) - fora do alcance de ataque");
            show_debug_message("💡 Lancha deve se POSICIONAR para ataque");
        }
        
        // Teste 3: Criar alvo em movimento
        var _alvo_movendo = instance_create_layer(_lancha.x + 300, _lancha.y + 300, "Instances", obj_inimigo);
        if (instance_exists(_alvo_movendo)) {
            with (_alvo_movendo) {
                nacao_proprietaria = 2; // Inimigo
                velocidade_atual = 2.0; // Em movimento
                destino_x = x + 100;
                destino_y = y + 100;
            }
            
            show_debug_message("✅ Alvo criado em movimento (300px)");
            show_debug_message("💡 Lancha deve SEGUIR o alvo em movimento");
        }
        
        show_debug_message("✅ Todos os testes de combate configurados!");
        show_debug_message("💡 Verifique se os círculos de alcance aparecem");
        show_debug_message("💡 Verifique se a lancha para no alcance de ataque");
        show_debug_message("💡 Verifique se a lancha segue alvos em movimento");
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada");
        show_debug_message("💡 Execute scr_criar_lancha_teste() primeiro");
    }
    
    show_debug_message("=============================================");
    show_debug_message("🏁 Teste do novo sistema de combate concluído");
}

// =========================================================
// FUNÇÃO PARA CRIAR LANCHA COM SISTEMA DE COMBATE MELHORADO
// =========================================================

function scr_criar_lancha_combate_melhorado() {
    show_debug_message("🚢 CRIANDO LANCHA COM SISTEMA DE COMBATE MELHORADO");
    show_debug_message("=================================================");
    
    // Criar lancha no centro da tela
    var _lancha = instance_create_layer(400, 300, "Instances", obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha criada: " + string(_lancha));
        
        // Configurar lancha com sistema de combate melhorado
        with (_lancha) {
            selecionado = true;
            modo_ataque = true;
            estado = "parado";
            hp_atual = 300;
            hp_max = 300;
            velocidade_atual = 0;
            velocidade_maxima = 3.5;
            radar_alcance = 500;
            alcance_ataque = 400;
            seguindo_alvo = false;
            pontos_patrulha = ds_list_create();
            indice_patrulha_atual = 0;
            alvo_em_mira = noone;
            
            show_debug_message("✅ Lancha configurada com sistema de combate melhorado");
            show_debug_message("✅ Modo ATAQUE ativado");
            show_debug_message("✅ Radar: 500px, Alcance de ataque: 400px");
        }
        
        // Criar alvos para teste
        show_debug_message("🎯 Criando alvos para teste...");
        
        // Alvo 1: Próximo (dentro do alcance de ataque)
        var _alvo1 = instance_create_layer(500, 400, "Instances", obj_inimigo);
        if (instance_exists(_alvo1)) {
            with (_alvo1) {
                nacao_proprietaria = 2;
                velocidade_atual = 0;
            }
            show_debug_message("✅ Alvo 1: Próximo (100px) - deve ser atacado imediatamente");
        }
        
        // Alvo 2: Distante (fora do alcance de ataque)
        var _alvo2 = instance_create_layer(700, 500, "Instances", obj_inimigo);
        if (instance_exists(_alvo2)) {
            with (_alvo2) {
                nacao_proprietaria = 2;
                velocidade_atual = 0;
            }
            show_debug_message("✅ Alvo 2: Distante (300px) - deve ser posicionado para ataque");
        }
        
        // Alvo 3: Em movimento
        var _alvo3 = instance_create_layer(600, 400, "Instances", obj_inimigo);
        if (instance_exists(_alvo3)) {
            with (_alvo3) {
                nacao_proprietaria = 2;
                velocidade_atual = 2.0;
                destino_x = x + 200;
                destino_y = y + 200;
            }
            show_debug_message("✅ Alvo 3: Em movimento (200px) - deve ser seguido");
        }
        
        show_debug_message("✅ Todos os alvos criados!");
        show_debug_message("💡 Verifique se os círculos de alcance aparecem");
        show_debug_message("💡 Verifique se a lancha para no alcance de ataque");
        show_debug_message("💡 Verifique se a lancha segue alvos em movimento");
        
    } else {
        show_debug_message("❌ Erro ao criar lancha");
    }
    
    show_debug_message("=================================================");
    show_debug_message("🏁 Criação de lancha com combate melhorado concluída");
}

// =========================================================
// FUNÇÃO PARA TESTAR CONTROLES DE COMBATE
// =========================================================

function scr_teste_controles_combate_lancha() {
    show_debug_message("🎮 TESTE DOS CONTROLES DE COMBATE DA LANCHA");
    show_debug_message("===========================================");
    
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        with (_lancha) {
            selecionado = true;
            
            show_debug_message("✅ Lancha selecionada para teste de controles");
            show_debug_message("🎮 CONTROLES DISPONÍVEIS:");
            show_debug_message("   P - Modo PASSIVO (não ataca)");
            show_debug_message("   O - Modo ATAQUE (ataca automaticamente)");
            show_debug_message("   L - Para tudo e limpa alvo");
            show_debug_message("   K - Iniciar patrulha");
            show_debug_message("   Clique direito - Mover para posição");
            
            // Testar modo PASSIVO
            modo_ataque = false;
            show_debug_message("✅ Modo PASSIVO ativado - não deve atacar");
            
            // Testar modo ATAQUE
            modo_ataque = true;
            show_debug_message("✅ Modo ATAQUE ativado - deve atacar automaticamente");
            
            // Testar comando de parada
            estado = "atacando";
            alvo_em_mira = instance_nearest(x, y, obj_inimigo);
            seguindo_alvo = true;
            show_debug_message("✅ Estado de ataque simulado");
            show_debug_message("💡 Pressione L para parar e limpar alvo");
            
        }
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada");
    }
    
    show_debug_message("===========================================");
    show_debug_message("🏁 Teste dos controles de combate concluído");
}
