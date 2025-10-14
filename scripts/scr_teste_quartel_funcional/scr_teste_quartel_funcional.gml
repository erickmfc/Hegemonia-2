// ===============================================
// HEGEMONIA GLOBAL - TESTE QUARTEL FUNCIONAL
// Script para testar e diagnosticar problemas do quartel
// ===============================================

/// @description Testar funcionalidade completa do quartel
function scr_teste_quartel_funcional() {
    show_debug_message("=== INICIANDO TESTE COMPLETO DO QUARTEL ===");
    
    // === 1. VERIFICAR VARIÁVEIS GLOBAIS ===
    show_debug_message("1. VERIFICANDO VARIÁVEIS GLOBAIS:");
    show_debug_message("   Dinheiro: $" + string(global.dinheiro));
    show_debug_message("   População: " + string(global.populacao));
    show_debug_message("   Menu recrutamento aberto: " + string(global.menu_recrutamento_aberto));
    
    // === 2. VERIFICAR INSTÂNCIAS DE QUARTEL ===
    show_debug_message("2. VERIFICANDO INSTÂNCIAS DE QUARTEL:");
    var _quartel_count = instance_number(obj_quartel);
    show_debug_message("   Quartéis encontrados: " + string(_quartel_count));
    
    if (_quartel_count > 0) {
        var _quartel = instance_find(obj_quartel, 0);
        show_debug_message("   Primeiro quartel ID: " + string(_quartel));
        show_debug_message("   Posição: (" + string(_quartel.x) + ", " + string(_quartel.y) + ")");
        show_debug_message("   Esta treinando: " + string(_quartel.esta_treinando));
        show_debug_message("   Alarm[0]: " + string(_quartel.alarm[0]));
        show_debug_message("   Unidades disponíveis: " + string(ds_list_size(_quartel.unidades_disponiveis)));
        show_debug_message("   Unidade selecionada: " + string(_quartel.unidade_selecionada));
        
        // Verificar dados da unidade selecionada
        if (ds_list_size(_quartel.unidades_disponiveis) > 0) {
            var _unidade_data = ds_list_find_value(_quartel.unidades_disponiveis, _quartel.unidade_selecionada);
            if (_unidade_data != undefined) {
                show_debug_message("   Unidade atual: " + _unidade_data.nome);
                show_debug_message("   Custo dinheiro: $" + string(_unidade_data.custo_dinheiro));
                show_debug_message("   Custo população: " + string(_unidade_data.custo_populacao));
                show_debug_message("   Tempo treino: " + string(_unidade_data.tempo_treino) + " frames");
            }
        }
    } else {
        show_debug_message("   ❌ ERRO: Nenhum quartel encontrado!");
    }
    
    // === 3. VERIFICAR OBJETOS DE UNIDADE ===
    show_debug_message("3. VERIFICANDO OBJETOS DE UNIDADE:");
    var _infantaria_count = instance_number(obj_infantaria);
    var _soldado_count = instance_number(obj_soldado_antiaereo);
    var _tanque_count = instance_number(obj_tanque);
    var _blindado_count = instance_number(obj_blindado_antiaereo);
    
    show_debug_message("   Infantaria: " + string(_infantaria_count));
    show_debug_message("   Soldado Anti-Aéreo: " + string(_soldado_count));
    show_debug_message("   Tanque: " + string(_tanque_count));
    show_debug_message("   Blindado Anti-Aéreo: " + string(_blindado_count));
    
    // === 4. VERIFICAR MENU DE RECRUTAMENTO ===
    show_debug_message("4. VERIFICANDO MENU DE RECRUTAMENTO:");
    var _menu_count = instance_number(obj_menu_recrutamento);
    show_debug_message("   Menus de recrutamento ativos: " + string(_menu_count));
    
    if (_menu_count > 0) {
        var _menu = instance_find(obj_menu_recrutamento, 0);
        show_debug_message("   Menu ID: " + string(_menu));
        show_debug_message("   Quartel vinculado: " + string(_menu.id_do_quartel));
        show_debug_message("   Delay abertura: " + string(_menu.delay_abertura));
    }
    
    // === 5. TESTE DE RECRUTAMENTO MANUAL ===
    show_debug_message("5. TESTANDO RECRUTAMENTO MANUAL:");
    if (_quartel_count > 0) {
        var _quartel = instance_find(obj_quartel, 0);
        
        if (!_quartel.esta_treinando) {
            show_debug_message("   Quartel disponível para teste");
            
            // Verificar se tem recursos suficientes
            var _unidade_data = ds_list_find_value(_quartel.unidades_disponiveis, _quartel.unidade_selecionada);
            if (_unidade_data != undefined) {
                var _tem_recursos = (global.dinheiro >= _unidade_data.custo_dinheiro && 
                                   global.populacao >= _unidade_data.custo_populacao);
                show_debug_message("   Tem recursos suficientes: " + string(_tem_recursos));
                
                if (_tem_recursos) {
                    show_debug_message("   ✅ PRONTO PARA TESTE DE RECRUTAMENTO");
                    show_debug_message("   Para testar: Clique no quartel e depois no botão de recrutamento");
                } else {
                    show_debug_message("   ❌ Recursos insuficientes para teste");
                }
            }
        } else {
            show_debug_message("   Quartel ocupado - aguardando treinamento");
            show_debug_message("   Tempo restante: " + string(_quartel.alarm[0]) + " frames");
        }
    }
    
    show_debug_message("=== FIM DO TESTE DO QUARTEL ===");
}

/// @description Testar criação manual de unidade
function scr_teste_criacao_unidade_manual() {
    show_debug_message("=== TESTE DE CRIAÇÃO MANUAL DE UNIDADE ===");
    
    var _quartel_count = instance_number(obj_quartel);
    if (_quartel_count > 0) {
        var _quartel = instance_find(obj_quartel, 0);
        
        if (!_quartel.esta_treinando) {
            // Definir quantidade para 1
            _quartel.quantidade_recrutar = 1;
            
            // Executar evento de recrutamento
            with (_quartel) {
                event_perform(ev_other, ev_user0);
            }
            
            show_debug_message("✅ Ordem de recrutamento enviada!");
        } else {
            show_debug_message("❌ Quartel já está treinando");
        }
    } else {
        show_debug_message("❌ Nenhum quartel encontrado");
    }
    
    show_debug_message("=== FIM DO TESTE DE CRIAÇÃO ===");
}
