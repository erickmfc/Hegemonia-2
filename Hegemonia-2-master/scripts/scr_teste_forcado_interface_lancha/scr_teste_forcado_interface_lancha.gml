// =========================================================
// TESTE FORÇADO DA INTERFACE DA LANCHA
// Força a seleção e testa se a interface aparece
// =========================================================

function scr_teste_forcado_interface_lancha() {
    show_debug_message("🔧 TESTE FORÇADO DA INTERFACE DA LANCHA");
    show_debug_message("======================================");
    
    // Encontrar uma lancha
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha encontrada: " + string(_lancha));
        
        // Forçar seleção
        with (_lancha) {
            selecionado = true;
            show_debug_message("✅ Lancha FORÇADA a ser selecionada");
            
            // Verificar variáveis essenciais
            if (!variable_instance_exists(id, "estado")) {
                estado = "parado";
                show_debug_message("✅ Variável 'estado' criada");
            }
            
            if (!variable_instance_exists(id, "modo_ataque")) {
                modo_ataque = false;
                show_debug_message("✅ Variável 'modo_ataque' criada");
            }
            
            if (!variable_instance_exists(id, "hp_atual")) {
                hp_atual = 300;
                show_debug_message("✅ Variável 'hp_atual' criada");
            }
            
            if (!variable_instance_exists(id, "hp_max")) {
                hp_max = 300;
                show_debug_message("✅ Variável 'hp_max' criada");
            }
            
            if (!variable_instance_exists(id, "velocidade_atual")) {
                velocidade_atual = 0;
                show_debug_message("✅ Variável 'velocidade_atual' criada");
            }
            
            if (!variable_instance_exists(id, "velocidade_maxima")) {
                velocidade_maxima = 3.5;
                show_debug_message("✅ Variável 'velocidade_maxima' criada");
            }
            
            if (!variable_instance_exists(id, "pontos_patrulha")) {
                pontos_patrulha = ds_list_create();
                show_debug_message("✅ Variável 'pontos_patrulha' criada");
            }
            
            if (!variable_instance_exists(id, "indice_patrulha_atual")) {
                indice_patrulha_atual = 0;
                show_debug_message("✅ Variável 'indice_patrulha_atual' criada");
            }
            
            if (!variable_instance_exists(id, "alvo_em_mira")) {
                alvo_em_mira = noone;
                show_debug_message("✅ Variável 'alvo_em_mira' criada");
            }
            
            show_debug_message("✅ Todas as variáveis verificadas/criadas");
            show_debug_message("✅ Interface deve aparecer agora!");
        }
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada");
        show_debug_message("💡 Crie uma lancha primeiro");
    }
    
    show_debug_message("======================================");
    show_debug_message("🏁 Teste forçado concluído");
}

// =========================================================
// FUNÇÃO PARA CRIAR LANCHA DE TESTE
// =========================================================

function scr_criar_lancha_teste() {
    show_debug_message("🚢 CRIANDO LANCHA DE TESTE");
    show_debug_message("=========================");
    
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
        }
        
        show_debug_message("✅ Lancha configurada e selecionada");
        show_debug_message("✅ Interface deve aparecer!");
        
    } else {
        show_debug_message("❌ Erro ao criar lancha");
    }
    
    show_debug_message("=========================");
    show_debug_message("🏁 Criação de lancha concluída");
}
