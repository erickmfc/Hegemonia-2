// Sistema de Limpeza e Gerenciamento de Memória - Hegemonia Global
// Previne vazamentos de memória e otimiza performance

// Estrutura para rastrear data structures
global.data_structures = {
    lists: [],
    queues: [],
    stacks: [],
    grids: [],
    maps: [],
    priority_queues: []
};

// Contadores de objetos
global.object_counters = {};

function scr_inicializar_gerenciamento_memoria() {
    scr_log_sistema("MEMORIA", "Sistema de gerenciamento de memória inicializado");
    
    // Inicializar contadores
    global.object_counters = {
        total_objects: 0,
        active_objects: 0,
        pooled_objects: 0,
        memory_usage: 0
    };
}

function scr_criar_ds_list_tracked() {
    var _list = ds_list_create();
    array_push(global.data_structures.lists, _list);
    scr_debug_log("MEMORIA", "DS_List criado (ID: " + string(_list) + ")", DEBUG_LEVEL.DETAILED);
    return _list;
}

function scr_criar_ds_queue_tracked() {
    var _queue = ds_queue_create();
    array_push(global.data_structures.queues, _queue);
    scr_debug_log("MEMORIA", "DS_Queue criado (ID: " + string(_queue) + ")", DEBUG_LEVEL.DETAILED);
    return _queue;
}

function scr_criar_ds_stack_tracked() {
    var _stack = ds_stack_create();
    array_push(global.data_structures.stacks, _stack);
    scr_debug_log("MEMORIA", "DS_Stack criado (ID: " + string(_stack) + ")", DEBUG_LEVEL.DETAILED);
    return _stack;
}

function scr_criar_ds_grid_tracked(width, height) {
    var _grid = ds_grid_create(width, height);
    array_push(global.data_structures.grids, _grid);
    scr_debug_log("MEMORIA", "DS_Grid criado (ID: " + string(_grid) + ", " + string(width) + "x" + string(height) + ")", DEBUG_LEVEL.DETAILED);
    return _grid;
}

function scr_criar_ds_map_tracked() {
    var _map = ds_map_create();
    array_push(global.data_structures.maps, _map);
    scr_debug_log("MEMORIA", "DS_Map criado (ID: " + string(_map) + ")", DEBUG_LEVEL.DETAILED);
    return _map;
}

function scr_criar_ds_priority_tracked() {
    var _priority = ds_priority_create();
    array_push(global.data_structures.priority_queues, _priority);
    scr_debug_log("MEMORIA", "DS_Priority criado (ID: " + string(_priority) + ")", DEBUG_LEVEL.DETAILED);
    return _priority;
}

function scr_destruir_ds_list_tracked(list_id) {
    if (ds_exists(list_id, ds_type_list)) {
        ds_list_destroy(list_id);
        scr_remover_ds_da_lista(global.data_structures.lists, list_id);
        scr_debug_log("MEMORIA", "DS_List destruído (ID: " + string(list_id) + ")", DEBUG_LEVEL.DETAILED);
    }
}

function scr_destruir_ds_queue_tracked(queue_id) {
    if (ds_exists(queue_id, ds_type_queue)) {
        ds_queue_destroy(queue_id);
        scr_remover_ds_da_lista(global.data_structures.queues, queue_id);
        scr_debug_log("MEMORIA", "DS_Queue destruído (ID: " + string(queue_id) + ")", DEBUG_LEVEL.DETAILED);
    }
}

function scr_destruir_ds_stack_tracked(stack_id) {
    if (ds_exists(stack_id, ds_type_stack)) {
        ds_stack_destroy(stack_id);
        scr_remover_ds_da_lista(global.data_structures.stacks, stack_id);
        scr_debug_log("MEMORIA", "DS_Stack destruído (ID: " + string(stack_id) + ")", DEBUG_LEVEL.DETAILED);
    }
}

function scr_destruir_ds_grid_tracked(grid_id) {
    if (ds_exists(grid_id, ds_type_grid)) {
        ds_grid_destroy(grid_id);
        scr_remover_ds_da_lista(global.data_structures.grids, grid_id);
        scr_debug_log("MEMORIA", "DS_Grid destruído (ID: " + string(grid_id) + ")", DEBUG_LEVEL.DETAILED);
    }
}

