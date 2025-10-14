/// Strategic Dashboard - Create Event
/// Dashboard Estratégico - Inicialização

// Position in upper left corner - moved 10% down
dashboard_x = 20;
dashboard_y = 57; // 20 + (370 * 0.1) = 57 pixels down

// Double the size (was 250x120, now 500x240) + 20% increase + 10% additional
dashboard_width = 660;  // 600 * 1.1 = 660 (10% increase to the right)
dashboard_height = 370; // 336 * 1.1 = 370 (10% increase downward)

// Initialize cached data for performance
current_money = global.dinheiro;
current_population = global.populacao;
current_tourists = 0;
current_military = 0;
current_ranking = 1;

// Resource tracking
current_resources = ds_map_create();

// Research tracking
research_completed_count = 0;
research_active_count = 0;

show_debug_message("Dashboard: research_completed_count inicializado como " + string(research_completed_count));
show_debug_message("Dashboard: research_active_count inicializado como " + string(research_active_count));

// Production tracking
daily_income = 0;
total_buildings = 0;

// Set up periodic updates (every 2 seconds as per memory)
alarm[0] = game_get_speed(gamespeed_fps) * 2;

show_debug_message("Strategic Dashboard initialized - Size: " + string(dashboard_width) + "x" + string(dashboard_height));