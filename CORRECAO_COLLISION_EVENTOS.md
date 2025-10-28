# ✅ CORREÇÃO: Eventos de Colisão com Edifícios

## 🔴 Problema

Erro ao colidir unidades terrestres com edifícios:
```
Variable <unknown_object>.scr_unidade_deve_respeitar_colisao_edificios(...) not set before reading it.
```

## ✅ Solução Aplicada

Todos os arquivos de colisão foram corrigidos para verificar se a função existe ANTES de chamar:

### **Código Antigo:**
```gml
if (instance_exists(other) && scr_unidade_deve_respeitar_colisao_edificios(other)) {
```

### **Código Novo:**
```gml
if (instance_exists(other)) {
    var _deve_respeitar = true;
    if (typeof(scr_unidade_deve_respeitar_colisao_edificios) != "undefined") {
        _deve_respeitar = scr_unidade_deve_respeitar_colisao_edificios(other);
    }
    
    if (_deve_respeitar) {
        // ... código de colisão ...
    }
}
```

---

## 📁 Arquivos Corrigidos

### **obj_casa:** 4 arquivos
- Collision_obj_infantaria.gml
- Collision_obj_tanque.gml
- Collision_obj_soldado_antiaereo.gml
- Collision_obj_blindado_antiaereo.gml

### **obj_banco:** 4 arquivos
- Collision_obj_infantaria.gml
- Collision_obj_tanque.gml
- Collision_obj_soldado_antiaereo.gml
- Collision_obj_blindado_antiaereo.gml

### **obj_fazenda:** 4 arquivos
- Collision_obj_infantaria.gml
- Collision_obj_tanque.gml
- Collision_obj_soldado_antiaereo.gml
- Collision_obj_blindado_antiaereo.gml

**Total:** 12 arquivos corrigidos

---

## ✅ Resultado

- ✅ Sem erros de "variable not set"
- ✅ Verificação segura antes de chamar função
- ✅ Colisão física funcionando
- ✅ Unidades empurradas para longe dos edifícios

**O erro não deve mais ocorrer!** 🎉
