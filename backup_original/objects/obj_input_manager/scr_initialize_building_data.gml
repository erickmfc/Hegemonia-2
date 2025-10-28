// scr_initialize_building_data
function scr_initialize_building_data() {
    
    // Se o mapa já existe, não faz nada para evitar duplicação.
    if (variable_global_exists("building_definitions") && ds_exists(global.building_definitions, ds_type_map)) {
        return;
    }

    show_debug_message("🏗️ Inicializando definições de construção (global.building_definitions)...");
    
    global.building_definitions = ds_map_create();
    
    var _add = function(_object, _name, _cost) {
        var _data = {
            name: _name,
            cost: _cost,
            object: _object
        };
        ds_map_add(global.building_definitions, _object, _data);
    };
    
    // --- Adicionar todos os edifícios aqui ---
    _add(asset_get_index("obj_casa"), "Casa", 1000);
    _add(asset_get_index("obj_banco"), "Banco", 2500);
    _add(asset_get_index("obj_quartel"), "Quartel", 800);
    _add(asset_get_index("obj_quartel_marinha"), "Quartel Marinha", 1200);
    // Adicione futuros edifícios aqui com a mesma função _add().
    
    show_debug_message("✅ Definições de construção carregadas: " + string(ds_map_size(global.building_definitions)) + " edifícios.");
}