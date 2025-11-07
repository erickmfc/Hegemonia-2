// Colisão com alvo aéreo ou parede
var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
if (instance_exists(_explosao) && variable_instance_exists(id, "sem_som")) {
    _explosao.sem_som = sem_som; // Passa flag para explosão
}
// ✅ Som removido - sem som de impacto
instance_destroy();