function scr_destruir_ds_map_tracked(map_id) {
    if (ds_exists(map_id, ds_type_map)) {
        ds_map_destroy(map_id);
        scr_remover_ds_da_lista(global.data_structures.maps, map_id);
        scr_debug_log("MEMORIA", "DS_Map destruído (ID: " + string(map_id) + ")", DEBUG_LEVEL.DETAILED);
    }
}

function scr_destruir_ds_priority_tracked(priority_id) {
    if (ds_exists(priority_id, ds_type_priority)) {
        ds_priority_destroy(priority_id);
        scr_remover_ds_da_lista(global.data_structures.priority_queues, priority_id);
        scr_debug_log("MEMORIA", "DS_Priority destruído (ID: " + string(priority_id) + ")", DEBUG_LEVEL.DETAILED);
    }
}

function scr_remover_ds_da_lista(lista, id) {
    for (var i = array_length(lista) - 1; i >= 0; i--) {
        if (lista[i] == id) {
            array_delete(lista, i, 1);
            break;
        }
    }
}

function scr_limpar_todos_ds() {
    scr_debug_log("MEMORIA", "Iniciando limpeza de todos os data structures", DEBUG_LEVEL.BASIC);
    
    // Limpar lists
    for (var i = 0; i < array_length(global.data_structures.lists); i++) {
        var _list = global.data_structures.lists[i];
        if (ds_exists(_list, ds_type_list)) {
            ds_list_clear(_list);
        }
    }
    
    // Limpar queues
    for (var i = 0; i < array_length(global.data_structures.queues); i++) {
        var _queue = global.data_structures.queues[i];
        if (ds_exists(_queue, ds_type_queue)) {
            while (!ds_queue_empty(_queue)) {
                ds_queue_dequeue(_queue);
            }
        }
    }
    
    // Limpar stacks
    for (var i = 0; i < array_length(global.data_structures.stacks); i++) {
        var _stack = global.data_structures.stacks[i];
        if (ds_exists(_stack, ds_type_stack)) {
            while (!ds_stack_empty(_stack)) {
                ds_stack_pop(_stack);
            }
        }
    }
    
    // Limpar grids
    for (var i = 0; i < array_length(global.data_structures.grids); i++) {
        var _grid = global.data_structures.grids[i];
        if (ds_exists(_grid, ds_type_grid)) {
            ds_grid_clear(_grid, 0);
        }
    }
    
    // Limpar maps
    for (var i = 0; i < array_length(global.data_structures.maps); i++) {
        var _map = global.data_structures.maps[i];
        if (ds_exists(_map, ds_type_map)) {
            ds_map_clear(_map);
        }
    }
    
    // Limpar priority queues
    for (var i = 0; i < array_length(global.data_structures.priority_queues); i++) {
        var _priority = global.data_structures.priority_queues[i];
        if (ds_exists(_priority, ds_type_priority)) {
            ds_priority_clear(_priority);
        }
    }
    
    scr_debug_log("MEMORIA", "Limpeza de data structures concluída", DEBUG_LEVEL.BASIC);
}

function scr_destruir_todos_ds() {
    scr_debug_log("MEMORIA", "Destruindo todos os data structures", DEBUG_LEVEL.BASIC);
    
    // Destruir lists
    for (var i = 0; i < array_length(global.data_structures.lists); i++) {
        var _list = global.data_structures.lists[i];
        if (ds_exists(_list, ds_type_list)) {
            ds_list_destroy(_list);
        }
    }
    global.data_structures.lists = [];
    
    // Destruir queues
    for (var i = 0; i < array_length(global.data_structures.queues); i++) {
        var _queue = global.data_structures.queues[i];
        if (ds_exists(_queue, ds_type_queue)) {
            ds_queue_destroy(_queue);
        }
    }
    global.data_structures.queues = [];
    
    // Destruir stacks
    for (var i = 0; i < array_length(global.data_structures.stacks); i++) {
        var _stack = global.data_structures.stacks[i];
        if (ds_exists(_stack, ds_type_stack)) {
            ds_stack_destroy(_stack);
        }
    }
    global.data_structures.stacks = [];
    
    // Destruir grids
    for (var i = 0; i < array_length(global.data_structures.grids); i++) {
        var _grid = global.data_structures.grids[i];
        if (ds_exists(_grid, ds_type_grid)) {
            ds_grid_destroy(_grid);
        }
    }
    global.data_structures.grids = [];
    
    // Destruir maps
    for (var i = 0; i < array_length(global.data_structures.maps); i++) {
        var _map = global.data_structures.maps[i];
        if (ds_exists(_map, ds_type_map)) {
            ds_map_destroy(_map);
        }
    }
    global.data_structures.maps = [];
    
    // Destruir priority queues
    for (var i = 0; i < array_length(global.data_structures.priority_queues); i++) {
        var _priority = global.data_structures.priority_queues[i];
        if (ds_exists(_priority, ds_type_priority)) {
            ds_priority_destroy(_priority);
        }
    }
    global.data_structures.priority_queues = [];
    
    scr_debug_log("MEMORIA", "Todos os data structures foram destruídos", DEBUG_LEVEL.BASIC);
}

