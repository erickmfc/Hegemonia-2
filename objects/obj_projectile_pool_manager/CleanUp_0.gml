// =============================================
// LIMPEZA DE RECURSOS AO DESTRUIR
// =============================================

// ✅ LIMPEZA: Destruir todas as listas do pool com verificação
if (variable_instance_exists(id, "pool_tiro_simples")) {
    if (ds_exists(pool_tiro_simples, ds_type_list)) {
        ds_list_destroy(pool_tiro_simples);
    }
}

if (variable_instance_exists(id, "pool_tiro_infantaria")) {
    if (ds_exists(pool_tiro_infantaria, ds_type_list)) {
        ds_list_destroy(pool_tiro_infantaria);
    }
}

if (variable_instance_exists(id, "pool_tiro_tanque")) {
    if (ds_exists(pool_tiro_tanque, ds_type_list)) {
        ds_list_destroy(pool_tiro_tanque);
    }
}

if (variable_instance_exists(id, "pool_tiro_canhao")) {
    if (ds_exists(pool_tiro_canhao, ds_type_list)) {
        ds_list_destroy(pool_tiro_canhao);
    }
}

if (variable_instance_exists(id, "pool_projetil_naval")) {
    if (ds_exists(pool_projetil_naval, ds_type_list)) {
        ds_list_destroy(pool_projetil_naval);
    }
}

if (variable_instance_exists(id, "pool_skyfury")) {
    if (ds_exists(pool_skyfury, ds_type_list)) {
        ds_list_destroy(pool_skyfury);
    }
}

if (variable_instance_exists(id, "pool_ironclad")) {
    if (ds_exists(pool_ironclad, ds_type_list)) {
        ds_list_destroy(pool_ironclad);
    }
}

if (variable_instance_exists(id, "pool_missil_aereo")) {
    if (ds_exists(pool_missil_aereo, ds_type_list)) {
        ds_list_destroy(pool_missil_aereo);
    }
}
