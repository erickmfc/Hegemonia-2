/// @description Alarm[0] - Destruir explosão após animação
// ✅ CORREÇÃO: Destruir sistema de partículas e objeto
if (variable_instance_exists(id, "part_type")) {
    part_type_destroy(part_type);
}
if (variable_instance_exists(id, "part_sys")) {
    part_system_destroy(part_sys);
}
instance_destroy();
