// Evento Create de obj_centro_pesquisa

// Sistema de pesquisa tecnológica
global.menu_pesquisa_aberto = false;
global.slots_pesquisa_total = 3; // Máximo de 3 pesquisas simultâneas
global.slots_pesquisa_usados = 0;
global.pode_comprar_slot_extra = true; // Permite comprar 4º slot
global.slot_extra_comprado = false;

// Inicializar mapa de recursos pesquisados
global.recursos_pesquisados = ds_map_create();

// Custos de pesquisa (em dinheiro)
global.custos_pesquisa = ds_map_create();
ds_map_add(global.custos_pesquisa, "Minério", 5000);
ds_map_add(global.custos_pesquisa, "Petróleo", 7500);
ds_map_add(global.custos_pesquisa, "Silício", 8000);
ds_map_add(global.custos_pesquisa, "Borracha", 6000);
ds_map_add(global.custos_pesquisa, "Lítio", 12000);
ds_map_add(global.custos_pesquisa, "Alumínio", 9000);
ds_map_add(global.custos_pesquisa, "Aço", 10000);
ds_map_add(global.custos_pesquisa, "Ouro", 15000);
ds_map_add(global.custos_pesquisa, "Madeira", 4000);
ds_map_add(global.custos_pesquisa, "Titânio", 18000);
ds_map_add(global.custos_pesquisa, "Cobre", 7000);
ds_map_add(global.custos_pesquisa, "Urânio", 25000);

// Tempo de pesquisa (em segundos)
global.tempo_pesquisa = ds_map_create();
ds_map_add(global.tempo_pesquisa, "Minério", 30);
ds_map_add(global.tempo_pesquisa, "Petróleo", 45);
ds_map_add(global.tempo_pesquisa, "Silício", 60);
ds_map_add(global.tempo_pesquisa, "Borracha", 40);
ds_map_add(global.tempo_pesquisa, "Lítio", 90);
ds_map_add(global.tempo_pesquisa, "Alumínio", 50);
ds_map_add(global.tempo_pesquisa, "Aço", 70);
ds_map_add(global.tempo_pesquisa, "Ouro", 80);
ds_map_add(global.tempo_pesquisa, "Madeira", 25);
ds_map_add(global.tempo_pesquisa, "Titânio", 100);
ds_map_add(global.tempo_pesquisa, "Cobre", 35);
ds_map_add(global.tempo_pesquisa, "Urânio", 120);

// Pesquisas em andamento
global.pesquisas_ativas = ds_list_create();
global.pesquisas_tempo_restante = ds_map_create();

// Custo do slot extra
global.custo_slot_extra = 50000;

show_debug_message("Centro de Pesquisa inicializado com sucesso.");
