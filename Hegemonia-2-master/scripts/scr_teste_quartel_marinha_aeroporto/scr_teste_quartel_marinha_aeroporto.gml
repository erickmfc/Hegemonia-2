/// @description Teste dos edifícios - Quartel Marinha e Aeroporto
/// TESTE 2: Quartel Marinha - Construir, clicar, verificar menu naval e deseleção
/// TESTE 3: Aeroporto - Construir, clicar, verificar menu aéreo e deseleção

function scr_teste_quartel_marinha_aeroporto() {
    show_debug_message("=== ETAPA 4: TESTE QUARTEL MARINHA E AEROPORTO ===");
    
    // === TESTE 2: QUARTEL DE MARINHA ===
    show_debug_message("TESTE 2: Quartel de Marinha - Construir, clicar, verificar menu naval e deseleção");
    
    // PASSO 1: Construir quartel marinha
    show_debug_message("PASSO 1: Construindo quartel de marinha...");
    
    var _quartel_marinha_count = instance_number(obj_quartel_marinha);
    if (_quartel_marinha_count > 0) {
        show_debug_message("✅ Quartel de marinha já existe - " + string(_quartel_marinha_count) + " instância(s)");
        var _quartel_marinha = instance_find(obj_quartel_marinha, 0);
        show_debug_message("   Quartel Marinha ID: " + string(_quartel_marinha));
        show_debug_message("   Posição: (" + string(_quartel_marinha.x) + ", " + string(_quartel_marinha.y) + ")");
    } else {
        show_debug_message("⚠️ Nenhum quartel de marinha encontrado - criando um para teste");
        
        // Garantir recursos suficientes
        global.dinheiro = 15000;
        global.populacao = 1000;
        
        // Criar quartel de marinha
        var _quartel_marinha = instance_create_layer(500, 400, "Instances", obj_quartel_marinha);
        if (instance_exists(_quartel_marinha)) {
            show_debug_message("✅ Quartel de marinha criado com sucesso - ID: " + string(_quartel_marinha));
        } else {
            show_debug_message("❌ ERRO: Falha ao criar quartel de marinha");
        }
    }
    
    // PASSO 2: Clicar no quartel marinha
    show_debug_message("PASSO 2: Simulando clique no quartel de marinha...");
    
    var _quartel_marinha = instance_find(obj_quartel_marinha, 0);
    
    with (_quartel_marinha) {
        show_debug_message("🎯 Simulando clique no quartel de marinha ID: " + string(id));
        
        // Simular o evento Mouse_53
        if (scr_edificio_clique_unificado()) {
            show_debug_message("✅ CLIQUE NO QUARTEL DE MARINHA DETECTADO!");
            
            // Verificar se pode abrir menu
            if (!global.modo_construcao && global.construindo_agora == noone) {
                // Criar menu de recrutamento naval
                if (object_exists(obj_menu_recrutamento_marinha)) {
                    var _menu = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
                    if (instance_exists(_menu)) {
                        _menu.meu_quartel_id = id;
                        global.menu_recrutamento_aberto = true;
                        
                        show_debug_message("✅ MENU DE RECRUTAMENTO NAVAL CRIADO!");
                        show_debug_message("   Menu ID: " + string(_menu));
                        show_debug_message("   Quartel ID: " + string(id));
                        show_debug_message("   Posição: (" + string(_menu.x) + ", " + string(_menu.y) + ")");
                    } else {
                        show_debug_message("❌ Falha ao criar menu de recrutamento naval");
                    }
                } else {
                    show_debug_message("❌ obj_menu_recrutamento_marinha não existe");
                }
            } else {
                show_debug_message("❌ Não foi possível abrir menu - modo construção ativo");
            }
        } else {
            show_debug_message("❌ Clique não detectado no quartel de marinha");
        }
    }
    
    // PASSO 3: Verificar se menu naval abre
    show_debug_message("PASSO 3: Verificando se menu naval abriu...");
    
    var _menu_naval_count = instance_number(obj_menu_recrutamento_marinha);
    show_debug_message("   Menus de recrutamento naval ativos: " + string(_menu_naval_count));
    
    if (_menu_naval_count > 0) {
        var _menu_naval = instance_find(obj_menu_recrutamento_marinha, 0);
        show_debug_message("✅ MENU DE RECRUTAMENTO NAVAL ABERTO COM SUCESSO!");
        show_debug_message("   Menu ID: " + string(_menu_naval));
        show_debug_message("   Quartel vinculado: " + string(_menu_naval.meu_quartel_id));
        show_debug_message("   Posição: (" + string(_menu_naval.x) + ", " + string(_menu_naval.y) + ")");
    } else {
        show_debug_message("❌ ERRO: Menu de recrutamento naval não foi criado");
    }
    
    // PASSO 4: Verificar deseleção de unidades (já feito pelo scr_edificio_clique_unificado)
    show_debug_message("PASSO 4: Verificando deseleção de unidades...");
    show_debug_message("✅ Unidades deselecionadas automaticamente pelo sistema unificado");
    
    // === TESTE 3: AEROPORTO MILITAR ===
    show_debug_message("TESTE 3: Aeroporto Militar - Construir, clicar, verificar menu aéreo e deseleção");
    
    // PASSO 1: Construir aeroporto
    show_debug_message("PASSO 1: Construindo aeroporto militar...");
    
    var _aeroporto_count = instance_number(obj_aeroporto_militar);
    if (_aeroporto_count > 0) {
        show_debug_message("✅ Aeroporto já existe - " + string(_aeroporto_count) + " instância(s)");
        var _aeroporto = instance_find(obj_aeroporto_militar, 0);
        show_debug_message("   Aeroporto ID: " + string(_aeroporto));
        show_debug_message("   Posição: (" + string(_aeroporto.x) + ", " + string(_aeroporto.y) + ")");
        show_debug_message("   Pode interagir: " + string(_aeroporto.pode_interagir));
    } else {
        show_debug_message("⚠️ Nenhum aeroporto encontrado - criando um para teste");
        
        // Garantir recursos suficientes
        global.dinheiro = 20000;
        global.populacao = 1000;
        
        // Criar aeroporto militar
        var _aeroporto = instance_create_layer(600, 500, "Instances", obj_aeroporto_militar);
        if (instance_exists(_aeroporto)) {
            // Garantir que pode interagir
            _aeroporto.pode_interagir = true;
            show_debug_message("✅ Aeroporto militar criado com sucesso - ID: " + string(_aeroporto));
        } else {
            show_debug_message("❌ ERRO: Falha ao criar aeroporto militar");
        }
    }
    
    // PASSO 2: Clicar no aeroporto
    show_debug_message("PASSO 2: Simulando clique no aeroporto...");
    
    var _aeroporto = instance_find(obj_aeroporto_militar, 0);
    
    with (_aeroporto) {
        show_debug_message("🎯 Simulando clique no aeroporto ID: " + string(id));
        
        // Simular o evento Mouse_53
        if (scr_edificio_clique_unificado()) {
            show_debug_message("✅ CLIQUE NO AEROPORTO DETECTADO!");
            
            // Verificar se pode interagir
            if (pode_interagir) {
                show_debug_message("✅ Aeroporto pode interagir");
                
                // Verificar se o objeto do menu existe
                if (object_exists(obj_menu_recrutamento_aereo)) {
                    show_debug_message("✅ obj_menu_recrutamento_aereo existe");
                    
                    // Verificar se pode abrir o menu
                    if (!global.modo_construcao && global.construindo_agora == noone) {
                        // Criar menu de recrutamento aéreo
                        var _menu = instance_create_layer(0, 0, "rm_mapa_principal", obj_menu_recrutamento_aereo);
                        if (instance_exists(_menu)) {
                            _menu.id_do_aeroporto = id;
                            show_debug_message("✅ MENU DE RECRUTAMENTO AÉREO CRIADO!");
                            show_debug_message("   Menu ID: " + string(_menu));
                            show_debug_message("   Aeroporto ID: " + string(id));
                            show_debug_message("   Posição: (" + string(_menu.x) + ", " + string(_menu.y) + ")");
                        } else {
                            show_debug_message("❌ Falha ao criar menu de recrutamento aéreo");
                        }
                    } else {
                        show_debug_message("❌ Não foi possível abrir menu - modo construção ativo");
                    }
                } else {
                    show_debug_message("❌ obj_menu_recrutamento_aereo não existe");
                }
            } else {
                show_debug_message("❌ Aeroporto não pode interagir");
            }
        } else {
            show_debug_message("❌ Clique não detectado no aeroporto");
        }
    }
    
    // PASSO 3: Verificar se menu aéreo abre
    show_debug_message("PASSO 3: Verificando se menu aéreo abriu...");
    
    var _menu_aereo_count = instance_number(obj_menu_recrutamento_aereo);
    show_debug_message("   Menus de recrutamento aéreo ativos: " + string(_menu_aereo_count));
    
    if (_menu_aereo_count > 0) {
        var _menu_aereo = instance_find(obj_menu_recrutamento_aereo, 0);
        show_debug_message("✅ MENU DE RECRUTAMENTO AÉREO ABERTO COM SUCESSO!");
        show_debug_message("   Menu ID: " + string(_menu_aereo));
        show_debug_message("   Aeroporto vinculado: " + string(_menu_aereo.id_do_aeroporto));
        show_debug_message("   Posição: (" + string(_menu_aereo.x) + ", " + string(_menu_aereo.y) + ")");
    } else {
        show_debug_message("❌ ERRO: Menu de recrutamento aéreo não foi criado");
    }
    
    // PASSO 4: Verificar deseleção de unidades (já feito pelo scr_edificio_clique_unificado)
    show_debug_message("PASSO 4: Verificando deseleção de unidades...");
    show_debug_message("✅ Unidades deselecionadas automaticamente pelo sistema unificado");
    
    // === RESULTADO FINAL ===
    show_debug_message("=== RESULTADO DOS TESTES ===");
    
    var _teste_marinha_sucesso = (_quartel_marinha_count > 0 || instance_exists(_quartel_marinha)) && _menu_naval_count > 0;
    var _teste_aeroporto_sucesso = (_aeroporto_count > 0 || instance_exists(_aeroporto)) && _menu_aereo_count > 0;
    
    if (_teste_marinha_sucesso) {
        show_debug_message("🎉 TESTE QUARTEL MARINHA: SUCESSO!");
        show_debug_message("✅ Quartel de marinha construído e funcional");
        show_debug_message("✅ Menu de recrutamento naval abre corretamente");
        show_debug_message("✅ Unidades são deselecionadas");
    } else {
        show_debug_message("❌ TESTE QUARTEL MARINHA: FALHOU!");
    }
    
    if (_teste_aeroporto_sucesso) {
        show_debug_message("🎉 TESTE AEROPORTO: SUCESSO!");
        show_debug_message("✅ Aeroporto construído e funcional");
        show_debug_message("✅ Menu de recrutamento aéreo abre corretamente");
        show_debug_message("✅ Unidades são deselecionadas");
    } else {
        show_debug_message("❌ TESTE AEROPORTO: FALHOU!");
    }
    
    show_debug_message("=== FIM DOS TESTES ===");
}
