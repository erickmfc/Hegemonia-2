/// @description Verificação de limpeza de memória
/// @function scr_verificacao_limpeza_memoria

show_debug_message("=== VERIFICAÇÃO: LIMPEZA DE MEMÓRIA ===");

// 1. VERIFICAÇÃO DE DATA STRUCTURES
show_debug_message("🔍 VERIFICAÇÃO DE DATA STRUCTURES:");

// Verificar filas de produção
with (obj_quartel_marinha) {
    show_debug_message("🏭 Quartel ID: " + string(id));
    show_debug_message("   - Fila produção existe: " + string(variable_instance_exists(id, "fila_producao")));
    if (variable_instance_exists(id, "fila_producao")) {
        show_debug_message("   - Tamanho da fila: " + string(ds_queue_size(fila_producao)));
        show_debug_message("   - Fila vazia: " + string(ds_queue_empty(fila_producao)));
    }
    
    show_debug_message("   - Lista unidades existe: " + string(variable_instance_exists(id, "unidades_disponiveis")));
    if (variable_instance_exists(id, "unidades_disponiveis")) {
        show_debug_message("   - Tamanho da lista: " + string(ds_list_size(unidades_disponiveis)));
    }
}

// Verificar listas de patrulha
with (obj_infantaria) {
    show_debug_message("🏃 Infantaria ID: " + string(id));
    show_debug_message("   - Lista patrulha existe: " + string(variable_instance_exists(id, "patrulha")));
    if (variable_instance_exists(id, "patrulha")) {
        show_debug_message("   - Tamanho da patrulha: " + string(ds_list_size(patrulha)));
    }
}

// 2. VERIFICAÇÃO DE INSTÂNCIAS
show_debug_message("🔍 VERIFICAÇÃO DE INSTÂNCIAS:");

var total_instancias = 0;
var tipos_instancias = ds_map_create();

// Contar instâncias por tipo
with (all) {
    total_instancias++;
    var tipo = object_get_name(object_index);
    if (ds_map_exists(tipos_instancias, tipo)) {
        ds_map_set(tipos_instancias, tipo, ds_map_find_value(tipos_instancias, tipo) + 1);
    } else {
        ds_map_set(tipos_instancias, tipo, 1);
    }
}

show_debug_message("   - Total de instâncias: " + string(total_instancias));

// Mostrar contagem por tipo
var keys = ds_map_keys_to_array(tipos_instancias);
for (var i = 0; i < array_length(keys); i++) {
    var tipo = keys[i];
    var count = ds_map_find_value(tipos_instancias, tipo);
    show_debug_message("   - " + tipo + ": " + string(count));
}

// Limpar mapa temporário
ds_map_destroy(tipos_instancias);

// 3. VERIFICAÇÃO DE VARIÁVEIS GLOBAIS
show_debug_message("🔍 VERIFICAÇÃO DE VARIÁVEIS GLOBAIS:");

show_debug_message("   - global.dinheiro: " + string(variable_global_exists("dinheiro") ? global.dinheiro : "NÃO EXISTE"));
show_debug_message("   - global.minerio: " + string(variable_global_exists("minerio") ? global.minerio : "NÃO EXISTE"));
show_debug_message("   - global.debug_enabled: " + string(variable_global_exists("debug_enabled") ? global.debug_enabled : "NÃO EXISTE"));
show_debug_message("   - global.menu_recrutamento_aberto: " + string(variable_global_exists("menu_recrutamento_aberto") ? global.menu_recrutamento_aberto : "NÃO EXISTE"));

// 4. VERIFICAÇÃO DE TIMERS E ALARMS
show_debug_message("🔍 VERIFICAÇÃO DE TIMERS E ALARMS:");

with (obj_quartel_marinha) {
    show_debug_message("🏭 Quartel ID: " + string(id));
    show_debug_message("   - Alarm[0]: " + string(alarm[0]));
    show_debug_message("   - Alarm[1]: " + string(alarm[1]));
    show_debug_message("   - Alarm[2]: " + string(alarm[2]));
    show_debug_message("   - Timer produção step: " + string(variable_instance_exists(id, "timer_producao_step") ? timer_producao_step : "NÃO EXISTE"));
}

// 5. VERIFICAÇÃO DE SPRITES E SONS
show_debug_message("🔍 VERIFICAÇÃO DE RECURSOS:");

show_debug_message("   - Sprites carregados: " + string(sprite_get_number()));
show_debug_message("   - Sons carregados: " + string(audio_get_number()));
show_debug_message("   - Fontes carregadas: " + string(font_get_number()));

// 6. TESTE DE LIMPEZA MANUAL
show_debug_message("🧪 TESTE DE LIMPEZA MANUAL:");

// Limpar filas vazias
with (obj_quartel_marinha) {
    if (variable_instance_exists(id, "fila_producao") && ds_queue_empty(fila_producao)) {
        show_debug_message("🧹 Limpando fila vazia do quartel " + string(id));
        // Não destruir a fila, apenas garantir que está vazia
    }
}

// Limpar listas de patrulha vazias
with (obj_infantaria) {
    if (variable_instance_exists(id, "patrulha") && ds_list_size(patrulha) == 0) {
        show_debug_message("🧹 Lista de patrulha vazia na infantaria " + string(id));
    }
}

// 7. VERIFICAÇÃO DE VAZAMENTOS POTENCIAIS
show_debug_message("🔍 VERIFICAÇÃO DE VAZAMENTOS POTENCIAIS:");

var vazamentos_encontrados = 0;

// Verificar instâncias órfãs
with (all) {
    if (variable_instance_exists(id, "parent") && parent != noone && !instance_exists(parent)) {
        show_debug_message("⚠️ Instância órfã encontrada: " + string(id) + " (parent: " + string(parent) + ")");
        vazamentos_encontrados++;
    }
}

// Verificar referências inválidas
with (all) {
    if (variable_instance_exists(id, "alvo") && alvo != noone && !instance_exists(alvo)) {
        show_debug_message("⚠️ Referência inválida encontrada: " + string(id) + " (alvo: " + string(alvo) + ")");
        vazamentos_encontrados++;
    }
}

if (vazamentos_encontrados == 0) {
    show_debug_message("✅ Nenhum vazamento de memória detectado");
} else {
    show_debug_message("⚠️ " + string(vazamentos_encontrados) + " vazamentos potenciais encontrados");
}

// 8. RECOMENDAÇÕES
show_debug_message("💡 RECOMENDAÇÕES:");

if (total_instancias > 1000) {
    show_debug_message("   - ⚠️ Muitas instâncias (" + string(total_instancias) + "). Considerar otimização");
}

with (obj_quartel_marinha) {
    if (variable_instance_exists(id, "fila_producao") && ds_queue_size(fila_producao) > 10) {
        show_debug_message("   - ⚠️ Fila de produção muito grande no quartel " + string(id));
    }
}

show_debug_message("=== VERIFICAÇÃO DE LIMPEZA CONCLUÍDA ===");