function scr_calcular_uso_memoria() {
    var _total_objects = instance_number(all);
    var _total_ds = array_length(global.data_structures.lists) + 
                   array_length(global.data_structures.queues) + 
                   array_length(global.data_structures.stacks) + 
                   array_length(global.data_structures.grids) + 
                   array_length(global.data_structures.maps) + 
                   array_length(global.data_structures.priority_queues);
    
    // Cálculo aproximado de uso de memória
    var _memoria_objetos = _total_objects * 0.1; // Estimativa por objeto
    var _memoria_ds = _total_ds * 0.5; // Estimativa por data structure
    
    var _uso_total = _memoria_objetos + _memoria_ds;
    var _limite_memoria = 100; // Limite arbitrário
    
    return min(100, (_uso_total / _limite_memoria) * 100);
}

function scr_relatorio_memoria() {
    scr_debug_log("MEMORIA", "=== RELATÓRIO DE MEMÓRIA ===", DEBUG_LEVEL.BASIC, true);
    
    var _total_objects = instance_number(all);
    var _total_ds = array_length(global.data_structures.lists) + 
                   array_length(global.data_structures.queues) + 
                   array_length(global.data_structures.stacks) + 
                   array_length(global.data_structures.grids) + 
                   array_length(global.data_structures.maps) + 
                   array_length(global.data_structures.priority_queues);
    
    scr_debug_log("MEMORIA", "Objetos ativos: " + string(_total_objects), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("MEMORIA", "Data Structures: " + string(_total_ds), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("MEMORIA", "  - Lists: " + string(array_length(global.data_structures.lists)), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("MEMORIA", "  - Queues: " + string(array_length(global.data_structures.queues)), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("MEMORIA", "  - Stacks: " + string(array_length(global.data_structures.stacks)), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("MEMORIA", "  - Grids: " + string(array_length(global.data_structures.grids)), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("MEMORIA", "  - Maps: " + string(array_length(global.data_structures.maps)), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("MEMORIA", "  - Priority Queues: " + string(array_length(global.data_structures.priority_queues)), DEBUG_LEVEL.BASIC, true);
    
    var _uso_memoria = scr_calcular_uso_memoria();
    scr_debug_log("MEMORIA", "Uso estimado de memória: " + string(_uso_memoria) + "%", DEBUG_LEVEL.BASIC, true);
    
    scr_debug_log("MEMORIA", "=== FIM DO RELATÓRIO ===", DEBUG_LEVEL.BASIC, true);
}

function scr_limpeza_automatica_memoria() {
    if (!global.config.auto_cleanup) return;
    
    var _uso_memoria = scr_calcular_uso_memoria();
    var _threshold = global.config.memory_threshold;
    
    if (_uso_memoria > _threshold) {
        scr_debug_log("MEMORIA", "Limpeza automática iniciada (uso: " + string(_uso_memoria) + "%)", DEBUG_LEVEL.BASIC);
        
        // Limpar data structures não utilizados
        scr_limpar_todos_ds();
        
        // Forçar garbage collection se disponível
        if (function_exists("gc_collect")) {
            gc_collect();
        }
        
        scr_debug_log("MEMORIA", "Limpeza automática concluída", DEBUG_LEVEL.BASIC);
    }
}
