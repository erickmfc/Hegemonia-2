// =============================================
// SISTEMA DE OBJECT POOLING PARA PROJÉTEIS
// Gerencia pool de projéteis para reutilização
// =============================================

// === POOLS POR TIPO DE PROJÉTIL ===
pool_tiro_simples = ds_list_create();
pool_tiro_infantaria = ds_list_create();
pool_tiro_tanque = ds_list_create();
pool_tiro_canhao = ds_list_create();
pool_projetil_naval = ds_list_create();
pool_skyfury = ds_list_create();
pool_ironclad = ds_list_create();
pool_missil_aereo = ds_list_create(); // ✅ NOVO

// === ESTATÍSTICAS ===
objetos_criados = 0;
objetos_reutilizados = 0;
objetos_no_pool = 0;
max_pool_size = 50; // Máximo de objetos em cada pool

// === CONFIGURAÇÕES ===
pool_enabled = true; // Habilitar/desabilitar pooling
auto_cleanup_timer = 0;
auto_cleanup_interval = 300; // Limpar objetos inativos a cada 5 segundos

// === INICIALIZAÇÃO PRÉ-CRIADA (opcional) ===
// Pré-criar alguns objetos para melhor performance
pre_warm_pool_size = 10; // Criar 10 objetos de cada tipo antecipadamente

// Debug
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("✅ Sistema de Projectile Pool Manager ativado");
    show_debug_message("📋 Pools disponíveis: 8 tipos de projéteis");
}

// Pré-aquecer pools após um pequeno delay (para garantir que tudo está inicializado)
alarm[0] = 1; // Executar pre-warm no próximo frame
