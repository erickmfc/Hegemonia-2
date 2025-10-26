// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA v4.0
// Clean Up Event - Otimização de Memória
// =========================================================
// Este evento é executado quando a lancha é destruída,
// garantindo que a lista de pontos de patrulha seja
// removida da memória para evitar memory leaks.
// =========================================================

ds_list_destroy(pontos_patrulha);
